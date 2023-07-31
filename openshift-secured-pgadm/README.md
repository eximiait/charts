# Project: Secured PgAdmin Chart 

## Overview
This project contains a Helm chart that enables the deployment of the
[PgAdmin](https://www.pgadmin.org/) application on an OpenShift environment.
The application is secured using [OpenShift oauth-proxy](https://github.com/openshift/oauth-proxy) to control access and provide robust authentication and authorization. 

## Features
- **PgAdmin**: Is the most popular and feature rich Open Source administration and development platform for PostgreSQL, the most advanced Open Source database in the world.

- **OAuth-proxy**: The OAuth proxy is an integral part of our security setup. It stands as a gatekeeper between the user and the RedisInsight application, providing a protective layer of authentication and authorization.

## Pre-requisites

- OpenShift environment
- Helm installed

## Installation

Before installing the Secured PgAdmin Chart, add the chart repository to your Helm configuration:

```sh
helm repo add eximiait https://charts.eximiait.com.ar
helm repo update
```

To install the Secured PgAdmin Chart from the EximiaIT repository with the release name `my-release`, run the following command:

```sh
helm install my-release eximiait/openshift-secured-pgadmin
```

You can also customize the installation by specifying a `values.yaml` file:

```sh
helm install my-release eximiait/openshift-secured-pgadmin -f values.yaml
```

## Configuration

The following table lists the configurable parameters of the Secured PgAdmin Chart and their default values.

| Parameter                                              | Description                                                                                                                             | Default                                          |
|--------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------|
| `base.nameOverride`                                    | Overrides the name of the chart                                                                                                         | `"pgadmin"`                                 |
| `base.fullnameOverride`                                | Overrides the full name of the chart                                                                                                    | `"pgadmin"`                                 |
| `base.volumes[0].name`                                 | Name of the volume                                                                                                                      | `"pgadmin-data"`                                           |
| `base.volumes[0].emptyDir`                             | Sets to use an empty directory as volume                                                                                                | `{}`                                             |
| `base.volumes[0].persistentVolumeClaim.claimName`      | The name of PersistentVolumeClaim to use. If selected, you should set `pvc.enabled: true`. | `storage-claim`                                           |
| `base.containers[0].name`                              | Name of the container                                                                                                                   | `"app"`                                          |
| `base.containers[0].image`                             | The Docker image for PgAdmin                                                                                                       | `"dpage/pgadmin4:7.4"`                |
| `base.containers[0].imagePullPolicy`                   | Image pull policy for PgAdmin                                                                                                      | `"IfNotPresent"`                                 |
| `base.containers[0].ports[0].name`                     | Name of the exposed port                                                                                                                | `"http"`                                         |
| `base.containers[0].ports[0].containerPort`            | Port to expose on the container's IP address                                                                                            | `80`                                           |
| `base.containers[0].ports[0].protocol`                 | Protocol for the port                                                                                                                   | `"HTTP"`                                          |
| `base.containers[0].livenessProbe.httpGet.path`        | Path to access on the IP to check the health                                                                                            | `"/misc/ping"`                                |
| `base.containers[0].livenessProbe.httpGet.port`        | Port to use to check the health                                                                                                         | `80`                                           |
| `base.containers[0].livenessProbe.initialDelaySeconds` | Number of seconds after the container has started before liveness probes are initiated                                                  | `30`                                              |
| `base.containers[0].livenessProbe.periodSeconds`       | How often (in seconds) to perform the probe                                                                                             | `60`                                              |
| `base.containers[0].livenessProbe.failureThreshold`    | When a Pod starts and the probe fails, Kubernetes will try failureThreshold times before giving up                                      | `3`                                              |
| `base.containers[0].resources`                         | Compute resources required by the container                                                                                             | `{}`                                             |
| `base.containers[0].volumeMounts[0].name`              | Name of the volume mount                                                                                                                | `"pgadmin"`                                           |
| `base.containers[0].volumeMounts[0].mountPath`         | Path where the volume should be mounted in the container                                                                                | `"/pgadmin-data"`                                          |
| `base.upstream`                                        | Upstream URL for the OAuth Proxy                                                                                                        | `"http://localhost:80"`                        |
| `base.cookieSecret`                                    | Secret used to encrypt OAuth cookies                                                                                                    | `"bA7kPuPzko-igWaLPhVDWVj_VhENVnVcHce6rYQwu_s="` |
| `pvc.enabled`                                    | Used to create a PVC                                                                                                    | `false` |
| `pvc.size`                                    | Used to indicate a PVC size                                                                                                    | `1Gi` |

These parameters can be set in the `values.yaml` file or passed on the command line during chart installation. For example:

```sh
helm install my-release eximiait/redisinsight-oauth-proxy --set base.nameOverride=myapp
```

## Chart dependencies

This chart has the following dependency:

```yaml
dependencies:
  - name: openshift-secured-app
    version: x.y.z
    repository: https://charts.eximiait.com.ar
```

## Security

We use OAuth-proxy as a mechanism for securing access to PgAdmin. OAuth-proxy provides a layer of security that handles authentication and authorization, ensuring only authenticated and authorized users can access the application.

## Contribution

Contributions are welcome! Read the [Contribution Guidelines](../CONTRIBUTING.md) for more information.
