# Meios de Pagamento no Brasil

Painel de BI que fiz pra faculdade (disciplina de Software Product), olhando como os meios de pagamento mudaram no Brasil ao longo dos anos: cartão de crédito, débito, cheque e débito direto. Dado vem direto do Banco Central, não é nada inventado.

A ideia é ir construindo esse painel em etapas ao longo do semestre, cada entrega adicionando uma análise nova.

## Por que esse tema

Escolhi pagamentos porque é um assunto que muda rápido (o Pix é o exemplo mais óbvio disso) e porque o Banco Central disponibiliza os dados de forma aberta, o que dá pra puxar tudo direto de uma API, sem precisar simular nada.

## Por que esse tema

Meios de pagamento é um assunto que muda rápido no Brasil (a ascensão do Pix é o exemplo mais óbvio) e o Banco Central disponibiliza séries históricas abertas sobre isso, o que permite um projeto de BI com dado real e verificável, sem precisar simular nada.

## Fonte dos dados

Sistema Gerenciador de Séries Temporais (SGS) do Banco Central do Brasil.

- Consulta oficial: https://www3.bcb.gov.br/sgspub/
- Endpoint usado neste projeto: `https://api.bcb.gov.br/dados/serie/bcdata.sgs.{codigo}/dados?formato=json`
- Cada série tem um código numérico próprio (ex: 25223 = quantidade de transações com cartão de crédito)

O detalhe de cada série usada está em `fonte-dados/catalogo_indicadores.csv`.

## Etapa 1 — Panorama Geral por Instrumento

Nessa primeira entrega, o foco foi entender o tamanho e a evolução de cada meio de pagamento ao longo dos anos, antes de entrar em análises mais específicas (Pix, fraude) nas próximas etapas.

Indicadores construídos:
- Quantidade de transações por instrumento, por ano
- Valor total movimentado (R$) por instrumento, por ano
- Participação de cada instrumento no total transacionado
- Variação percentual (ano corrente vs. ano anterior)

Filtros do painel:
- Ano (intervalo)
- Instrumento de pagamento
- Tipo de métrica (quantidade ou valor financeiro)

### Principais achados (2011–2020)

- Em valor movimentado, o **cartão de crédito responde por 61,6%** do total transacionado entre crédito e débito, contra **38,4% do débito** — um sinal de que, apesar do crescimento do débito, o crédito segue dominante em volume financeiro.
- Em quantidade de transações, os quatro instrumentos (crédito, débito, cheques e débito direto) mostram trajetórias de crescimento mais equilibradas entre si ao longo da década.
- Cheques seguem em uso residual quando comparados aos demais instrumentos, mas ainda aparecem na série histórica do Banco Central.

## Como os dados chegam no Power BI

Em vez de baixar CSV manualmente, o Power Query consulta a API do Banco Central diretamente, usando `Web.Contents`. A função reutilizável está em `consultas-powerquery/buscar_serie_bcb.pq` — ela recebe o código da série e devolve uma tabela já tratada (ano + valor + rótulo do indicador).

Isso significa que atualizar o painel no futuro é só reabrir e atualizar a consulta — sem precisar editar arquivo nenhum.

Os dois arquivos CSV dentro de `fonte-dados/` são uma cópia estática dos dados já validados (guardados como evidência/backup), mas o relatório em si consome a API ao vivo.

## Estrutura das pastas

```
MeiosPagamento-BI/
├── fonte-dados/
│   ├── cartao_credito_quantidade.csv
│   ├── debito_direto_quantidade.csv
│   └── catalogo_indicadores.csv
├── consultas-powerquery/
│   └── buscar_serie_bcb.pq
├── relatorio/
│   └── (arquivo .pbix será adicionado aqui)
├── docs/
│   └── roadmap.md
└── README.md
```

## Roadmap do projeto

Ver `docs/roadmap.md` para o detalhamento de cada etapa futura.
