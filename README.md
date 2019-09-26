# backpack
Containerization of the Stockpile project (https://github.com/redhat-performance/stockpile)

To create a new container image modify the Dockerfile and then run create_container.sh.

NOTE: Update create_container.sh and backpack.yaml to use your own image repository if building a new image.

backpack.yaml is to be run on a container platform. However, the container can
run on with generic Docker/podman as well.
NOTE: The container needs to run priviliged on OpenShift based systems.
To do this set Allow Privileged to true in the restricted scc

It has been tested on minikube and kni.

It will launch the backpack daemon set, which is the containerized stockpile 
we built above, on all nodes of the cluster. 
Note: since it is a daemon set it will restart once complete (there is a 1 hour
wait after the stockpile job runs so be sure to get the logs at that time).

The data is written to stdout in the container. To obtain this information view the logs of the individual container.
