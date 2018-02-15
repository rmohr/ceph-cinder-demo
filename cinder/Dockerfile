FROM kubevirtci/cinder:intermediate

RUN yum -y install python-rbd python-rados iproute ceph-common && yum clean all

COPY etc/* /etc/cinder/
COPY scripts/* /scripts/
