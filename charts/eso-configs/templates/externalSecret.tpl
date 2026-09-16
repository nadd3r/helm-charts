{{- if .Values.externalSecret }}
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ .Values.externalSecret.name }}
spec:
{{- with .Values.externalSecret.spec }}
  {{- toYaml . | nindent 2}}
{{- end }}
{{- end }}