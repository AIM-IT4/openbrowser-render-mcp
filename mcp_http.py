import os
from ax_browser_broker.remote_mcp_server import mcp

mcp.settings.host = "0.0.0.0"
mcp.settings.port = int(os.environ.get("PORT", "10000"))
mcp.settings.stateless_http = True
mcp.settings.json_response = True

if __name__ == "__main__":
    mcp.run(transport="streamable-http")
