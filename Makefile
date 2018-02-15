cluster-up:
	vagrant up --no-provision

cluster-provision:
	vagrant provision node
	vagrant provision master
