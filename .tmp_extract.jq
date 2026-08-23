{
  type: .type,
  role: (.message.role // null),
  content_summary: (
    if .message.content == null then null
    elif (.message.content | type) == "string" then (.message.content[0:500])
    else
      [.message.content[]? |
        if .type == "text" then {t:"text", v:(.text[0:800])}
        elif .type == "tool_use" then {t:"tool_use", name:.name, input:(.input | tostring | .[0:300])}
        elif .type == "tool_result" then {t:"tool_result", v:(.content | tostring | .[0:300])}
        else {t:.type}
        end
      ]
    end
  )
} | select(.type=="user" or .type=="assistant")
