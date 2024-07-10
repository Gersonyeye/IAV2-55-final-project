
# Directorio de los datos

wd <- '../data/'

options(encoding = "UTF-8")

# Instalar librarías

options(repos = 'https://cloud.r-project.org/')

paquetes <- c('missForest', 'zoo', 'xts')

for (paquete in paquetes) {
    if (!requireNamespace(paquete, quietly = TRUE)) {
        # Si no está instalado, instálalo
        cat(paste('Instalando',paquete,'\n'))
        install.packages(paquete)
    } else {
        # Si ya está instalado, muestra un mensaje
        cat(paste(paquete, "ya está instalado.\n"))
        }
    }

# Importar librerías

cat('Importando librerías \n \n')

library(readr)
library(missForest)
library(zoo)
library(xts)

# Importar datos

cat("Importando datos \n \n")

df <- read_csv(paste0(wd,"PM25_limpio.csv"))

# Quitar columna 'Fecha'

Fecha <- df$Fecha
df_numerico <- as.data.frame((df[,-1]))

# Imputar datos con missForest

cat('Imputación de datos con MissForest en ejecución \n \n')

imp <- missForest(df_numerico,
                    maxiter=15,
                    verbose=TRUE,
                    variablewise=FALSE,
                    mtry=floor(sqrt(ncol(df_numerico))),
                    replace=TRUE,
                    parallelize = c("no","variables","forests")
                    )

cat('imputación finalizada \n \n')

# Error

e <- imp$OOBerror
NRMSE <- data.frame(NRMSE = e)

# Datos completos imputados

df_imp <- round(as.data.frame(imp$ximp),2)

# Complementar datos con fecha

df_compl <- data.frame(Fecha,df_imp)


# Guardar en formato csv todos los datos completos

write.csv(df_compl,paste0(wd,"PM25_imputado.csv"),row.names = FALSE)

cat('PM25_imputado.csv guardado en el directorio data \n \n')

# Guardar el NRMSE del missforest

write.csv(NRMSE,paste0(wd,"NRMSE_missforest.csv"),row.names = FALSE)

cat('NRMSE_missforest.csv guardado en el directorio data \n \n')
