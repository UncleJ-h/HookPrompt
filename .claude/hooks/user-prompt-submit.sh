#!/bin/bash

# 提示词自动优化Hook - 展示优化结果并自动继续
#
# 工作流程：
# 1. 用户输入提示词
# 2. Hook优化
# 3. 展示优化后的结果
# 4. 自动继续执行

# 读取用户输入
USER_INPUT="$*"
if [ -z "$USER_INPUT" ]; then
    USER_INPUT=$(cat)
fi

# 智能过滤：简短问题不优化（<30字）
INPUT_LENGTH=${#USER_INPUT}
if [ "$INPUT_LENGTH" -lt 10 ]; then
    echo "$USER_INPUT"
    exit 0
fi

# 简单交互式回复不优化
case "$USER_INPUT" in
    好的|是的|继续|谢谢|ok|OK|yes|YES|no|NO|确认|取消)
        echo "$USER_INPUT"
        exit 0
        ;;
esac

# 获取目录路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# 读取优化提示词模板
OPTIMIZER_PROMPT_FILE="$CLAUDE_DIR/prompt-optimizer-meta.md"
if [ ! -f "$OPTIMIZER_PROMPT_FILE" ]; then
    echo "$USER_INPUT"
    exit 0
fi

OPTIMIZER_PROMPT=$(cat "$OPTIMIZER_PROMPT_FILE")

# 构建优化请求
OPTIMIZATION_REQUEST="$OPTIMIZER_PROMPT

---

## 用户原始输入

$USER_INPUT

---

请严格按照格式输出优化结果，最后必须包含完整的优化后提示词。"

# 输出分隔符 + 优化请求
cat << 'EOF'

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔄 提示词自动优化中...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

# 输出优化请求，让模型处理
echo "$OPTIMIZATION_REQUEST"

cat << 'EOF'

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ 优化完成，自动继续执行...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
