#!/usr/bin/env bash
# 결과 마크다운의 mermaid 블록을 PNG로 렌더해 미리보기 (파이썬 없음 — bash + curl + base64 + awk).
# 터미널에선 mermaid가 안 보이므로, 발표 연습 때 다이어그램을 눈으로 확인하는 용도.
#
# 사용법:  ./render-mermaid.sh outputs/kyc-screening.md [출력디렉토리]
#   예시:  ./render-mermaid.sh outputs/dcf-valuation.md
#          (기본 출력: /tmp/mermaid-preview/, macOS면 마지막에 자동으로 open)
set -euo pipefail

md="${1:?사용법: ./render-mermaid.sh <markdown 파일> [출력디렉토리]}"
outdir="${2:-/tmp/mermaid-preview}"
mkdir -p "$outdir"
base="$(basename "$md" .md)"

# 마크다운에서 ```mermaid ... ``` 블록을 추출해 base-1.mmd, base-2.mmd ... 로 분리
awk -v base="$base" -v dir="$outdir" '
  /^```mermaid/ { f=1; n++; fn=dir"/"base"-"n".mmd"; next }
  /^```/        { if (f) { f=0 }; next }
  f             { print > fn }
' "$md"

shopt -s nullglob
mmds=("$outdir/$base"-*.mmd)
if [ ${#mmds[@]} -eq 0 ]; then
  echo "mermaid 블록 없음: $md"; exit 0
fi

for mmd in "${mmds[@]}"; do
  b64="$(base64 < "$mmd" | tr -d '\n')"
  png="${mmd%.mmd}.png"
  code="$(curl -s -o "$png" -w '%{http_code}' "https://mermaid.ink/img/${b64}?type=png&bgColor=0d1117")"
  echo "[$code] $png"
done

# macOS면 첫 PNG 열기
[ "$(uname)" = "Darwin" ] && open "$outdir/$base"-1.png 2>/dev/null || true
echo "완료 → $outdir"
