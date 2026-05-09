<#
.SYNOPSIS
  Auto Role Router - Windows PowerShell installer

.DESCRIPTION
  Installs (or uninstalls) auto-role-router hooks into
  %USERPROFILE%\.claude\settings.json.

  Logic is intentionally mirrored with install.sh so both platforms
  produce the same result.

.PARAMETER DryRun
  Preview changes without writing settings.json.

.PARAMETER Legacy
  Use the smaller legacy hook payload (hooks-config-legacy.json).

.PARAMETER Uninstall
  Remove auto-role-router hooks, preserving other unrelated hooks.

.EXAMPLE
  .\install.ps1
  .\install.ps1 -DryRun
  .\install.ps1 -Legacy
  .\install.ps1 -Uninstall
#>
[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$Legacy,
    [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'

# Requires PowerShell 5.1+ for ConvertFrom-Json / ConvertTo-Json
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Error "PowerShell 5.1 or newer is required. Current: $($PSVersionTable.PSVersion)"
    exit 1
}

$mode = if ($Uninstall) { 'uninstall' } elseif ($DryRun) { 'dry-run' } else { 'install' }
$variant = if ($Legacy) { 'legacy' } else { 'default' }

Write-Host "Auto Role Router installer"
Write-Host "  mode:    $mode"
Write-Host "  variant: $variant"
Write-Host ""

$settingsDir  = Join-Path $env:USERPROFILE '.claude'
$settingsFile = Join-Path $settingsDir 'settings.json'
$scriptDir    = Split-Path -Parent $MyInvocation.MyCommand.Path

$hookFileName = if ($variant -eq 'legacy') { 'hooks-config-legacy.json' } else { 'hooks-config.json' }
$hooksFile    = Join-Path $scriptDir $hookFileName

# If run stand-alone (not from a cloned repo), fall back to the GitHub raw URL.
if (-not (Test-Path $hooksFile)) {
    $remoteUrl = "https://raw.githubusercontent.com/AlexPlum405/skills/main/auto-role-router/$hookFileName"
    $hooksFile = Join-Path ([IO.Path]::GetTempPath()) "auto-role-router-$([Guid]::NewGuid().ToString('N')).json"
    Write-Host "Fetching hook config from $remoteUrl"
    Invoke-WebRequest -UseBasicParsing -Uri $remoteUrl -OutFile $hooksFile
}

# Ensure settings.json exists
if (-not (Test-Path $settingsFile)) {
    Write-Host "No $settingsFile — creating a minimal one."
    if ($mode -ne 'dry-run') {
        New-Item -ItemType Directory -Path $settingsDir -Force | Out-Null
        '{}' | Set-Content -Path $settingsFile -Encoding UTF8
    }
}

function Read-Json([string]$path) {
    if (Test-Path $path) {
        (Get-Content -Raw -Path $path) | ConvertFrom-Json
    } else {
        [pscustomobject]@{}
    }
}

function To-JsonPretty($obj) {
    $obj | ConvertTo-Json -Depth 100
}

# Deep-merge: right wins on scalar collisions, arrays get concatenated, objects merge recursively.
function Merge-Object($left, $right) {
    if ($null -eq $left)  { return $right }
    if ($null -eq $right) { return $left }

    if ($right -is [pscustomobject] -and $left -is [pscustomobject]) {
        $merged = [pscustomobject]@{}
        $keys = @($left.PSObject.Properties.Name) + @($right.PSObject.Properties.Name) | Sort-Object -Unique
        foreach ($k in $keys) {
            $l = $left.PSObject.Properties[$k]
            $r = $right.PSObject.Properties[$k]
            if ($null -eq $l) {
                $merged | Add-Member -NotePropertyName $k -NotePropertyValue $r.Value
            } elseif ($null -eq $r) {
                $merged | Add-Member -NotePropertyName $k -NotePropertyValue $l.Value
            } else {
                $merged | Add-Member -NotePropertyName $k -NotePropertyValue (Merge-Object $l.Value $r.Value)
            }
        }
        return $merged
    }
    if ($right -is [System.Collections.IEnumerable] -and $right -isnot [string] -and
        $left  -is [System.Collections.IEnumerable] -and $left  -isnot [string]) {
        return @($left) + @($right)
    }
    return $right
}

function Remove-AutoRoleRouterHooks($settings) {
    if (-not $settings.PSObject.Properties['hooks']) { return $settings }
    $hooks = $settings.hooks
    if ($null -eq $hooks) { return $settings }

    $newHooks = [pscustomobject]@{}
    foreach ($eventProp in $hooks.PSObject.Properties) {
        $filteredGroups = foreach ($group in $eventProp.Value) {
            # Keep every hook whose command does NOT contain the [auto-role-router] marker.
            $kept = $group.hooks | Where-Object { $_.command -notmatch '\[auto-role-router\]' }
            if ($kept -and $kept.Count -gt 0) {
                [pscustomobject]@{ hooks = @($kept) }
            }
        }
        if ($filteredGroups -and @($filteredGroups).Count -gt 0) {
            $newHooks | Add-Member -NotePropertyName $eventProp.Name -NotePropertyValue @($filteredGroups)
        }
    }

    if (@($newHooks.PSObject.Properties).Count -eq 0) {
        $settings.PSObject.Properties.Remove('hooks')
    } else {
        $settings.hooks = $newHooks
    }
    return $settings
}

$existing = Read-Json $settingsFile
$newJson  = $existing

switch ($mode) {
    { $_ -in 'install', 'dry-run' } {
        $hooksPayload = Read-Json $hooksFile
        $newJson = Merge-Object $existing $hooksPayload
    }
    'uninstall' {
        $newJson = Remove-AutoRoleRouterHooks $existing
    }
}

if ($mode -eq 'dry-run') {
    Write-Host "--- Proposed settings.json ---"
    To-JsonPretty $newJson
    Write-Host "--- End. No changes written. ---"
    exit 0
}

# Back up before writing
$timestamp  = Get-Date -Format 'yyyyMMdd_HHmmss'
$backupFile = "$settingsFile.backup.$timestamp"
if (Test-Path $settingsFile) {
    Copy-Item $settingsFile $backupFile
}
To-JsonPretty $newJson | Set-Content -Path $settingsFile -Encoding UTF8

switch ($mode) {
    'install' {
        Write-Host ""
        Write-Host "Installed. Restart Claude Code for hooks to take effect."
        Write-Host ""
        Write-Host "To roll back:"
        Write-Host "  Copy-Item `"$backupFile`" `"$settingsFile`" -Force"
        Write-Host ""
        Write-Host "To uninstall cleanly later:"
        Write-Host "  $scriptDir\install.ps1 -Uninstall"
    }
    'uninstall' {
        Write-Host ""
        Write-Host "Removed auto-role-router hooks from settings.json."
        Write-Host "Backup saved at: $backupFile"
    }
}
