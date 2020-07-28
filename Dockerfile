FROM registry.access.redhat.com/ubi8:latest

RUN dnf install -y --nodocs git python3-pip hostname dmidecode pciutils procps-ng && dnf clean all
RUN pip3 install --no-cache-dir  ansible elasticsearch elasticsearch-dsl openshift kubernetes redis
RUN git clone https://github.com/cloud-bulldozer/scribe ${HOME}/scribe --depth=1
RUN pip3 install --no-cache-dir  -e ${HOME}/scribe
COPY ansible.cfg /etc/ansible/ansible.cfg
RUN git clone https://github.com/cloud-bulldozer/stockpile.git --depth=1 /tmp/stockpile && mv /tmp/stockpile/* ${HOME}
RUN sed -i '/become: true/d' ${HOME}/stockpile.yml
RUN curl https://raw.githubusercontent.com/cloud-bulldozer/bohica/master/stockpile-wrapper/stockpile-wrapper.py -o ${HOME}/stockpile-wrapper.py
RUN curl https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/openshift-client-linux.tar.gz | tar xz -C /usr/bin/
RUN chmod +x /usr/bin/oc /usr/bin/kubectl
RUN ln -s /usr/local/bin/ansible-playbook /usr/bin/ansible-playbook
RUN mkdir -p /opt/app-root/bin/ && ln -s /usr/bin/python3 /opt/app-root/bin/python

WORKDIR /root
