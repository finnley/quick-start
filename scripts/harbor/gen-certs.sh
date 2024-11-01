#!/bin/bash

# 参考：https://goharbor.io/docs/2.11.0/install-config/configure-https/

# Step 1: Generate a Certificate Authority Certificate
# 生成CA证书
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -sha512 -days 3650 \
  -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=harbor.einscat.com" \
  -key ca.key \
  -out ca.crt

# Step 2: Generate a Server Certificate
# 使用CA证书生成服务端证书
openssl genrsa -out harbor.einscat.com.key 4096
openssl req -sha512 -new \
  -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=harbor.einscat.com" \
  -key harbor.einscat.com.key \
  -out harbor.einscat.com.csr

cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=harbor.einscat.com
DNS.2=einscat
DNS.3=VM-0-2-centos
EOF

openssl x509 -req -sha512 -days 3650 \
  -extfile v3.ext \
  -CA ca.crt -CAkey ca.key -CAcreateserial \
  -in harbor.einscat.com.csr \
  -out harbor.einscat.com.crt

# Step 3: Provide the Server Certificate and Key to Harbor
# 将CA证书配置到docker环境，并重启 Docker
mkdir -p /data/cert
cp harbor.einscat.com.crt /data/cert/
cp harbor.einscat.com.key /data/cert/

openssl x509 -inform PEM -in harbor.einscat.com.crt -out harbor.einscat.com.cert
mkdir -p /etc/docker/certs.d/harbor.einscat.com/
cp harbor.einscat.com.cert /etc/docker/certs.d/harbor.einscat.com/
cp harbor.einscat.com.key /etc/docker/certs.d/harbor.einscat.com/
cp ca.crt /etc/docker/certs.d/harbor.einscat.com/

systemctl restart docker

# 使用说明
# harbor.example.com 是搭建好后 Harbor 的访问地址
# 后续可以使用下面命令进行替换
# sed -i 's/harbor.example.com/your_domain/g' ./gen-certs.sh.example
# 如 sed -i 's/harbor.example.com/harbor.xxxx.com/g' ./gen-certs.sh.example