# Amostra do modelo

Amostra pequena para abrir o modelo no Power BI Desktop sem baixar o dataset completo.

- Fonte: `combustiveis-sql-analytics/data/processed/precos_rj.csv` (ANP, recorte RJ, 2023 a 2025).
- Recorte: 2025-01-01 a 2025-03-31.
- Municípios: os 5 com mais registros no período (RIO DE JANEIRO, SAO GONCALO, DUQUE DE CAXIAS, NOVA IGUACU, NITEROI).
- Script que gera tudo: `scripts/gerar_amostra.py` (só biblioteca padrão).
- Colunas removidas: `cnpj_revenda` (não entra no modelo). Razão social do posto é mantida, por ser dado público de empresa.

| Arquivo | Linhas | Papel |
|---|---:|---|
| `data/amostra/fato_preco.csv` | 5.009 | Fato: uma linha por preço observado |
| `data/amostra/dim_data.csv` | 44 | Dimensão de data |
| `data/amostra/dim_produto.csv` | 4 | Dimensão de produto |
| `data/amostra/dim_localidade.csv` | 5 | Dimensão de município |
| `data/amostra/dim_revenda.csv` | 254 | Dimensão de revenda (uma bandeira por revenda: a mais frequente) |

Verificação feita ao gerar: nenhuma chave órfã no fato, nenhuma linha descartada por preço inválido, nenhum campo `cnpj` nos arquivos.

Para regerar: `python scripts/gerar_amostra.py`
