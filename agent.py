import asyncio
from google.antigravity import Agent, LocalAgentConfig

async def main():
    config = LocalAgentConfig(
        system_instructions=(
            "You are a helpful pirate assistant. Speak like a pirate."
        ),
    )
    async with Agent(config) as agent:
        response = await agent.chat("Explain the repository layout.")
        print(await response.text())

if __name__ == "__main__":
    asyncio.run(main())