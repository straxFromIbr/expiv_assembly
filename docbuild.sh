#! /bin/bash
set -euxo pipefail
cd "$(dirname "$0")"

MDBIN="./docs"
IMGBIN="./images"

REPORT_MD="report.md"
REPORT_HTML="report.html"
REPORT_PDF="report.pdf"

if test "${1:-"build"}" = 'clear'; then
    rm ${REPORT_MD} ${REPORT_HTML} ${REPORT_PDF}
    exit
fi

# * markdownファイルを結合
# * 画像パスを変更
ls "${MDBIN}"/*.md \
    | sort -h \
    | xargs -I% cat % \
    | sed -e "s|${IMGBIN}|${MDBIN}/${IMGBIN}|g" > "${REPORT_MD}"

# * HTMLに変換
md2html "${REPORT_MD}" > "${REPORT_HTML}"

# * Headless Chromeで変換
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
    --headless \
    --run-all-compositor-stages-before-draw \
    --virtual-time-budget=10000 \
    --print-to-pdf "${REPORT_HTML}" \
    && mv output.pdf "${REPORT_PDF}"

 
