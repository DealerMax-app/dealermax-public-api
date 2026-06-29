#!/usr/bin/env bash
# List a dealer's used vehicles for sale (REWIND).
# Swap REWIND for NOS (rent, no scoring) or NLT (long-term rental offers).
set -euo pipefail
: "${DEALERMAX_API_KEY:?set DEALERMAX_API_KEY}"
BASE="${DEALERMAX_BASE_URL:-https://catalog.dealermax.app}"

resp=$(curl -s "${BASE}/dealer/REWIND/listing?page=1&page_size=20" \
  -H "X-Api-Key: ${DEALERMAX_API_KEY}")
echo "$resp" | jq . 2>/dev/null || echo "$resp"
