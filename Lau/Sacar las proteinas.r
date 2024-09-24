#Hello Lau Pues aqui te subo el codigo de R para que esta Vina salga rápido
#Primero necesitas anotar los genes que tienes diferencialmente expresados, para eso en galaxy buisca la opción anotate your Deseq/dexseq results con los parametros que aparecen en la primera imagen del README llamado Imagenes.md

#Una vez los tengas los descargas en tu compu y tambein te sugiero descargar el editor de texto Notepad++ que como te comenté es mucho mejor que el bloc de notas y de titulo vas a borrar lo que tenga el descargado y vas a pegar la siguiente linea tal cual aparece

#baseMean	log2FoldChange	lfcSE	stat	pvalue	padj	seqname	start	end	strand	GeneID	transcript_id	product	protein_id

#Debes iincluir el # para que R no lea la primera columna como columna sino como rownames te dejo imagen de referencia en el README
#Ahora vamos con el codigo, esto que sigue es R base asi que no necesitas descargar nada mas que la ultima versió de R y R studio

ori_degs <- read.delim("Path_To_Degs", row.names = NULL)
#Reemplaza Path_to_Degs por la ubicación de donde descargaste el archivo, te recomiendo crear una carpeta en documentos  solo para esto y darle a set directory
degs <- na.omit(ori_degs)
names(degs)[names(degs) == "row.names"] <- "gene_id"
names(degs)[names(degs) == "X.baseMean"] <- "baseMean"

#Ahora vamos a filtrar para sacar solo lossignificativos y los de LFC >= 1
degs <- subset(degs, padj >= 0.05)
degs <- subset(degs, abs(log2FoldChange) >= 1)

#Ahora si vamos con lo que necesitas para sacar las secuencias del proteoma
#Primero necesitas descargar el archivo que dice protein.faa.gz del ftp de tu genoma y descomprimirlo
#Ahora camos a descargar Bioconductor si no lo tienes ya y el paquete que uso para extraeer secuencias llamado Biostrings

install.packages("BiocManager")
BiocManager::install("Biobase")
BiocManager::install(update = TRUE)

if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("Biostrings")

#Ahora solo es subir el proteoma (archivo .faa) y correr el codigo de filtrado 

fastap <- "Path_To_FAA"
protein_sequences <- readAAStringSet(fastap)
pids <- degs$protein_id
sequence_names <- names(protein_sequences)
extracted_pids <- gsub("^([^ ]+) .*", "\\1", sequence_names)
matching_indices <- match(pids, extracted_pids)
selected_proteins <- protein_sequences[matching_indices]

DEGS_protein <- "DEGS_protein.fasta"
writeXStringSet(selected_proteins, file = DEGS_protein)

#Y pos eso lo subes aqui http://eggnog-mapper.embl.de/ y ahio es solo seguir la interfaz gráfica, si quieres la anotación de dominios me dices a mi o a Frank y te corremos el interproscan en el servidor o si tienes cuenta y lo quieres hacer tu me dices y te dejo el codigo para hacerlo
#Para el enriquecimiento es solo que nos digas a alguno de los dos para mirar como salió la tabla y mirar como subirla y filtrarla para que el paquete la lea
#Y pos ya seria solo eso :D

