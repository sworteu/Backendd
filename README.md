# Backendd
A web server made with Xojo, for use as a backend (backendd for daemon).

- Originally based on AloeExpress made by Tim Dietrich
- Rebranded to be interchangable (no-naming conflicts)

## Includes AloeExpress features:
- Session management
- Cache management
- Server/client management
- Threading (Multi-server configuration)
- Template parser/engine
- Loopback interface usage (only local machine can communicate with the application)

## Backendd features:
- Event based (Backendd.BackenddApplication, as superclass of App class)
- Run as Daemon or as child process (usefull in WebApplication as master setup)
- Alows to communicate trough Shell/Cli when not configured as daemon (default, -d option to start as daemon)
- More to come.
