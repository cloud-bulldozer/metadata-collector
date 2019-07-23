FROM centos:7.6.1810

COPY group_vars/ ${HOME}/group_vars/
COPY roles/ ${HOME}/roles/
COPY stockpile.yml ${HOME}/stockpile.yml
COPY hosts ${HOME}/hosts
COPY ansible.cfg ${HOME}/

RUN yum install -y ansible dmidecode which lscpu
RUN mv ansible.cfg /etc/ansible/ansible.cfg
RUN mkdir -p /tmp
RUN sed -i '/become: true/d' roles/dmidecode/tasks/main.yml

CMD ansible-playbook -c local stockpile.yml > /dev/null 2>&1 && cat /tmp/machine_facts.json
