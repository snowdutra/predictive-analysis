library(tidyverse)
library(car)

# localizar CSV (Downloads)
csv_path <- file.path(Sys.getenv('USERPROFILE'), 'Downloads', 'train.csv') # nolint
if (!file.exists(csv_path)) stop('train.csv não encontrado em Downloads: ', csv_path) # nolint

df <- read_csv(csv_path)

# selecionar colunas e remover NA
cols <- c('SalePrice','OverallQual','GrLivArea','GarageCars','TotalBsmtSF','YearBuilt','FullBath','LotArea') # nolint
df <- df %>% select(all_of(cols)) %>% drop_na()

# transformação log
df <- df %>% mutate(SalePrice = log(SalePrice))

# modelo completo
formula_full <- as.formula('SalePrice ~ OverallQual + GrLivArea + GarageCars + TotalBsmtSF + YearBuilt + FullBath + LotArea') # nolint
m_full <- lm(formula_full, data = df)

# busca exaustiva por AIC (todos os subconjuntos)
predictors <- c('OverallQual','GrLivArea','GarageCars','TotalBsmtSF','YearBuilt','FullBath','LotArea') # nolint
best_aic <- Inf
best_model <- NULL
best_vars <- NULL
for (k in 1:length(predictors)){
  combos <- combn(predictors, k, simplify = FALSE)
  for (vars in combos){
    f <- as.formula(paste('SalePrice ~', paste(vars, collapse = '+'))) # nolint
    m <- lm(f, data = df)
    a <- AIC(m)
    if (a < best_aic){
      best_aic <- a
      best_model <- m
      best_vars <- vars
    }
  }
}

# calcular VIFs
vif_full <- vif(m_full)
vif_step <- vif(best_model)

# ANOVA entre modelos
anova_res <- anova(m_full, best_model)

# preparar saída
out_file <- 'analysis_output_questao01.txt' # nolint
sink(out_file)
cat('--- Modelo completo ---\n') # nolint
cat(sprintf('R2: %.4f  R2 ajustado: %.4f\n\n', summary(m_full)$r.squared, summary(m_full)$adj.r.squared)) # nolint
cat('Tabela de coeficientes (modelo completo)\n') # nolint
print(coef(summary(m_full))) 
cat('\nVIF (modelo completo)\n') # nolint
print(vif_full)

cat('\n--- Modelo selecionado (exhaustive AIC) ---\n') # nolint
cat('Variáveis selecionadas: ', paste(best_vars, collapse = ', '), '\n') # nolint
cat(sprintf('R2: %.4f  R2 ajustado: %.4f\n\n', summary(best_model)$r.squared, summary(best_model)$adj.r.squared)) # nolint
cat('Tabela de coeficientes (modelo step)\n') # nolint
print(coef(summary(best_model)))
cat('\nVIF (modelo step)\n') # nolint
print(vif_step)

cat('\nANOVA (modelo step vs completo)\n') # nolint
print(anova_res)

sink()
cat('Análise salva em', out_file, '\n')     # nolint