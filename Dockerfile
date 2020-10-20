FROM registry.access.redhat.com/ubi8:latest

RUN dnf install -y --nodocs git python3-pip hostname dmidecode pciutils procps-ng && dnf clean all
RUN pip3 install --no-cache-dir --upgrade-strategy=only-if-needed ansible==2.10 kubernetes==11 elasticsearch elasticsearch-dsl openshift redis
RUN mkdir -p /backpack && chmod 770 /backpack
ENV HOME /backpack
WORKDIR /backpack
RUN git clone https://github.com/cloud-bulldozer/scribe --depth=1
RUN pip3 install --no-cache-dir -e scribe
RUN git clone https://github.com/cloud-bulldozer/stockpile.git --depth=1 /tmp/stockpile && mv /tmp/stockpile/* .
RUN sed -i '/become: true/d' stockpile.yml
RUN curl -sS https://raw.githubusercontent.com/cloud-bulldozer/bohica/master/stockpile-wrapper/stockpile-wrapper.py -o stockpile-wrapper.py
RUN curl -sS https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/openshift-client-linux.tar.gz | tar xz -C /usr/bin/
RUN chmod +x /usr/bin/oc /usr/bin/kubectl
COPY ansible.cfg .
COPY stockpile_hosts hosts
