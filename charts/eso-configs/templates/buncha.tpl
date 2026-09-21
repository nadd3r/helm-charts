{{- $root := . }}
{{- $all := .Values.clusterSecretStores | default dict }}
{{- $global := $all.global | default dict }}

{{- range $name, $store := $all }}
{{- if and (ne $name "global") (ne ($store.enabled | default true) false) }}
{{- $merged := mergeOverwrite (deepCopy $global) (deepCopy $store) }}

{{- $ca := index $global "caProvider" }}
{{- if and $ca $merged.provider }}
{{- range $backend, $cfg := $merged.provider }}
  {{- if kindIs "map" $cfg }}
    {{- if not (hasKey $cfg "caProvider") }}
      {{- $_ := set $cfg "caProvider" (deepCopy $ca) }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}
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
  {{- $spec := omit $merged "annotations" "labels" "enabled" "caProvider" }}
  {{- tpl (toYaml $spec) $root | nindent 2 }}
{{- end }}
{{- end }}