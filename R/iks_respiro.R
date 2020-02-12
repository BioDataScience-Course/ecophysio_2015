# Importation des données --------------
load("data/raw/C_2016-04-18_17.00.01_57151291_IKS.RData")
EcoA<-EcoNumData_IKS.C
load("data/raw/C_2016-04-19_00.00.12_5715750C_IKS.RData")
EcoB<-EcoNumData_IKS.C
load("data/raw/C_2016-04-20_00.00.02_5716C682_IKS.RData")
EcoC<-EcoNumData_IKS.C
load("data/raw/C_2016-04-21_00.00.14_5718180E_IKS.RData")
EcoD<-EcoNumData_IKS.C

# Combinaison avec dplyr -------------
library("dplyr")
Eco<-bind_rows(EcoA,EcoB,EcoC,EcoD)
rm(EcoA,EcoB,EcoC,EcoD, EcoNumData_IKS.C)
## par la succession d'étape j'ai compilé mes données pour avoir un unique jeu de données

## Lors du lancement des respiromètres, des mesures d'oxygènes sont réalisé pour calibrer les sondes à oxygène employés par les sondes IKS.
## correction de l'erreur sur le jeu de donnée de base. décalage entre l'IKS et l'oxymètre de plus haute précision

Eco %>% 
  mutate(
    O2_1N = ((O2_1*10.3)/8.88),
    O2_2N = ((O2_2*10.3)/9.01),
    O2_3N = ((O2_3*10.3)/10.38),
    O2_4N = ((O2_4*10.3)/9.12),
    O2_5N = ((O2_5*10.3)/9.45),
    O2_6N = ((O2_6*10.3)/10.1)) -> Eco

## Traitment des données du respiromètre du 2016-04-18 20:00:00 à 2016-04-21 18:00:00
ecoph <- Eco[Eco$Time >= as.POSIXct("2016-04-19 20:11:00") & Eco$Time < as.POSIXct("2016-04-21 18:11:00"), ]

saveRDS(ecoph, file = "data/respiro.rds", compress = "xz")
