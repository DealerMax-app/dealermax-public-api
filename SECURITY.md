# Security Policy

## Reporting a vulnerability

Email **security@dealermax.app** with a description, reproduction steps, and impact.
Please do not open public issues for security reports. We acknowledge reports as
quickly as we can and will keep you updated on remediation.

## API key handling

The Dealer Public API key authenticates **one dealer** and grants read access to
that dealer's data. Treat it as a server-side secret:

- Store it in a backend secret manager or environment variable — **never** in
  browser code, mobile bundles, or committed source.
- Call the API only from your server, BFF, or a trusted job. Proxy responses to
  the client; never proxy the key.
- Rotate it from *Settings → Public API* in DealerMAX. A regenerated key invalidates
  the previous one immediately.

If a key is exposed, regenerate it from the dashboard right away.
