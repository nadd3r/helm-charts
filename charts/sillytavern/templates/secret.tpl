{{- if and .Values.config.basicAuthMode (not .Values.config.basicAuthUser.existingSecret.name) }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "sillytavern.fullname" . }}-basicauth-secrets
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "sillytavern.labels" . | nindent 4 }}
type: Opaque
data:
  SILLYTAVERN_BASICAUTHUSER_USERNAME: {{ .Values.config.basicAuthUser.username | b64enc | quote }}
  SILLYTAVERN_BASICAUTHUSER_PASSWORD: {{ .Values.config.basicAuthUser.password | b64enc | quote }}
{{- end }}

{{- if and .Values.config.adminUserPassword (not .Values.config.adminUserPassword.existingSecret.name) }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "sillytavern.fullname" . }}-admin-password
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "sillytavern.labels" . | nindent 4 }}
type: Opaque
data:
  DEFAULT_USER_PASSWORD: {{ .Values.config.adminUserPassword.password | b64enc | quote }}
{{- end }}