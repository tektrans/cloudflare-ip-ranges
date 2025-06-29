NEED_COMMIT=$(shell git status --porcelain)
VERSION=$(shell date -Iseconds -u)

all: \
	cidrs/ipv4.json cidrs/ipv6.json cidrs/ipv4-and-ipv6.json \
	cidrs/ipv4.txt cidrs/ipv6.txt cidrs/ipv4-and-ipv6.txt \
	cidrs/ipv4.single-line.txt cidrs/ipv6.single-line.txt\
	cidrs/ipv4.single-line.json cidrs/ipv6.single-line.json \
	cidrs/ipv4-and-ipv6.single-line.txt \
	cidrs/ipv4-and-ipv6.single-line.json\
	cidrs/apache2-remote-ip.conf

commit-and-push:
	@[ "${NEED_COMMIT}" ] || (echo Nothing to commit; exit 0)
	git add .
	git commit -a -m ${VERSION}
	git tag -a v${VERSION} -m v${VERSION}
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
