USE ex02DDLDML

SELECT * FROM cliente
SELECT * FROM dvd
SELECT * FROM locacao
SELECT * FROM estrela
SELECT * FROM filme
SELECT * FROM filme_estrela

--Consultar num_cadastro e nome do cliente. Data_locacao (dd/mm/aaaa), Qtd_dias_alugado (dias que o filme ficou alugado). Titulo e ano do filme. Da locação do cliente cujo nome inicia com 'Matilde'
SELECT cliente.num_cadastro AS cadastro_cliente, 
	   cliente.nome AS nome_cliente, 
       CONVERT(CHAR(10), locacao.data_locacao, 103) AS data_locacao, 
       DATEDIFF(DAY, locacao.data_locacao, locacao.data_devolucao) AS dias_alugado,
	   filme.titulo AS titulo_filme, filme.ano AS ano_lancamento
FROM locacao
INNER JOIN cliente
ON locacao.clienteNum_cadastro = cliente.num_cadastro
INNER JOIN dvd
ON locacao.dvdNum = dvd.num
INNER JOIN filme
ON dvd.filmeId = filme.id
WHERE cliente.nome LIKE 'Matilde%'

--Consultar nome e nome_real da estrela. E 'Título' dos filmes cadastrados do ano de 2015.
SELECT estrela.nome AS nome_estrela,
	   estrela.nome_real AS nome_real_estrela,
	   filme.titulo AS titulo_filme,
	   filme.ano AS ano_filme
FROM filme_estrela
INNER JOIN estrela
ON filme_estrela.estrelaId = estrela.id
INNER JOIN filme
ON filme_estrela.filmeId = filme.id
WHERE filme.ano = 2015

--Consultar título do filme. Data_fabricação do dvd (dd/mm/aaaa). Caso a diferença do ano do filme com o ano atual seja maior que 6, deve aparecer a diferença do ano com o ano atual concatenado com a palavra anos (Exemplo: 7 anos), caso contrário só a diferença (Exemplo: 4).
SELECT filme.titulo AS titulo_filme,
	   CONVERT(VARCHAR(10), dvd.data_fabricacao, 103) AS data_fab_dvd,
	   filme.ano AS ano_filme,
	   CASE 
				WHEN  (2021 - filme.ano) > 6
				THEN  CONVERT(VARCHAR(10), (2021 - filme.ano)) + ' anos'
				ELSE  CONVERT(VARCHAR(10), (2021 - filme.ano))
			END AS idade
FROM dvd
INNER JOIN filme
ON dvd.filmeId = filme.id
