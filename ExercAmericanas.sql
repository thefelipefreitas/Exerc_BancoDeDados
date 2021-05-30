CREATE DATABASE americanas
GO
USE americanas

CREATE TABLE fornecedores (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
atividade		VARCHAR(50)		NOT NULL,
telefone		CHAR(9)			NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE cliente (
codigo			INT				NOT NULL,
nome			VARCHAR(60)		NOT NULL,
endereco		VARCHAR(100)	NOT NULL,
telefone		CHAR(9)			NOT NULL,
idade			INT				NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE produto (
codigo					INT					NOT NULL,
nome					VARCHAR(50)			NOT NULL,
valor_unitario			DECIMAL(7,2)		NOT NULL,
quantidade_estoque		INT					NOT NULL,
descricao				VARCHAR(50)			NOT NULL,
codigo_fornecedor		INT					NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (codigo_fornecedor) REFERENCES fornecedores(codigo)
)
GO
CREATE TABLE pedido (
codigo					INT				NOT NULL,
codigo_cliente			INT				NOT NULL,
codigo_produto			INT				NOT NULL,
quantidade				INT				NOT NULL,
valor_total				DECIMAL(7,2)	NOT NULL,
previsao_entrega		DATETIME		NOT NULL
PRIMARY KEY (codigo, codigo_cliente, codigo_produto)
FOREIGN KEY (codigo_cliente) REFERENCES cliente(codigo),
FOREIGN KEY (codigo_produto) REFERENCES produto(codigo)
)

SELECT * FROM cliente
SELECT * FROM fornecedores
SELECT * FROM produto
SELECT * FROM pedido

--Consultar a quantidade, valor total e valor total com desconto (25%) dos itens comprados par Maria Clara.					
SELECT ped.quantidade, ped.valor_total, CAST(ped.valor_total * 0.75 AS DECIMAL(7,2)) AS total_com_desconto
FROM pedido ped
INNER JOIN cliente cli
ON ped.codigo_cliente = cli.codigo
WHERE cli.nome LIKE 'Maria C%'

--Verificar quais brinquedos não tem itens em estoque.			
SELECT prod.nome
FROM produto prod
WHERE prod.quantidade_estoque = 0

--Alterar para reduzir em 10% o valor das barras de chocolate.			
UPDATE produto
SET valor_unitario = (valor_unitario * 0.90)
WHERE produto.descricao LIKE 'Barra%'

--Alterar a quantidade em estoque do faqueiro para 10 peças.			
UPDATE produto
SET produto.quantidade_estoque = 10
WHERE produto.nome LIKE 'Faquei%'

--Consultar quantos clientes tem mais de 40 anos.		
SELECT cli.nome
FROM cliente cli
WHERE cli.idade > 40

--Consultar Nome e telefone dos fornecedores de Brinquedos e Chocolate			
SELECT forn.nome, forn.telefone
FROM fornecedores forn
WHERE forn.atividade LIKE 'Brinqued%'
		OR forn.atividade LIKE 'Choco%'

--Consultar nome e desconto de 25% no preço dos produtos que custam menos de R$50,00				
SELECT prod.nome, CAST(prod.valor_unitario * 0.75 AS DECIMAL(7,2)) AS valor_com_desconto
FROM produto prod
WHERE prod.valor_unitario < 50

--Consultar nome e aumento de 10% no preço dos produtos que custam mais de R$100,00				
SELECT prod.nome, CAST(prod.valor_unitario * 1.10 AS DECIMAL(7,2)) AS valor_com_aumento
FROM produto prod
WHERE prod.valor_unitario > 100

--Consultar desconto de 15% no valor total de cada produto da venda 99001
SELECT CAST(ped.valor_total * 0.85 AS DECIMAL(7,2)) AS valor_com_desconto
FROM pedido ped
WHERE ped.codigo = 99001