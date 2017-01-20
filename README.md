# RethinkDB Cluster for Openshift

MIT Licensed by Ross Kukulinski [@RossKukulinski](https://twitter.com/rosskukulinski)

## Overview

This repository contains Kubernetes configurations to easily deploy RethinkDB.
By default, all RethinkDB Replicas are configured with Resource Limits and Requests for:

* 512Mi memory
* 200m cpu

In addition, RethinkDB Replicas are configured with a 100Mi cache-size.  All
of these settings can be tuned for your specific needs.

## Start without persistent storage

Start services:
rethinkdb-admin-service
rethinkdb-proxy-service
rethinkdb-replica-service

Start pods:
rethinkdb-admin-pod
rethinkdb-proxy-pod
rethinkdb-replica-pod

Set up a route to rethinkdb admin-service.

If the proxy-pod and the admin-pod is not booting (crash loop bakoff), then its mostly because of the rights to see endpoints in that namespace, or it might not have rights to run as root.
You can check this by opening a terminal to the pod and run this cmd:
curl -H "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" -k -XGET "https://172.30.0.1/api/v1/namespaces/<projectname>/endpoints/"

If you get this error:
"status": "Failure",
"message": "User \"system:deployer\" cannot get namespaces in project \"<prosjektnavn>\"",
"reason": "Forbidden",  
Run "oc policy add-role-to-group view system:serviceaccounts -n <prosjektnavn>" (may need admin or cluster-admin).
Test the curl-command again.

If everything above is ok, check if the route to the admin-service is working. Test by scaling the rethink-rc up and down (servers will connect and disconnect in admin-gui).

## GKE/GCE Configuration with persistent storage (recommended)

Due to the way persistent volumes are handled in Kubernetes, we have to have one RC per replica, each with its own persistent volume.  The RC is used to create a new pod should there be any issues.
