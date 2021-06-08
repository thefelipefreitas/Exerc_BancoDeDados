CREATE DATABASE  mercado
GO
USE mercado

CREATE TABLE cliente (
codigo				INT				NOT NULL,
nome				VARCHAR(75)		NOT NULL,
endereco			VARCHAR(100)	NOT NULL,
tel					CHAR(8)			NOT NULL,
tel_comercial		CHAR(8)			NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE tipos_mercadoria (
codigo		INT				NOT NULL,
nome		VARCHAR(40)		NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE corredores (
codigo		INT				NOT NULL,
tipo		INT				NOT NULL,
nome		VARCHAR(35)		NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (tipo) REFERENCES tipos_mercadoria(codigo)
)
GO
CREATE TABLE mercadoria (
codigo		INT				NOT NULL,
nome		VARCHAR(45)		NOT NULL,	
corredor	INT				NOT NULL,
tipo		INT				NOT NULL,
valor		DECIMAL(7,2)	NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (corredor) REFERENCES corredores(codigo),
FOREIGN KEY (tipo) REFERENCES tipos_mercadoria(codigo)
)
GO
CREATE TABLE compra (
nota_fiscal		INT				NOT NULL,
cliente			INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL
PRIMARY KEY (nota_fiscal)
FOREIGN KEY (cliente) REFERENCES cliente(codigo)
)

--Valor da Compra de Luis Paulo		
SELECT com.valor AS valor_compra
FROM compra com
INNER JOIN cliente cli
ON com.cliente = cli.codigo
WHERE cli.nome LIKE 'Luis Pa%'

--Valor da Compra de Marcos Henrique		
SELECT com.valor AS valor_compra
FROM compra com
INNER JOIN cliente cli
ON com.cliente = cli.codigo
WHERE cli.nome LIKE 'Marcos He%'