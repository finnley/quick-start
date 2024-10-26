HOST_ARCHITECTURE=el7_x86_64

default: build

build: ${HOST_ARCHITECTURE}

el7_x86_64:
	docker build -f Dockerfile.el7.x86_64 -t reg.einscat.com:10010/library/centos7:x86_64 .

el7_altarch:
	docker build -f Dockerfile.el7.altarch -t reg.einscat.com:10010/library/centos7:altarch .

ubuntu2004_amd64:
	docker build -f Dockerfile.ubuntu2004.amd64 -t reg.einscat.com:10010/library/ubuntu2004:amd64 .
