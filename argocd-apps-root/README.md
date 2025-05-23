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

### Instalación mediante ArgoCD

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

Luego crar un Application en ArgoCD apuntando al repositorio git creado anteriormente.

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

### Instalación con Helm

```bash
helm repo add eximiait https://charts.eximiait.com.ar
helm repo update

helm install argocd-apps-root eximiait/argocd-apps-root \
  --namespace argocd \
  --values values.yaml \
  --version x.y.z
```