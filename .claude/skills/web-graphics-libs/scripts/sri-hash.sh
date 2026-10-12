#!/usr/bin/env bash
# 허용목록 CDN의 고정 버전 URL에 대해 SRI(sha384) 해시를 계산해 <script> 태그를 출력한다.
# 사용법: bash sri-hash.sh https://cdn.jsdelivr.net/npm/canvas-confetti@1.9.3/dist/confetti.browser.min.js
set -euo pipefail
url="${1:?URL을 지정하세요}"

case "$url" in
  https://cdn.jsdelivr.net/npm/*|https://unpkg.com/*|https://cdnjs.cloudflare.com/*) ;;
  *) echo "거부: 허용목록 CDN이 아닙니다: $url" >&2; exit 2 ;;
esac

# 정확한 버전(@x.y.z) 고정 여부 확인 — latest/범위 지정 금지
if ! grep -qE '@[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.]+)?/' <<<"$url" && ! grep -qE '/libs/[^/]+/[0-9]+\.[0-9]+\.[0-9]+/' <<<"$url"; then
  echo "거부: 정확한 버전(@x.y.z)이 URL에 없습니다: $url" >&2; exit 2
fi

hash="sha384-$(curl -fsSL "$url" | openssl dgst -sha384 -binary | openssl base64 -A)"
echo "integrity: $hash"
echo "<script src=\"$url\" integrity=\"$hash\" crossorigin=\"anonymous\" referrerpolicy=\"no-referrer\"></script>"
