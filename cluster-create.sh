#!/bin/bash

token=$(docker run --rm swarm create)

 Create the KV node using consul
docker-machine create \
    -d digitalocean \
    --digitalocean-access-token=$DO_ACCESS_TOKEN \
    consul

docker-machine ssh consul docker run -d \
    -p "8500:8500" \
    -h "consul" \
    progrium/consul -server -bootstrap

KV_IP=$(docker-machine ip consul)
KV_ADDR="consul://${KV_IP}:8500"

# Swarm manager machine
echo "Create swarm manager"
docker-machine create \
    -d digitalocean \
    --digitalocean-access-token=$DO_ACCESS_TOKEN \
    --swarm --swarm-master \
    --swarm-discovery=$KV_ADDR \
    --engine-opt="cluster-store=${KV_ADDR}" \
    --engine-opt="cluster-advertise=eth0:2376" \
    manager

    echo "Creating ${agent}"

docker-machine create \
    -d digitalocean \
    --digitalocean-access-token=$DO_ACCESS_TOKEN \
    --swarm \
    --swarm-discovery=$KV_ADDR \
    --engine-opt="cluster-store=${KV_ADDR}" \
    --engine-opt="cluster-advertise=eth0:2376" \
    backend &
docker-machine create \
    -d digitalocean \
    --digitalocean-access-token=$DO_ACCESS_TOKEN \
    --swarm \
    --swarm-discovery=$KV_ADDR \
    --engine-opt="cluster-store=${KV_ADDR}" \
    --engine-opt="cluster-advertise=eth0:2376" \
    public &
wait

# Information
echo ""
echo "CLUSTER INFORMATION"
echo "discovery token: ${token}"
echo "Environment variables to connect trough docker cli"
docker-machine env --swarm manager
