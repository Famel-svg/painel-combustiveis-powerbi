# Dicionário de Dados

Dicionário do modelo estrela da amostra (`data\amostra\`): uma tabela fato e quatro dimensões.

## fato_preco

Tabela **fato**: registra o preço de um combustível em uma revenda, em uma data e município. Chave estrangeira para `dim_data` (`id_data`), `dim_localidade` (`id_municipio`), `dim_revenda` (`id_revenda`) e `dim_produto` (`id_produto`).

| Coluna | Tipo | Descrição | Exemplo |
|---|---|---|---|
| data | date | Data da coleta do preço. | 2025-01-03 |
| municipio | texto | Nome do município da revenda. | DUQUE DE CAXIAS |
| revenda | texto | Nome da revenda (posto). | POSTO DE SERVICO MANDA BRASA LTDA |
| produto | texto | Nome do combustível. | DIESEL |
| preco | decimal | Preço do produto na data, em R$ por litro. | 5.99 |
| id_data | inteiro | Chave estrangeira para `dim_data.id_data`. | 20250103 |
| id_municipio | inteiro | Chave estrangeira para `dim_localidade.id_municipio`. | 1 |
| id_revenda | inteiro | Chave estrangeira para `dim_revenda.id_revenda`. | 204 |
| id_produto | inteiro | Chave estrangeira para `dim_produto.id_produto`. | 1 |

## dim_data

Tabela **dimensão** de calendário. Chave primária: `id_data` (no formato AAAAMMDD). Cada linha é um dia.

| Coluna | Tipo | Descrição | Exemplo |
|---|---|---|---|
| id_data | inteiro | Chave primária da dimensão, data no formato AAAAMMDD. | 20250102 |
| data | date | Data no formato ISO. | 2025-01-02 |
| ano | inteiro | Ano da data. | 2025 |
| mes | inteiro | Mês da data (1 a 12). | 1 |
| dia | inteiro | Dia do mês. | 2 |
| semana_iso | inteiro | Número da semana ISO da data. | 1 |
| ano_iso | inteiro | Ano ISO da data. | 2025 |

## dim_produto

Tabela **dimensão** de produtos. Chave primária: `id_produto`.

| Coluna | Tipo | Descrição | Exemplo |
|---|---|---|---|
| id_produto | inteiro | Chave primária da dimensão. | 1 |
| produto | texto | Nome do combustível. | DIESEL S10 |
| unidade | texto | Unidade de medida do preço. | R$ / litro |

## dim_localidade

Tabela **dimensão** de localidades (municípios). Chave primária: `id_municipio`.

| Coluna | Tipo | Descrição | Exemplo |
|---|---|---|---|
| id_municipio | inteiro | Chave primária da dimensão. | 1 |
| municipio | texto | Nome do município. | DUQUE DE CAXIAS |
| uf | texto | Sigla da unidade federativa. | RJ |

## dim_revenda

Tabela **dimensão** de revendas (postos). Chave primária: `id_revenda`.

| Coluna | Tipo | Descrição | Exemplo |
|---|---|---|---|
| id_revenda | inteiro | Chave primária da dimensão. | 1 |
| revenda | texto | Nome da revenda. | 3POSTO JULIO DE CASTILHO LIMITADA |
| bandeira | texto | Bandeira (marca) da revenda. | VIBRA |

## Relacionamentos

- fato_preco.id_data -> dim_data.id_data (muitos para um)
- fato_preco.id_municipio -> dim_localidade.id_municipio (muitos para um)
- fato_preco.id_revenda -> dim_revenda.id_revenda (muitos para um)
- fato_preco.id_produto -> dim_produto.id_produto (muitos para um)
