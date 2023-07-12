# Openshift Secured App

Este chart sirve para *segurizar* una aplicación con openshift oauth-proxy.

# Uso

- Agregar la configuración del container que se quiere segurizar en el archivo `values.yaml`:

```yaml
containers:
  - name: app
    image: "quay.io/eximiait/openshift-secured-app:latest"
    imagePullPolicy: IfNotPresent
    ports:
      - name: http
        containerPort: 8080
        protocol: TCP
    livenessProbe:
      httpGet:
        path: /healthcheck/
        port: 8080
      initialDelaySeconds: 5
      periodSeconds: 5
      failureThreshold: 2
    resources: {}
    volumeMounts:
      - name: db
        mountPath: /db
```
- Setear la URL al ***upstream*** en el archivo `values.yaml`:

```yaml
upstream: "http://app:8080"
```

- Generar y configurar ***cookieSecret*** en el archivo `values.yaml`:

```yaml
cookieSecret: "value" # dd if=/dev/urandom bs=32 count=1 2>/dev/null | base64 | tr -d -- '\n' | tr -- '+/' '-_'; echo
```