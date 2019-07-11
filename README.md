# backpack
Containerization of the Stockpile project (https://github.com/redhat-performance/stockpile)

To create a new container image modify the Dockerfile and then run create_container.sh.
NOTE: you will want to update create_container.sh to use your own image repository

backpack.yaml is to be run on a container platform. It will launch backpack which is
the containerized stockpile we built above. Set the number of replicas to be the number
of nodes in your environment.
