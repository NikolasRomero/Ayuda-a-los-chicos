#Primero van a subir el archivo .gaf para modificarlo  y otros archivos de texto plano les sugiero descargar Notepad++ que es une ditor de texto mucho mejhor que el Bloc de Notas
#En Path to GAF deben cambiarlo por la ruta donde guardaron el GAF modificado
gaf <- read.delim("Path_to_GAF", header = TRUE, comment.char = "!", stringsAsFactors = FALSE)
#Si quieren extraer columnas seria asi
annotations <- gaf[, c("GeneID", "GO_ID", "Aspect", "With.From")]
#No es obligatorio

#Vamos a crear una lista de loa GO mas importantes, aqui inclui unos de humano a ver si cae por ese lado

GOs <- c("GO:0030881", "GO:0032393 ", "GO:0042608", "GO:0002474", "GO:0002854", "GO:0002729", "GO:0002767", "GO:0042610", "GO:0001916", "GO:0002476", "GO:0002486", "GO:0042612", "GO:0042613", "GO:0023026", "GO:0032395", "GO:0019886", "GO:0002587", "GO:0002503")

#Filtrosobre el GAF

Possible_MHC <- gaf[gaf$GO_ID %in% GOs, ]

