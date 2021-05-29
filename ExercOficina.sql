CREATE DATABASE oficina
GO
USE oficina

CREATE TABLE carro (
placa	 CHAR(9)			NOT NULL,
marca	 VARCHAR(15)		NOT NULL,
modelo	 VARCHAR(10)		NOT NULL,
cor		 VARCHAR(10)		NOT NULL,
ano		 INT				NOT NULL
PRIMARY KEY (placa)
)
GO
CREATE TABLE pecas (
cod			INT				NOT NULL,
nome		VARCHAR(30)		NOT NULL,
valor		DECIMAL(7,2)	NOT NULL
PRIMARY KEY (cod)
)
GO
CREATE TABLE servico (
placa_carro		CHAR(9)			NOT NULL,
cod_peca		INT				NOT NULL,
quantidade		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL,
data_servico	DATETIME		NOT NULL
PRIMARY KEY (placa_carro, cod_peca, data_servico)
FOREIGN KEY (placa_carro) REFERENCES carro(placa),
FOREIGN KEY (cod_peca) REFERENCES pecas(cod)
)
GO
CREATE TABLE cliente (
nome			VARCHAR(60)			NOT NULL,
logradouro		VARCHAR(100)		NOT NULL,
num				INT					NOT NULL,
bairro			VARCHAR(20)			NOT NULL,
telefone		CHAR(10)			NOT NULL,
placa_carro		CHAR(9)				NOT NULL
PRIMARY KEY (placa_carro)
FOREIGN KEY (placa_carro) REFERENCES carro(placa)
)

SELECT * FROM carro
SELECT * FROM cliente
SELECT * FROM pecas
SELECT * FROM servico

--Consultar:
--Placas dos carros de anos anteriores a 2001		
SELECT car.placa
FROM carro car
WHERE car.ano < 2001

--Marca, modelo e cor, concatenado dos carros posteriores a 2005				
SELECT car.marca + ', ' + car.modelo + ': ' + car.cor AS carro
FROM carro car
WHERE car.ano > 2005

--Código e nome das peças que custam menos de R$80,00			
SELECT pec.cod AS codigo, pec.nome
FROM pecas pec
WHERE pec.valor < 80.00

--Consultar em Subqueries:
--Telefone do dono do carro Ka, Azul	
SELECT cli.telefone
FROM cliente cli
INNER JOIN carro car
ON cli.placa_carro = car.placa
WHERE car.modelo = 'Ka' AND car.cor = 'Azul'

--Endereço concatenado do cliente que fez o serviço do dia 02/08/2020				
SELECT cli.logradouro + ', ' + CAST(cli.num AS VARCHAR(6)) + ' - ' + cli.bairro AS endereco_cliente
FROM cliente cli, servico serv, carro car
WHERE cli.placa_carro = car.placa
		AND car.placa = serv.placa_carro
		AND serv.data_servico = '2020-08-02'