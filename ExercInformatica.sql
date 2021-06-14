CREATE DATABASE informatica
GO
USE informatica

CREATE TABLE clientes (
rg				VARCHAR(15)			NOT NULL	 PRIMARY KEY,
cpf				CHAR(14)			NOT NULL,
nome			VARCHAR(75)			NOT NULL,
endereço		VARCHAR(150)		NOT NULL
)
GO
CREATE TABLE pedido (
nota_fiscal		INT					NOT NULL		PRIMARY KEY,
valor			DECIMAL(7,2)		NOT NULL,
data_pedido		DATETIME			NOT NULL,
rg_cliente		VARCHAR(15)			NOT NULL
FOREIGN KEY (rg_cliente) REFERENCES clientes (rg)
)
GO
CREATE TABLE fornecedor (
codigo			INT				NOT NULL		PRIMARY KEY,
nome			VARCHAR(30)		NOT NULL,
endereco		VARCHAR(80)		NOT NULL,
telefone		VARCHAR(20)		NULL,
cgc				VARCHAR(35)		NULL,
cidade			VARCHAR(30)		NULL,
transporte		VARCHAR(20)		NULL,
pais			VARCHAR(20)		NULL,
moeda			VARCHAR(10)		NULL
)
GO
CREATE TABLE mercadoria (
codigo				INT					NOT NULL		PRIMARY KEY,
descricao			VARCHAR(30)			NOT NULL,
preco				DECIMAL(7,2)		NOT NULL,
quantidade			INT					NOT NULL,
cod_fornecedor		INT					NOT NULL
FOREIGN KEY (cod_fornecedor) REFERENCES fornecedor (codigo)
)

--Consultar 10% de desconto no pedido 1003		
SELECT CONVERT(DECIMAL(7,2), ped.valor * 0.90) AS desconto
FROM pedido ped
WHERE ped.nota_fiscal = 1003

--Consultar 5% de desconto em pedidos com valor maior de R$700,00				
SELECT CONVERT(DECIMAL(7,2), ped.valor * 0.95) AS desconto
FROM pedido ped
WHERE ped.valor > 700

--Consultar e atualizar aumento de 20% no valor de marcadorias com estoque menor de 10						
SELECT CONVERT(DECIMAL(7,2), mer.preco * 1.20) AS aumento
FROM mercadoria mer
WHERE mer.quantidade < 10

--Data e valor dos pedidos do Luiz		
SELECT ped.data_pedido, ped.valor
FROM pedido ped
INNER JOIN clientes cli
ON ped.rg_cliente = cli.rg
WHERE cli.nome LIKE 'Lui%'

--CPF, Nome e endereço do cliente de nota 1004			
SELECT cli.cpf, cli.nome, cli.endereço
FROM clientes cli
INNER JOIN pedido ped
ON cli.rg = ped.rg_cliente
WHERE ped.nota_fiscal = 1004

--País e meio de transporte da Cx. De som		
SELECT forn.pais, forn.transporte
FROM fornecedor forn
INNER JOIN mercadoria mer
ON forn.codigo = mer.cod_fornecedor
WHERE mer.descricao LIKE 'Cx.%'

--Nome e Quantidade em estoque dos produtos fornecidos pela Clone				
SELECT mer.descricao AS nome_produto, mer.quantidade
FROM mercadoria mer
INNER JOIN fornecedor forn
ON mer.cod_fornecedor = forn.codigo
WHERE forn.nome LIKE 'Clone'

--Endereço e telefone dos fornecedores do monitor			
SELECT forn.endereco, forn.telefone
FROM fornecedor forn
INNER JOIN mercadoria mer
ON forn.codigo = mer.cod_fornecedor
WHERE mer.descricao LIKE 'Moni%'

--Tipo de moeda que se compra o notebook		
SELECT forn.moeda
FROM fornecedor forn
INNER JOIN mercadoria mer
ON forn.codigo = mer.cod_fornecedor
WHERE mer.descricao LIKE 'Note%'

--Há quantos dias foram feitos os pedidos e, criar uma coluna que escreva Pedido antigo para pedidos feitos há mais de 6 meses									
SELECT DATEDIFF(DAY, ped.data_pedido, GETDATE()) AS qtd_dias_pedido,
		CASE
			WHEN DATEDIFF(MONTH, ped.data_pedido, GETDATE()) > 6
			THEN CONVERT(VARCHAR(3), DATEDIFF(MONTH, ped.data_pedido, GETDATE())) + ' meses'
		END AS pedido_antigo
FROM pedido ped

--Nome e Quantos pedidos foram feitos por cada cliente			
SELECT cli.nome, COUNT(ped.rg_cliente) AS pedidos_feitos
FROM clientes cli
INNER JOIN pedido ped
ON cli.rg = ped.rg_cliente
GROUP BY cli.nome

--RG,CPF,Nome e Endereço dos cliente cadastrados que Não Fizeram pedidos				
SELECT DISTINCT cli.rg, cli.cpf, cli.nome, cli.endereço
FROM clientes cli
LEFT OUTER JOIN pedido ped
ON cli.rg = ped.rg_cliente












