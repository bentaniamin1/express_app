#!/bin/bash

mkdir -p ~/docker-certs && cd ~/docker-certs

# Generate CA (Certificate Authority)
openssl genrsa -aes256 -out ca-key.pem 4096
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem

# Generate cert for server (Docker in Docker)
openssl genrsa -out server-key.pem 4096
openssl req -subj "/CN=dind" -sha256 -new -key server-key.pem -out server.csr
echo "subjectAltName = DNS:dind,IP:127.0.0.1" > extfile.cnf
openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -out server-cert.pem -extfile extfile.cnf

# Generate cert for client (Docker client)
openssl genrsa -out client-key.pem 4096
openssl req -subj "/CN=client" -new -key client-key.pem -out client.csr
echo "extendedKeyUsage = clientAuth" > client-extfile.cnf

openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -out client-cert.pem -extfile client-extfile.cnf