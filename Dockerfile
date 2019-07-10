FROM centos:7.6.1810

COPY group_vars/ ${HOME}/group_vars/
COPY roles/ ${HOME}/roles/
COPY stockpile.yml ${HOME}/stockpile.yml
COPY hosts ${HOME}/hosts

RUN yum install -y ansible

CMD ansible-playbook -i hosts -c local stockpile.yml
