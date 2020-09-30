#!/bin/bash

###
# Default settings
###

CLEANUP=true
PRIVILEGED=false
NAMESPACE=backpack
UUID=`uuidgen`
LABEL_NAME=""
LABEL_VALUE=""
IMAGE="quay.io/cloud-bulldozer/backpack:latest"

while getopts s:p:n:xa:t:c:u:l:v:i:h flag
do
    case "${flag}" in
        s) ES_SERVER=${OPTARG};;
        p) ES_PORT=${OPTARG};;
        n) NAMESPACE=${OPTARG};;
        x) PRIVILEGED=true;;
        c) CLEANUP=${OPTARG};;
        u) UUID=${OPTARG};;
        l) LABEL_NAME=${OPTARG};;
        v) LABEL_VALUE=${OPTARG};;
        i) IMAGE=${OPTARG};;
        h) echo "Usage: run_backpack.sh [-s ELASTICSERCH_SERVER] [-p ELASTICSEARCH_PORT] [-c true|false] [-n NAMESPACE] [-x] [-u UUID] [-l LABEL_NAME] [-v LABEL_VALUE] [-i IMAGE]" ; exit ;;
        ?) echo "Usage: run_backpack.sh [-s ELASTICSERCH_SERVER] [-p ELASTICSEARCH_PORT] [-c true|false] [-n NAMESPACE] [-x] [-u UUID] [-l LABEL_NAME] [-v LABEL_VALUE] [-i IMAGE]" ; exit 1 ;;
    esac
done

echo "Running Backpack with the following options"
echo "ES Server: "$ES_SERVER
echo "ES Port: "$ES_PORT
echo "Namespace: "$NAMESPACE
echo "Privileged: "$PRIVILEGED
echo "Cleanup: "$CLEANUP
echo "UUID: "$UUID

cp backpack_daemonset.yml backpack_$UUID.yml

sed -i "s/{UUID}/$UUID/g" backpack_$UUID.yml
sed -i "s/{NAMESPACE}/$NAMESPACE/g" backpack_$UUID.yml
sed -i "s?{ELASTICSEARCH_SERVER}?-s $ES_SERVER?g" backpack_$UUID.yml
sed -i "s/{ELASTICSEARCH_PORT}/-p $ES_PORT/g" backpack_$UUID.yml
sed -i "s/{PRIV}/$PRIVILEGED/g" backpack_$UUID.yml
sed -i "s?{IMAGE}?$IMAGE?g" backpack_$UUID.yml

kubectl create namespace $NAMESPACE

if [[ $PRIVILEGED == "true" ]]
then
  sed -i "s/{ACCOUNT}/backpack-view/g" backpack_$UUID.yml
  cp backpack_role.yaml backpack_role_$UUID.yaml
  sed -i "s/{NAMESPACE}/$NAMESPACE/g" backpack_role_$UUID.yaml
  kubectl apply -f backpack_role_$UUID.yaml
  if [[ `command -v oc` ]]
  then
    if [[ `oc get securitycontextconstraints.security.openshift.io` ]]
    then
      oc adm policy -n $NAMESPACE add-scc-to-user privileged -z backpack-view
    fi
  fi
else
  sed -i "s/{ACCOUNT}/default/g" backpack_$UUID.yml
fi


if [[ $LABEL_NAME != "" && $LABEL_VALUE != "" ]]
then
  cat <<EOT >> backpack_$UUID.yml
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: $LABEL_NAME
                operator: In
                values:
                - $LABEL_VALUE
EOT
fi

kubectl apply -f backpack_$UUID.yml

while [[ `kubectl -n $NAMESPACE get pods -l=name=backpack-$UUID -o jsonpath='{range .items[*]}{.status.containerStatuses[*].ready}{"\n"}{end}' | grep false` ]]
do
  sleep 15
done

if [[ $CLEANUP == "true" ]]
then
  if [[ $ACCOUNT == "true" ]]
  then
    kubectl delete -f backpack_role_$UUID.yaml
  fi
  kubectl delete -f backpack_$UUID.yml
fi
