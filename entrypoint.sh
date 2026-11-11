#!/bin/sh
# Render injects $PORT at runtime; UUID and WS_PATH come from Render env vars.
# Render terminates TLS at *.onrender.com and forwards plain HTTP to $PORT,
# so Xray serves plain WebSocket here and the client sees VLESS+WS+TLS.
set -e
: "${UUID:?missing UUID env var}"
: "${WS_PATH:?missing WS_PATH env var}"
PORT="${PORT:-10000}"
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": {"loglevel": "warning"},
  "inbounds": [
    {
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [{"id": "${UUID}", "flow": ""}],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {"path": "${WS_PATH}"}
      }
    }
  ],
  "outbounds": [{"protocol": "freedom", "tag": "direct"}]
}
EOF
exec /usr/local/bin/xray run -config /etc/xray/config.json
