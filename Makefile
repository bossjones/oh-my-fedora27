mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

.PHONY: list help

help:
	@echo "Convenience Make commands for provisioning a scarlett node"

list:
	@$(MAKE) -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /);for(i in A)print A[i]}' | sort

vagrant-provision:
	vagrant provision

vagrant-up:
	vagrant up

vagrant-ssh:
	ssh -X -F ssh_config_vagrant vagrant@oh_my_fedora27

vagrant-destroy:
	vagrant destroy

vagrant-halt:
	vagrant halt

vagrant-config:
	vagrant ssh-config > ssh_config_vagrant

vagrant-ssh-x11:
	vagrant ssh -- -X

serverspec-diff:
	cat serverspec_things_to_check_for.txt

serverspec:
	bundle exec rake

serverspec-install:
	bundle install --path .vendor

make-host-file:
	echo "localhost ansible_connection=local ansible_python_interpreter=${_PATH_TO_PYTHON}" > hosts.private

download-roles:
	ansible-galaxy install -r install_roles.txt --roles-path roles/

download-roles-advanced:
	ansible-galaxy install -r requirements.yml --roles-path roles/

install-cidr-brew:
	pip install cidr-brewer

install-test-deps:
	pip install ansible==2.2.3.0
	pip install docker-py
	pip install molecule --pre

bootstrap-molecule:
	molecule init scenario --role-name $(current_dir) --scenario-name default

ci:
	molecule test
