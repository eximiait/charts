# Project: Secured RedisInsight Chart 

## Overview
This project contains a Helm chart that enables the deployment of the
[RedisInsight](https://github.com/RedisInsight/RedisInsight) application on an OpenShift environment.
The application is secured using [OpenShift oauth-proxy](https://github.com/openshift/oauth-proxy) to control access and provide robust authentication and authorization. 

## Features
- **RedisInsight**: This powerful tool lets you visualize your data, monitor Redis servers, manage your databases, and execute commands on your Redis server. You can use RedisInsight for data modeling, performance optimization, and real-time tracking of your Redis data.

- **OAuth-proxy**: The OAuth proxy is an integral part of our security setup. It stands as a gatekeeper between the user and the RedisInsight application, providing a protective layer of authentication and authorization.

## Pre-requisites

- OpenShift environment
- Helm installed

## Installation

Before installing the Secured RedisInsight Chart, add the chart repository to your Helm configuration:

```sh
helm repo add eximiait https://charts.eximiait.com.ar
helm repo update
```

To install the Secured RedisInsight Chart from the EximiaIT repository with the release name `my-release`, run the following command:

```sh
helm install my-release eximiait/openshift-secured-redisinsight
```

You can also customize the installation by specifying a `values.yaml` file:

```sh
helm install my-release eximiait/openshift-secured-redisinsight -f values.yaml
```

## Configuration

The following table lists the configurable parameters of the Secured RedisInsight Chart and their default values.

| Parameter                  | Description                                     | Default                                                    |
|----------------------------|-------------------------------------------------|------------------------------------------------------------|
| `base.nameOverride`| Overrides the name of the chart | `"redisinsight"` |
| `base.fullnameOverride`| Overrides the full name of the chart | `"redisinsight"` |
| `base.volumes[0].name`| Name of the volume | `"db"` |
| `base.volumes[0].emptyDir`| Specifies that the volume is to have initially empty directories | `{}` |
| `base.containers[0].name`| Name of the container | `"app"` |
| `base.containers[0].image`| The Docker image for RedisInsight | `"redislabs/redisinsight:1.14.0"` |
| `base.containers[0].imagePullPolicy`| Image pull policy for RedisInsight | `"IfNotPresent"` |
| `base.containers[0].ports[0].name`| Name of the exposed port | `"http"` |
| `base.containers[0].ports[0].containerPort`| Port to expose on the container's IP address | `8001` |
| `base.containers[0].ports[0].protocol`| Protocol for the port | `"TCP"` |
| `base.containers[0].livenessProbe.httpGet.path`| Path to access on the IP to check the health | `"/healthcheck/"` |
| `base.containers[0].livenessProbe.httpGet.port`| Port to use to check the health | `8001` |
| `base.containers[0].livenessProbe.initialDelaySeconds`| Number of seconds after the container has started before liveness probes are initiated | `5` |
| `base.containers[0].livenessProbe.periodSeconds`| How often (in seconds) to perform the probe | `5` |
| `base.containers[0].livenessProbe.failureThreshold`| When a Pod starts and the probe fails, Kubernetes will try failureThreshold times before giving up | `2` |
| `base.containers[0].resources`| Compute resources required by the container | `{}` |
| `base.containers[0].volumeMounts[0].name`| Name of the volume mount | `"db"` |
| `base.containers[0].volumeMounts[0].mountPath`| Path where the volume should be mounted in the container | `"/db"` |
| `base.upstream`| Upstream URL for the OAuth Proxy | `"http://localhost:8001"` |
| `base.cookieSecret`| Secret used to encrypt OAuth cookies | `"bA7kPuPzko-igWaLPhVDWVj_VhENVnVcHce6rYQwu_s="` |

These parameters can be set in the `values.yaml` file or passed on the command line during chart installation. For example:

```sh
helm install my-release eximiait/redisinsight-oauth-proxy --set base.nameOverride=myapp
```

## Chart dependencies

This chart has the following dependency:

```yaml
dependencies:
  - name: openshift-secured-app
    version: 0.2.0
    repository: https://charts.eximiait.com.ar
```

## Security

We use OAuth-proxy as a mechanism for securing access to RedisInsight. OAuth-proxy provides a layer of security that handles authentication and authorization, ensuring only authenticated and authorized users can access the application.

## Contribution

Contributions are welcome! Read the [Contribution Guidelines](CONTRIBUTING.md) for more information.

## License

The chart is distributed under the license chosen by the chart maintainer. Check the chart's documentation for more details.