export GO15VENDOREXPERIMENT := 1

all: build

build:
	hack/dockerized "hack/glide-checksync.sh && ./hack/check.sh && ./hack/build-go.sh install ${WHAT}"

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

cluster-sync: cluster-build cluster-deploy

.PHONY: all build clean distclean cluster-up cluster-down cluster-deploy cluster-sync
