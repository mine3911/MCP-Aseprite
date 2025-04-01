

> [!IMPORTANT]
>
> **This project is under development and will be updated from time to time.**



## 1、File structure

- mcp: MCP-related code
	- mcp/mcp-client: The key code for the MCP function. Please make sure you have basic knowledge related to MCP.
	- server.python: The intermediate server built with Python is used for communication between the two ends.
- Aseprite: Aseprite-related code,please place all the files inside into the directory of the Aseprite plugin.
	- main.lua: The main entry point for plugin functionality

## 2、How to use

 1. First, start the Server

	```sh
	python server.py
	```

 2. Start the main.lua plugin in Aseprite.

 3. Configure the MCP settings on Claude for desktop or other terminals that support MCP function, and then enable the function.
