{{- if .Values.secretStore }}
apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: {{ .Values.clusterSecretStore.name }}
spec:
{{- with .Values.clusterSecretStore.spec }}
  {{- toYaml . | nindent 2}}
{{- end }}
{{- end }}