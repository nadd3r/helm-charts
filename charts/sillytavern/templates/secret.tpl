{{- if and .Values.config.basicAuthMode (not .Values.config.basicAuthUser.existingSecret) }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "sillytavern.fullname" . }}-secrets
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "sillytavern.labels" . | nindent 4 }}
type: Opaque
data:
  SILLYTAVERN_BASICAUTHUSER_USERNAME: {{ .Values.config.basicAuthUser.username | b64enc | quote }}
  SILLYTAVERN_BASICAUTHUSER_PASSWORD: {{ .Values.config.basicAuthUser.password | b64enc | quote }}
{{- end }}