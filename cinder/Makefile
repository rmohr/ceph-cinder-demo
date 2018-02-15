export GO15VENDOREXPERIMENT := 1
DOCKER_ORG=kubevirtci
DOCKER_TAG=latest

all: build

build:
	docker build -t ${DOCKER_ORG}/cinder-ceph-demo:${DOCKER_TAG} images/cinder-ceph-demo

release:
	docker push ${DOCKER_ORG}/cinder-ceph-demo:${DOCKER_TAG}

clean:
	hack/dockerized "./hack/build-go.sh clean ${WHAT} && rm _out/* -rf && rm tools/openapispec/openapispec -rf"
	rm tools/openapispec/openapispec -rf

distclean: clean
	hack/dockerized "rm -rf vendor/ && rm -f .glide.*.hash && glide cc"
	rm -rf vendor/

cluster-up:
	./cluster/up.sh

cluster-down:
	./cluster/down.sh

cluster-deploy:
	./cluster/deploy.sh

.PHONY: all build clean distclean cluster-up cluster-down cluster-deploy
