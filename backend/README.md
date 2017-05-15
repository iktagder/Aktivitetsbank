


DB migrering og oppdatering
Åpne powershell i VAF.Aktivitetsbank.Data mappen:

For å legge til migrering:
´´´
dotnet ef migrations add parentUtdanningsprogram -s ..\VAF.Aktivitetsbank.Data.UI\
´´´

For å oppdatere databasen:
´´´
dotnet ef database update -s ..\VAF.Aktivitetsbank.Data.UI\
´´´

For å lage databasescript:
´´´
dotnet ef migrations script -s ..\VAF.Aktivitetsbank.Data.UI\ -o c:\tmp\dbscript.sql
dotnet ef migrations script 20170514210915_required_user -s ..\VAF.Aktivitetsbank.Data.UI\ -o c:\tmp\dbscript_aktivt_felt.sql

´´´