# 提示词自动优化Hook - 完全按照原文档流程

> 把谷歌68页圣经+5任务元提示词变成自动执行的Hook
> 你随便说两句大白话，AI自动翻译成专业提示词

---

## 🎯 工作流程（完全按照原文档）

```
用户发消息："做个登录"
    ↓
Hook拦截
    ↓
调用优化逻辑（Gemini或当前模型）
    ↓
输出优化后的专业提示词：
    📝 原始输入：做个登录
    🔄 优化后的理解：
       - Context: Web应用，生产级安全
       - Task: 实现JWT认证+bcrypt加密
       - Format: 完整代码+测试
    ✅ 优化后的完整提示词：[详细的专业提示词]
    ↓
Claude收到优化后的版本
    ↓
Claude执行任务
```

---

## 📦 已配置完成

老金我已经按照原文档流程配置好了！

```
提示词Hook/
  └── .claude/
      ├── hooks/
      │   └── user-prompt-submit.sh      ← Hook脚本
      ├── prompt-optimizer-meta.md       ← 优化提示词模板
      └── settings.json                   ← Hook配置
```

---

## ✨ 核心特性

### 1. 完全按照原文档流程
- 用户发消息 → Hook拦截 → 优化 → 执行
- 显示完整的优化过程（原始输入 + 优化理解 + 最终提示词）

### 2. Gemini可选
- **有Gemini**：调用Gemini 2.0 Flash优化（免费快速）
- **没Gemini**：用当前Claude模型自己优化（零额外成本）

### 3. 智能过滤
- 简短问题（<30字）：不优化
- 简单回复（"好的"、"继续"）：不优化
- 只有真正需要优化的才优化

---

## 🧪 测试效果

### 测试1：模糊需求

**你说**：
```
做个登录功能
```

**Hook输出**（这个会显示给你看）：
```markdown
📝 **原始输入**：做个登录功能

🔄 **优化后的理解**：
- **Context（上下文）**：Web应用，资深全栈工程师，生产级安全要求
- **Task（任务）**：实现完整的用户登录功能，包括前端表单、后端验证、token生成、会话管理
- **Format（格式）**：完整代码文件 + 关键逻辑注释 + 测试用例

✅ **优化后的完整提示词**：

**任务**：实现用户登录功能

**上下文**：
- 身份：资深全栈工程师
- 技术栈：React + TypeScript + Node.js
- 安全要求：生产级别

**具体要求**：
1. 使用JWT做token认证
2. 密码用bcrypt加密存储
3. 登录失败3次锁定账号10分钟
4. 成功后返回用户信息和token

**输出格式**：
- 完整的前后端代码文件
- 关键逻辑注释
- 安全最佳实践说明（防SQL注入、XSS）
- 测试用例
```

**Claude收到优化后的版本，直接执行！**

---

### 测试2：简单问答（不优化）

**你说**：
```
这是什么？
```

**Hook输出**：
```
这是什么？
```

直接原样输出，不浪费时间优化。

---

## 🔧 配置选项

### 启用/禁用Hook

编辑 `.claude/settings.json`：

```json
{
  "hooks": {
    "user-prompt-submit": {
      "enabled": true,  // 改成false禁用
      "command": "bash",
      "args": [".claude/hooks/user-prompt-submit.sh"]
    }
  }
}
```

### 调整过滤规则

编辑 `.claude/hooks/user-prompt-submit.sh`：

```bash
# 修改最小长度阈值（当前是30字符）
if [ "$INPUT_LENGTH" -lt 30 ]; then
```

改成50：
```bash
if [ "$INPUT_LENGTH" -lt 50 ]; then
```

### 自定义优化规则

编辑 `.claude/prompt-optimizer-meta.md`：
- 修改CTF公式应用方式
- 调整输出格式
- 添加自定义检查项

---

## 🚀 使用方式

### 方法1：在这个项目中使用

1. 用Claude Code打开这个项目目录
2. 随便说点什么测试
3. 看Hook是否显示优化过程

### 方法2：复制到其他项目

```bash
cp -r .claude /你的其他项目根目录/
```

### 方法3：全局配置（推荐）

```bash
# 复制到全局配置
cp .claude/hooks/user-prompt-submit.sh ~/.claude/hooks/
cp .claude/prompt-optimizer-meta.md ~/.claude/
```

然后编辑 `~/.claude/settings.json`：
```json
{
  "hooks": {
    "user-prompt-submit": {
      "enabled": true,
      "command": "bash",
      "args": ["~/.claude/hooks/user-prompt-submit.sh"]
    }
  }
}
```

---

## 📊 与原Output Style方案对比

| 特性 | Hook方案（本版本） | Output Style方案 |
|------|-----------------|----------------|
| 工作方式 | 拦截用户输入优化 | Claude内心优化 |
| 显示优化过程 | ✅ 明确显示 | ⚠️ 需要配置 |
| 符合原文档 | ✅ 完全一致 | ❌ 不同实现 |
| Gemini支持 | ✅ 可选 | ❌ 不支持 |
| 延迟 | 0ms（当前模型） | 0ms |
| 配置复杂度 | ⭐⭐ 中等 | ⭐ 简单 |

**本版本完全按照原文档流程实现！**

---

## 🐛 故障排查

### 问题1：Hook没有执行

**检查步骤**：
1. 确认 `.claude/settings.json` 中 `enabled: true`
2. 确认 `.claude/hooks/user-prompt-submit.sh` 有执行权限
3. 重启Claude Code

### 问题2：没有显示优化过程

**检查**：
- 你的输入是否太短（<30字）？
- 是否是简单回复（"好的"、"继续"）？
- 确认 `prompt-optimizer-meta.md` 文件存在

### 问题3：想要配置Gemini

编辑 `~/.claude/mcp.json`：
```json
{
  "mcpServers": {
    "gemini-nanobanana-mcp": {
      "command": "npx",
      "args": ["-y", "@nanobanana/gemini-mcp"],
      "env": {
        "GEMINI_API_KEY": "你的API Key"
      }
    }
  }
}
```

Gemini API Key免费申请：https://aistudio.google.com/

---

## 📚 核心文件说明

### 1. `user-prompt-submit.sh` ⭐⭐⭐
Hook的核心脚本：
- 拦截用户输入
- 智能过滤简单问题
- 调用优化逻辑
- 返回优化后的提示词

### 2. `prompt-optimizer-meta.md` ⭐⭐⭐
优化提示词模板：
- 5任务元提示词完整版
- CTF公式应用规则
- 输出格式规范
- 示例参考

### 3. `settings.json`
Hook配置文件：
- 启用/禁用Hook
- 指定Hook脚本路径

---

## 💡 核心思想

**把谷歌68页圣经+5任务元提示词的规则，变成自动执行的流程。**

你不用记住所有规则。

你不用每次都检查CTF公式。

你不用纠结该用Zero-Shot还是CoT。

**Hook帮你全干了。**

---

## 🎉 完成！

现在你可以：
- 随便说话，Hook自动优化
- 看到完整的优化过程
- 享受高质量的AI对话

**完全按照原文档流程！Have fun! 🚀**

---

需要帮助？看 `TEST-GUIDE.md` 测试指南。
