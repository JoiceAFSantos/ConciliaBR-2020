# Etapa 2 — Pix por estado e município

Segunda entrega. O foco é o Pix, que ficou de fora da Etapa 1 porque as séries antigas do Banco Central terminam em 2020 e o Pix começou em novembro de 2020.

## Fonte

API de dados abertos do Pix do Banco Central, serviço `TransacoesPixPorMunicipio`:
`https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/`

Cada chamada devolve um mês (`DataBase` no formato AAAAMM). Campos usados:

| Campo | O que é |
|---|---|
| AnoMes | mês de referência (AAAAMM) |
| Municipio | município |
| Estado | estado |
| VL_PagadorPF / QT_PagadorPF | valor (R$) e quantidade de Pix pagos por pessoas físicas |
| VL_PagadorPJ / QT_PagadorPJ | valor (R$) e quantidade de Pix pagos por pessoas jurídicas |

Os valores são do lado do pagador, agrupados pelo município do pagador.

## Página do relatório

- Filtros: Ano, Mês, Estado
- Cartões: Quantidade de Pix, Valor total, Ticket médio
- Gráfico de colunas: evolução mensal (valor ou quantidade)
- Mapa: valor de Pix por estado (mapa preenchido) ou por município (bolhas)
- Gráfico de barras: top 10 municípios por valor

## Medidas DAX

Crie todas na tabela `Pix_Municipio`, uma por vez em "Nova medida".

```
Qtd_Pix = SUM(Pix_Municipio[QT_PagadorPF]) + SUM(Pix_Municipio[QT_PagadorPJ])
```

```
Valor_Pix = SUM(Pix_Municipio[VL_PagadorPF]) + SUM(Pix_Municipio[VL_PagadorPJ])
```

```
Ticket_Medio_Pix = DIVIDE([Valor_Pix], [Qtd_Pix])
```

```
Participacao_Estado =
DIVIDE(
    [Valor_Pix],
    CALCULATE([Valor_Pix], ALL(Pix_Municipio[Estado]))
)
```

`Participacao_Estado` usa a mesma lógica de `ALL` da participação da Etapa 1: o denominador ignora o filtro de estado, então cada estado é dividido pelo total do período.

## Pontos para checar ao montar

- A primeira carga baixa 12 meses, uns 5.500 municípios por mês. Pode demorar.
- Se algum nome de coluna der erro no Power Query, abra a API no navegador com `$top=5` e confira o nome exato.
- No mapa, selecione `Estado` e marque a categoria de dados como "Estado ou Província" para o Power BI localizar certo. Os nomes vêm em maiúsculas (ex.: SÃO PAULO).
- Teste os cartões com o filtro de mês antes de gravar.

## Cards do board

Crie as issues no GitHub e leve a Etapa 2 para "Done" no fim:

- Etapa 2 — Pix por estado e município
- Etapa 3 — Fraude e contestações (MED)
- Entrega final — Consolidação dos meios de pagamento

## Roteiro do vídeo (tópicos, não decorar)

1. Quem você é e o que mostra a Etapa 2
2. Por que o Pix ficou para essa etapa (as séries antigas acabam em 2020)
3. Mostrar a API do Pix no navegador, depois a consulta no Power Query
4. Filtrar por ano, mês e estado e mostrar cartões, gráfico e mapa mudando
5. Explicar uma medida DAX com suas palavras (sugestão: ticket médio)
6. Mostrar o GitHub, o board e o próximo passo (Etapa 3)
