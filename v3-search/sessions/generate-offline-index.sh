#!/bin/bash

# 离线索引生成脚本（增量更新 + 完整版格式）
# 只处理上次更新后新增或修改的 JSONL 文件
# 生成完整版索引：基本信息 + 主题关键词 + 摘要 + 详细内容

SESSIONS_DIR="D:/Claude-memory/sessions"
CLAUDE_DIR="$HOME/.claude/projects"
LAST_UPDATE_FILE="$SESSIONS_DIR/.last_update"

# 创建 sessions 目录（如果不存在）
mkdir -p "$SESSIONS_DIR"

# 读取上次更新时间
if [ -f "$LAST_UPDATE_FILE" ]; then
    LAST_UPDATE=$(cat "$LAST_UPDATE_FILE")
    echo "上次更新时间: $LAST_UPDATE"
    echo "增量更新模式"
else
    LAST_UPDATE=""
    echo "首次运行，全量更新模式"
fi

# 获取当前时间戳
CURRENT_UPDATE=$(date +%Y-%m-%dT%H:%M:%S)

# 计数器
total_files=0
updated_files=0
skipped_files=0

echo "开始生成离线索引（完整版）..."

# 扫描所有项目目录
for project_dir in "$CLAUDE_DIR"/*/; do
    if [ -d "$project_dir" ]; then
        echo "处理项目: $(basename "$project_dir")"

        # 扫描所有 JSONL 文件
        for jsonl_file in "$project_dir"*.jsonl; do
            if [ -f "$jsonl_file" ]; then
                total_files=$((total_files + 1))

                # 提取会话ID（文件名去掉 .jsonl）
                session_id=$(basename "$jsonl_file" .jsonl)

                # 提取会话标题
                title=$(grep -o '"aiTitle":"[^"]*"' "$jsonl_file" | head -1 | sed 's/"aiTitle":"//;s/"//' 2>/dev/null)

                # 如果没有标题，尝试从用户输入推断
                if [ -z "$title" ]; then
                    # 获取第一个用户输入
                    first_user_input=$(grep '"type":"user"' "$jsonl_file" | head -1 | grep -o '"content":"[^"]*"' | head -1 | sed 's/"content":"//;s/"$//' 2>/dev/null)
                    if [ -n "$first_user_input" ]; then
                        # 截取前50个字符作为标题
                        title=$(echo "$first_user_input" | cut -c1-50)
                    else
                        title="未知主题"
                    fi
                fi

                # 提取时间戳
                timestamp=$(grep -o '"timestamp":"[^"]*"' "$jsonl_file" | head -1 | sed 's/"timestamp":"//;s/"//' 2>/dev/null)

                # 提取用户输入关键词
                keywords=$(grep '"type":"user"' "$jsonl_file" | grep -o '"content":"[^"]*"' | head -5 | sed 's/"content":"//;s/"$//' | tr '\n' ' ' | cut -c1-200 2>/dev/null)

                # 生成索引文件名（使用时间戳的日期部分）
                if [ -n "$timestamp" ]; then
                    date_part=$(echo "$timestamp" | cut -dT -f1)
                else
                    date_part=$(date +%Y-%m-%d)
                fi

                index_file="$SESSIONS_DIR/${date_part}_${session_id:0:8}.md"

                # 检查是否已存在索引
                if [ -f "$index_file" ]; then
                    # 增量模式：检查文件修改时间
                    if [ -n "$LAST_UPDATE" ]; then
                        # 获取 JSONL 文件的修改时间
                        file_mtime=$(stat -c %Y "$jsonl_file" 2>/dev/null || stat -f %m "$jsonl_file" 2>/dev/null)
                        last_update_ts=$(date -d "$LAST_UPDATE" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%S" "$LAST_UPDATE" +%s 2>/dev/null)

                        if [ -n "$file_mtime" ] && [ -n "$last_update_ts" ]; then
                            if [ "$file_mtime" -le "$last_update_ts" ]; then
                                skipped_files=$((skipped_files + 1))
                                continue
                            fi
                        fi
                    else
                        skipped_files=$((skipped_files + 1))
                        continue
                    fi
                fi

                # 提取更多详细信息
                # 提取 AI 回复摘要
                ai_summary=$(grep '"type":"assistant"' "$jsonl_file" | head -1 | grep -o '"content":"[^"]*"' | head -1 | sed 's/"content":"//;s/"$//' | cut -c1-100 2>/dev/null)

                # 提取工具调用
                tools_used=$(grep '"type":"tool_use"' "$jsonl_file" | grep -o '"name":"[^"]*"' | sed 's/"name":"//;s/"//' | sort -u | tr '\n' ', ' | sed 's/, $//' 2>/dev/null)

                # 生成完整版索引
                cat > "$index_file" << EOF
# 会话索引

## 基本信息
- 时间：${timestamp:-未知}
- 会话ID：${session_id}
- 项目：$(basename "$project_dir")

## 主题
${title}

## 关键词
${keywords:-无}

## 摘要
${ai_summary:-待补充}

---

## 详细内容

### 任务完成情况

| 任务 | 状态 | 交付物 | 核心内容 |
|------|------|--------|---------|
| 待补充 | ⏳ | 无 | 需要分析会话内容 |

### 关键决策

| 决策 | 内容 | 原因 |
|------|------|------|
| 待补充 | 无 | 无 |

### 踩坑记录

| 问题 | 原因 | 解决方案 |
|------|------|---------|
| 待补充 | 无 | 无 |

---

## 参考
- 原始文件：${jsonl_file}
- 工具调用：${tools_used:-无}
EOF

                updated_files=$((updated_files + 1))
                echo "  生成索引: $(basename "$index_file")"
            fi
        done
    fi
done

# 更新上次更新时间
echo "$CURRENT_UPDATE" > "$LAST_UPDATE_FILE"

echo ""
echo "离线索引生成完成（完整版）！"
echo "统计："
echo "  总文件数: $total_files"
echo "  新增/更新: $updated_files"
echo "  跳过: $skipped_files"
echo "索引目录: $SESSIONS_DIR"
echo ""
echo "注意：新生成的索引为完整版格式，但详细内容需要手动补充。"
