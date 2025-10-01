#
# Builder images
#
FROM registry.redhat.io/rhel9/rhel-bootc:latest as ansible-stage
RUN dnf -y install ansible-core rhel-system-roles
RUN mkdir -p /deps
# Generate list of package dependencies for roles to be used for images during runtime
RUN for role in firewall sshd; do \
      /usr/share/ansible/collections/ansible_collections/redhat/rhel_system_roles/roles/$role/.ostree/get_ostree_data.sh packages runtime RedHat-9 raw >> /deps/ansible.txt ; \
    done

#
# RHEL bootc image
#
FROM registry.redhat.io/rhel9/rhel-bootc:latest

# Install role dependencies
RUN --mount=type=bind,from=ansible-stage,source=/deps,target=/deps dnf -y install $(cat /deps/ansible.txt)

#RUN dnf -y install pcp-system-tools && dnf -C clean all && systemctl enable pmcd.service
RUN dnf -y install pcp-system-tools && systemctl enable pmcd.service

#RUN dnf -y install zsh && dnf -C clean all
RUN dnf -y install zsh

#RUN dnf -y install tcpdump && dnf -C clean all
#RUN dnf -y install tcpdump

ADD etc /etc
