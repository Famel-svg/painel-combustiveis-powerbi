import csv
from collections import Counter
from datetime import date
from pathlib import Path

ENTRADA = Path(r"E:\Programacao\Python\combustiveis-sql-analytics\data\processed\precos_rj.csv")
SAIDA = Path(__file__).resolve().parent.parent / "data" / "amostra"
INI, FIM = date(2025, 1, 1), date(2025, 3, 31)


def ler():
    for enc in ("utf-8", "utf-8-sig", "latin-1"):
        try:
            with open(ENTRADA, newline="", encoding=enc) as f:
                rows = list(csv.DictReader(f))
            print("encoding usado:", enc)
            return rows
        except UnicodeDecodeError:
            continue
    raise SystemExit("nenhum encoding funcionou")


def escrever(nome, cab, linhas):
    with open(SAIDA / nome, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(cab)
        w.writerows(linhas)
    print(f"{nome}: {len(linhas)} linhas")


SAIDA.mkdir(parents=True, exist_ok=True)
periodo = []
for r in ler():
    try:
        d = date.fromisoformat(r["data"].strip())
    except ValueError:
        continue
    if INI <= d <= FIM:
        r["_d"] = d
        periodo.append(r)

top5 = [m for m, _ in Counter(r["municipio"].strip() for r in periodo).most_common(5)]
amostra, descartes = [], 0
for r in periodo:
    if r["municipio"].strip() not in top5:
        continue
    try:
        r["_p"] = float(r["preco"].strip().replace(",", "."))
    except ValueError:
        descartes += 1
        continue
    r["municipio"], r["produto"], r["revenda"] = (r[k].strip() for k in ("municipio", "produto", "revenda"))
    r["bandeira"], r["unidade"] = r["bandeira"].strip(), r["unidade"].strip()
    amostra.append(r)

ids = lambda vals: {v: i for i, v in enumerate(sorted(set(vals)), 1)}
id_mun = ids(r["municipio"] for r in amostra)
id_prod = ids(r["produto"] for r in amostra)
id_rev = ids(r["revenda"] for r in amostra)
datas = sorted({r["_d"] for r in amostra})

band = {}
for r in amostra:
    band.setdefault(r["revenda"], Counter())[r["bandeira"]] += 1
unid = {}
for r in amostra:
    unid.setdefault(r["produto"], Counter())[r["unidade"]] += 1
top = lambda c: c.most_common(1)[0][0]

escrever("fato_preco.csv",
         ["data", "municipio", "revenda", "produto", "preco", "id_data", "id_municipio", "id_revenda", "id_produto"],
         [[r["_d"].isoformat(), r["municipio"], r["revenda"], r["produto"], f"{r['_p']:.2f}",
           r["_d"].strftime("%Y%m%d"), id_mun[r["municipio"]], id_rev[r["revenda"]], id_prod[r["produto"]]]
          for r in amostra])
escrever("dim_data.csv", ["id_data", "data", "ano", "mes", "dia", "semana_iso", "ano_iso"],
         [[d.strftime("%Y%m%d"), d.isoformat(), d.year, d.month, d.day, d.isocalendar()[1], d.isocalendar()[0]] for d in datas])
escrever("dim_produto.csv", ["id_produto", "produto", "unidade"],
         [[i, p, top(unid[p])] for p, i in id_prod.items()])
escrever("dim_localidade.csv", ["id_municipio", "municipio", "uf"], [[i, m, "RJ"] for m, i in id_mun.items()])
escrever("dim_revenda.csv", ["id_revenda", "revenda", "bandeira"], [[i, v, top(band[v])] for v, i in id_rev.items()])
print("5 municipios:", top5)
print("descartadas por preco invalido:", descartes)
