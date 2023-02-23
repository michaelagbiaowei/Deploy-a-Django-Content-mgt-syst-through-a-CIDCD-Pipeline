global:
  resolve_timeout: 1m
  slack_api_url: "https://hooks.slack.com/services/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"

route:
  group_by: [Alertname]
  receiver: alert-me

receivers:
  - name: alert-me
    # Email
    email_configs:
      - to: your@email.address
        from: your@email.address
        smarthost: mail.server.address:587
        auth_username: your@email.address
        auth_identity: your@email.address
        auth_password: abcdefghijklmnop
    # Slack
    slack_configs:
      - channel: "#project"
        send_resolved: true
        icon_url: https://avatars3.githubusercontent.com/u/3380462
        title: |-
          [{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}] {{ .CommonLabels.alertname }} for {{ .CommonLabels.job }}
          {{- if gt (len .CommonLabels) (len .GroupLabels) -}}
          {{" "}}(
          {{- with .CommonLabels.Remove .GroupLabels.Names }}
              {{- range $index, $label := .SortedPairs -}}
              {{ if $index }}, {{ end }}
              {{- $label.Name }}="{{ $label.Value -}}"
              {{- end }}
          {{- end -}}
          )
          {{- end }}
        text: >-
          {{ range .Alerts -}}
          *Alert:* {{ .Annotations.title }}{{ if .Labels.severity }} - `{{ .Labels.severity }}`{{ end }}
          *Description:* {{ .Annotations.description }}
          *Details:*
          {{ range .Labels.SortedPairs }} • *{{ .Name }}:* `{{ .Value }}`
          {{ end }}
          {{ end }}
