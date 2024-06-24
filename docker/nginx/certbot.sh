docker run -it --rm --name certbot \
            -p 80:80 -p 443:443 \
            -v "$(pwd)/cert:/etc/letsencrypt" \
            certbot/certbot certonly --standalone -d ggraph.jioswap.finance \
                 --non-interactive --agree-tos \
                 --email dezzyboy@glibx.com --expand
