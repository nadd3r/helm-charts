{{- if .Values.secretStore }}
apiVersion: external-secrets.io/v1
kind: SecretStore
metadata:
  name: {{ .Values.secretStore.global.name }}
spec:
  {{- if .Values.secretStore.global.conditions }}
  conditions:
    {{- with .Values.secretStore.global.conditions }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
  provider:
    {{ .Values.secretStore.global.provider }}:
    {{- if eq .Values.secretStore.global.provider "gitlab" }}
      url: {{ .Values.secretStore.global.url }}
      projectID: {{ .Values.secretStore.gitlab.projectID | quote }}
      {{- $quoted := list }}
      {{- range .Values.secretStore.gitlab.groupIDs }}
      {{- $quoted = append $quoted (quote .) }}
      {{- end }}
      groupIDs: {{ printf "[%s]" (join ", " $quoted) }}
      environment: {{ .Values.secretStore.gitlab.environment }}
      auth:
        SecretRef:
          accessToken:
            {{- if .Values.accessToken }}
            name: {{ .Values.accessToken.name }}
            {{- end }}
            {{- if not .Values.accessToken }}
            name: {{ .Values.secretStore.gitlab.accessToken.name }}
            {{- end }}
            key: {{ .Values.secretStore.gitlab.accessToken.key }}
      {{- if .Values.secretStore.global.caProvider }}
      caProvider:
        key: {{ .Values.secretStore.global.caProvider.key }}
        name: {{ .Values.secretStore.global.caProvider.name }}
        namespace: {{ .Values.secretStore.global.caProvider.namespace }}
        type: {{ .Values.secretStore.global.caProvider.type | default "Secret" }}
      {{- end }}
    {{- end }}


    {{- if eq .Values.secretStore.global.provider "vault" }}
      server: {{ .Values.secretStore.global.url }}
      path: {{ .Values.secretStore.vault.path | default "kv" }}
      version: {{ .Values.secretStore.vault.version | default "v2"}}
    {{- if .Values.secretStore.global.caProvider }}
      caProvider:
        key: {{ .Values.secretStore.global.caProvider.key }}
        name: {{ .Values.secretStore.global.caProvider.name }}
        namespace: {{ .Values.secretStore.global.caProvider.namespace }}
        type: {{ .Values.secretStore.global.caProvider.type | default "Secret" }}
    {{- end }}
      auth:
        {{ .Values.secretStore.vault.authMethod }}:
        {{- if eq .Values.secretStore.vault.authMethod "kubernetes" }}
        mountPath: {{ .Values.secretStore.vault.kubernetesAuth.mountPath }}
        role: {{ .Values.secretStore.vault.kubernetesAuth.role }}
        serviceAccountRef:
          name: {{ .Values.secretStore.vault.kubernetesAuth.serviceAccount.name }}
          namespace: {{ .Values.secretStore.vault.kubernetesAuth.serviceAccount.namespace }}
        {{- end }}
    {{- end }}
{{- end }}