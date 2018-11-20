# Aktivitetsbank for videregående skoler

[![Build Status](https://vaf.visualstudio.com/VAF.Aktivitetsbank/_apis/build/status/vest-agder.VAF.Aktivitetsbank)](https://vaf.visualstudio.com/VAF.Aktivitetsbank/_build/latest?definitionId=41)

## Består av følgende deler

|                                   | 
|-----------------------------------|
| [Frontend](./frontend/README.md)  |
| [Backend](./backend/README.md)    |
| Database Migration                |

## Requirements

Deploy av Migrations:

* PowerShell må kunne kjøre. Ved feil, settes med: `Set-ExecutionPolicy RemoteSigned`.
* PowerShell v4 (feks ved installasjon på Windows 2008 R2)
* .NET Framework v4.6.1 (evt. nyere som 4.7.2)

For å kjøre backend:

* _.NET Core_ må være installert. (https://www.microsoft.com/net/download/dotnet-core/2.1)
  * ASP.NET Core/.NET Core: Runtime & Hosting Bundle
  * ASP.NET Core Installer: x64
* IIS må være satt opp med `Windows Authentication` aktivert.