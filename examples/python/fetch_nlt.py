"""Fetch a dealer's long-term rental (NLT) offers, server-side.

    export DEALERMAX_API_KEY="your-dealer-key"
    pip install httpx
    python examples/python/fetch_nlt.py
"""

import os
import httpx

api_key = os.environ["DEALERMAX_API_KEY"]
base_url = os.getenv("DEALERMAX_BASE_URL", "https://catalog.dealermax.app")

with httpx.Client(timeout=20) as client:
    response = client.get(
        f"{base_url}/dealer/NLT/listing",
        headers={"X-Api-Key": api_key},
        params={"page": 1, "page_size": 20},
    )
    response.raise_for_status()
    offers = response.json().get("items", [])

print(f"{len(offers)} NLT offers")
for offer in offers:
    print(f"- {offer.get('marca')} {offer.get('modello')} | id_offerta={offer.get('id_offerta')}")
