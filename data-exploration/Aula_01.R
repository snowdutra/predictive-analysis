library(stats)
library(car)

dados <- read.csv2("C:/Users/gustavo.telles/Desktop/Predictive-Analysis/csv/uber_analise_20181003.csv") # nolint

summary(dados)

modelo_media_RENDP2010 <- lm(data = dados, # nolint
                            formula = dados$media ~ dados$RENDP2010) # nolint

summary(modelo_media_RENDP2010)

modelo_media_ESTAB2016 <- lm(data = dados, # nolint
                            formula = dados$media ~ dados$ESTAB2016) # nolint

summary(modelo_media_ESTAB2016)

modelo_media <- lm(data = dados,
                   formula = dados$media ~
                     dados$QTLINBUS2018 +
                     dados$KMLINBUS2018 +  # nolint
                     dados$QTPONTBUS2018 +
                     dados$QTESTMETRO2018 +
                     dados$RENDP2010 +
                     dados$ARE1 +
                     dados$POP2018 +
                     dados$DENPOP2018 +
                     dados$DOMP2018 +
                     dados$ESTAB2016 +
                     dados$EMP2016 +
                     dados$PNBRAN2010 +
                     dados$TEMP2010_5MIN +
                     dados$TEMP2010_30MIN +
                     dados$TEMP2010_60MIN +
                     dados$TEMP2010_120MIN +
                     dados$TEMP2010_121MIN +
                     dados$TEMP2010_0MIN +
                     dados$PDOMC2010 +
                     dados$PDOMM2010)

summary(modelo_media)
vif(modelo_media)

#stepwise m?dia
modelo_media_stepwise <- step(object = modelo_media)
summary(modelo_media_stepwise)
vif(modelo_media_stepwise)

#teste de multicolinearidade - retira campo TEMP2010_30MIN
modelo_media_stepwise_v2 <- lm(data = dados,
                                formula =  dados$media ~ 
                                              dados$KMLINBUS2018 + 
                                              dados$ARE1 + 
                                              dados$DENPOP2018 + 
                                              dados$EMP2016 + 
                                              dados$PNBRAN2010 + 
                                              #dados$TEMP2010_30MIN + 
                                              dados$TEMP2010_120MIN + 
                                              dados$TEMP2010_121MIN + 
                                              dados$TEMP2010_0MIN)
summary(modelo_media_stepwise_v2)
vif(modelo_media_stepwise_v2)