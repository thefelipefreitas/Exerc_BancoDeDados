CREATE DATABASE ex04SelectSimples
GO
USE ex04SelectSimples

CREATE TABLE filme (
id		 INT			 NOT NULL,
titulo	 VARCHAR(40)	 NOT NULL,
ano		 INT			 NULL	    	CHECK(ano <= 2021)
PRIMARY KEY (id)
)
GO
CREATE TABLE estrela (
id		   INT			NOT NULL,
nome	   VARCHAR(50)	NOT NULL,
nome_real  VARCHAR(50)  NULL
PRIMARY KEY (id)
)
GO
CREATE TABLE filme_estrela (
filmeId		INT		NOT NULL,
estrelaId	INT		NOT NULL
PRIMARY KEY (filmeId, estrelaId)
FOREIGN KEY (filmeId) REFERENCES filme(id),
FOREIGN KEY (estrelaId) REFERENCES estrela(id)
)
GO
CREATE TABLE dvd (
num				 INT		 NOT NULL,
dt_fabricacao	 DATE	     NOT NULL    	CHECK(dt_fabricacao < GETDATE()),
filmeId			 INT		 NOT NULL
PRIMARY KEY (num)
FOREIGN KEY (filmeId) REFERENCES filme(id)
)
GO
CREATE TABLE cliente (
num_cadastro     INT				NOT NULL,
nome		     VARCHAR(70)		NOT NULL,
logradouro	     VARCHAR(150)	    NOT NULL,
numero			 INT				NOT NULL	   CHECK(numero > 0),
cep				 CHAR(8)			NULL		   CHECK(LEN(cep) = 8)
PRIMARY KEY (num_cadastro)
)
GO
CREATE TABLE locacao (
dvdNum				   INT				NOT NULL,
clienteNum_cadastro	   INT				NOT NULL,
data_locacao		   DATE			    NOT NULL	  DEFAULT(GETDATE()),
data_devolucao		   DATE			    NOT NULL,
valor				   DECIMAL(7,2)	    NOT NULL	  CHECK(valor>=0.00)
PRIMARY KEY (dvdNum, clienteNum_cadastro, data_locacao)
FOREIGN KEY (dvdNum) REFERENCES dvd(num),
FOREIGN KEY (clienteNum_cadastro) REFERENCES cliente (num_cadastro),
CONSTRAINT check_dt CHECK(data_devolucao > data_locacao)
)

ALTER TABLE filme
ALTER COLUMN titulo VARCHAR(80) NOT NULL

INSERT INTO filme VALUES
(1001, 'Whiplash', 2015),
(1002, 'Birdman', 2015),
(1003, 'Interestelar', 2014),
(1004, 'A Culpa é das estrelas', 2014),
(1005, 'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014),
(1006, 'Sing', 2016)

INSERT INTO estrela VALUES 
(9901, 'Michael Keaton', 'Michael John Douglas'),
(9902, 'Emma Stone', 'Emily Jean Stone'),
(9903, 'Miles Teller', NULL),
(9904, 'Steve Carell', 'Steven John Carell'),
(9905, 'Jennifer Garner', 'Jennifer Anne Garner')

INSERT INTO filme_estrela VALUES
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905)

INSERT INTO dvd VALUES
(10001, '2020-12-02', 1001),
(10002, '2019-10-18', 1002),
(10003, '2020-04-03', 1003),
(10004, '2020-12-02', 1001),
(10005, '2019-10-18', 1004),
(10006, '2020-04-03', 1002),
(10007, '2020-12-02', 1005),
(10008, '2019-10-18', 1002),
(10009, '2020-04-03', 1003)

INSERT INTO cliente VALUES
(5501, 'Matilde Luz', 'Rua Síria', 150, '03086040'),
(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
(5503, 'Daniel Ramalho', 'Rua Itajutiba', 169, NULL),
(5504, 'Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL),
(5505, 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')

INSERT INTO locacao VALUES
(10001, 5502, '2021-02-18', '2021-02-21', 3.50),
(10009, 5502, '2021-02-18', '2021-02-21', 3.50),
(10002, 5503, '2021-02-18', '2021-02-19', 3.50),
(10002, 5505, '2021-02-20', '2021-02-23', 3.00),
(10004, 5505, '2021-02-20', '2021-02-23', 3.00),
(10005, 5505, '2021-02-20', '2021-02-23', 3.00),
(10001, 5501, '2021-02-24', '2021-02-26', 3.50),
(10008, 5501, '2021-02-24', '2021-02-26', 3.50)

UPDATE cliente
SET cep = '08411150'
WHERE num_cadastro = 5503

UPDATE cliente
SET cep = '02918190'
WHERE num_cadastro = 5504

UPDATE locacao
SET valor = 3.25
WHERE data_locacao = '2021-02-18' AND clienteNum_cadastro = 5502

UPDATE locacao
SET valor = 3.10
WHERE data_locacao = '2021-02-24' AND clienteNum_cadastro = 5501

UPDATE dvd
SET dt_fabricacao = '2019-07-14'
WHERE num = 10005

UPDATE estrela
SET nome_real = 'Miles Alexander Teller'
WHERE nome = 'Miles Teller'

DELETE filme
WHERE titulo = 'Sing'

SELECT * FROM cliente
SELECT * FROM dvd
SELECT * FROM estrela
SELECT * FROM filme
SELECT * FROM filme_estrela
SELECT * FROM locacao

--Retorne o nome dos filmes de 2014
SELECT titulo
FROM filme
WHERE ano = 2014

--Retorne id e ano do filme 'Birdman'
SELECT id, ano
FROM filme
WHERE titulo = 'Birdman'

--Retorne o id e o ano do filme '___plash'
SELECT id, ano
FROM filme
WHERE titulo LIKE '%plash'

--Retorne o id, nome e o nomeReal da estrela cujo nome começa com 'Steve'
SELECT id, nome, nome_real
FROM estrela
WHERE nome LIKE 'Steve%'

--Retorne filmeId e data_fabricacao em formato (DD/MM/YYYY), apelidar de 'fab' dos flmes fabricados apos 01-01-2020
SELECT filmeId, 
	   CONVERT(CHAR(10), dt_fabricacao, 103) AS fab 
FROM dvd
WHERE dt_fabricacao > '2020-01-01'

--Retorne DVDnum, data_locacao, data_devolucao, valor e valor com multa de acréscimo de 2.00 da locação do cliente '5505'
SELECT dvdNum, data_locacao, data_devolucao, valor,
       CAST((valor + 2.00) AS DECIMAL(7,2)) AS multa
FROM locacao
WHERE clienteNum_cadastro = 5505

--Retorne Logradouro, num e CEP de 'Matilde Luz'
SELECT logradouro, numero, cep
FROM cliente
WHERE nome = 'Matilde Luz'

--Retorne o nome real de 'Michael Keaton'
SELECT nome_real
FROM estrela
WHERE nome = 'Michael Keaton'

--Retorne o num_cadastro, nome e endereço completo, concatenando (logradouro, numero e CEP), apelido end_comp, dos clientes cujo ID é maior ou igual '5503'
SELECT num_cadastro, nome,
       logradouro + ',' + CAST(numero AS VARCHAR(4)) + ' - ' + cep AS end_comp
FROM cliente
WHERE num_cadastro >= 5503