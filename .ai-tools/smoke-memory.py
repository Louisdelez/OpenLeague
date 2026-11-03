"""Exercise the actual local stdio MCP memory service without launching an AI agent."""
import asyncio
import json
from pathlib import Path

from fastmcp import Client


async def main():
    root = Path(__file__).resolve().parent.parent
    config = {"mcpServers": {"openleague-memory": {
        "command": "node", "args": [str(root / ".ai-tools/memory.mjs")]
    }}}
    async with Client(config, timeout=45, init_timeout=30) as client:
        tools = await client.list_tools()
        names = [tool.name for tool in tools]
        assert "search_notes" in names, names
        assert "read_note" in names, names
        # The service accepts MCP requests before its initial background index is ready.
        payload = ""
        for attempt in range(20):
            result = await client.call_tool("search_notes", {"query": "scope", "project": "openleague", "search_type": "text"})
            payload = "\n".join(getattr(item, "text", "") for item in result.content)
            if "OpenLeague project scope and evidence" in payload:
                break
            await asyncio.sleep(1)
        assert "OpenLeague project scope and evidence" in payload, payload
        note = await client.call_tool("read_note", {"identifier": "project", "project": "openleague"})
        text = "\n".join(getattr(item, "text", "") for item in note.content)
        assert "# OpenLeague" in text and "Observations" in text, text
        print(json.dumps({"mcp_handshake": True, "tools_count": len(names), "search_notes_call": True, "search_result_contains_project": True, "read_note_call": True, "local_only": True}))


if __name__ == "__main__":
    asyncio.run(main())
