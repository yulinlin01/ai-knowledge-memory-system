# 操作流程

> 从零搭建一个结构化知识库的完整步骤。

## 准备工作

```bash
# 1. 创建知识库目录
mkdir my-knowledge-base
cd my-knowledge-base

# 2. 初始化 Git（可选，用于版本管理）
git init
```

## Step 1：定义 Schema（30 分钟）

1. 打开 `schema-template.md`
2. 思考你的知识领域需要哪些分类维度
3. 填写 Schema，定义：
   - 一级分类（3-7 个）
   - 二级分类（每个一级下 3-5 个）
   - 元数据规范
   - 文件命名规范

**关键原则**：
- 先粗后细，不要一开始就想得太细
- 分类之间尽量不重叠
- 留好扩展空间

## Step 2：建骨架（1 小时）

根据 Schema 创建目录和空文件：

```bash
# 批量创建目录
mkdir -p knowledge-base/{分类A,分类B,分类C}

# 批量创建文件
touch knowledge-base/分类A/01.主题1.md
touch knowledge-base/分类A/02.主题2.md
# ... 根据 Schema 展开
```

或者用脚本批量生成：

```bash
#!/bin/bash
# generate-skeleton.sh
# 根据你的 Schema 修改这个脚本

CATEGORIES=("核心知识" "技术专题" "面试题库")
SUB_TOPICS=("闭包" "事件循环" "Promise" "原型链")

for cat in "${CATEGORIES[@]}"; do
    mkdir -p "knowledge-base/$cat"
    for topic in "${SUB_TOPICS[@]}"; do
        touch "knowledge-base/$cat/$topic.md"
    done
done
```

## Step 3：批量 Ingest（2-5 小时）

### 方式 A：爬虫批量获取

适用于：飞书、Notion、语雀等在线文档平台

```python
# 示例：爬取飞书文档
import requests

# 1. 获取文档列表
docs = get_feishu_docs(workspace_id)

# 2. 批量下载
for doc in docs:
    content = download_doc(doc['id'])
    save_as_markdown(content, f"knowledge-base/{doc['category']}/{doc['title']}.md")
```

### 方式 B：手动导入

适用于：零散的文章、PDF、笔记

```bash
# 手动复制粘贴，或用脚本转换格式
pandoc input.pdf -o output.md
```

### 方式 C：混合方式

- 在线文档用爬虫
- 本地文件用手动导入
- PDF 用 pandoc 转换

## Step 4：Lint 检查（1 小时）

### 检查清单

- [ ] 每个 Schema 分类下都有内容
- [ ] 文件命名统一
- [ ] 元数据完整
- [ ] 交叉引用已建立
- [ ] 没有过时信息

### 自动化检查脚本

```bash
#!/bin/bash
# lint-knowledge-base.sh

echo "=== 检查文件命名 ==="
find knowledge-base -name "*.md" | while read file; do
    if ! [[ $(basename "$file") =~ ^[0-9]+\..*\.md$ ]]; then
        echo "⚠️ 命名不规范: $file"
    fi
done

echo "=== 检查元数据 ==="
find knowledge-base -name "*.md" | while read file; do
    if ! head -5 "$file" | grep -q "---"; then
        echo "⚠️ 缺少元数据: $file"
    fi
done

echo "=== 检查空文件 ==="
find knowledge-base -name "*.md" -empty
echo "完成！"
```

## 迭代优化

知识库不是一次建好的。持续迭代：

1. **每周**：补充新内容，更新过时信息
2. **每月**：检查 Schema 是否需要调整
3. **每季度**：评估知识库的使用效果，优化结构

## 常见问题

### Q: 分类太多怎么办？
A: 先用 3-5 个大分类，用的时候再细化。分类是「长出来」的，不是「设计出来」的。

### Q: 内容太多整理不完？
A: 先整理最重要的 20%（帕累托原则）。这 20% 会覆盖 80% 的使用场景。

### Q: 怎么保证持续更新？
A: 建立「新知识入库流程」：每次学到新东西，先找它在 Schema 中的位置，再写入。
