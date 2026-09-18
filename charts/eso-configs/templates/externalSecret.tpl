{{- if .Values.externalSecret }}
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ .Values.externalSecret.name }}
  namespace: {{ .Release.Namespace }}
  {{- with .Values.externalSecret.labels }}
  labels:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  refreshInterval: {{ .Values.externalSecret.refreshInterval | default "60s" }}
  secretStoreRef:
    kind: {{ .Values.externalSecret.secretStore.kind }}
    name: {{ .Values.externalSecret.secretStore.name }}
  target:
    name: {{ .Values.externalSecret.targetSecret.name }}
    creationPolicy: {{ .Values.externalSecret.targetSecret.policy | default "Owner" }}
  {{- with .Values.externalSecret.targetSecret.data }}
  data:
    {{- toYaml . | nindent 4}}
  {{- end }}
{{- end }}