TS_ISO8601=$(shell date -Iseconds -u)
TS_COMPACT=$(shell date +%Y%m%d%H%M%S)

all: \
	cidrs/ipv4.json cidrs/ipv6.json cidrs/ipv4-and-ipv6.json \
	cidrs/ipv4.txt cidrs/ipv6.txt cidrs/ipv4-and-ipv6.txt \
	cidrs/ipv4.single-line.txt cidrs/ipv6.single-line.txt\
	cidrs/ipv4.single-line.json cidrs/ipv6.single-line.json \
	cidrs/ipv4-and-ipv6.single-line.txt \
	cidrs/ipv4-and-ipv6.single-line.json\
	cidrs/apache2-remote-ip.conf \
	cidrs/nginx-http-realip-module.conf

commit:
	git add .
	git commit -a -m ${TS_ISO8601}

push:
	git tag v1.0.0-${TS_COMPACT}
	git push && git push --tags
	
cidrs/ipv4-and-ipv6.single-line.json: cidrs/ipv4-and-ipv6.json
	jq -c . cidrs/ipv4-and-ipv6.json > cidrs/ipv4-and-ipv6.single-line.json

cidrs/ipv4-and-ipv6.single-line.txt: cidrs/ipv4-and-ipv6.json
	jq -r '.|@csv' cidrs/ipv4-and-ipv6.json > cidrs/ipv4-and-ipv6.single-line.txt

cidrs/ipv6.single-line.json: cidrs/ipv6.json
	jq -c . cidrs/ipv6.json > cidrs/ipv6.single-line.json

cidrs/ipv4.single-line.json: cidrs/ipv4.json
	jq -c . cidrs/ipv4.json > cidrs/ipv4.single-line.json

cidrs/ipv6.single-line.txt: cidrs/ipv6.json
	jq -r '.|@csv' cidrs/ipv6.json > cidrs/ipv6.single-line.txt

cidrs/ipv4.single-line.txt: cidrs/ipv4.json
	jq -r '.|@csv' cidrs/ipv4.json > cidrs/ipv4.single-line.txt

cidrs/nginx-http-realip-module.conf: cidrs/ipv4-and-ipv6.json
	echo "# Put these lines on your nginx http-real-ip configuration" > cidrs/nginx-http-realip-module.conf
	echo >> cidrs/nginx-http-realip-module.conf
	echo real_ip_header CF-Connecting-IP\; >> cidrs/nginx-http-realip-module.conf
	echo >> cidrs/nginx-http-realip-module.conf
	jq -r '.[]| "set_real_ip_from " + . + ";"' cidrs/ipv4-and-ipv6.json >> cidrs/nginx-http-realip-module.conf


cidrs/apache2-remote-ip.conf: cidrs/ipv4-and-ipv6.json
	echo "# Put these lines on your apache2's mod_remoteip configuration" > cidrs/apache2-remote-ip.conf
	echo >> cidrs/apache2-remote-ip.conf
	echo RemoteIPHeader CF-Connecting-IP >> cidrs/apache2-remote-ip.conf
	echo >> cidrs/apache2-remote-ip.conf
	jq -r '.[]| "RemoteIPTrustedProxy " + .' cidrs/ipv4-and-ipv6.json  >> cidrs/apache2-remote-ip.conf

cidrs/ipv4-and-ipv6.txt: cidrs/ipv4-and-ipv6.json
	jq -r .[] cidrs/ipv4-and-ipv6.json > cidrs/ipv4-and-ipv6.txt

cidrs/ipv4.txt: cidrs/ipv4.json
	jq -r .[] cidrs/ipv4.json > cidrs/ipv4.txt

cidrs/ipv6.txt: cidrs/ipv6.json
	jq -r .[] cidrs/ipv6.json > cidrs/ipv6.txt

cidrs/ipv4-and-ipv6.json: cidrs cf-response.json
	jq  '(.result.ipv4_cidrs + .result.ipv6_cidrs)' cf-response.json > cidrs/ipv4-and-ipv6.json

cidrs/ipv6.json: cidrs cf-response.json
	jq .result.ipv6_cidrs cf-response.json > cidrs/ipv6.json

cidrs/ipv4.json: cidrs cf-response.json
	jq .result.ipv4_cidrs cf-response.json > cidrs/ipv4.json

cf-response.json:
	curl --silent https://api.cloudflare.com/client/v4/ips > cf-response.json

clean-result:
	rm -rf cidrs

cidrs:
	mkdir cidrs

clean:
	rm -fv cf-response.json
	make clean-result
