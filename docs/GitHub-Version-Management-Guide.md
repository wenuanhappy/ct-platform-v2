# Claude Code 本地项目上传 GitHub 版本管理指南

> 本文档记录使用 Claude Code 将本地项目上传到 GitHub 进行版本管理的完整操作流程，可作为同类操作的参考指南。

## 📋 目录

- [环境准备](#环境准备)
- [操作流程](#操作流程)
- [常见问题与解决方案](#常见问题与解决方案)
- [Git 常用命令速查](#git-常用命令速查)

---

## 环境准备

### 1. 检查 Git 安装

```bash
git --version
```

预期输出：`git version 2.x.x`

### 2. 检查 GitHub CLI 安装

```bash
gh --version
```

预期输出：`gh version 2.x.x`

### 3. 登录 GitHub CLI

```bash
gh auth status
```

如果未登录，执行：

```bash
gh auth login
```

### 4. 配置网络代理（如需要）

如果网络无法直接访问 GitHub，需配置代理：

```bash
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890
```

**提示：** 将 `http://127.0.0.1:7890` 替换为你实际的代理地址。

---

## 操作流程

### 阶段一：检查与初始化

#### 步骤 1：检查当前目录状态

```bash
git status
```

- **如果是 Git 仓库**：会显示分支和文件状态
- **如果不是 Git 仓库**：会提示 `fatal: not a git repository`

#### 步骤 2：检查远程仓库配置

```bash
git remote -v
```

预期输出（已配置远程仓库）：

```
origin  https://github.com/username/repo.git (fetch)
origin  https://github.com/username/repo.git (push)
```

### 阶段二：项目准备

#### 步骤 3：创建 .gitignore 文件

创建 `.gitignore` 文件以排除不需要版本控制的文件：

```
# Dependencies
node_modules/
.pnp
.pnp.js

# Build outputs
dist/
dist-ssr/
*.local

# Editor directories and files
.vscode/*
!.vscode/extensions.json
.idea/
*.suo

# Backend
backend/target/
backend/*.log

# Large binary files (自定义)
mysql-portable/

# OS
.DS_Store
Thumbs.db

# Environment
.env
.env.local
```

#### 步骤 4：初始化 Git 仓库（全新项目）

```bash
git init
```

预期输出：`Initialized empty Git repository in /path/to/repo/.git/`

### 阶段三：提交代码

#### 步骤 5：添加文件到暂存区

```bash
# 添加所有文件
git add -A

# 或添加特定文件
git add filename

# 或添加特定目录
git add directory/
```

#### 步骤 6：创建提交

```bash
git commit -m "Initial commit: 项目名称 v1.0.0"
```

### 阶段四：创建远程仓库并推送

#### 方式一：使用 GitHub CLI（推荐）

**创建私有仓库：**

```bash
gh repo create <仓库名称> --private --source=. --push --description "<仓库描述>"
```

**创建公开仓库：**

```bash
gh repo create <仓库名称> --public --source=. --push --description "<仓库描述>"
```

#### 方式二：手动创建仓库后推送

**1. 先在 GitHub 网页创建仓库**

**2. 添加远程仓库地址：**

```bash
git remote add origin https://github.com/username/repo-name.git
```

**3. 推送代码：**

```bash
git push -u origin main
```

---

## 常见问题与解决方案

### 问题 1：网络无法访问 GitHub

**错误信息：**
```
fatal: unable to access 'https://github.com/...': Failed to connect to github.com port 443
```

**解决方案：**

1. 配置 Git 全局代理：
   ```bash
   git config --global http.proxy http://127.0.0.1:7890
   git config --global https.proxy http://127.0.0.1:7890
   ```

2. 验证代理配置：
   ```bash
   git config --global --list | grep proxy
   ```

3. 测试连接：
   ```bash
   curl -I --connect-timeout 10 https://github.com
   ```

### 问题 2：推送大文件被拒绝

**错误信息：**
```
remote: error: GH001: Large files detected.
remote: error: File xxx.exe is 51.66 MB; this exceeds GitHub's file size limit of 100.00 MB
```

**原因：** GitHub 对单个文件有 100MB 限制，推荐不超过 50MB。

**解决方案：**

#### 方案 A：删除 .git 重新开始（推荐）

```bash
# 1. 删除本地 .git 目录
rm -rf .git

# 2. 重新初始化
git init

# 3. 确保 .gitignore 包含大文件目录
# 例如：echo "mysql-portable/" >> .gitignore

# 4. 重新添加并提交
git add -A
git commit -m "Initial commit"

# 5. 推送（如果远程仓库历史有大文件，需删除重建）
gh repo create new-repo-name --private --source=. --push
```

#### 方案 B：使用 BFG 工具清理历史

```bash
# 1. 安装 BFG（需要 Java）
# 下载地址：https://rtyley.github.io/bfg-repo-cleaner/

# 2. 使用 BFG 删除大文件
java -jar bfg.jar --delete-folders mysql-portable

# 3. 清理残留
git reflog expire --expire=now --all && git gc --prune=now --aggressive
```

### 问题 3：远程仓库已存在且历史包含大文件

**错误信息：**
```
remote: error: GH001: Large files detected...
! [remote rejected] main -> main (pre-receive hook declined)
```

**解决方案：**

由于无法修改远程仓库历史，最佳做法是：

1. 删除本地 `.git` 目录
2. 重新初始化 Git 仓库
3. 确保 `.gitignore` 正确配置
4. 创建新的 GitHub 仓库或使用新名称

```bash
# 删除并重建
rm -rf .git
git init
git add -A
git commit -m "Initial commit"

# 创建新仓库
gh repo create repo-name-v2 --private --source=. --push
```

### 问题 4：GitHub CLI 权限不足

**错误信息：**
```
HTTP 403: Must have admin rights to Repository.
```

**解决方案：**

1. 刷新 GitHub CLI 认证，增加权限：
   ```bash
   gh auth refresh -h github.com -s delete_repo
   ```

2. 或改用新名称创建仓库：
   ```bash
   gh repo create new-repo-name --private --source=. --push
   ```

### 问题 5：推送超时或中断

**解决方案：**

1. 增加 Git 缓冲区大小：
   ```bash
   git config http.postBuffer 524288000
   ```

2. 使用后台任务执行推送：
   ```bash
   git push -u origin main &
   ```

3. 检查网络代理是否稳定

---

## Git 常用命令速查

### 基础操作

| 命令 | 说明 |
|------|------|
| `git init` | 初始化新仓库 |
| `git clone <url>` | 克隆远程仓库 |
| `git status` | 查看工作区状态 |
| `git add <file>` | 添加文件到暂存区 |
| `git commit -m "<message>"` | 提交更改 |
| `git log --oneline` | 查看提交历史 |

### 远程仓库操作

| 命令 | 说明 |
|------|------|
| `git remote -v` | 查看远程仓库配置 |
| `git remote add origin <url>` | 添加远程仓库 |
| `git push -u origin <branch>` | 推送到远程仓库 |
| `git pull` | 拉取远程更新 |
| `git fetch` | 获取远程更新（不合并）|

### 分支操作

| 命令 | 说明 |
|------|------|
| `git branch` | 查看本地分支 |
| `git branch -a` | 查看所有分支 |
| `git checkout <branch>` | 切换分支 |
| `git checkout -b <branch>` | 创建并切换新分支 |
| `git merge <branch>` | 合并分支 |

### 撤销与重置

| 命令 | 说明 |
|------|------|
| `git checkout -- <file>` | 撤销工作区修改 |
| `git reset HEAD <file>` | 取消暂存 |
| `git reset --soft HEAD~1` | 撤销上次提交（保留修改）|
| `git reset --hard HEAD~1` | 撤销上次提交（删除修改）|

### 配置操作

| 命令 | 说明 |
|------|------|
| `git config --global user.name "<name>"` | 设置用户名 |
| `git config --global user.email "<email>"` | 设置邮箱 |
| `git config --global http.proxy <url>` | 设置 HTTP 代理 |
| `git config --global https.proxy <url>` | 设置 HTTPS 代理 |
| `git config --list` | 查看所有配置 |

---

## 完整操作示例

以下是将本地项目上传到 GitHub 的完整流程：

```bash
# 1. 进入项目目录
cd /path/to/project

# 2. 检查 Git 状态
git status

# 3. 初始化仓库（如需）
git init

# 4. 创建 .gitignore 文件
vim .gitignore

# 5. 添加所有文件
git add -A

# 6. 创建提交
git commit -m "Initial commit: 项目名称 v1.0.0"

# 7. 配置代理（如需要）
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890

# 8. 创建 GitHub 仓库并推送
gh repo create my-project --private --source=. --push --description "项目描述"

# 9. 验证推送结果
gh repo view --json name,url
```

---

## 注意事项

1. **不要上传大文件**：GitHub 对单文件限制 100MB，推荐不超过 50MB
2. **正确配置 .gitignore**：在首次提交前配置，避免 node_modules、target 等目录进入版本控制
3. **代理配置**：国内用户通常需要配置代理才能访问 GitHub
4. **仓库命名**：建议使用简洁的英文名称，避免中文或特殊字符
5. **敏感信息**：不要将密码、密钥等敏感信息提交到仓库

---

## 参考链接

- [Git 官方文档](https://git-scm.com/doc)
- [GitHub CLI 文档](https://cli.github.com/manual/)
- [GitHub 大文件限制](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github)
- [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)

---

**文档版本：** v1.0  
**创建日期：** 2026-06-20  
**适用场景：** Claude Code 环境下的项目版本管理
