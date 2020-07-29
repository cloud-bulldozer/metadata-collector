# Backpack
Metadata collection and indexing tool.

Metadata is obtained by using the Stockpile project (https://github.com/redhat-performance/stockpile) within the container.
Doing so eliminates the need to install additional packages on systems which may be imutable

# Creating a new image

To create a new container image modify the Dockerfile and then run create_container.sh.

NOTE: Update create_container.sh and backpack.yml to use your own image repository if building a new image.

# Basic information

The main script within backpack is the stockpile-wrapper. This can be located [here](https://github.com/cloud-bulldozer/bohica/blob/master/stockpile-wrapper/stockpile-wrapper.py).

This wrapper script will run a collection of stockpile in the container and then, optionally, push it to an Elasticsearch instance.

The two flags to the wrapper that will likely always be used is for indexing. Using -s and -p you can pass the Elasticsearch server and port information like this:

```
python3 stockpile-wrapper.py -s foo.es -p 9200
```

# Running with Podman/Docker

In many cases backpack will be run with some container orchestration, however it can be run easily with podman as well.

```
sudo podman run --privileged quay.io/cloud-bulldozer/backpack python3 stockpile-wrapper.py -s foo.es -p 9200
```

*NOTE* While it is not required to run the container in privileged mode, you will get far less information if done without privileges.

# Running with run_backpack.sh

Backpack can be easily executed with the run_backpack.sh script in the kubernetes environment as well

The script takes a few notable options:
- -s: the elasticsearch server
- -p: the elasticsearch port
- -n: the namespace to be used (it will be created if it does not already exist but will NOT be delete)
- -x: true|false - if the pods should run with elevated privileges
- -a: true|false - if you wish to apply the backpack-view service account and role to gather additional details
- -c: true|false - if true after all pods have collected their data the daemonset will be cleaned up
- -u: UUID - if you wish to pass a specific UUID otherwise one will be generated for you
- -l: label name - if you wish to target servers with a specific label you can enter the label name here. It is expected to be used with -v for the value
- -v: label value - if you wish to target servers with a specific label you can enter the label value here. It is expected to be used with -l for the name
- -i: custom backpack image location
- -h: help page

*NOTE* If using the lable name/value and no node is found to match the script will quickly create and delete the daemonset

*NOTE* If -c is false (the default) then the daemonset will not be cleaned up and you can reference the pods at any time

Each run of the script will create a backpack_$UUID.yml file for the run. It will not get deleted in case you wish to reference it later.

An example execution:

```
$ ./run_backpack.sh -s foo.es -p 9200 -c true -l foo -v bar2
Running Backpack with the following options
ES Server: foo.es
ES Port: 9200
Namespace: backpack
Privileged: false
Account: false
Cleanup: true
UUID: 60ebe07c-5944-4169-8c4e-fbf9f9d79ad0
namespace/backpack created
daemonset.apps/backpack-60ebe07c-5944-4169-8c4e-fbf9f9d79ad0 created
daemonset.apps "backpack-60ebe07c-5944-4169-8c4e-fbf9f9d79ad0" deleted
```

*NOTE* If you see an error that states the namespace already exists it is safe to ignore.

# Privileges

If not privileged and with the default service account the data gathered will be limited.
If you wish to obtain the full set of information you will need to allow the containers to be 
privileged and setup a service account with proper read/view privileges. Please see
backpack_role.yaml for a correctly configured service account.

It will launch the backpack daemon set, which is the containerized stockpile 
we built above, on all nodes of the cluster (including the masters). 
Note: It will not reach "running" state until after the stockpile collection and indexing is complete.
Additionally, it will never go to complete state as the DaemonSet would restart it.

The data is written to /tmp/stockpile.json in the container.

Backpack will create multiple indexes in the targeted Elasticsearch server, depending on
which metadata collection modules run.   These indexes all have names with "-metadata" in the 
suffix so they are not hard to find.   The contents are usually self-explanatory and
can be browsed with kibana for example.
