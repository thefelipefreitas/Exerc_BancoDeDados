USE ex02DDLDML

--Retorne ID, Ano, nome do Filme (Caso o nome do filme tenha mais de 10 caracteres, para caber no campo da tela, mostrar os 10 primeiros caracteres, seguidos de '...') dos filmes cujos DVDs foram fabricados depois de 01/01/2020
SELECT id, ano, 
			CASE 
				WHEN LEN(titulo) > 10    
				THEN  SUBSTRING(titulo, 1, 10) + '...'
				ELSE  titulo
			END AS titulo
FROM filme
WHERE id IN
(
	SELECT filmeId
	FROM dvd
	WHERE data_fabricacao > '2020-01-01'
)

--Retorne num, data_fabricacao, qtd_meses_desde_fabricacao (Quantos meses desde que o dvd foi fabricado até hoje) do filme Interestelar
SELECT num, data_fabricacao,
			DATEDIFF(MONTH, data_fabricacao, GETDATE()) AS qtd_meses_desde_fabricacao
FROM dvd
WHERE filmeId IN
(
SELECT id
FROM filme
WHERE titulo = 'Interestelar'
)

--Retorne num_dvd, data_locacao, data_devolucao, dias_alugado(Total de dias que o dvd ficou alugado) e valor das locações da cliente que tem, no nome, o termo Rosa
SELECT dvdNum,			
			CONVERT(CHAR(10), data_locacao, 103) AS data_locacao,
			CONVERT(CHAR(10), data_devolucao, 103) AS data_devolucao,
			DATEDIFF(DAY, data_locacao, data_devolucao) AS dias_alugado,
			valor
FROM locacao
WHERE clienteNum_cadastro IN
(
SELECT num_cadastro
FROM cliente
WHERE nome LIKE '%Rosa%'
)

--Nome, endereço_completo (logradouro e número concatenados), cep (formato XXXXX-XXX) dos clientes que alugaram DVD de num 10002
SELECT nome,
			logradouro + ',' + CAST(num AS VARCHAR(5)) AS endereco_completo,
			SUBSTRING(cep, 1, 5) + '-' + SUBSTRING(cep, 6, 8) AS cep
FROM cliente
WHERE num_cadastro IN
(
SELECT clienteNum_cadastro
FROM locacao
WHERE dvdNum = 10002
)