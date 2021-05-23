USE ex02DDLDML

SELECT * FROM cliente
SELECT * FROM dvd
SELECT * FROM estrela
SELECT * FROM filme
SELECT * FROM filme_estrela
SELECT * FROM locacao

--Consultar num_cadastro e nome do cliente. Titulo do filme. Data_fabricação do dvd. Valor da locação, dos dvds que tem a maior data de fabricação dentre todos os cadastrados.
SELECT cli.num_cadastro AS cadastro_cliente, cli.nome AS nome_cliente,
		fil.titulo AS titulo_filme, dvd.data_fabricacao, loc.valor
FROM cliente cli, filme fil, dvd , locacao loc
WHERE cli.num_cadastro = loc.clienteNum_cadastro
	AND fil.id = dvd.filmeId
	AND dvd.num = loc.dvdNum
	AND dvd.data_fabricacao IN
	(
		SELECT MAX(data_fabricacao)
		FROM dvd
	)

--Consultar num_cadastro e nome do cliente. Data de locação (DD/MM/AAAA) e a quantidade de DVD´s alugados por cliente (Chamar essa coluna de qtd), por data de locação
SELECT cli.num_cadastro AS cadastro_cliente, cli.nome AS nome_cliente,
		CONVERT(VARCHAR(10), dvd.data_fabricacao, 103) AS data_fab_dvd,
		COUNT(loc.clienteNum_cadastro) AS qtd
FROM cliente cli, locacao loc, dvd
WHERE cli.num_cadastro = loc.clienteNum_cadastro
	AND dvd.num = loc.dvdNum
GROUP BY loc.data_locacao, cli.num_cadastro, cli.nome, dvd.data_fabricacao
ORDER BY loc.data_locacao

--Consultar num_cadastro e nome do cliente. Data de locação (DD/MM/AAAA) e valor total de todos os dvd´s alugados (Chamar essa coluna de valor_total), por data de locação
SELECT cli.num_cadastro AS cadastro_cliente, cli.nome AS nome_cliente,
		CONVERT(VARCHAR(10), loc.data_locacao, 103) AS data_locacao,
		SUM(loc.valor) AS valor_total
FROM cliente cli, locacao loc
WHERE cli.num_cadastro = loc.clienteNum_cadastro
GROUP BY cli.num_cadastro, cli.nome, loc.data_locacao, loc.valor
ORDER BY loc.data_locacao

--Consultar num_cadastro e nome do cliente. Endereço concatenado de logradouro e numero como 'Endereco'. Data de locação (DD/MM/AAAA) dos clientes que alugaram mais de 2 filmes simultaneamente.
SELECT cli.num_cadastro AS cadastro_cliente, cli.nome AS nome_cliente,
		cli.logradouro + ',' + CAST(cli.num AS VARCHAR(4)) + ' - ' + cli.cep AS endereco,
		CONVERT(VARCHAR(10), loc.data_locacao, 103) AS data_locacao
FROM cliente cli, locacao loc
WHERE cli.num_cadastro = loc.clienteNum_cadastro
GROUP BY cli.num_cadastro, cli.nome, cli.logradouro, cli.num, cli.cep, loc.data_locacao
HAVING COUNT(loc.dvdNum) > 2
