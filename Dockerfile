FROM registry.access.redhat.com/ubi8:latest

RUN dnf install -y --nodocs git python3-pip hostname dmidecode pciutils procps-ng && dnf clean all
RUN pip3 install --no-cache-dir  ansible elasticsearch elasticsearch-dsl openshift kubernetes redis
RUN git clone https://github.com/cloud-bulldozer/scribe ${HOME}/scribe --depth=1
RUN pip3 install --no-cache-dir  -e ${HOME}/scribe
RUN git clone https://github.com/cloud-bulldozer/stockpile.git --depth=1 /tmp/stockpile && mv /tmp/stockpile/* ${HOME}
RUN sed -i '/become: true/d' ${HOME}/stockpile.yml
RUN curl -sS https://raw.githubusercontent.com/cloud-bulldozer/bohica/master/stockpile-wrapper/stockpile-wrapper.py -o ${HOME}/stockpile-wrapper.py
RUN curl -sS https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/openshift-client-linux.tar.gz | tar xz -C /usr/bin/
RUN chmod +x /usr/bin/oc /usr/bin/kubectl
COPY ansible.cfg /etc/ansible/ansible.cfg
COPY stockpile_hosts /root/hosts

WORKDIR /root
