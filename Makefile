cluster-up:
	vagrant up --no-provision

cluster-provision:
	vagrant provision node
	vagrant provision master

cluster-provisioner:
	vagrant provision --provision-with=provisioner
