#!/bin/bash

set -euo pipefail

curl -s -X GET "https://api.anthropic.com/api/oauth/usage" \
    -H "Accept: application/json, text/plain" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $(jq -r '.claudeAiOauth.accessToken' ~/.claude/.credentials.json)" \
    -H "anthropic-beta: oauth-2025-04-20" | jq -r '
    .five_hour |
    "Claude: \(.utilization)% [\(
      ((.resets_at | sub("\\.[0-9]+\\+00:00$"; "Z") | fromdateiso8601) - now) / 60 |
      if . >= 60 then "\(floor / 60 | floor)h \(floor % 60)m" else "\(floor)m" end
    )]"
  '
