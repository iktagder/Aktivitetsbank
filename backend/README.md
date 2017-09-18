


DB migrering og oppdatering
�pne powershell i VAF.Aktivitetsbank.Data mappen:

For � legge til migrering:
���
dotnet ef migrations add parentUtdanningsprogram -s ..\VAF.Aktivitetsbank.API\
���

For � oppdatere databasen / kj�re f�rste migrering: (F�rste migrering vil ogs� legge inn metadata)
���
dotnet ef database update -s ..\VAF.Aktivitetsbank.API\
���

For � lage databasescript:
���
dotnet ef migrations script -s ..\VAF.Aktivitetsbank.API\ -o c:\tmp\dbscript.sql
dotnet ef migrations script 20170514210915_required_user -s ..\VAF.Aktivitetsbank.API\ -o c:\tmp\dbscript_aktivt_felt.sql

���


Hvordan endre mellom lese/skriverettighet i utviklingsmodus:
Endre i appsettings.json - VafOptions.UtviklerKanRedigere true/false


NB! For separat DB/Test/Produksjon - VAF.Aktivitetsbank.Data.Migrations er et eget DbUp migreringsprosjekt uavhengig fra EF Migrations (Se dokumentasjon for mer detaljer)