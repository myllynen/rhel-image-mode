#
# Builder image
#
FROM registry.redhat.io/rhel9/rhel-bootc:latest as builder

RUN dnf -y install ansible-core rhel-system-roles
# Add custom and updated collections
ADD dot-ansible /root/dot-ansible
# Add commands and playbooks
ADD ansible /root/ansible
RUN cp -p /usr/bin/ansible-config /root/ansible/ansible-config
RUN cp -p /usr/bin/ansible-galaxy /root/ansible/ansible-galaxy
# The systemd prefix is needed for ansible.builtin.service to work
RUN cp -p /usr/bin/ansible-playbook /root/ansible/systemd-ansible-playbook

# Generate list of package dependencies for roles to be used during runtime
# See meta/mail.yml of each role to see if it supports bootc containerbuild
RUN mkdir -p /deps
RUN for role in crypto_policies firewall storage; do \
      cd /usr/share/ansible/collections/ansible_collections/redhat/rhel_system_roles/roles ; \
      ./$role/.ostree/get_ostree_data.sh packages runtime RedHat-9 raw >> /deps/ansible.txt ; \
    done

# Install packages in builder to provide dependencies for bind mounts
RUN dnf -y install $(cat /deps/ansible.txt)


#
# RHEL bootc image
#
FROM registry.redhat.io/rhel9/rhel-bootc:latest

# Install role dependencies
#RUN --mount=type=bind,from=builder,source=/deps,target=/deps dnf -y install $(cat /deps/ansible.txt) && dnf -C clean all
RUN --mount=type=bind,from=builder,source=/deps,target=/deps dnf -y install $(cat /deps/ansible.txt)

# Configure image with Ansible roles
RUN --mount=type=bind,from=builder,source=/usr/lib/python3.9/site-packages,target=/usr/lib/python3.9/site-packages,ro \
    --mount=type=bind,from=builder,source=/root/dot-ansible,target=/root/.ansible,rw \
    --mount=type=bind,from=builder,source=/root/ansible,target=/root/ansible,ro \
    /root/ansible/ansible-galaxy collection list && \
    /root/ansible/ansible-config dump --only-changed && \
    /root/ansible/systemd-ansible-playbook --version && \
    /root/ansible/systemd-ansible-playbook -c local -i localhost, /root/ansible/baseline.yml

#RUN dnf -y install pcp-system-tools && dnf -C clean all && systemctl enable pmcd.service
RUN dnf -y install pcp-system-tools && systemctl enable pmcd.service

#RUN dnf -y install zsh && dnf -C clean all
RUN dnf -y install zsh

#RUN dnf -y install tcpdump && dnf -C clean all
#RUN dnf -y install tcpdump

ADD etc /etc
