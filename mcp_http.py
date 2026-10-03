import os
from ax_browser_broker.remote_mcp_server import mcp
from mcp.server.transport_security import TransportSecuritySettings

public_host = os.environ["MCP_PUBLIC_HOST"].strip()

mcp.settings.host = "0.0.0.0"
mcp.settings.port = int(os.environ.get("PORT", "10000"))
mcp.settings.stateless_http = True
mcp.settings.json_response = True
mcp.settings.transport_security = TransportSecuritySettings(
    enable_dns_rebinding_protection=True,
    allowed_hosts=[
        public_host,
        f"{public_host}:*",
        "127.0.0.1:*",
        "localhost:*",
    ],
    allowed_origins=[
        "https://chatgpt.com",
        "https://chat.openai.com",
    ],
)

if __name__ == "__main__":
    mcp.run(transport="streamable-http")
