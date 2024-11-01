HOST_ARCHITECTURE=el7_altarch

default: build

build: ${HOST_ARCHITECTURE}

el7_x86_64:
	docker build -f Dockerfile.el7.x86_64 -t harbor.einscat.com:10011/library/centos7:x86_64 .

ubuntu2004_amd64:
	docker build -f Dockerfile.ubuntu2004.amd64 -t harbor.einscat.com:10011/library/ubuntu2004:amd64 .

el7_altarch:
	docker build -f Dockerfile.el7.altarch -t harbor.einscat.com:10011/library/centos7:altarch .
