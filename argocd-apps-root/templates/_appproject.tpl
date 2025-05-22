{{- define "argocd-apps-root.appproject.resourceLists" -}}
{{- $app := .app -}}
{{- $root := .root.Values -}}

{{- if and (hasKey $app "argoProject") (hasKey $app.argoProject "clusterResourceWhitelist") }}
clusterResourceWhitelist:
  {{- toYaml $app.argoProject.clusterResourceWhitelist | nindent 2 }}
{{- else if and (hasKey $root "argoProjectGlobal") (hasKey $root.argoProjectGlobal "clusterResourceWhitelist") }}
clusterResourceWhitelist:
  {{- toYaml $root.argoProjectGlobal.clusterResourceWhitelist | nindent 2 }}
{{- end }}

{{- if and (hasKey $app "argoProject") (hasKey $app.argoProject "clusterResourceBlacklist") }}
clusterResourceBlacklist:
  {{- toYaml $app.argoProject.clusterResourceBlacklist | nindent 2 }}
{{- else if and (hasKey $root "argoProjectGlobal") (hasKey $root.argoProjectGlobal "clusterResourceBlacklist") }}
clusterResourceBlacklist:
  {{- toYaml $root.argoProjectGlobal.clusterResourceBlacklist | nindent 2 }}
{{- end }}

{{- if and (hasKey $app "argoProject") (hasKey $app.argoProject "namespaceResourceWhitelist") }}
namespaceResourceWhitelist:
  {{- toYaml $app.argoProject.namespaceResourceWhitelist | nindent 2 }}
{{- else if and (hasKey $root "argoProjectGlobal") (hasKey $root.argoProjectGlobal "namespaceResourceWhitelist") }}
namespaceResourceWhitelist:
  {{- toYaml $root.argoProjectGlobal.namespaceResourceWhitelist | nindent 2 }}
{{- end }}

{{- if and (hasKey $app "argoProject") (hasKey $app.argoProject "namespaceResourceBlacklist") }}
namespaceResourceBlacklist:
  {{- toYaml $app.argoProject.namespaceResourceBlacklist | nindent 2 }}
{{- else if and (hasKey $root "argoProjectGlobal") (hasKey $root.argoProjectGlobal "namespaceResourceBlacklist") }}
namespaceResourceBlacklist:
  {{- toYaml $root.argoProjectGlobal.namespaceResourceBlacklist | nindent 2 }}
{{- end }}
{{- end -}}
