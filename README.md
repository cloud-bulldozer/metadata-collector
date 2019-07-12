# backpack
Containerization of the Stockpile project (https://github.com/redhat-performance/stockpile)

To create a new container image modify the Dockerfile and then run create_container.sh.
NOTE: you will want to update create_container.sh to use your own image repository

backpack.yaml is to be run on a container platform.
NOTE: On kni based environments it needs to run priviliged. To do this set Allow Privileged to true in the restricted scc

It has been tested on minikube and kni.

It will launch backpack which is the containerized stockpile we built above. 
Set the number of parallelism to be the number of nodes in your environment.

It will then run on each node (it has anti-affinity rules to ensure it runs on unique nodes).
The data is written to stdout in the container. To obtain this information view the logs of the individual container.
