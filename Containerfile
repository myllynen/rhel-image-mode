FROM registry.redhat.io/rhel9/rhel-bootc:latest

#RUN dnf -y install pcp-system-tools && dnf -C clean all && systemctl enable pmcd.service
RUN dnf -y install pcp-system-tools && systemctl enable pmcd.service

#RUN dnf -y install zsh && dnf -C clean all
RUN dnf -y install zsh

#RUN dnf -y install tcpdump && dnf -C clean all
#RUN dnf -y install tcpdump

ADD etc /etc
