{{- $root := . }}
{{- $all := .Values.clusterSecretStores | default dict }}
{{- $global := $all.global | default dict }}

{{- range $name, $store := $all }}
{{- if and (ne $name "global") (ne ($store.enabled | default true) false) }}
{{- $merged := mergeOverwrite (deepCopy $global) (deepCopy $store) }}
---
apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: {{ $name }}
  labels:
    {{- include "eso-configs.labels" $root | nindent 4 }}
    {{- with $merged.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with $merged.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- $spec := omit $merged "annotations" "labels" "enabled" }}
  {{- tpl (toYaml $spec) $root | nindent 2 }}
{{- end }}
{{- end }}