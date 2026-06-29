#!/usr/bin/env bash
# Search DealerMAX-generated content (guides shown here).
# Content types: faq | news | glossary | guides | videos | podcasts
set -euo pipefail
: "${DEALERMAX_API_KEY:?set DEALERMAX_API_KEY}"
BASE="${DEALERMAX_BASE_URL:-https://catalog.dealermax.app}"

resp=$(curl -s "${BASE}/dealer/content/guides/listing?q=garanzia&page=1&page_size=10" \
  -H "X-Api-Key: ${DEALERMAX_API_KEY}")
echo "$resp" | jq . 2>/dev/null || echo "$resp"
