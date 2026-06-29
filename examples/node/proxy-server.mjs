// Backend-for-frontend (BFF) proxy.
// The browser calls YOUR /api/inventory route; your server adds the DealerMAX
// key and calls the Dealer Public API. The key never reaches the client.
//
//   export DEALERMAX_API_KEY="your-dealer-key"
//   node examples/node/proxy-server.mjs
//   curl http://localhost:3000/api/inventory
//
// Requires Node 18+ (built-in fetch) and `npm i express`.

import express from "express";

const app = express();
const baseUrl = process.env.DEALERMAX_BASE_URL || "https://catalog.dealermax.app";
const apiKey = process.env.DEALERMAX_API_KEY;

app.get("/api/inventory", async (_req, res) => {
  if (!apiKey) return res.status(500).json({ error: "missing_api_key" });

  try {
    const upstream = await fetch(`${baseUrl}/dealer/REWIND/listing?page_size=20`, {
      headers: { "X-Api-Key": apiKey },
    });

    const contentType = upstream.headers.get("content-type") || "";
    const payload = contentType.includes("application/json")
      ? await upstream.json()
      : { error: "upstream_non_json", status: upstream.status };

    res.status(upstream.status).json(payload);
  } catch {
    res.status(502).json({ error: "dealermax_unreachable" });
  }
});

app.listen(3000, () => console.log("BFF proxy on http://localhost:3000"));
