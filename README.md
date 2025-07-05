# cloudflare-ip-ranges

Compilation of cloudflare's IP ranges.

All available formats are available on "[cidrs](cidrs/)" directory.

- [apache2-remote-ip.conf](cidrs/apache2-remote-ip.conf):
  you can use this file for configuring mod_remoteip of your apache2 web server
  if your apache2 is behind cloudflare service.
- [nginx-http-realip-module](cidrs/nginx-http-realip-module.conf):
  you can use this file for configuring nginx
  if your nginx is behind cloudflare service.
- [ipv4-and-ipv6.json](cidrs/ipv4-and-ipv6.json):
  all cloudflare's CIDR (IPv4 and IPv6) in JSON format.
- [ipv4-and-ipv6.txt](cidrs/ipv4-and-ipv6.txt):
  all cloudflare's CIDR (IPv4 and IPv6) in plain text format.
- [ipv4-and-ipv6.single-line.json](cidrs/ipv4-and-ipv6.single-line.json):
  all cloudflare's CIDR (IPv4 and IPv6) in single line JSON format.
- [ipv4-and-ipv6.single-line.txt](cidrs/ipv4-and-ipv6.single-line.txt):
  all cloudflare's CIDR (IPv4 and IPv6) in single line plain text format.
- [ipv4.json](cidrs/ipv4.json):
  all IPv4 cloudflare's CIDR in JSON format.
- [ipv4.txt](cidrs/ipv4.txt):
  all IPv4 cloudflare's CIDR in plain text format.
- [ipv4.single-line.json](cidrs/ipv4.single-line.json):
  all IPv4 cloudflare's CIDR in single line JSON format.
- [ipv4.single-line.txt](cidrs/ipv4.single-line.txt):
  all IPv4 cloudflare's CIDR in single line plain text format.
- [ipv6.json](cidrs/ipv6.json):
  all IPv6 cloudflare's CIDR in JSON format.
- [ipv6.txt](cidrs/ipv6.txt):
  all IPv6 cloudflare's CIDR in plain text format.
- [ipv6.single-line.json](cidrs/ipv6.single-line.json):
  all IPv6 cloudflare's CIDR in single line JSON format.
- [ipv6.single-line.txt](cidrs/ipv6.single-line.txt):
  all IPv6 cloudflare's CIDR in single line plain text format.

## Data source
All files compiled from fetch result of official Cloudflare's API
(https://api.cloudflare.com/client/v4/ips).
