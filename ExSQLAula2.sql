CREATE DATABASE ExSQLAula2
GO
USE ExSQLAula2
GO
CREATE TABLE fornecedor (
id				INT				NOT NULL	PRIMARY KEY,
nome			VARCHAR(50)		NOT NULL,
logradouro		VARCHAR(100)	NOT NULL,
numero			INT				NOT NULL,
complemento		VARCHAR(30)		NOT NULL,
cidade			VARCHAR(70)		NOT NULL
)
GO
CREATE TABLE cliente (
cpf			CHAR(11)		NOT NULL		PRIMARY KEY,
nome		VARCHAR(50)		NOT NULL,	
telefone	VARCHAR(9)		NOT NULL,
)
GO
CREATE TABLE produto (
codigo		INT				NOT NULL	PRIMARY KEY,
descricao	VARCHAR(50)		NOT NULL,
fornecedor	INT				NOT NULL,
preco		DECIMAL(7,2)	NOT NULL
FOREIGN KEY (fornecedor) REFERENCES fornecedor(ID)
)
GO
CREATE TABLE venda (
codigo			INT				NOT NULL,
produto			INT				NOT NULL,
cliente			CHAR(11)		NOT NULL,
quantidade		INT				NOT NULL,
data			DATE			NOT NULL
PRIMARY KEY (codigo, produto, cliente, data)
FOREIGN KEY (produto) REFERENCES produto (codigo),
FOREIGN KEY (cliente) REFERENCES cliente (cpf)
)

SELECT * FROM fornecedor
SELECT * FROM cliente
SELECT * FROM produto
SELECT * FROM venda

--Quantos produtos não foram vendidos (nome da coluna qtd_prd_nao_vend)?
SELECT COUNT(prod.codigo) AS qtd_prd_nao_vend
FROM produto prod
LEFT OUTER JOIN venda ven
ON prod.codigo = ven.produto

--Descrição do produto, Nome do fornecedor, count() do produto nas vendas
SELECT prod.descricao, prod.fornecedor, COUNT(ven.produto) AS qtd_vendida
FROM produto prod
INNER JOIN venda ven
ON prod.codigo = ven.codigo
GROUP BY prod.descricao, prod.fornecedor

--Nome do cliente e Quantos produtos cada um comprou ordenado pela quantidade
SELECT cli.nome AS nome_cliente, COUNT(ven.cliente) AS qtd_prod_comp
FROM cliente cli
INNER JOIN venda ven
ON cli.cpf = ven.cliente
GROUP BY cli.nome, ven.cliente
ORDER BY qtd_prod_comp DESC

--Descrição do produto e Quantidade de vendas do produto com menor valor do catálogo de produtos
SELECT prod.descricao, COUNT(ven.produto) AS qtd_venda
FROM produto prod
INNER JOIN venda ven
ON prod.codigo = ven.produto
WHERE prod.preco IN
(
SELECT MIN(prod.preco)
FROM produto prod
)
GROUP BY prod.descricao, ven.produto

--Nome do Fornecedor e Quantos produtos cada um fornece	
SELECT forn.nome, COUNT(prod.fornecedor) AS qtd_prod_fornece 
FROM fornecedor forn
INNER JOIN produto prod
ON forn.id = prod.fornecedor
GROUP BY forn.nome, prod.fornecedor
ORDER BY qtd_prod_fornece DESC

--Considerando que hoje é 20/10/2019, consultar, sem repetições, o código da compra, nome do cliente, telefone do cliente (Mascarado XXXX-XXXX ou XXXXX-XXXX) e quantos dias da data da compra
SELECT DISTINCT ven.codigo AS codigo_compra, cli.nome AS nome_cliente,
		SUBSTRING(cli.telefone, 1, 5) + '-' + SUBSTRING(cli.telefone, 6, 9) AS telefone_cliente,
		DATEDIFF(DAY, ven.data, '2019-10-20') AS qtd_dias_compra
FROM venda ven
INNER JOIN cliente cli
ON ven.cliente = cli.cpf

--CPF do cliente, mascarado (XXX.XXX.XXX-XX), Nome do cliente e quantidade comprada dos clientes que compraram mais de 2 produtos
SELECT SUBSTRING(cli.cpf, 1, 3) + '.' + 
	   SUBSTRING(cli.cpf, 4, 3) + '.' + 
	   SUBSTRING(cli.cpf, 7, 3) + '-' + 
	   SUBSTRING(cli.cpf, 10, 2) AS cpf_cliente, cli.nome AS nome_cliente,
	   COUNT(ven.cliente) AS qtd_comprada
FROM cliente cli
INNER JOIN venda ven
ON cli.cpf = ven.cliente
GROUP BY cli.cpf, cli.nome, ven.quantidade
HAVING COUNT(ven.produto) > 2

--Sem repetições, Código da venda, CPF do cliente, mascarado (XXX.XXX.XXX-XX), Nome do Cliente e Soma do valor_total gasto(valor_total_gasto = preco do produto * quantidade de venda).Ordenar por nome do cliente
SELECT DISTINCT vend.codigo AS codigo_compra,
	   SUBSTRING(cli.cpf, 1, 3) + '.' + 
	   SUBSTRING(cli.cpf, 4, 3) + '.' + 
	   SUBSTRING(cli.cpf, 7, 3) + '-' + 
	   SUBSTRING(cli.cpf, 10, 2) AS cpf_cliente, cli.nome AS nome_cliente,
	   SUM(prod.preco * vend.quantidade) AS valor_total
FROM cliente cli, venda vend, produto prod
WHERE cli.cpf = vend.cliente
		AND vend.produto = prod.codigo
GROUP BY vend.codigo, cli.cpf, cli.nome
ORDER BY cli.nome

--Código da venda, data da venda em formato (DD/MM/AAAA) e uma coluna, chamada dia_semana, que escreva o dia da semana por extenso		
--Exemplo: Caso dia da semana 1, escrever domingo. Caso 2, escrever segunda-feira, assim por diante, até caso dia 7, escrever sábado	
SELECT DISTINCT ven.codigo, CONVERT(CHAR(10), ven.data, 103) AS data_venda,
		CASE DATEPART(WEEKDAY, ven.data)    
			  WHEN 1 THEN 'Domingo'
			  WHEN 2 THEN 'Segunda-Feira'
			  WHEN 3 THEN 'Terça-Feira'
			  WHEN 4 THEN 'Quarta-Feira'
			  WHEN 5 THEN 'Quinta-Feira' 
		   	  WHEN 6 THEN 'Sexta-Feira'
			  WHEN 7 THEN 'Sábado'  
		END AS dia_semana
FROM venda ven

