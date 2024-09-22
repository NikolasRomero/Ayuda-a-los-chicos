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

#Me di cuenta que les tocría a mano extraer las secuencias de las proteinas y me parece que es demasiado complique entonces les dejo esto 
#Necesitan descargar los archivos de la pagina del genoma de porosus que aparecen en la imagen del README
#Tienen que instalar estos paquetes que pues en general les van a servir mucho porque son de bioinformatica se descargan asi porque hacen parte de un repositorio que no es de R base

install.packages("BiocManager")
BiocManager::install("Biobase")
BiocManager::install(update = TRUE)

if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("Biostrings")
BiocManager::install("rtracklayer")

library(rtracklayer)
library(BioStrings)

#Nuevamente reemplazen el path_to pot la ruta a su archivo

gtf_file <- "Path_to_gtf"
gtf_data <- import(gtf_file)
gtf_df <- as.data.frame(gtf_data)


matching_rows <- gtf_df[gtf_df$gene_id %in% Possible_MHC$Symbol, ]
protein_ids <- unique(matching_rows$protein_id)

#Extraer las Secuencias del proteoma (archivo .faa)

fastap <- "Path_To_FAA"
protein_sequences <- readAAStringSet(fastap)
pids <- na.omit(protein_ids)
sequence_names <- names(protein_sequences)
extracted_pids <- gsub("^([^ ]+) .*", "\\1", sequence_names)
matching_indices <- match(pids, extracted_pids)
selected_proteins <- protein_sequences[matching_indices]

MHC<- "MHC.fasta"
writeXStringSet(selected_proteins, file = MHC)


