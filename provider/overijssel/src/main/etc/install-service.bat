publisher-provider //IS --DisplayName "GIS Publicatieomgeving Provider" --Description "Hiermee krijgt de GIS Publicatieomgeving toegang tot de brongegevens" --Classpath classes;publisher-provider-app.jar --StartMode jvm --StartClass nl.idgis.publisher.provider.App --StopMode jvm --StopClass nl.idgis.publisher.provider.App --StopMethod stop --Startup auto --JvmOptions=-javaagent:aspectjweaver.jar