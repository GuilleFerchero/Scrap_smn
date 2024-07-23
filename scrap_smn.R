#SCRAPEO DE SMN


library(tidyverse)
library(lubridate)

fechas <- seq.Date(ymd("2023-01-01"),ymd("2023-12-31"), by = "day") #aux para crear listado de fechas
list <- paste0(substr(fechas,1,4),substr(fechas,6,7),substr(fechas,9,10))
dataclima <- data.frame()

for (i in list){
  linkday <- paste0("https://ssl.smn.gob.ar/dpd/descarga_opendata.php?file=observaciones/datohorario",i,".txt")
  
  day <- read.table(linkday, skip = 2, nrows = 23)
  dataclima <- rbind(dataclima,day)
  print(paste("Fecha: ", i))
}

#####Limpieza

df <- dataclima %>% 
  select(Fecha = V1,
         Hora = V2,
         Temp = V3,
         Humedad = V4) %>% 
  group_by(Fecha) %>% 
  summarise(Temp_Min = min(Temp),
            Temp_Max = max(Temp),
            Humedad_Media = round(mean(Humedad),2)) %>% 
  mutate(Fecha = dmy(Fecha)) %>% 
  arrange(Fecha)

write.csv(df, "datos_clima_2023.csv", row.names = FALSE)