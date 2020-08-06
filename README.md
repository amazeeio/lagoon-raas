# Lagoon Redis as a Service Operator

[![Build Status](https://travis-ci.org/amazeeio/lagoon-raas.svg?branch=master)](https://travis-ci.org/amazeeio/lagoon-raas)

## Overview

The Lagoon Redis as a Service operator allows a project to setup a redis service that points to a shared redis host.
It also creates a cache key prefix and attaches the configuration to a lagoon-env ConfigMap.

## Custom Resource.

To create a new service add a `RedisService` object to a namespace.
Only the name is required, if the spec data if not set the operator will create them for you.

```
apiVersion: amazee.io/v1alpha1
kind: RedisService
metadata:
  name: lagoon-raas
spec:
  # redis_host_external:
  # redis_host_internal:
  # redis_port:
  # redis_cache_key_prefix:
```

## Prerequisites

- [docker][docker_tool] version 17.03+
- [kubectl][kubectl_tool] v1.12+
- [operator_sdk][operator_install]

### Building the operator

Run `make build` to rebuild the operator image and push it to the registry.

### Installing


Run `make install` to install the operator. Check that the operator is running in the cluster.

Following the expected result. 

```shell
$ oc get pod -n lagoon-raas
NAME                           READY   STATUS    RESTARTS   AGE
lagoon-raas-78467d8f64-trmsj   2/2     Running   0          22s
```

Update the `REDIS_HOST` and `REDIS_PORT` environment variables on the operator deployment with the default values of a shared redis cluster.

### Uninstalling 

To uninstall all that was performed in the above step run `make uninstall`.

### Testing the Operator

Run `make test` to run the molecule test suite.

See [Testing Ansible Operators with Molecule][ansible-test-guide] documentation to know how to use the operator framework features to test it.  

[python]: https://www.python.org/
[ansible]: https://www.ansible.com/
[kubectl_tool]: https://kubernetes.io/docs/tasks/tools/install-kubectl/
[docker_tool]: https://docs.docker.com/install/
[operator_sdk]: https://github.com/operator-framework/operator-sdk
[operator_install]: https://github.com/operator-framework/operator-sdk/blob/master/doc/user/install-operator-sdk.md
[ansible-test-guide]: https://github.com/operator-framework/operator-sdk/blob/master/doc/ansible/dev/testing_guide.md
[ansible-guide]: https://github.com/operator-framework/operator-sdk/blob/master/doc/ansible/user-guide.md
