# Examples

All examples read the API key from the `DEALERMAX_API_KEY` environment variable
and run **server-side**. Never hardcode a key or expose it to a browser.

```bash
export DEALERMAX_API_KEY="your-dealer-key"
# optional: defaults to https://catalog.dealermax.app
export DEALERMAX_BASE_URL="https://catalog.dealermax.app"
```

| Example | Run |
|---|---|
| [`curl/`](curl/) | `bash curl/rewind-listing.sh` |
| [`node/proxy-server.mjs`](node/proxy-server.mjs) | `node node/proxy-server.mjs` → `GET http://localhost:3000/api/inventory` |
| [`python/fetch_nlt.py`](python/fetch_nlt.py) | `pip install httpx && python python/fetch_nlt.py` |

The Node example is a **backend-for-frontend (BFF)** proxy: the browser calls
*your* route, your server adds the key and calls DealerMAX. That is the
recommended integration shape — the key never leaves your backend.
