install.packages("tidyverse")
library(tidyverse)

#Diferencia entre .csv y _csv
#.csv genera un data frame
#_csv genera un tibble
sat <- read.csv("C:\\Users\\amali\\OneDrive\\Documentos\\UniAndes\\Big data y Machine Learning\\BDML\\2012_SAT_Results.csv")
demog<-read_csv("C:\\Users\\amali\\OneDrive\\Documentos\\UniAndes\\Big data y Machine Learning\\BDML\\demog.csv")

#Para seleccionar variables que nos interesan
demog<- demog %>% 
  select(DBN,Name,schoolyear,asian_per,black_per,hispanic_per,white_per,starts_with("grade"))

#Para remover
rm(demog_subset)

#Para filtrar
demog<- demog %>% filter(grade9!="NA")

#Renombrar
demog<-demog %>% rename(Anoescolar=schoolyear)

#Creación de nueva variable
demog<-demog %>% mutate(perc_total=asian_per+black_per+hispanic_per+white_per)

#Para tener estadistica descriptiva
summary(demog$perc_total)

#Para transformar nuestros datos (lo racial) de wide (ancho) a long pero solo
#de 2011

demog_long<-demog %>% 
  filter(Anoescolar=="20112012") %>% 
  select(DBN,Name,Anoescolar,asian_per,black_per,hispanic_per,white_per) %>% 
  pivot_longer(cols=c(asian_per,black_per,hispanic_per,white_per),
               names_to = "Race",values_to ="Perc" )

#Resumen por grupos
demog_long_summary<- demog_long %>% 
  group_by(DBN,Name,Anoescolar) %>% 
  summarize(perc_total=sum(Perc))

sat_demog<-sat %>% 
  left_join(demog,by=c("DBN")) %>% 
  filter(Anoescolar=="20112012")

#Gráfico dispersión 
plot(sat_demog$SAT.Math.Avg..Score, sat_demog$black_per)
