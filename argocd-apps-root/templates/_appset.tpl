{{/*
Get applicationSetRoot name with default value "apps-root"
*/}}
{{- define "argocd-apps-root.appsetRootName" -}}
{{- if .Values.applicationSetRoot -}}
{{- default "apps-root" .Values.applicationSetRoot.name -}}
{{- else -}}
{{- "apps-root" -}}
{{- end -}}
{{- end }}

{{/*
Get goTemplate value with default value "true"
*/}}
{{- define "argocd-apps-root.appsetGoTemplate" -}}
{{- if .Values.applicationSetRoot -}}
{{- default true .Values.applicationSetRoot.goTemplate -}}
{{- else -}}
{{- true -}}
{{- end -}}
{{- end }}

{{/*
Check if baseChart is enabled
*/}}
{{- define "argocd-apps-root.baseChartEnabled" -}}
{{- if and .Values.applicationSetRoot .Values.applicationSetRoot.baseChart -}}
{{- default false .Values.applicationSetRoot.baseChart.enabled -}}
{{- else -}}
{{- false -}}
{{- end -}}
{{- end }}

{{/*
Get syncPolicy
*/}}
{{- define "argocd-apps-root.syncPolicy" -}}
{{- if .Values.applicationSetRoot.syncPolicy }}
syncPolicy:  
{{ toYaml .Values.applicationSetRoot.syncPolicy | indent 2 }}
{{- end }}
{{- end }}
