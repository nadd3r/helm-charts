apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "kanbn.fullname" . }}
  labels:
    {{- include "kanbn.labels" . | nindent 4 }}
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "kanbn.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
        {{- include "kanbn.labels" . | nindent 8 }}
        {{- with .Values.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "kanbn.serviceAccountName" . }}
      {{- with .Values.podSecurityContext }}
      securityContext:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      initContainers:
        - name: {{ .Chart.Name }}-migrations
          {{- with .Values.securityContext }}
          securityContext:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          image: "{{ .Values.kanbn.migrations.image.repository }}:{{ .Values.kanbn.migrations.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.kanbn.migrations.image.pullPolicy }}
          {{- with .Values.resources }}
          resources:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          env:
          - name: POSTGRES_URL
            valueFrom:
              secretKeyRef:
              {{- if .Values.kanbn.database.existingSecret.secretName }}
                name: {{ .Values.kanbn.database.existingSecret.secretName }}
              {{- end }}
              {{- if not .Values.kanbn.database.existingSecret.secretName }}
                name: {{ .Chart.Name }}-secrets
              {{- end }}
                key: {{ .Values.kanbn.database.key | default "uri" }}
      containers:
        - name: {{ .Chart.Name }}
          {{- with .Values.securityContext }}
          securityContext:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          image: "{{ .Values.kanbn.image.repository }}:{{ .Values.kanbn.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.kanbn.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ .Values.service.port }}
              protocol: TCP
          env:
          - name: POSTGRES_URL
            valueFrom:
              secretKeyRef:
              {{- if .Values.kanbn.database.existingSecret.secretName }}
                name: {{ .Values.kanbn.database.existingSecret.secretName }}
              {{- end }}
              {{- if not .Values.kanbn.database.existingSecret.secretName }}
                name: {{ .Chart.Name }}-secrets
              {{- end }}
                key: {{ .Values.kanbn.database.key | default "uri" }}
          - name: NEXT_PUBLIC_BASE_URL
            value: {{ .Values.kanbn.publicUrl }}
          - name: LOG_LEVEL
            value: {{ .Values.kanbn.logLevel }}
          - name: NEXT_PUBLIC_ALLOW_CREDENTIALS
            value: {{ .Values.kanbn.allowUserPass | quote }}
          - name: NEXT_PUBLIC_DISABLE_SIGN_UP
            value: {{ .Values.kanbn.disableSignUps | quote }}
          - name: BETTER_AUTH_SECRET
            valueFrom:
              secretKeyRef:
              {{- if .Values.kanbn.authSecret.existingSecret.secretName }}
                name: {{ .Values.kanbn.authSecret.existingSecret.secretName }}
                key: {{ .Values.kanbn.authSecret.existingSecret.key | default "authSecret" }}
              {{- end }}
              {{- if not .Values.kanbn.authSecret.existingSecret.secretName }}
                name: {{ .Chart.Name }}-secrets
                key: authSecret
              {{- end }}
          - name: S3_REGION
            value: {{ .Values.kanbn.s3.region }}
          - name: S3_ENDPOINT
            value: {{ .Values.kanbn.s3.endpoint }}
          - name: S3_FORCE_PATH_STYLE
            value: {{ .Values.kanbn.s3.forcePathStyle | quote }}
          - name: S3_AVATAR_UPLOAD_LIMIT
            value: {{ .Values.kanbn.s3.avatarSizeLimit | quote }}
          - name: NEXT_PUBLIC_STORAGE_URL
            value: {{ .Values.kanbn.s3.storageUrl | default .Values.kanbn.s3.endpoint }}
          - name: NEXT_PUBLIC_STORAGE_DOMAIN
            value: {{ .Values.kanbn.s3.domain | default ( .Values.kanbn.s3.endpoint | trimPrefix "https://") }}
          - name: NEXT_PUBLIC_AVATAR_BUCKET_NAME
            {{- if and .Values.kanbn.s3.buckets.global ( not .Values.kanbn.s3.buckets.avatar ) }}
            value: {{ .Values.kanbn.s3.buckets.global }}
            {{- end }}
            {{- if .Values.kanbn.s3.buckets.avatar }}
            value: {{ .Values.kanbn.s3.buckets.avatar }}
            {{- end }}
          - name: NEXT_PUBLIC_ATTACHMENTS_BUCKET_NAME
            {{- if and .Values.kanbn.s3.buckets.global ( not .Values.kanbn.s3.buckets.attachments ) }}
            value: {{ .Values.kanbn.s3.buckets.global }}
            {{- end }}
            {{- if .Values.kanbn.s3.buckets.attachments }}
            value: {{ .Values.kanbn.s3.buckets.attachments }}
            {{- end }}
          - name: S3_ACCESS_KEY_ID
            valueFrom:
              secretKeyRef:
              {{- if .Values.kanbn.s3.accessKey.existingSecret.secretName }}
                name: {{ .Values.kanbn.s3.accessKey.existingSecret.secretName }}
                key: {{ .Values.kanbn.s3.accessKey.existingSecret.idKey | default "accessKeyId" }}
              {{- end }}
              {{- if not .Values.kanbn.s3.accessKey.existingSecret.secretName }}
                name: {{ .Chart.Name }}-secrets
                key: accessKeyId
              {{- end }}
          - name: S3_SECRET_ACCESS_KEY
            valueFrom:
              secretKeyRef:
              {{- if .Values.kanbn.s3.accessKey.existingSecret.secretName }}
                name: {{ .Values.kanbn.s3.accessKey.existingSecret.secretName }}
                key: {{ .Values.kanbn.s3.accessKey.existingSecret.secretKey | default "secretAccessKey" }}
              {{- end }}
              {{- if not .Values.kanbn.s3.accessKey.existingSecret.secretName }}
                name: {{ .Chart.Name }}-secrets
                key: secretAccessKey
              {{- end }}
            {{- if eq .Values.kanbn.oidc.enabled true }}
          - name: OIDC_DISCOVERY_URL
            value: {{ .Values.kanbn.oidc.discoveryUrl }}
          - name: OIDC_CLIENT_ID
            valueFrom:
              secretKeyRef:
              {{- if .Values.kanbn.oidc.client.existingSecret.secretName }}
                name: {{ .Values.kanbn.oidc.client.existingSecret.secretName }}
                key: {{ .Values.kanbn.oidc.client.existingSecret.idKey | default "clientId" }}
              {{- end }}
              {{- if not .Values.kanbn.oidc.client.existingSecret.secretName }}
                name: {{ .Chart.Name }}-secrets
                key: clientId
              {{- end }}
          - name: OIDC_CLIENT_SECRET
            valueFrom:
              secretKeyRef:
              {{- if .Values.kanbn.oidc.client.existingSecret.secretName }}
                name: {{ .Values.kanbn.oidc.client.existingSecret.secretName }}
                key: {{ .Values.kanbn.oidc.client.existingSecret.secretKey | default "clientSecret" }}
              {{- end }}
              {{- if not .Values.kanbn.oidc.client.existingSecret.secretName }}
                name: {{ .Chart.Name }}-secrets
                key: clientSecret
              {{- end }}
          {{- end }}
          {{- with .Values.livenessProbe }}
          livenessProbe:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with .Values.readinessProbe }}
          readinessProbe:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with .Values.resources }}
          resources:
            {{- toYaml . | nindent 12 }}
          {{- end }}
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
