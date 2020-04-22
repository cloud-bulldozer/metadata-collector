# backpack
Containerization of the Stockpile project (https://github.com/redhat-performance/stockpile)

To create a new container image modify the Dockerfile and then run create_container.sh.

NOTE: Update create_container.sh and backpack.yml to use your own image repository if building a new image.

backpack.yml is to be run on a container platform. However, the container can
run via Docker/podman as well.

You will need to update the backpack.yml file to supply your own trunc_uuid for unique identification
as well as adjust the securityContext and serviceAccountName.

If not privileged and with the default service account the data gathered will be limited.
If you wish to obtain the full set of information you will need to allow the containers to be 
privileged and setup a service account with proper read/view privileges. Please see
backpack_role.yaml for a correctly configured service account.

It will launch the backpack daemon set, which is the containerized stockpile 
we built above, on all nodes of the cluster (including the masters). 
Note: It will not reach "running" state until after the stockpile collection is complete.
Additionally, it will never go to complete state as the DaemonSet would restart it so
it will need to be cleaned up once you are finished with it.

The data is written to /tmp/stockpile.json in the container.

If you want to disable backpack because you are debugging a ripsaw workload, etc., you can do so by
setting metadata_collection: false in the ripsaw CR.

Backpack will create multiple indexes in the targeted Elasticsearch server, depending on
which metadata collection modules run.   These indexes all have names with "-metadata" in the 
suffix so they are not hard to find.   The contents are usually self-explanatory and
can be browsed with kibana for example.

