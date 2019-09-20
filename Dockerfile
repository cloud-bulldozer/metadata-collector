FROM centos/python-36-centos7

USER root
COPY group_vars/ ${HOME}/group_vars/
COPY roles/ ${HOME}/roles/
COPY stockpile.yml ${HOME}/stockpile.yml
COPY hosts ${HOME}/hosts
COPY ansible.cfg ${HOME}/
COPY backpack-wrapper.py ${HOME}/backpack-wrapper.py
COPY scribe ${HOME}/scribe

RUN yum install -y epel-release 
RUN yum install -y ansible dmidecode which python-pip
RUN pip install --upgrade pip
RUN pip install elasticsearch
RUN pip install -e scribe/
RUN mv ansible.cfg /etc/ansible/ansible.cfg
RUN mkdir -p /tmp
RUN sed -i '/become: true/d' roles/dmidecode/tasks/main.yml
RUN sed -i 's/become: true/ignore_errors: yes/' stockpile.yml

CMD ansible-playbook -c local stockpile.yml > /dev/null 2>&1 && cat /tmp/machine_facts.json

