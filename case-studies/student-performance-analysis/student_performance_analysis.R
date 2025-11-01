# Script para executar
library(tidyverse)
library(readr)
library(car)
library(MASS)

# Carregar dados: procurar no diretório atual ou em Downloads
csv_paths <- c('StudentsPerformance.csv', file.path(Sys.getenv('USERPROFILE'), 'Downloads', 'StudentsPerformance.csv'))  
csv_exists <- csv_paths[file.exists(csv_paths)]
if (length(csv_exists) == 0) {
  stop('Arquivo StudentsPerformance.csv não encontrado no diretório do projeto nem em ~/Downloads. Por favor coloque o CSV no diretório do projeto ou em Downloads.')  
csv_exists <- csv_paths[file.exists(csv_paths)]
}
df <- read_csv(csv_exists[1])

# Normalizar nomes de colunas (ex: 'math score' -> 'math.score') para compatibilidade  
csv_exists <- csv_paths[file.exists(csv_paths)]
names(df) <- make.names(names(df))

# Criar avg_score e fatores
df <- df %>%
  mutate(
    avg_score = (math.score + reading.score + writing.score)/3,  
    gender = factor(gender),
    race.ethnicity = factor(race.ethnicity),
    lunch = factor(lunch),
    test.preparation.course = factor(test.preparation.course)
  )

sink('analysis_output_questao02.txt')  
cat('--- Modelo completo (summary) ---\n')  
m_full <- lm(avg_score ~ gender + race.ethnicity + lunch + test.preparation.course, data = df)  
print(summary(m_full))
cat('\n--- VIF (modelo completo) ---\n')  
print(vif(m_full))
 
cat('\n--- Modelo stepAIC (summary) ---\n')  
m_step <- stepAIC(m_full, direction='both', trace=FALSE)  
print(summary(m_step))
cat('\n--- VIF (modelo step) ---\n')  
print(vif(m_step))

cat('\n--- ANOVA (m_full vs m_step) ---\n')  
print(anova(m_full, m_step))

sink()

cat('Resultados gravados em questao02_output.txt\n')  
