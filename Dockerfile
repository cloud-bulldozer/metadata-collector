FROM centos:7.6.1810

COPY group_vars/ ${HOME}/group_vars/
COPY roles/ ${HOME}/roles/
COPY stockpile.yml ${HOME}/stockpile.yml
COPY hosts ${HOME}/hosts
COPY ansible.cfg ${HOME}/
COPY backpack-wrapper.py ${HOME}/backpack-wrapper.py

RUN yum install -y epel-release
RUN yum install -y ansible dmidecode which python-elasticsearch
RUN mv ansible.cfg /etc/ansible/ansible.cfg
RUN mkdir -p /tmp
RUN sed -i '/become: true/d' roles/dmidecode/tasks/main.yml

CMD ansible-playbook -c local stockpile.yml > /dev/null 2>&1 && cat /tmp/machine_facts.json

