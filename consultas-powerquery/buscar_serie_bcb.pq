// Consulta parametrizada ao Banco Central (SGS)
// Reaproveitável para qualquer código de série informado abaixo.

let
    BuscarSerieBCB = (codigo as number, rotulo as text) as table =>
    let
        endereco = "https://api.bcb.gov.br/dados/serie/bcdata.sgs." & Number.ToText(codigo) & "/dados?formato=json",
        bruto = Json.Document(Web.Contents(endereco)),
        tabela = Table.FromList(bruto, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        expandida = Table.ExpandRecordColumn(tabela, "Column1", {"data", "valor"}, {"periodo", "valor"}),
        tipada = Table.TransformColumnTypes(expandida, {{"periodo", type text}, {"valor", type number}}),
        comAno = Table.AddColumn(tipada, "ano", each Date.Year(Date.FromText(Text.Middle([periodo], 6, 4) & "-" & Text.Middle([periodo], 3, 2) & "-" & Text.Start([periodo], 2)))),
        comRotulo = Table.AddColumn(comAno, "indicador", each rotulo),
        comCodigo = Table.AddColumn(comRotulo, "codigo_bcb", each codigo),
        resultado = Table.SelectColumns(comCodigo, {"codigo_bcb", "indicador", "ano", "valor"})
    in
        resultado
in
    BuscarSerieBCB

// Exemplos de chamada (uma consulta por indicador, depois anexadas):
// BuscarSerieBCB(25223, "Cartão de crédito - quantidade")
// BuscarSerieBCB(25224, "Cartão de débito - quantidade")
// BuscarSerieBCB(25225, "Cheques - quantidade")
// BuscarSerieBCB(25226, "Débito direto - quantidade")
// BuscarSerieBCB(25228, "Cartão de débito - valor")
// BuscarSerieBCB(25229, "Cartão de crédito - valor")
