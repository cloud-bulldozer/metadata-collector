FROM centos/python-36-centos7

USER root
COPY group_vars/ ${HOME}/group_vars/
COPY hosts ${HOME}/hosts
COPY ansible.cfg ${HOME}/
COPY stockpile.yml ${HOME}/stockpile.yml
COPY roles/ ${HOME}/roles/
COPY stockpile-wrapper.py ${HOME}/stockpile-wrapper.py
COPY scribe ${HOME}/scribe
COPY kubectl /usr/local/bin/kubectl

RUN yum install -y epel-release 
RUN yum install -y ansible dmidecode which python-pip pciutils
RUN pip3 install --upgrade pip
RUN pip3 install elasticsearch-dsl
RUN pip3 install openshift
RUN pip3 install kubernetes
RUN pip3 install redis
RUN pip3 install -e scribe/
RUN mv ansible.cfg /etc/ansible/ansible.cfg
RUN mkdir -p /tmp
RUN sed -i '/become: true/d' stockpile.yml
RUN chmod +x /usr/local/bin/kubectl

CMD sleep infinity
