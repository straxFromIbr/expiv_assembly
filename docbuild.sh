#! /bin/bash
set -euxo pipefail
cd "$(dirname "$0")"

MDBIN="docs/"
IMGBIN="img/"
PATH_CONV="sed -e 's|$(IMGBIN)|$(MDBIN)/$(IMGBIN)|g'"

REPORT_MD="report.md"
BACKUP_MD="report_backup.md"
REPORT_HTML="report.html"
REPORT_PDF="report.pdf"

# * markdownファイルを結合
# * 画像パスを変更
ls "${MDBIN}/*.md" \
    | sort -h \
    | xargs -I% cat % \
    | sed -e "s|${IMGBIN}|${MDBIN}/${IMGBIN}|g" > "${REPORT_MD}"



# * Headless Chromeで変換
chrome --headless \
    --run-all-compositor-stages-before-draw \
    --virtual-time-budget=10000 \
    --print-to-pdf "${REPORT_HTML}" \
    && mv output.pdf "${REPORT_PDF}"

 
