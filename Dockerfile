FROM ubuntu:latest
MAINTAINER kost@kost.com

ARG USERNAME=ansible-service-account
EXPOSE 22

RUN apt update 
RUN apt -y install openssh-server sudo net-tools less

RUN groupadd sshgroup
RUN useradd -ms /bin/bash -g sshgroup $USERNAME

USER $USERNAME
RUN mkdir -p /home/$USERNAME/.ssh
COPY id_rsa.pub /home/$USERNAME/.ssh/authorized_keys
RUN mkdir -p /home/$USERNAME/workdir

USER root
RUN chown $USERNAME /home/$USERNAME/.ssh/authorized_keys
RUN chmod 600 /home/$USERNAME/.ssh/authorized_keys
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL " >> /etc/sudoers
RUN chown -R $USERNAME /home/$USERNAME/workdir

RUN service ssh start

CMD ["/usr/sbin/sshd","-D"]
