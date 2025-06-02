# ArgoCD Apps Root

## Purpose

The purpose of this chart is to provide an easy way to implement the app-of-apps pattern with ArgoCD.

The app-of-apps pattern allows you to manage multiple applications and environments in Kubernetes from a single entry point, enabling centralized and simplified configuration management.

Through a single inventory file (values.yaml), the corresponding AppProjects and ApplicationSets for each application and environment can be generated.

## Example

```yaml
# values.yaml
applications:
  - name: app1    
    environments:
      - name: dev
        namespace: app1-dev
        argoApplicationName: app1-test-gitops
        cluster: https://kubernetes.default.svc
        argoProjectName: app1
        appGitopsRepoURL: https://gitlab.com/app1-dev-gitops.git
        jwtTokens:
          - iat: 1712332996
            id: argocd-sync
      - name: prod
        namespace: app1-prod
        cluster: https://api.prod.example.com:6443
        argoApplicationName: app1-prod-gitops
        argoProjectName: app1        
        appGitopsRepoURL: https://gitlab.com/app1-prod-gitops.git
  
  - name: app2  
    environments:
      - name: dev
        namespace: app2-dev
        argoApplicationName: app2-dev-gitops
        cluster: https://kubernetes.default.svc
        argoProjectName: app2
        appGitopsRepoURL: https://gitlab.com/app2-dev-gitops.git
        jwtTokens:
          - iat: 1712332996
            id: argocd-sync
      - name: prod
        namespace: app2-prod
        cluster: https://api.prod.example.com:6443
        argoApplicationName: app2-prod-gitops
        argoProjectName: app2
        appGitopsRepoURL: https://gitlab.com/app2-prod-gitops.git
        jwtTokens:
          - iat: 1712332996
            id: argocd-sync
```

From this inventory, the corresponding AppProjects and ApplicationSets will be generated automatically.

## Installation

It is recommended to install from a Git repo and ArgoCD to version the inventory (values.yaml).

#### Installation via Git and ArgoCD

Create a git repository with the Chart definition (Chart.yaml) and the inventory (values.yaml).
Within Chart.yaml, you must define the argocd-apps-root chart as a dependency.

```yaml
# Chart.yaml
apiVersion: v2
name: apps
description: Repository to implement the app-of-apps pattern with ArgoCD
type: application
version: 0.1.0
appVersion: "1.0"
dependencies:
  - name: argocd-apps-root
    version: x.y.z
    repository: https://charts.eximiait.com.ar
```

Then create an Application in ArgoCD pointing to the previously created git repository.

```yaml
# argocd-app.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: argocd-apps-root
  namespace: argocd
spec:
  destination:
    namespace: argocd
    server: https://kubernetes.default.svc
  project: default
  source:
    repoURL: https://gitlab.com/eximiait/argocd-apps-root.git
    targetRevision: HEAD
    path: .
    helm:
      valueFiles:
        - values.yaml    
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

The creation of this application should be part of the ArgoCD post-installation, as it is responsible for creating all applications and environments.

#### Installation with Helm

```bash
helm repo add eximiait https://charts.eximiait.com.ar
helm repo update

helm install argocd-apps-root eximiait/argocd-apps-root \
  --namespace argocd \
  --values values.yaml \
  --version x.y.z
```

## Configuration

The chart uses a hierarchical values structure to define projects, applications, and their environments.

Below are all available configuration options:

| Parameter | Description | Default value |
|-----------|-------------|--------------|
| **applicationSetGlobal** | Global configuration applied to all ApplicationSets | |
| `applicationSetGlobal.baseChart.enabled` | Enables the use of a base chart to install manifests common to all applications (quota, network-policies, etc) | `false` |
| `applicationSetGlobal.baseChart.url` | Git repository URL where the base chart is located | `""` |
| `applicationSetGlobal.baseChart.path` | Path within the repository where the base chart is located | `""` |
| `applicationSetGlobal.baseChart.targetRevision` | Repository revision to use for the base chart | `""` |
| **argoProjectGlobal** | Global configuration for all AppProjects | |
| `argoProjectGlobal.clusterResourceWhitelist` | List of allowed cluster-level resources | `[]` |
| `argoProjectGlobal.clusterResourceBlacklist` | List of forbidden cluster-level resources | `[]` |
| `argoProjectGlobal.namespaceResourceWhitelist` | List of allowed namespace-level resources | `[]` |
| `argoProjectGlobal.namespaceResourceBlacklist` | List of forbidden namespace-level resources | `[]` |
| **applications** | List of applications to manage | `[]` |
| `applications[].name` | Application name, used for the ApplicationSet name | |
| `applications[].environments` | List of environments for the application | `[]` |
| `applications[].environments[].name` | Environment name (dev, test, prod, etc.) | |
| `applications[].environments[].namespace` | Namespace where the application will be deployed | |
| `applications[].environments[].cluster` | API server URL of the cluster where it will be deployed | |
| `applications[].environments[].argoApplicationName` | Name of the application in ArgoCD | |
| `applications[].environments[].argoProjectName` | Name of the associated ArgoCD project | |
| `applications[].environments[].appGitopsRepoURL` | Git repository URL with the application's GitOps configuration | |
| `applications[].environments[].project` | Specific configuration for the AppProject | |
| `applications[].environments[].project.groupName` | Name of the group with access to the AppProject | |
| `applications[].environments[].jwtTokens` | List of JWT tokens for API access | `[]` |
| `applications[].environments[].jwtTokens[].iat` | JWT token issued-at timestamp | |
| `applications[].environments[].jwtTokens[].id` | JWT token identifier | |

### Full configuration example

```yaml
applicationSetGlobal:
  baseChart:
    enabled: true
    url: https://github.com/eximiait/chart-base.git
    path: .
    targetRevision: main

# Global configuration to apply to all appProjects
argoProjectGlobal:
  clusterResourceWhitelist:
  - group: '*'
    kind: Namespace
  namespaceResourceBlacklist:
  - group: '*'
    kind: Secret

applications:
  - name: app1
    environments:
      - name: dev
        namespace: app1-dev
        cluster: https://kubernetes.default.svc
        argoApplicationName: app1-dev-gitops
        argoProjectName: app1
        appGitopsRepoURL: https://github.com/eximiait/app1-dev-gitops.git
        jwtTokens:
          - iat: 1712332996
            id: argocd-sync
      - name: test
        namespace: app1-test
        cluster: https://kubernetes.default.svc
        argoApplicationName: app1-test-gitops
        argoProjectName: app1
        appGitopsRepoURL: https://github.com/eximiait/app1-test-gitops.git
        jwtTokens:
          - iat: 7373737737
            id: argocd-sync
      - name: prod
        namespace: app1-prod
        cluster: https://api.prod.example.com:6443
        argoApplicationName: app1-prod-gitops
        argoProjectName: app1
        project:
          groupName: app1-prod-admin
        appGitopsRepoURL: https://github.com/eximiait/app1-prod-gitops.git
        jwtTokens:
          - iat: 9685485868
            id: argocd-sync
```

