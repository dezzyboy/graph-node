
# Graph Node Docker Image (Nginx/LetsEncrypt Edition)

Preconfigured Docker image for running a Graph Node behind an Nginx reverse proxy secured with a LetsEncrypt SSL certificate.

## Docker Compose

The Docker Compose setup requires an Ethereum network name and node
to connect to. By default, it will use `mainnet:http://host.docker.internal:8545`
in order to connect to an Ethereum node running on your host machine.
You can replace this with anything else in `docker-compose.yaml`.

> **Note for Linux users:** On Linux, `host.docker.internal` is not
> currently supported. Instead, you will have to replace it with the
> IP address of your Docker host (from the perspective of the Graph
> Node container).
> To do this, run:
>
> ```
> CONTAINER_ID=$(docker container ls | grep graph-node | cut -d' ' -f1)
> docker exec $CONTAINER_ID /bin/bash -c 'apt install -y iproute2 && ip route' | awk '/^default via /{print $3}'
> ```
>
> This will print the host's IP address. Then, put it into `docker-compose.yml`:
>
> ```
> sed -i -e 's/host.docker.internal/<IP ADDRESS>/g' docker-compose.yml
> ```

After you have set up an Ethereum node—e.g. Ganache or Parity—simply
clone this repository and do the following:

Navigate to `graph-node/nginx` and edit `certbot.sh`.
Configure your domain and email

Then, run:

```sh
sudo ./certbot.sh
```

Make sure cert directory was created. If not, check your firewall rules.

Edit `graph-node/nginx/conf.d/default.conf` and change `example.com` to your domain on the following lines:
```sh
server_name example.com;
...
server_name example.com;

ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
```

Now, you are ready to build the container in `graph-node/docker`:

```sh
sudo docker-compose up
```

This will start IPFS, Postgres, Graph Node, and Nginx in Docker and create persistent
data directories for IPFS and Postgres in `./data/ipfs` and `./data/postgres`. You
can access these via:

- Graph Node:
  - GraphiQL: `https://example.com/`
  - HTTP: `http://example.com/subgraphs/name/<subgraph-name>`
  - HTTP: `http://example.com:8000/subgraphs/name/<subgraph-name>`
  - HTTPS: `https://example.com/subgraphs/name/<subgraph-name>`
  - WebSockets: `ws://example.com:8001/subgraphs/name/<subgraph-name>`
  - Admin: `http://localhost:8020/` (Make sure to block admin port in your network firewall or it will be exposed on example.com as well)
- IPFS:
  - `127.0.0.1:5001` or `/ip4/127.0.0.1/tcp/5001`
- Postgres:
  - `postgresql://graph-node:let-me-in@localhost:5432/graph-node`

Once this is up and running, you can use
[`graph-cli`](https://github.com/graphprotocol/graph-cli) to create and
deploy your subgraph to the running Graph Node.

