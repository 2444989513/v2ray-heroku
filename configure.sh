#!/bin/sh
# Download and install V2Ray
#curl -L -H "Cache-Control: no-cache" -o /v2ray.zip https://github.com/v2ray/v2ray-core/releases/latest/download/v2ray-linux-64.zip
curl -L -H "Cache-Control: no-cache" -o /v2ray.zip https://github.com/v2ray/v2ray-core/releases/download/v4.23.1/v2ray-linux-64.zip
mkdir /usr/bin/v2ray /etc/v2ray
touch /etc/v2ray/config.json
unzip /v2ray.zip -d /usr/bin/v2ray
# Remove /v2ray.zip and other useless files
rm -rf /v2ray.zip /usr/bin/v2ray/*.sig /usr/bin/v2ray/doc /usr/bin/v2ray/*.json /usr/bin/v2ray/*.dat /usr/bin/v2ray/sys*
# V2Ray new configuration
cat <<-EOF > /etc/v2ray/config.json
{
  "inbounds": [
  {
    "port": ${PORT},
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "${UUID}",
          "alterId": 2
        }
      ]
    },
      "streamSettings": {
        "network": "ws", 
        "wsSettings": {
          "path": "/"
        }
      }
  }
  ],
  "outbounds": [
    {
      "protocol": "freedom", 
      "settings": {
        "domainStrategy": "UseIP"
	  }, 
      "tag": "direct"
    }, 
    {
      "protocol": "blackhole", 
      "settings": { }, 
      "tag": "blocked"
    }
  ], 
    "dns": {
    "servers": [
	"https+local://1.1.1.1/dns-query",
	"https+local://1.0.0.1/dns-query",
	"https+local://dns.google/dns-query",
	"https+local://dns.google/resolve",
	"localhost"
    ]
  },
  "routing": {
    "domainStrategy": "IPOnDemand",
    "rules": [
      {
        "type": "field",
        "inboundTag": [
          "vmess-in"
        ],
        "outboundTag": "direct"
      }
    ]
  }
}
EOF
/usr/bin/v2ray/v2ray -config=/etc/v2ray/config.json
