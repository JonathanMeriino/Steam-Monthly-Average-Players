# Cargar el paquete tidyverse
library(tidyverse)


# Carga de datos
steam_data <- read.csv('/home/jonathan/Documentos/R Project/steamcharts.csv')

#Definir el umbral de popularidad(100,000 jugadores promedio)

UMBRAL_JUGADORES <- 50000

# Filtrado de juegos populares 
juegos_populares <- steam_data %>%
  # 1. Agrupar por el nombre del juego para operar a nivel de cada titulo 
  group_by(name) %>%
  #2. Calcular el valor maximo de "avg_players" dentro de cada grupo (juego)
  # y almacenarlo temporalmente en la columna "Max_jugadores"
  mutate(Max_jugadores = max(avg_players,na.rm=TRUE)) %>%
  #3. Filtrar el dataset, manteniendo solo las filas cuyo Max_jugadores
  # haya superado nuestro umbral
  filter(Max_jugadores>= UMBRAL_JUGADORES) %>%
  
  #4. Eliminar la columna temporal de maximo y el ID de steam (si no se usara)
  select (-Max_jugadores,-steam_appid) %>%
  
  #5. Desagrupar para que futuras operaciones se apliquen a todo el dataset
  ungroup()

# ------ Verificacion de Resultados -------

head(juegos_populares)
print(juegos_populares)
#Contar cuantos juegos quedaron en total
juegos_finales <- n_distinct(juegos_populares$name)
print()
cat(sprintf("\nEl dataset filtrado contiene %d juegos que superaron los %s jugadores promedio. \n",
            juegos_finales, format (UMBRAL_JUGADORES,big.mark = ",")))

# --- Preparacion de la columna de fecha ---

# Convertir la columna 'month' a un objeto de fecha
juegos_listos <- juegos_populares %>%
  mutate(
    # La columna 'month' tiene un formato Month-Year corto (ej. Jan-25)
    # Usamos my() de lubridate para interpretar "Mes-Año"
    month = my(month)
  )

# Verificar que el formato de la columna 'month' es correcto
print(head(juegos_listos))
