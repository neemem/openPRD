#!/usr/bin/env python3
"""
openPRD v4.2.2 - 200 字摘要自动提取脚本

实现 reference/19-audience-tag-table.md §3.2 摘要提取算法。

用法:
    python3 reference/19-summarizer.py <template_path> [excluded_audience ...]
    echo "..." | python3 reference/19-summarizer.py -

参数:
    template_path           - 模板文件路径(.md),或 - 表示从 stdin 读取
    excluded_audience ...   - 排除的受众列表(产品/技术/运营/合规),可多个

输出:
    标准输出打印 Markdown 格式的 200 字摘要(可被主 Agent 直接 append 到文档)

设计原则:
    - 零外部依赖,纯 Python 3.6+ 标准库
    - 截断按字符数(中文 1 字符、英文 1 字符),≤ 200 中文字符
    - 降级:five_field / decisions / numbers 提取失败时优雅降级到模板描述
    - 符合 reference/19 §3.1 固定结构
"""

import re
import sys
from pathlib import Path


def extract_h1(content: str) -> str:
    """提取 H1 标题(模板名)。"""
    m = re.search(r"^#\s+(.+?)$", content, re.MULTILINE)
    return m.group(1).strip() if m else "未命名模板"


def extract_first_h3(content: str) -> str:
    """提取第一个 ### 章节(模板说明)。"""
    m = re.search(r"^###\s+(.+?)$", content, re.MULTILINE)
    return m.group(1).strip() if m else ""


def extract_decisions(content: str, limit: int = 5) -> list:
    """提取 ⭐ 决策标注(最多 5 条)。"""
    pattern = re.compile(r"⭐\s*[^*]*?\*\*([^*]+)\*\*[：:]\s*([^\n]+)")
    decisions = []
    for m in pattern.finditer(content):
        title = m.group(1).strip()
        body = m.group(2).strip()
        decisions.append(f"**{title}**:{body}")
        if len(decisions) >= limit:
            break
    return decisions


def extract_key_numbers(content: str) -> str:
    """提取关键数字 / 对象(P0 数 / 接口数 / 表数 / 合规条款数)。"""
    found = []
    # P0 功能数
    m = re.search(r"(\d+)\s*个\s*P0", content)
    if m:
        found.append(f"P0 {m.group(1)}")
    # 接口 / API 数
    m = re.search(r"(\d+)\s*(?:个|个\s*)RESTful", content)
    if m:
        found.append(f"API {m.group(1)}")
    # 表数
    m = re.search(r"(\d+)\s*张表", content)
    if m:
        found.append(f"表 {m.group(1)}")
    # 合规条款
    m = re.search(r"(\d+)\s*条\s*合规", content)
    if m:
        found.append(f"合规 {m.group(1)}")
    return " / ".join(found) if found else "见完整版"


def truncate_to_chars(text: str, max_chars: int = 200) -> str:
    """截断到 ≤ max_chars 字符(中英文统一按 1 字符算)。"""
    if len(text) <= max_chars:
        return text
    return text[: max_chars - 1] + "…"


def build_summary(template_path: str, excluded: list, content: str) -> str:
    """组装 200 字摘要(符合 reference/19 §3.1 固定结构)。"""
    h1 = extract_h1(content)
    first_section = extract_first_h3(content)
    decisions = extract_decisions(content)
    numbers = extract_key_numbers(content)

    excluded_str = "、".join(excluded) if excluded else "未指定"

    parts = []
    parts.append(f"## 摘要(降级输出,200 字内)\n")
    if excluded and excluded != ["未指定"]:
        parts.append(
            f"> 本文档已降级。受众 **{excluded_str}** 未列入产出范围,完整定义仅对主受众开放。"
        )
    else:
        parts.append(
            f"> 模板定位摘要(全受众可见)。完整定义见下方各章。"
        )
    if first_section:
        parts.append(f"> 模板定位:{first_section}")
    parts.append("")

    if decisions:
        parts.append("**核心决策**:")
        for d in decisions[:5]:
            parts.append(f"- {d}")
        parts.append("")
    else:
        # fallback 到模板描述
        parts.append(f"**模板说明**:`{h1}`")
        parts.append("")

    parts.append(f"**关键数字/对象**:{numbers}")
    parts.append("")
    parts.append(f"**完整版见**:`{template_path}`(主受众可访问)")

    full = "\n".join(parts)
    return truncate_to_chars(full, 200)


def main():
    if len(sys.argv) < 2:
        print(__doc__, file=sys.stderr)
        sys.exit(1)

    template_path = sys.argv[1]
    excluded = sys.argv[2:] or ["未指定"]

    if template_path == "-":
        content = sys.stdin.read()
        template_path = "<stdin>"
    else:
        path = Path(template_path)
        if not path.exists():
            print(f"错误:文件不存在 {template_path}", file=sys.stderr)
            sys.exit(1)
        content = path.read_text(encoding="utf-8")

    summary = build_summary(template_path, excluded, content)
    print(summary)


if __name__ == "__main__":
    main()
