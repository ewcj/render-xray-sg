# Personal Xray node for Render free tier (Singapore).
# No secrets in this repo: UUID / WS_PATH come from Render env vars.
FROM alpine:3.21

RUN apk add --no-cache ca-certificates curl unzip

ARG XRAY_VERSION=26.11.9

RUN set -eux; \
    curl -sSL -o /tmp/xray.zip "https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-64.zip"; \
    curl -sSL -o /tmp/xray.zip.dgst "https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-64.zip.dgst"; \
    EXPECTED=$(grep '^SHA256' /tmp/xray.zip.dgst | grep -oE '[0-9a-f]{64}'); \
    ACTUAL=$(sha256sum /tmp/xray.zip | awk '{print $1}'); \
    [ -n "$EXPECTED" ] && [ "$EXPECTED" = "$ACTUAL" ]; \
    unzip -o /tmp/xray.zip -d /tmp/xray; \
    install -m 0755 /tmp/xray/xray /usr/local/bin/xray; \
    rm -rf /tmp/xray /tmp/xray.zip /tmp/xray.zip.dgst

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

CMD ["/usr/local/bin/entrypoint.sh"]
