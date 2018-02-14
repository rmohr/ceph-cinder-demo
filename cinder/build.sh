#docker build https://git.openstack.org/openstack/loci.git \
#	--build-arg PROJECT=cinder \
#	--build-arg FROM=centos:7 \
#	--build-arg PROJECT_REF=stable/ocata \
#	--tag kubevirtci/cinder:intermediate
docker build . -t kubevirtci/cinder:ocata
