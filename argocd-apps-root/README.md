# Argocd Apps Root

## Objetivo

El objetivo de este chart es proveer una forma sencilla de poder implementar el patrón app-of-apps con ArgoCD.

El patrón app-of-apps permite gestionar múltiples aplicaciones y ambientes en Kubernetes desde un único punto de entrada, permitiendo una gestión centralizada y simplificada de las configuraciones.

A través de un único inventario (values.yaml) se pueden generar los AppProject y ApplicationSet correspondientes a cada aplicación y ambiente.

## Ejemplo

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

A partir de este inventario se generarán automaticamente los AppProject y ApplicationSet correspondientes.

## Instalación

Se recomienda la instalación mediante ArgoCD para poder versionar el inventario (values.yaml).

#### Instalación mediante ArgoCD

Crear un repositorio git con la definición del Chart (Chart.yaml) y el inventario (values.yaml).
Dentro del Chart.yaml se debe definir como dependencia el chart de argocd-apps-root.

```yaml
# Chart.yaml
apiVersion: v2
name: apps
description: Repositorio para implementar el patrón app-of-apps con ArgoCD
type: application
version: 0.1.0
appVersion: "1.0"
dependencies:
  - name: argocd-apps-root
    version: x.y.z
    repository: https://charts.eximiait.com.ar
```

Luego crear un Application en ArgoCD apuntando al repositorio git creado anteriormente.

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

La creación de esta application debe formar parte de la post-instalación de ArgoCD, ya que es la encargada de crear todas las aplicaciones y ambientes.

#### Instalación con Helm

```bash
helm repo add eximiait https://charts.eximiait.com.ar
helm repo update

helm install argocd-apps-root eximiait/argocd-apps-root \
  --namespace argocd \
  --values values.yaml \
  --version x.y.z
```

## Configuración

El chart utiliza una estructura de valores jerárquica para definir los proyectos y las aplicaciones y sus ambientes.

A continuación se detallan todas las opciones de configuración disponibles:

| Parámetro | Descripción | Valor por defecto |
|-----------|-------------|-------------------|
| **applicationSetGlobal** | Configuración global que se aplica a todos los ApplicationSets | |
| `applicationSetGlobal.baseChart.enabled` | Habilita el uso de un chart base para instalar manifiestos comunes a todas las aplicaciones (quota, network-policies, etc) | `false` |
| `applicationSetGlobal.baseChart.url` | URL del repositorio git donde se encuentra el chart base | `""` |
| `applicationSetGlobal.baseChart.path` | Ruta dentro del repositorio donde se encuentra el chart base | `""` |
| `applicationSetGlobal.baseChart.targetRevision` | Revisión del repositorio a utilizar para el chart base | `""` |
| **argoProjectGlobal** | Configuración global para todos los AppProjects | |
| `argoProjectGlobal.clusterResourceWhitelist` | Lista de recursos a nivel de cluster permitidos | `[]` |
| `argoProjectGlobal.clusterResourceBlacklist` | Lista de recursos a nivel de cluster prohibidos | `[]` |
| `argoProjectGlobal.namespaceResourceWhitelist` | Lista de recursos a nivel de namespace permitidos | `[]` |
| `argoProjectGlobal.namespaceResourceBlacklist` | Lista de recursos a nivel de namespace prohibidos | `[]` |
| **applications** | Lista de aplicaciones a gestionar | `[]` |
| `applications[].name` | Nombre de la aplicación, se usará para el nombre del applicationSet | |
| `applications[].environments` | Lista de ambientes para la aplicación | `[]` |
| `applications[].environments[].name` | Nombre del ambiente (dev, test, prod, etc.) | |
| `applications[].environments[].namespace` | Namespace donde se implementará la aplicación | |
| `applications[].environments[].cluster` | URL del API server del cluster donde se implementará | |
| `applications[].environments[].argoApplicationName` | Nombre de la aplicación en ArgoCD | |
| `applications[].environments[].argoProjectName` | Nombre del proyecto ArgoCD asociado | |
| `applications[].environments[].appGitopsRepoURL` | URL del repositorio git con la configuración GitOps de la aplicación | |
| `applications[].environments[].project` | Configuración específica para el AppProject | |
| `applications[].environments[].project.groupName` | Nombre del grupo con acceso al AppProject | |
| `applications[].environments[].jwtTokens` | Lista de tokens JWT para acceso a la API | `[]` |
| `applications[].environments[].jwtTokens[].iat` | Timestamp de emisión del token JWT | |
| `applications[].environments[].jwtTokens[].id` | Identificador del token JWT | |

### Ejemplo completo de configuración

```yaml
applicationSetGlobal:
  baseChart:
    enabled: true
    url: https://github.com/eximiait/chart-base.git
    path: .
    targetRevision: main

# Configuración global para aplicar a todos los appProjects
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

