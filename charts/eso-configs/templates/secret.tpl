{{- if .Values.accessToken }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Values.accessToken.name }}
  namespace: {{ .Release.Namespace }}
  {{- with .Values.accessToken.labels }}
  labels:
    {{- toYaml . | nindent 4 }}
  {{- end }}
type: Opaque
data:
  token: {{ .Values.accessToken.token | b64enc | quote }}
{{- end }}