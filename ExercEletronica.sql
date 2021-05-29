CREATE DATABASE eletronica
GO
USE eletronica

CREATE TABLE cliente (
cpf			VARCHAR(13)		NOT NULL,
nome		VARCHAR(50)		NOT NULL,
telefone	CHAR(9)
PRIMARY KEY (cpf)
)
GO
CREATE TABLE fornecedor (
id				INT				NOT NULL,
nome			VARCHAR(50)		NOT NULL,
logradouro		VARCHAR(100)	NOT NULL,
num				INT				NOT NULL,
complemento		VARCHAR(30)		NOT NULL,
cidade			VARCHAR(40)		NOT NULL
PRIMARY KEY (id)
)
GO
CREATE TABLE produto (
cod				INT				NOT NULL,
descricao		VARCHAR(60)		NULL,
id_forn			INT				NOT NULL,
preco			DECIMAL(7,2)	NOT NULL
PRIMARY KEY (cod)
FOREIGN KEY (id_forn) REFERENCES fornecedor(id)
)
GO
CREATE TABLE venda (
codigo			INT				NOT NULL,
cod_prod		INT				NOT NULL,
cpf_cliente		VARCHAR(13)		NOT NULL,
quantidade		INT				NOT NULL,
valor_total		DECIMAL(7,2)	NOT NULL,
data_venda		DATETIME		NOT NULL
PRIMARY KEY (codigo, cod_prod, cpf_cliente)
FOREIGN KEY (cod_prod) REFERENCES produto(cod),
FOREIGN KEY (cpf_cliente) REFERENCES cliente(cpf)
)

SELECT * FROM cliente
SELECT * FROM fornecedor
SELECT * FROM produto
SELECT * FROM venda

--Consultar no formato dd/mm/aaaa:		
--Data da Venda 4	
SELECT CONVERT(VARCHAR(10), ven.data_venda, 103) AS data_venda
FROM venda ven
WHERE ven.codigo = 4

--Inserir na tabela Fornecedor, a coluna Telefone e os seguintes dados:			
--1	 7216-5371		
--2	 8715-3738		
--4	 3654-6289		
ALTER TABLE fornecedor
ADD telefone	CHAR(9)		 NULL

UPDATE fornecedor
SET telefone = '7216-5371'
WHERE id = 1

UPDATE fornecedor
SET telefone = '8715-3738'
WHERE id = 2

UPDATE fornecedor
SET telefone = '3654-6289'
WHERE id = 4

--Consultar por ordem alfabética de nome, o nome, o enderço concatenado e o telefone dos fornecedores						
SELECT forn.nome AS nome_fornecedor,
	   forn.logradouro + ', ' + CAST(forn.num AS VARCHAR(8)) + ' - ' + forn.cidade AS endereco_forn,
	   forn.telefone AS telefone_fornecedor
FROM fornecedor forn
ORDER BY forn.nome

--Consultar:
--Produto, quantidade e valor total do comprado por Julio Cesar					
SELECT prod.descricao AS produto, ven.quantidade, ven.valor_total
FROM produto prod, venda ven, cliente cli
WHERE prod.cod = ven.cod_prod
		AND ven.cpf_cliente = cli.cpf
		AND cli.nome LIKE 'Juli%'

--Data, no formato dd/mm/aaaa e valor total do produto comprado por  Paulo Cesar						
SELECT CONVERT(VARCHAR(10), vend.data_venda, 103) AS data_venda, vend.valor_total
FROM venda vend, cliente cli
WHERE vend.cpf_cliente = cli.cpf
		AND cli.nome LIKE 'Paul%'

--Consultar, em ordem decrescente, o nome e o preço de todos os produtos 						
SELECT prod.descricao AS produto, prod.preco
FROM produto prod
ORDER BY prod.descricao DESC






