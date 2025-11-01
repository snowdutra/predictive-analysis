# Relatório — Análise Preditiva de Custos Médicos (insurance.csv)

## Escolha das Features
Foram selecionadas as variáveis age, bmi, children, sex, smoker e region como preditoras, pois representam fatores demográficos, comportamentais e socioeconômicos que influenciam o custo médico. A variável alvo para regressão foi charges (custo médico). Para classificação, foi criada a variável binária high_cost, definida como 1 se charges $\geq$ 3º quartil (p75), 0 caso contrário. Não utilizamos charges como preditora na classificação, evitando vazamento de dados.

## Pipeline e Boas Práticas
O pipeline seguiu as melhores práticas: a divisão entre treino e teste foi realizada antes do pré-processamento (padronização e one-hot encoding), garantindo que informações do teste não influenciassem o treino. O pré-processamento foi aplicado apenas nos dados de treino e replicado no teste. Utilizamos pipelines do scikit-learn para garantir reprodutibilidade e organização.

## Métricas Utilizadas
Na regressão linear, avaliamos:
- RMSE (Root Mean Squared Error): mede o erro médio quadrático das previsões.
- MAE (Mean Absoluate Error): erro absoluto médio.
- R² (Coeficiente de Determinação): proporção da variância explicada pelo modelo.

Na classificação logística, avaliamos:
- Matriz de Confusão: mostra acertos e erros do modelo.
- F1-score: equilíbrio entre precisão e recall.
- ROC-AUC: capacidade de discriminação do modelo.
- Comparação de limiares: testamos o limiar padrão (0,5) e o limiar que maximiza o F1-score.

## Interpretação dos Resultados
Na regressão, os coeficientes indicam o impacto de cada variável (após escala). smoker e bmi foram os principais fatores de aumento do custo médico. Na classificação, coeficientes positivos indicam maior probabilidade de alto custo; novamente, ser fumante e ter alto IMC são os fatores mais relevantes.

## Conclusão
O modelo seguiu todas as boas práticas, com pipeline reprodutível, métricas adequadas e interpretação clara dos resultados. Foram testadas validação cruzada e regularização, reforçando a robustez da análise.
