{{/*
Check if baseChart is enabled
*/}}
{{- define "argocd-apps-root.baseChartEnabled" -}}
{{- if and .Values.applicationSetGlobal .Values.applicationSetGlobal.baseChart -}}
{{- default false .Values.applicationSetGlobal.baseChart.enabled -}}
{{- else -}}
{{- false -}}
{{- end -}}
{{- end }}

{{/*
Get syncPolicy
*/}}
{{- define "argocd-apps-root.syncPolicy" -}}
{{- $root := .root.Values -}}
{{- if $root.applicationSetGlobal.syncPolicy }}
syncPolicy:  
{{ toYaml $root.applicationSetGlobal.syncPolicy | indent 2 }}
{{- else -}}
syncPolicy:
  syncOptions:
    - ApplyOutOfSyncOnly=true
    - CreateNamespace=true
{{- end }}
{{- end }}
