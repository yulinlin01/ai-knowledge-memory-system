#!/bin/bash

# 索引搜索脚本
# 支持按关键词、时间、主题搜索会话索引

SESSIONS_DIR="D:/Claude-memory/sessions"

# 显示帮助
show_help() {
    echo "用法: $0 [选项] <搜索词>"
    echo ""
    echo "选项："
    echo "  -k, --keyword    按关键词搜索（默认）"
    echo "  -t, --time       按时间搜索（格式：YYYY-MM-DD）"
    echo "  -s, --subject    按主题搜索"
    echo "  -a, --all        搜索所有字段"
    echo "  -h, --help       显示帮助"
    echo ""
    echo "示例："
    echo "  $0 飞书                    # 搜索包含'飞书'的索引"
    echo "  $0 -t 2026-06-17           # 搜索 2026-06-17 的索引"
    echo "  $0 -s 记忆系统             # 搜索主题包含'记忆系统'的索引"
    echo "  $0 -a 简历                 # 搜索所有字段包含'简历'的索引"
}

# 默认搜索模式
SEARCH_MODE="keyword"
SEARCH_TERM=""

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -k|--keyword)
            SEARCH_MODE="keyword"
            shift
            ;;
        -t|--time)
            SEARCH_MODE="time"
            shift
            ;;
        -s|--subject)
            SEARCH_MODE="subject"
            shift
            ;;
        -a|--all)
            SEARCH_MODE="all"
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            SEARCH_TERM="$1"
            shift
            ;;
    esac
done

if [ -z "$SEARCH_TERM" ]; then
    echo "错误：请提供搜索词"
    show_help
    exit 1
fi

echo "搜索模式: $SEARCH_MODE"
echo "搜索词: $SEARCH_TERM"
echo "搜索目录: $SESSIONS_DIR"
echo ""

# 执行搜索
case $SEARCH_MODE in
    keyword)
        echo "=== 按关键词搜索 ==="
        grep -r -l "$SEARCH_TERM" "$SESSIONS_DIR"/*.md 2>/dev/null | while read file; do
            echo ""
            echo "文件: $(basename "$file")"
            grep -A 2 -B 2 "$SEARCH_TERM" "$file" 2>/dev/null | head -10
        done
        ;;
    time)
        echo "=== 按时间搜索 ==="
        ls "$SESSIONS_DIR"/${SEARCH_TERM}*.md 2>/dev/null | while read file; do
            echo ""
            echo "文件: $(basename "$file")"
            head -20 "$file" | grep -E "## (基本信息|主题|摘要)" -A 1
        done
        ;;
    subject)
        echo "=== 按主题搜索 ==="
        grep -r -l "## 主题" "$SESSIONS_DIR"/*.md 2>/dev/null | while read file; do
            if grep -q "$SEARCH_TERM" "$file" 2>/dev/null; then
                echo ""
                echo "文件: $(basename "$file")"
                grep -A 2 "## 主题" "$file" 2>/dev/null
            fi
        done
        ;;
    all)
        echo "=== 搜索所有字段 ==="
        grep -r -l "$SEARCH_TERM" "$SESSIONS_DIR"/*.md 2>/dev/null | while read file; do
            echo ""
            echo "文件: $(basename "$file")"
            grep -n "$SEARCH_TERM" "$file" 2>/dev/null | head -5
        done
        ;;
esac

echo ""
echo "搜索完成"
