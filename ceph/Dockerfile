FROM ceph/demo:tag-build-master-kraken-centos-7

RUN yum -y install iproute && yum clean all

COPY /scripts/entrypoint.sh /scripts/

ENTRYPOINT [ "/scripts/entrypoint.sh" ]
