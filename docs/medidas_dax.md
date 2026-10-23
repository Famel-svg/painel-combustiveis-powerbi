# Medidas DAX

Modelo: `fato_preco` (preco, id_data, id_municipio, id_revenda, id_produto) ligada a `dim_data[id_data]`, `dim_localidade[id_municipio]`, `dim_revenda[id_revenda]`, `dim_produto[id_produto]`. Produtos em `dim_produto[produto]`: `DIESEL`, `DIESEL S10`, `ETANOL`, `GASOLINA`.

Decisoes de modelagem:
- Marque `dim_data` como tabela de data usando a coluna `data`.
- `dim_data` so tem dias com observacao (sem fins de semana), nao e calendario continuo. Por isso `DATEADD`/`SAMEPERIODLASTYEAR` nao sao confiaveis; as medidas abaixo deslocam o intervalo com `MIN`/`MAX` de `dim_data[data]` e `ALL(dim_data)`. Se o calendario for completado, pode trocar por `DATEADD`.
- "Semana" aqui e a janela de 7 dias do contexto; se quiser semana ISO, use `dim_data[ano_iso]` e `dim_data[semana_iso]` no eixo (decisao de modelagem). Variacao semanal faz sentido com o eixo em semana ISO.

## Preco medio

Media simples das observacoes de preco no contexto de filtro.

```dax
Preço Médio = AVERAGE ( fato_preco[preco] )
```

## Variacao semanal (% vs semana anterior)

Compara o preco medio do contexto com o mesmo intervalo deslocado 7 dias para tras.

```dax
Variação Semanal % =
VAR ini = MIN ( dim_data[data] )
VAR fim = MAX ( dim_data[data] )
VAR anterior =
    CALCULATE (
        [Preço Médio],
        FILTER ( ALL ( dim_data ), dim_data[data] >= ini - 7 && dim_data[data] <= fim - 7 )
    )
RETURN
    DIVIDE ( [Preço Médio] - anterior, anterior )
```

## Variacao anual (% vs mesmo periodo do ano anterior)

Compara com o mesmo intervalo 12 meses antes.

```dax
Variação Anual % =
VAR ini = MIN ( dim_data[data] )
VAR fim = MAX ( dim_data[data] )
VAR anoAnterior =
    CALCULATE (
        [Preço Médio],
        FILTER ( ALL ( dim_data ), dim_data[data] >= EDATE ( ini, -12 ) && dim_data[data] <= EDATE ( fim, -12 ) )
    )
RETURN
    DIVIDE ( [Preço Médio] - anoAnterior, anoAnterior )
```

## Media movel de 4 semanas

Preco medio dos ultimos 28 dias terminando na ultima data do contexto.

```dax
Média Móvel 4 Semanas =
VAR fim = MAX ( dim_data[data] )
RETURN
    CALCULATE (
        [Preço Médio],
        FILTER ( ALL ( dim_data ), dim_data[data] > fim - 28 && dim_data[data] <= fim )
    )
```

## Ranking de municipio

Posicao do municipio por preco medio (1 = mais barato); troque `ASC` por `DESC` para 1 = mais caro. Use em visual com `dim_localidade[municipio]`.

```dax
Ranking Município =
IF (
    NOT ISBLANK ( [Preço Médio] ),
    RANKX ( ALL ( dim_localidade[municipio] ), [Preço Médio], , ASC, DENSE )
)
```

## Percentual etanol sobre gasolina

Preco medio do etanol dividido pelo da gasolina (referencia classica: abaixo de 70% o etanol compensa).

```dax
Etanol / Gasolina % =
VAR etanol = CALCULATE ( [Preço Médio], dim_produto[produto] = "ETANOL" )
VAR gasolina = CALCULATE ( [Preço Médio], dim_produto[produto] = "GASOLINA" )
RETURN
    DIVIDE ( etanol, gasolina )
```
