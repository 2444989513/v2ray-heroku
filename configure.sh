#!/bin/sh

# Download and install V2Ray
mkdir /tmp/v2ray
curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip https://raw.githubusercontent.com/2444989513/Backup-v2ray/master/v2ray-kernel-1/v2ray-linux-64.zip
unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray
install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl

# Remove temporary directory
rm -rf /tmp/v2ray

# V2Ray new configuration
install -d /usr/local/etc/v2ray
cat << EOF > /usr/local/etc/v2ray/config.json
{
    "inbounds": [
        {
            "port": $PORT,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "alterId": 4
                    }
                ],
                "disableInsecureEncryption": true
            },
            "streamSettings": {
                "network": "ws"
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

# Run V2Ray
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json
