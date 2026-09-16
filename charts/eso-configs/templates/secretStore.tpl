{{- if .Values.secretStore }}
apiVersion: external-secrets.io/v1
kind: SecretStore
metadata:
  name: {{ .Values.secretStore.name }}
spec:
{{- with .Values.secretStore.spec }}
  {{- toYaml . | nindent 2}}
{{- end }}
{{- end }}