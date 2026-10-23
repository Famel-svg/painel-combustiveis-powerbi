// Consultas Power Query M - painel de combustiveis (modelo estrela).
// Parametro de caminho: crie no Power Query uma consulta/parametro "CaminhoAmostra" (tipo Texto)
// apontando para a pasta data\amostra, SEMPRE com barra final. Exemplo (comentado, nao use caminho absoluto no repo):
//
//   CaminhoAmostra = "data\amostra\" meta [IsParameterQuery=true, Type="Text", IsParameterQueryRequired=true]
//
// Power Query nao resolve caminho relativo ao .pbix sozinho: ajuste o parametro por maquina
// (Transformar dados > Gerenciar parametros) ou publique a pasta em um local fixo. Todas as consultas usam CaminhoAmostra.
// Os CSVs sao UTF-8, separados por virgula, preco com ponto decimal (cultura en-US na conversao).

// ============================================================
// fato_preco
// Fonte: fato_preco.csv. Colunas: data, municipio, revenda, produto, preco, id_data, id_municipio, id_revenda, id_produto.
// Limpeza: cabecalho promovido; trim nos textos; data como date; preco como number; ids como Int64.
// ============================================================
shared fato_preco = let
    Fonte = Csv.Document(File.Contents(CaminhoAmostra & "fato_preco.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Cabecalho = Table.PromoteHeaders(Fonte, [PromoteAllScalars = true]),
    Tipos = Table.TransformColumnTypes(Cabecalho, {
        {"data", type date}, {"municipio", type text}, {"revenda", type text}, {"produto", type text},
        {"preco", type number},
        {"id_data", Int64.Type}, {"id_municipio", Int64.Type}, {"id_revenda", Int64.Type}, {"id_produto", Int64.Type}
    }, "en-US"),
    Limpo = Table.TransformColumns(Tipos, {
        {"municipio", Text.Trim, type text}, {"revenda", Text.Trim, type text}, {"produto", Text.Trim, type text}
    })
in
    Limpo;

// ============================================================
// dim_data
// Fonte: dim_data.csv. Colunas: id_data, data, ano, mes, dia, semana_iso, ano_iso.
// Limpeza: cabecalho promovido; data como date; demais colunas inteiras (Int64).
// Obs.: so contem dias com observacao (nao e calendario continuo).
// ============================================================
shared dim_data = let
    Fonte = Csv.Document(File.Contents(CaminhoAmostra & "dim_data.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Cabecalho = Table.PromoteHeaders(Fonte, [PromoteAllScalars = true]),
    Tipos = Table.TransformColumnTypes(Cabecalho, {
        {"id_data", Int64.Type}, {"data", type date}, {"ano", Int64.Type}, {"mes", Int64.Type},
        {"dia", Int64.Type}, {"semana_iso", Int64.Type}, {"ano_iso", Int64.Type}
    }, "en-US")
in
    Tipos;

// ============================================================
// dim_produto
// Fonte: dim_produto.csv. Colunas: id_produto, produto, unidade.
// Limpeza: cabecalho promovido; id Int64; textos com trim.
// ============================================================
shared dim_produto = let
    Fonte = Csv.Document(File.Contents(CaminhoAmostra & "dim_produto.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Cabecalho = Table.PromoteHeaders(Fonte, [PromoteAllScalars = true]),
    Tipos = Table.TransformColumnTypes(Cabecalho, {{"id_produto", Int64.Type}, {"produto", type text}, {"unidade", type text}}, "en-US"),
    Limpo = Table.TransformColumns(Tipos, {{"produto", Text.Trim, type text}, {"unidade", Text.Trim, type text}})
in
    Limpo;

// ============================================================
// dim_localidade
// Fonte: dim_localidade.csv. Colunas: id_municipio, municipio, uf.
// Limpeza: cabecalho promovido; id Int64; textos com trim.
// ============================================================
shared dim_localidade = let
    Fonte = Csv.Document(File.Contents(CaminhoAmostra & "dim_localidade.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Cabecalho = Table.PromoteHeaders(Fonte, [PromoteAllScalars = true]),
    Tipos = Table.TransformColumnTypes(Cabecalho, {{"id_municipio", Int64.Type}, {"municipio", type text}, {"uf", type text}}, "en-US"),
    Limpo = Table.TransformColumns(Tipos, {{"municipio", Text.Trim, type text}, {"uf", Text.Trim, type text}})
in
    Limpo;

// ============================================================
// dim_revenda
// Fonte: dim_revenda.csv. Colunas: id_revenda, revenda, bandeira.
// Limpeza: cabecalho promovido; id Int64; textos com trim.
// ============================================================
shared dim_revenda = let
    Fonte = Csv.Document(File.Contents(CaminhoAmostra & "dim_revenda.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Cabecalho = Table.PromoteHeaders(Fonte, [PromoteAllScalars = true]),
    Tipos = Table.TransformColumnTypes(Cabecalho, {{"id_revenda", Int64.Type}, {"revenda", type text}, {"bandeira", type text}}, "en-US"),
    Limpo = Table.TransformColumns(Tipos, {{"revenda", Text.Trim, type text}, {"bandeira", Text.Trim, type text}})
in
    Limpo;
