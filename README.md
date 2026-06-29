<div align="center">

<img src="https://dealermax.app/assets/dealermax-wordmark-light.png" alt="DealerMAX" width="220">

# DealerMAX Public API

**Read-only REST access to a dealer's own vehicle inventory, long-term rental (NLT) offers, and DealerMAX-generated content.**

[![Docs](https://img.shields.io/badge/docs-developers.dealermax.app-FDB825)](https://developers.dealermax.app)
[![OpenAPI](https://img.shields.io/badge/OpenAPI-3.1.0-3fb950)](openapi/dealer-public-api.json)
[![License: MIT](https://img.shields.io/badge/spec%20%26%20examples-MIT-blue)](LICENSE)
[![Status](https://img.shields.io/badge/status-stable%20v1-3fb950)](https://developers.dealermax.app/rate-limits)

[Full documentation](https://developers.dealermax.app) · [Quickstart](https://developers.dealermax.app/quickstart) · [Error reference](https://developers.dealermax.app/errors) · [Service status](https://status.dealermax.app)

</div>

---

## What this is

The **Dealer Public API** lets a DealerMAX dealer connect a custom frontend, a backend, a BFF, or a sync job to its own dealer-ready data:

- **Used vehicles for sale** — `REWIND`
- **Used vehicles for rent, no scoring** — `NOS`
- **Long-term rental offers** — `NLT`
- **DealerMAX-generated content** — FAQ, news, glossary, guides, videos, podcasts

It is **read-only by design** and **backend-first**: one API key maps to one dealer, and the key must never ship in browser code. The contract exposes already-rendered, frontend-ready resources only — no technical catalogs, no cascade lookups, no internal identifiers.

This repository holds the **canonical OpenAPI specification** and **runnable examples**. It is the open companion to the developer portal at **[developers.dealermax.app](https://developers.dealermax.app)**.

## The three surfaces of the DealerMAX platform

| Surface | What it is | Auth | Where |
|---|---|---|---|
| **Dealer Public API** *(this repo)* | One dealer's own inventory + content, read-only | API key (`X-Api-Key`) | `catalog.dealermax.app` |
| **MCP Server** | Keyless, network-wide search for AI agents | None (public) | [`mcp.dealermax.app/mcp`](https://developers.dealermax.app/mcp) |
| **PartnerMAX Enterprise** | Multi-dealer, write-side workflows for approved partners | Partner key (`pmx_…`) | [partnermax-python](https://github.com/DealerMax-app/partnermax-python) · [partnermax-node](https://github.com/DealerMax-app/partnermax-node) |

> Write operations live behind **PartnerMAX Enterprise**. The Dealer Public API never writes.

## Quickstart

1. **Get a dealer API key** — generate or regenerate it inside DealerMAX (*Settings → Public API*) and store it as a **backend secret**.
2. **Call the inventory API** server-side with the `X-Api-Key` header.
3. **Fetch dealer content** for guides, glossary, FAQ, news, videos, podcasts, and search.
4. **Proxy through your backend** — expose only your own BFF route to browsers; never expose the key client-side.

```bash
# List used vehicles for sale (REWIND)
curl "https://catalog.dealermax.app/dealer/REWIND/listing?page=1&page_size=20" \
  -H "X-Api-Key: $DEALERMAX_API_KEY"
```

```bash
# Long-term rental offers (NLT) — Bearer is also accepted
curl "https://catalog.dealermax.app/dealer/NLT/listing?page=1&page_size=20" \
  -H "Authorization: Bearer $DEALERMAX_API_KEY"
```

```bash
# Search dealer content
curl "https://catalog.dealermax.app/dealer/content/guides/listing?q=garanzia&page_size=10" \
  -H "X-Api-Key: $DEALERMAX_API_KEY"
```

More in [`examples/`](examples/): a Node/Express BFF proxy, a Python `httpx` client, and copy-paste cURL.

## Authentication

| Aspect | Detail |
|---|---|
| Header | `X-Api-Key: <key>` (preferred) or `Authorization: Bearer <key>` |
| Issuance | From DealerMAX dashboard; shown **once** on create/regenerate |
| Scope | One key → one dealer's own data |
| Where it runs | **Server-side only** — never in browsers or client bundles |
| Invalid / expired / revoked | `401` with a Problem Details body (see below) |

## Endpoints

| Method | Path | Purpose |
|---|---|---|
| `GET` | `/dealer/{service}/listing` | List inventory — `service` ∈ `REWIND` \| `NOS` \| `NLT` |
| `GET` | `/dealer/{service}/details` | One vehicle (`id_auto`) or offer (`id_offerta`) |
| `GET` | `/dealer/content/hub` | Homepage/footer content summary |
| `GET` | `/dealer/content/search` | Light cross-content text search |
| `GET` | `/dealer/content/{type}/listing` | List content — `type` ∈ `faq` \| `news` \| `glossary` \| `guides` \| `videos` \| `podcasts` |
| `GET` | `/dealer/content/{type}/details` | One content item by `slug` |

Full request/response schemas: [`openapi/dealer-public-api.json`](openapi/dealer-public-api.json) · rendered at [developers.dealermax.app/api](https://developers.dealermax.app/api).

## Error handling — RFC 7807

Every error is `application/problem+json` with a **dereferenceable** `type` URL, a stable `code`, and a `request_id` for support.

```bash
curl -i "https://catalog.dealermax.app/dealer/REWIND/listing"   # no key
```

```json
{
  "type": "https://developers.dealermax.app/errors/missing_api_key",
  "title": "Missing API key",
  "status": 401,
  "code": "missing_api_key",
  "detail": "Missing API key",
  "request_id": "c1ce05c9-edb3-47ed-aa0c-90565e4638b4"
}
```

Open any `type` URL for the human-readable cause and fix. Full catalog: [developers.dealermax.app/errors](https://developers.dealermax.app/errors).

## Rate limits

`60 requests / minute` per API key (IP fallback). The bucket hashes the key — the raw key is never stored. Need more for an aggregator integration? Write to **support@dealermax.app**. Details: [developers.dealermax.app/rate-limits](https://developers.dealermax.app/rate-limits).

## Versioning & stability

`v1` is stable. Additive changes (new fields, new content types) ship without a version bump; breaking changes get a new major and advance notice on [developers.dealermax.app/changelog](https://developers.dealermax.app/changelog).

## License & attribution

- **Specification and examples in this repo:** [MIT](LICENSE).
- **Content returned by the API** (guides, glossary, FAQ, news): **CC-BY-4.0** — reuse with attribution to DealerMAX.

## Links

- 📚 Developer portal — https://developers.dealermax.app
- 🤖 MCP server — https://developers.dealermax.app/mcp
- 📦 PartnerMAX SDKs — [Python](https://github.com/DealerMax-app/partnermax-python) · [Node](https://github.com/DealerMax-app/partnermax-node)
- 🟢 Service status — https://status.dealermax.app
- ✉️ Support — support@dealermax.app
