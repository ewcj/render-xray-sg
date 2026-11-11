# render-xray-sg

Personal Xray node on Render's free tier (Singapore region), for my own
light use only. Deploys as a Docker Web Service from this repo.

## How it works

- `Dockerfile` downloads the official Xray release (pinned version) and
  verifies its SHA256 against the official `.dgst` file before unpacking.
- `entrypoint.sh` writes the Xray config at container start from env vars
  and listens on Render's injected `$PORT`.
- Render terminates TLS at `*.onrender.com`, so the client sees
  VLESS + WS + TLS on port 443; inside the container it is plain WS.

## Required env vars (set in the Render dashboard, never in this repo)

- `UUID` — VLESS client UUID (random)
- `WS_PATH` — WebSocket path, e.g. `/<random-hex>`

## Free-tier notes

- 512 MB RAM, 0.1 CPU, 750 instance-hours/month per workspace.
- Spins down after 15 minutes without inbound traffic; ~1 minute to wake.
- Hobby workspace outbound bandwidth is 5 GB/month. Light use only.
