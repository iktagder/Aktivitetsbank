


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