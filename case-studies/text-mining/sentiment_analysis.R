# --- Pacotes necessários ---
library(tidyverse)
library(tidytext)
library(dplyr)
library(ggplot2)

# --- Detectar arquivo do texto ---
possible_files <- c("tom_sawyer.txt", "tom-sawyer.txt", "tom_sawyer_1.txt", "tom sawyer.txt")  
text_path <- NULL
for (f in possible_files) {
	if (file.exists(f)) {  
		text_path <- f  
		break  
	}  
}
if (is.null(text_path)) {
	stop(paste0("Arquivo do texto não encontrado. Copie o arquivo 'tom_sawyer.txt' para o diretório: ", getwd()))  
}

# --- Carregar o texto ---
texto <- readLines(text_path, encoding = "UTF-8")
df <- tibble(line = 1:length(texto), text = texto)

# --- Tokenização (palavra por linha) ---
data("stop_words")
tokens <- df %>% 
	unnest_tokens(word, text) %>%   
	mutate(word = str_to_lower(word)) %>%  
	mutate(word = str_extract(word, "[a-z']+")) %>%  
	filter(!is.na(word)) %>%  
	anti_join(stop_words, by = "word")  

# --- Associação de sentimentos (léxico Bing) ---
# Agrupamos o texto em blocos para observar variação ao longo da narrativa.
block_size <- 40 # linhas por bloco (pode ajustar para 20 ou 80)
sent_join <- tokens %>%
	inner_join(get_sentiments("bing"), by = "word") %>%  
	mutate(index = (line - 1) %/% block_size + 1) %>%  
	count(index, sentiment) %>%  
	pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>%  
	mutate(sentiment_score = positive - negative)  

# --- Palavras que mais contribuem ---
top_pos <- tokens %>%
	inner_join(get_sentiments("bing") %>% filter(sentiment == "positive"), by = "word") %>%   
	count(word, sort = TRUE) %>%  
	slice_max(n, n = 20)   

top_neg <- tokens %>%
	inner_join(get_sentiments("bing") %>% filter(sentiment == "negative"), by = "word") %>%  
	count(word, sort = TRUE) %>%  
	slice_max(n, n = 20)  

# --- Gráfico de variação de sentimento ---
plot_file <- "sentiment_variation_bing.png"
png(plot_file, width = 1200, height = 600)
ggplot(sent_join, aes(x = index, y = sentiment_score)) +
	geom_col(fill = "steelblue", show.legend = FALSE) +  
	labs(title = "Variação de Sentimento ao longo de 'The Adventures of Tom Sawyer' (Bing)",  
			 x = paste0("Trecho (agrupamento de ", block_size, " linhas)"),  
			 y = "Índice de sentimento líquido (Positivo - Negativo)") +  
	theme_minimal()  
dev.off()

# --- Salvar tabelas de palavras ---
write_csv(top_pos, "top_positive_words_bing.csv")
write_csv(top_neg, "top_negative_words_bing.csv")

# --- Salvar dados de sentimento por bloco ---
write_csv(sent_join, "sentiment_by_block_bing.csv")

# --- Sumário em arquivo de texto ---
out_file <- "analysis_output_questao03.txt"
sink(out_file)
cat("Questão 3 - Análise de Sentimento em 'The Adventures of Tom Sawyer'\n")
cat("Arquivo usado:", text_path, "\n\n")
cat("Configuração: block_size =", block_size, "linhas por bloco\n\n")
cat("Número de blocos analisados:", nrow(sent_join), "\n\n")
cat("Top 20 palavras positivas (Bing):\n")
print(top_pos)
cat("\nTop 20 palavras negativas (Bing):\n")
print(top_neg)
cat("\nResumo rápido da variação de sentimento (primeiros 10 blocos):\n")
print(head(sent_join, 10))
sink()

cat("Análise concluída. Arquivos gerados:\n")
cat(" -", plot_file, "(gráfico)\n")
cat(" - top_positive_words_bing.csv\n")
cat(" - top_negative_words_bing.csv\n")
cat(" - sentiment_by_block_bing.csv\n")
cat(" -", out_file, "(resumo)\n")

# Fim do script
 