# geo-publisher-deployment

Dit project verzamelt de juiste componenten in een zip-bestand om de geo-publisher-provider te installeren bij de klant.

Hoe de provider code te bouwen staat in [geo-publisher](https://github.com/IDgis/geo-publisher)

Met het commanodo ``./gradlew clean createZip`` maak je een zip (in ./build) met de installatie bestanden. Kopieer deze naar de server waar je de provider wilt installeren. 
Voor de configuratie kun je de configuratie van een eventuele vorige installatie overnemen.
