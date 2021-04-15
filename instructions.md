### Prerequisite
1) helm should be installed and configured with kubectl
2) openebs should be setup and class should be created with openebs provsionor
3) should have the cluster-admin access
4) labels `nodeType=mongos` `nodeType=shard` `nodeType=config-server` should be assigned to your worker nodes
### Debug
1) execute 
```bash
$ make debug
```
2) look at the yaml file with *dry-run.yaml format
3) look for keys which are parsed or not with kubernetes yaml templates

### Installation
1) create namespace
```bash
$ make createns ns=mynamespace
```
2) either set annotation of your default storage class `storageclass.kubernetes.io/is-default-class: true``` or perform step 3
3) get the name of storage class and update the values.yaml `storageClass` in global scope and the other scope
4) execute command
```bash
$ make install ns=mynamespace release=myrelase 
$ # or just execute
$ make install
```
5) helm ls
6) also kubectl all -n yournamespace you will be able to see the deployment

### Uninstall
```bash
$ make uninstall release=yourrelase
```


### Test
kubectl port-forward mongodb-sharded-shard0-data-0  27017:27017