#!/bin/bash
# Auto Role Router - Smart Hook (方案 A)
# 在用户输入前分析领域并注入角色指令

# 注意：Claude Code 的 hook 无法直接访问用户输入
# 所以这个脚本使用"预测性注入"：基于常见模式提前注入角色指令

# 定义技术领域关键词映射
# 格式：关键词 -> 角色名
declare -A ROLE_MAP=(
    # 编程语言
    ["rust"]="Rust Expert"
    ["lifetime"]="Rust Lifetime Expert"
    ["async rust"]="Rust Async Expert"
    ["rust macro"]="Rust Macro Specialist"
    ["python"]="Python Expert"
    ["typescript"]="TypeScript Expert"
    ["javascript"]="JavaScript Expert"
    ["go"]="Go Expert"

    # 框架
    ["react"]="React Expert"
    ["react hook"]="React Hooks Specialist"
    ["vue"]="Vue Expert"
    ["nextjs"]="Next.js Expert"
    ["next.js"]="Next.js Expert"

    # 数据库
    ["postgresql"]="PostgreSQL Expert"
    ["postgres"]="PostgreSQL Expert"
    ["sql"]="Database Expert"
    ["mysql"]="MySQL Expert"
    ["mongodb"]="MongoDB Expert"
    ["redis"]="Redis Expert"

    # 基础设施
    ["kubernetes"]="Kubernetes Expert"
    ["k8s"]="Kubernetes Expert"
    ["docker"]="Docker Expert"
    ["terraform"]="Terraform Expert"

    # 工具
    ["git"]="Git Expert"
    ["claude code"]="Claude Code Configuration Expert"
)

# 由于无法直接访问用户输入，我们使用"通用角色指令"
# 让 AI 自己在回答前分析领域并选择角色

cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "# Auto Role Router - Pre-activation Mode\n\nBefore generating your response, you MUST:\n\n1. **Analyze the user's question** to identify:\n   - Programming language (Rust, Python, TypeScript, etc.)\n   - Framework (React, Vue, Next.js, etc.)\n   - Tool (Git, Docker, Kubernetes, etc.)\n   - Specific concept (lifetime, async, hooks, etc.)\n\n2. **Construct your expert role** using this formula:\n   [Technology] + [Specialization] + Expert/Specialist\n   \n   Examples:\n   - \"Rust lifetime error\" → Rust Lifetime Expert\n   - \"React hooks\" → React Hooks Specialist\n   - \"PostgreSQL query optimization\" → PostgreSQL Query Optimizer\n   - \"Unknown tech XYZ\" → XYZ Expert\n\n3. **Adopt this role BEFORE generating any response**:\n   - Think as this expert from the first token\n   - Use domain-specific terminology\n   - Provide expert-level insights\n\n4. **Declare your role on the first line**:\n   - English: **Role: [Role Name]**\n   - Chinese: **角色：[角色名称]**\n\n5. **Maintain role consistency**:\n   - If domain unchanged, keep the same role\n   - If domain switches, assign new role\n\nThis is a MANDATORY pre-processing step. You must complete steps 1-3 BEFORE generating the role declaration and response."
  }
}
EOF
