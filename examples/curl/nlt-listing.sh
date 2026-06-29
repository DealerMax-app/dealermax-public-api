#!/usr/bin/env bash
# List a dealer's long-term rental (NLT) offers. Bearer auth is also accepted.
set -euo pipefail
: "${DEALERMAX_API_KEY:?set DEALERMAX_API_KEY}"
BASE="${DEALERMAX_BASE_URL:-https://catalog.dealermax.app}"

resp=$(curl -s "${BASE}/dealer/NLT/listing?page=1&page_size=20" \
  -H "Authorization: Bearer ${DEALERMAX_API_KEY}")
echo "$resp" | jq . 2>/dev/null || echo "$resp"
