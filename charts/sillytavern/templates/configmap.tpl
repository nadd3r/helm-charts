apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "sillytavern.fullname" . }}-env
  namespace: {{ .Release.Namespace }}
  labels:
    app.kubernetes.io/component: sillytavern
    {{- include "sillytavern.labels" . | nindent 4 }}
{{- with .Values.configMapAnnotations }}
  annotations:
    {{- . | toYaml | nindent 4 }}
{{- end }}
data:
  SILLYTAVERN_DATAROOT: {{ .Values.config.dataRoot | default "./data" }}
  SILLYTAVERN_LISTEN: {{ .Values.config.listen | default "true" | quote }}
  SILLYTAVERN_LISTENADDRESS_IPV4: {{ .Values.config.listenAddress.ipv4 | default "0.0.0.0" | quote }}
  SILLYTAVERN_LISTENADDRESS_IPV6: {{ .Values.config.listenAddress.ipv6 | default "'[::]'" | quote }}
  SILLYTAVERN_PROTOCOL_IPV4: {{ .Values.config.protocol.ipv4 | default "true" | quote }}
  SILLYTAVERN_PROTOCOL_IPV6: {{ .Values.config.protocol.ipv6 | default "false" | quote }}
  SILLYTAVERN_DNSPREFERIPV6: {{ .Values.config.dnsPreferIPv6 | default "false" | quote }}

  SILLYTAVERN_BROWSERLAUNCH_ENABLED: "false"

  SILLYTAVERN_PORT: {{ .Values.config.port | default "8000" | quote }}
  SILLYTAVERN_HEARTBEATINTERVAL: {{ .Values.config.heartbeatInterval | default "5" | quote }}
  SILLYTAVERN_ENABLEKEEPALIVE: {{ .Values.config.enableKeepAlive | default "true" | quote }}

  SILLYTAVERN_SSL_ENABLED: {{ .Values.config.ssl.enabled | default "false" | quote }}
{{- if .Values.config.ssl.enabled }}
  SILLYTAVERN_SSL_CERTPATH:
  SILLYTAVERN_SSL_KEYPATH:
  SILLYTAVERN_SSL_KEYPASSPHRASE:
{{- end }}

  SILLYTAVERN_WHITELISTMODE: {{ .Values.config.whitelistMode | default "false" | quote }}
{{- if .Values.config.whitelistMode }}
  SILLYTAVERN_ENABLEFORWARDEDWHITELIST: {{ .Values.config.enableForwardedWhitelist | default "true" | quote }}
  {{- $quoted := list }}
  {{- range .Values.config.whitelist }}
    {{- $quoted = append $quoted (quote .) }}
  {{- end }}
  SILLYTAVERN_WHITELIST: {{ printf "[%s]" (join ", " $quoted) | squote }}
{{- end }}

  SILLYTAVERN_BASICAUTHMODE: {{ .Values.config.basicAuthMode | default "true" | quote }}

  SILLYTAVERN_ENABLECORSPROXY: {{ .Values.config.enableCorsProxy | default "false" | quote }}
  SILLYTAVERN_CORS_ENABLED: {{ .Values.config.cors.enabled | default "true" | quote }}
{{- if .Values.config.cors.enabled }}
  {{- $quoted := list }}
  {{- range .Values.config.cors.origin }}
    {{- $quoted = append $quoted (quote .) }}
  {{- end }}
  SILLYTAVERN_CORS_ORIGIN: {{ printf "[%s]" (join ", " $quoted) | squote }}
  {{- $quoted := list }}
  {{- range .Values.config.cors.methods }}
    {{- $quoted = append $quoted (quote .) }}
  {{- end }}
  SILLYTAVERN_CORS_METHODS: {{ printf "[%s]" (join ", " $quoted) | squote }}
  {{- $quoted := list }}
  {{- range .Values.config.cors.allowedHeaders }}
    {{- $quoted = append $quoted (quote .) }}
  {{- end }}
  SILLYTAVERN_CORS_ALLOWEDHEADERS: {{ printf "[%s]" (join ", " $quoted) | squote }}
  {{- $quoted := list }}
  {{- range .Values.config.cors.exposedHeaders }}
    {{- $quoted = append $quoted (quote .) }}
  {{- end }}
  SILLYTAVERN_CORS_EXPOSEDHEADERS: {{ printf "[%s]" (join ", " $quoted) | squote }}
  SILLYTAVERN_CORS_CREDENTIALS: {{ .Values.config.cors.credentials | default "false" | quote }}
  SILLYTAVERN_CORS_MAXAGE: {{ .Values.config.cors.maxAge | default "null" | quote }}
{{- end }}

  SILLYTAVERN_REQUESTPROXY_ENABLED: {{ .Values.config.requestProxy.enabled | default "false" | quote }}
{{- if .Values.config.requestProxy.enabled }}
  SILLYTAVERN_REQUESTPROXY_URL: {{ .Values.config.requestProxy.url | quote }}
  {{- $quoted := list }}
  {{- range .Values.config.requestProxy.bypass }}
    {{- $quoted = append $quoted (quote .) }}
  {{- end }}
  SILLYTAVERN_REQUESTPROXY_BYPASS: {{ printf "[%s]" (join ", " $quoted) | squote }}
{{- end }}

  SILLYTAVERN_ENABLEUSERACCOUNTS: {{ .Values.config.enableUserAccounts | default "false" | quote }}
  SILLYTAVERN_ENABLEDISCREETLOGIN: {{ .Values.config.enableDiscreetLogin | default "false" | quote }}
  SILLYTAVERN_PERUSERBASICAUTH: {{ .Values.config.perUserBasicAuth | default "false" | quote }}

  SILLYTAVERN_SSO_AUTHELIAAUTH: {{ .Values.config.sso.autheliaAuth | default "false" | quote }}
  SILLYTAVERN_SSO_AUTHENTIKAUTH: {{ .Values.config.sso.authentikAuth | default "false" | quote }}
{{- $quoted := list }}
{{- range .Values.config.sso.trustedProxies }}
  {{- $quoted = append $quoted (quote .) }}
{{- end }}
  SILLYTAVERN_SSO_TRUSTEDPROXIES: {{ printf "[%s]" (join ", " $quoted) | squote }}

  SILLYTAVERN_HOSTWHITELIST_ENABLED: {{ .Values.config.hostWhitelist.enabled | default "false" | quote }}
{{- if .Values.config.hostWhitelist.enabled }}
  SILLYTAVERN_HOSTWHITELIST_SCAN: {{ .Values.config.hostWhitelist.scan | default "true" | quote }}
{{- end }}
{{- if and .Values.config.hostWhitelist.hosts .Values.config.hostWhitelist.enabled }}
  {{- $quoted := list }}
  {{- range .Values.config.hostWhitelist.hosts }}
    {{- $quoted = append $quoted (quote .) }}
  {{- end }}
  SILLYTAVERN_HOSTWHITELIST_HOSTS: {{ printf "[%s]" (join ", " $quoted) | squote }}
{{- end }}

  SILLYTAVERN_PRIVATEADDRESSWHITELIST_ENABLED: {{ .Values.config.privateAddressWhitelist.enabled | default "false" | quote }}
{{- if .Values.config.privateAddressWhitelist.enabled }}
  SILLYTAVERN_PRIVATEADDRESSWHITELIST_ALLOWUNRESOLVEDHOSTS: {{ .Values.config.privateAddressWhitelist.allowUnresolvedHosts | default "false" | quote }}
  SILLYTAVERN_PRIVATEADDRESSWHITELIST_LOG_BLOCKEDREQUESTS: {{ .Values.config.privateAddressWhitelist.log.blockedRequests | default "true" | quote }}
  SILLYTAVERN_PRIVATEADDRESSWHITELIST_LOG_ALLOWEDREQUESTS: {{ .Values.config.privateAddressWhitelist.log.allowedRequests | default "false" | quote }}
  {{- $quoted := list }}
  {{- range .Values.config.privateAddressWhitelist.allowedRanges }}
    {{- $quoted = append $quoted (quote .) }}
  {{- end }}
  SILLYTAVERN_PRIVATEADDRESSWHITELIST_ALLOWEDRANGES: {{ printf "[%s]" (join ", " $quoted) | squote }}
{{- end }}

  SILLYTAVERN_SESSIONTIMEOUT: {{ .Values.config.sessionTimeout | default "3600" | quote }}
  SILLYTAVERN_DISABLECSRFPROTECTION: {{ .Values.config.disableCsrfProtection | default "false" | quote }}
  SILLYTAVERN_SECURITYOVERRIDE: {{ .Values.config.securityOverride | default "false" | quote }}
  
  SILLYTAVERN_LOGGING_ENABLEACCESSLOG: {{ .Values.config.logging.enableAccessLog | default "true" | quote }}
  SILLYTAVERN_LOGGING_MINLOGLEVEL: {{ .Values.config.logging.minLogLevel | default "1" | quote }}

  SILLYTAVERN_RATELIMITING_PREFERREALIPHEADER: {{ .Values.config.rateLimiting.preferRealIpHeader | default "false" | quote }}
  SILLYTAVERN_RATELIMITING_BASICAUTHMAXATTEMPTS: {{ .Values.config.rateLimiting.basicAuthMaxAttempts | default "5" | quote }}
  SILLYTAVERN_RATELIMITING_ACCOUNTSLOGINMAXATTEMPTS: {{ .Values.config.rateLimiting.enableUserAccounts | default "5" | quote }}
  SILLYTAVERN_RATELIMITING_ACCOUNTSRECOVERMAXATTEMPTS: {{ .Values.config.rateLimiting.accountsRecoverMaxAttempts | default "5" | quote }}

  SILLYTAVERN_FORWARDEDHEADERS_XREALIP: {{ .Values.config.forwardedHeaders.xRealIp | default "true" | quote }}
  SILLYTAVERN_FORWARDEDHEADERS_XFORWARDEDFOR: {{ .Values.config.forwardedHeaders.xForwardedFor | default "true" | quote }}
  SILLYTAVERN_FORWARDEDHEADERS_CFCONNECTINGIP: {{ .Values.config.forwardedHeaders.cfConnectingIp | default "true" | quote }}

  SILLYTAVERN_BACKUPS_ALLOWFULLDATABACKUP: {{ .Values.config.backups.allowFullDataBackup | default "true" | quote }}
  SILLYTAVERN_BACKUPS_COMMON_NUMBEROFBACKUPS: {{ .Values.config.backups.common.numberOfBackups | default "50" | quote }}
  SILLYTAVERN_BACKUPS_CHAT_ENABLED: {{ .Values.config.backups.chat.enabled | default "true" | quote }}
{{- if .Values.config.backups.chat.enabled }}
  SILLYTAVERN_BACKUPS_CHAT_CHECKINTEGRITY: {{ .Values.config.backups.chat.checkIntegrity | default "true" | quote }}
  SILLYTAVERN_BACKUPS_CHAT_MAXTOTALBACKUPS: {{ .Values.config.backups.chat.maxTotalBackups | default "10" | quote }}
  SILLYTAVERN_BACKUPS_CHAT_THROTTLEINTERVAL: {{ .Values.config.backups.chat.throttleInterval | default "10000" | quote }}
{{- end }}

  SILLYTAVERN_THUMBNAILS_ENABLED: {{ .Values.config.thumbnails.enabled | default "true" | quote }}
{{- if .Values.config.thumbnails.enabled }}
  SILLYTAVERN_THUMBNAILS_FORMAT: {{ .Values.config.thumbnails.format | default "jgp" | quote }}
  SILLYTAVERN_THUMBNAILS_QUALITY: {{ .Values.config.thumbnails.quality | default "95" | quote }}
  SILLYTAVERN_THUMBNAILS_DIMENSIONS: {{ .Values.config.thumbnails.dimensions | default "{ 'bg': [160, 90], 'avatar': [96, 144], 'persona': [96, 144] }" | quote }}
{{- end }}

  SILLYTAVERN_PERFORMANCE_LAZYLOADCHARACTERS: {{ .Values.config.performance.lazyLoadCharacters | default "false" | quote }}
  SILLYTAVERN_PERFORMANCE_MEMORYCACHECAPACITY: {{ .Values.config.performance.memoryCacheCapacity | default "100mb" | quote }}
  SILLYTAVERN_PERFORMANCE_USEDISKCACHE: {{ .Values.config.performance.useDiskCache | default "true" | quote }}
  SILLYTAVERN_PERFORMANCE_REQUESTCOMPRESSION_ENABLED: {{ .Values.config.performance.requestCompression.enabled | default "false" | quote }}
{{- if .Values.config.performance.requestCompression.enabled }}
  SILLYTAVERN_PERFORMANCE_REQUESTCOMPRESSION_MINPAYLOADSIZE: {{ .Values.config.performance.requestCompression.minPayloadSize | default "256kb" | quote }}
  SILLYTAVERN_PERFORMANCE_REQUESTCOMPRESSION_MAXPAYLOADSIZE: {{ .Values.config.performance.requestCompression.maxPayloadSize | default "8mb" | quote }}
  SILLYTAVERN_PERFORMANCE_REQUESTCOMPRESSION_TIMEOUT: {{ .Values.config.performance.requestCompression.timeout | default "4000" | quote }}
{{- end }}

  SILLYTAVERN_CACHEBUSTER_ENABLED: {{ .Values.config.cacheBuster.enabled | default "false" | quote }}
{{- if .Values.config.cacheBuster.enabled }}
  SILLYTAVERN_CACHEBUSTER_USERAGENTPATTERN: {{ .Values.config.cacheBuster.userAgentPattern | default "" | quote }}
{{- end }}

  SILLYTAVERN_ALLOWKEYSEXPOSURE: {{ .Values.config.allowKeysExposure | default "false" | quote }}
  SILLYTAVERN_SKIPCONTENTCHECK: {{ .Values.config.skipContentCheck | default "false" | quote }}
{{- $quoted := list }}
{{- range .Values.config.whitelistImportDomains }}
  {{- $quoted = append $quoted (quote .) }}
{{- end }}
  SILLYTAVERN_WHITELISTIMPORTDOMAINS: {{ printf "[%s]" (join ", " $quoted) | squote }}

  SILLYTAVERN_REQUESTOVERRIDES: {{ .Values.config.requestOverrides | default "[]" | quote }}

  SILLYTAVERN_EXTENSIONS_ENABLED: {{ .Values.config.extensions.enabled | default "true" | quote }}
{{- if .Values.config.extensions.enabled }}
  SILLYTAVERN_EXTENSIONS_AUTOUPDATE: {{ .Values.config.extensions.autoUpdate | default "true" | quote }}
  SILLYTAVERN_EXTENSIONS_MODELS_AUTODOWNLOAD: {{ .Values.config.extensions.models.autoDownload | default "true" | quote }}
  SILLYTAVERN_EXTENSIONS_MODELS_CLASSIFICATION: {{ .Values.config.extensions.models.classification | default "Cohee/distilbert-base-uncased-go-emotions-onnx" | quote }}
  SILLYTAVERN_EXTENSIONS_MODELS_CAPTIONING: {{ .Values.config.extensions.models.captioning | default "Xenova/vit-gpt2-image-captioning" | quote }}
  SILLYTAVERN_EXTENSIONS_MODELS_EMBEDDING: {{ .Values.config.extensions.models.embedding | default "Cohee/jina-embeddings-v2-base-en" | quote }}
  SILLYTAVERN_EXTENSIONS_MODELS_SPEECHTOTEXT: {{ .Values.config.extensions.models.speechToText | default "Xenova/whisper-small" | quote }}
  SILLYTAVERN_EXTENSIONS_MODELS_TEXTTOSPEECH: {{ .Values.config.extensions.models.textToSpeech | default "Xenova/speecht5_tts" | quote }}
{{- end }}

  SILLYTAVERN_GIT_BACKEND: {{ .Values.config.git.backend | default "auto" | quote }}
  
  SILLYTAVERN_ENABLDOWNLOADABLETOKENIZERS: {{ .Values.config.enableDownloadableTokenizers | default "true" | quote }}

  SILLYTAVERN_PROMPTPLACEHOLDER: {{ .Values.config.promptPlaceholder | default "[Start a new chat]" | quote }}

  SILLYTAVERN_OPENAI_RANDOMIZEUSERID: {{ .Values.config.openai.randomizeUserId | default "false" | quote }}
  SILLYTAVERN_OPENAI_CAPTIONSYSTEMPROMPT: {{ .Values.config.openai.captionSystemPrompt | default "" | quote }}

  SILLYTAVERN_DEEPL_FORMALITY: {{ .Values.config.deepl.formality | default "default" | quote }}

  SILLYTAVERN_MISTRAL_ENABLEPREFIX: {{ .Values.config.mistral.enablePrefix | default "false" | quote }}

  SILLYTAVERN_OLLAMA_KEEPALIVE: {{ .Values.config.ollama.keepAlive | default "-1" | quote }}
  SILLYTAVERN_OLLAMA_BATCHSIZE: {{ .Values.config.ollama.batchSize | default "-1" | quote }}

  SILLYTAVERN_CLAUDE_ENABLESYSTEMPROMPTCACHE: {{ .Values.config.claude.enableSystemPromptCache | default "false" | quote }}
  SILLYTAVERN_CLAUDE_CACHINGATDEPTH: {{ .Values.config.claude.cachingAtDepth | default "-1" | quote }}
  SILLYTAVERN_CLAUDE_EXTENDEDTTL: {{ .Values.config.claude.extendedTTL | default "false" | quote }}
  SILLYTAVERN_CLAUDE_ENABLEADAPTIVETHINKING: {{ .Values.config.claude.enableAdaptiveThinking | default "false" | quote }}

  SILLYTAVERN_GEMINI_APIVERSION: {{ .Values.config.gemini.apiVersion | default "v1beta" | quote }}
  SILLYTAVERN_GEMINI_THOUGHTSIGNATURE: {{ .Values.config.gemini.thoughtSignatures | default "true" | quote }}
  SILLYTAVERN_GEMINI_ENABLESYSTEMPROMPTCACHE: {{ .Values.config.gemini.enableSystemPromptCache | default "false" | quote }}
  SILLYTAVERN_GEMINI_IMAGE_PERSONGENERATION: {{ .Values.config.gemini.image.personGeneration | default "allow_audit" | quote }}

  SILLYTAVERN_ENABLESERVERPLUGINS: {{ .Values.config.enableServerPlugins | default "false" | quote }}
  SILLYTAVERN_ENABLESERVERPLUGINSAUTOUPDATE: {{ .Values.config.enableServerPluginsAutoUpdate | default "true" | quote }}
