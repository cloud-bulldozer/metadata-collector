FROM centos/python-36-centos7

USER root
COPY group_vars/ ${HOME}/group_vars/
COPY hosts ${HOME}/hosts
COPY ansible.cfg ${HOME}/
COPY stockpile.yml ${HOME}/stockpile.yml
COPY roles/ ${HOME}/roles/

RUN yum install -y epel-release 
RUN yum install -y ansible dmidecode which
RUN mv ansible.cfg /etc/ansible/ansible.cfg
RUN mkdir -p /tmp
RUN sed -i '/become: true/d' stockpile.yml

CMD ansible-playbook -c local stockpile.yml > /dev/null 2>&1 && cat /tmp/machine_facts.json && echo "BACKPACK_DONE" && sleep 1h

