


DB migrering og oppdatering
�pne powershell i VAF.Aktivitetsbank.Data mappen:

For � legge til migrering:
���
dotnet ef migrations add parentUtdanningsprogram -s ..\VAF.Aktivitetsbank.Data.UI\
���

For � oppdatere databasen:
���
dotnet ef database update -s ..\VAF.Aktivitetsbank.Data.UI\
���

For � lage databasescript:
���
dotnet ef migrations script -s ..\VAF.Aktivitetsbank.Data.UI\ -o c:\tmp\dbscript.sql
���