// Etapa 2 - Pix por município (API Olinda do Banco Central)
// A API devolve um mês por chamada (parâmetro DataBase no formato AAAAMM),
// então a consulta chama a função uma vez para cada mês da lista e empilha tudo.
//
// Como usar no Power BI:
// 1. Transformar dados > Nova Fonte > Consulta Nula > Editor Avançado
// 2. Colar este código e renomear a consulta para Pix_Municipio
// 3. Credenciais: Anônimo, nível Público (mesmo processo da Etapa 1)

let
    // Meses que entram no painel. Para mudar o período, edite só esta lista.
    meses = {"202501","202502","202503","202504","202505","202506",
             "202507","202508","202509","202510","202511","202512"},

    buscarMes = (anoMes as text) as table =>
    let
        resposta = Json.Document(
            Web.Contents(
                "https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/",
                [
                    RelativePath = "TransacoesPixPorMunicipio(DataBase=@DataBase)",
                    Query = [
                        #"@DataBase" = "'" & anoMes & "'",
                        #"$format" = "json",
                        #"$top" = "10000"
                    ]
                ]
            )
        ),
        lista = resposta[value],
        tabela = Table.FromList(lista, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        expandida = Table.ExpandRecordColumn(
            tabela, "Column1",
            {"AnoMes", "Municipio", "Estado", "VL_PagadorPF", "QT_PagadorPF", "VL_PagadorPJ", "QT_PagadorPJ"}
        )
    in
        expandida,

    todosMeses = List.Transform(meses, each buscarMes(_)),
    empilhado = Table.Combine(todosMeses),

    tipado = Table.TransformColumnTypes(empilhado, {
        {"AnoMes", type text}, {"Municipio", type text}, {"Estado", type text},
        {"VL_PagadorPF", type number}, {"QT_PagadorPF", Int64.Type},
        {"VL_PagadorPJ", type number}, {"QT_PagadorPJ", Int64.Type}
    }),

    comAno = Table.AddColumn(tipado, "Ano", each Number.FromText(Text.Start([AnoMes], 4)), Int64.Type),
    comMes = Table.AddColumn(comAno, "Mes", each Number.FromText(Text.End([AnoMes], 2)), Int64.Type)
in
    comMes
