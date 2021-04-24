USE ex02DDLDML

INSERT INTO filme (id, titulo, ano) VALUES
(1001, 'Whiplash', 2015)
GO
INSERT INTO filme (id, titulo, ano) VALUES
(1002, 'Birdman', 2015)
GO
INSERT INTO filme (id, titulo, ano) VALUES
(1003, 'Interestelar', 2014)
GO
INSERT INTO filme (id, titulo, ano) VALUES
(1004, 'A Culpa é das estrelas', 2014)
GO
INSERT INTO filme (id, titulo, ano) VALUES
(1005, 'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014)
GO
INSERT INTO filme (id, titulo, ano) VALUES
(1006, 'Sing', 2016)

SELECT * FROM filme

INSERT INTO estrela (id, nome, nome_real) VALUES
(9901, 'Michael Keaton', 'Michael John Douglas')
GO
INSERT INTO estrela (id, nome, nome_real) VALUES
(9902, 'Emma Stone', 'Emily Jean Stone')
GO
INSERT INTO estrela (id, nome, nome_real) VALUES
(9903, 'Miles Teller', NULL)
GO
INSERT INTO estrela (id, nome, nome_real) VALUES
(9904, 'Steve Carell', 'Steven John Carell')
GO
INSERT INTO estrela (id, nome, nome_real) VALUES
(9905, 'Jennifer Garner', 'Jennifer Anne Garner')

SELECT * FROM estrela

INSERT INTO filme_estrela (filmeId, estrelaId) VALUES
(1002, 9901)
GO
INSERT INTO filme_estrela (filmeId, estrelaId) VALUES
(1002, 9902)
GO
INSERT INTO filme_estrela (filmeId, estrelaId) VALUES
(1001, 9903)
GO
INSERT INTO filme_estrela (filmeId, estrelaId) VALUES
(1005, 9904)
GO
INSERT INTO filme_estrela (filmeId, estrelaId) VALUES
(1005, 9905)

SELECT * FROM filme_estrela

INSERT INTO dvd (num, data_fabricacao, filmeId) VALUES
(10001, '2020-12-02', 1001)
GO
INSERT INTO dvd (num, data_fabricacao, filmeId) VALUES
(10002, '2019-10-18', 1002)
GO
INSERT INTO dvd (num, data_fabricacao, filmeId) VALUES
(10003, '2020-04-03', 1003)
GO
INSERT INTO dvd (num, data_fabricacao, filmeId) VALUES
(10004, '2020-12-02', 1001)
GO
INSERT INTO dvd (num, data_fabricacao, filmeId) VALUES
(10005, '2019-10-18', 1004)
GO
INSERT INTO dvd (num, data_fabricacao, filmeId) VALUES
(10006, '2020-04-03', 1002)
GO
INSERT INTO dvd (num, data_fabricacao, filmeId) VALUES
(10007, '2020-12-02', 1005)
GO
INSERT INTO dvd (num, data_fabricacao, filmeId) VALUES
(10008, '2019-10-18', 1002)
GO
INSERT INTO dvd (num, data_fabricacao, filmeId) VALUES
(10009, '2020-04-03', 1003)

SELECT * FROM dvd


INSERT INTO cliente (num_cadastro, nome, logradouro, num, cep) VALUES
(5501, 'Matilde Luz', 'Rua Síria', 150, 03086040)
GO
INSERT INTO cliente (num_cadastro, nome, logradouro, num, cep) VALUES
(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, 04419110)
GO
INSERT INTO cliente (num_cadastro, nome, logradouro, num, cep) VALUES
(5503, 'Daniel Ramalho', 'Rua Itajutiba', 169, NULL)
GO
INSERT INTO cliente (num_cadastro, nome, logradouro, num, cep) VALUES
(5504, 'Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL)
GO
INSERT INTO cliente (num_cadastro, nome, logradouro, num, cep) VALUES
(5505, 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, 02917110)

SELECT * FROM cliente


INSERT INTO locacao (dvdNum, clienteNum_cadastro, data_locacao, data_devolucao, valor) VALUES
(10001, 5502, '2021-02-18', '2021-05-21', 3.50)
GO
INSERT INTO locacao (dvdNum, clienteNum_cadastro, data_locacao, data_devolucao, valor) VALUES
(10009, 5502, '2021-02-18', '2021-05-21', 3.50)
GO
INSERT INTO locacao (dvdNum, clienteNum_cadastro, data_locacao, data_devolucao, valor) VALUES
(10002, 5503, '2021-02-18', '2021-05-19', 3.50)
GO 
INSERT INTO locacao (dvdNum, clienteNum_cadastro, data_locacao, data_devolucao, valor) VALUES
(10002, 5505, '2021-02-20', '2021-05-23', 3.00)
GO
INSERT INTO locacao (dvdNum, clienteNum_cadastro, data_locacao, data_devolucao, valor) VALUES
(10004, 5505, '2021-02-20', '2021-05-23', 3.00)
GO
INSERT INTO locacao (dvdNum, clienteNum_cadastro, data_locacao, data_devolucao, valor) VALUES
(10005, 5505, '2021-02-20', '2021-05-23', 3.00)
GO
INSERT INTO locacao (dvdNum, clienteNum_cadastro, data_locacao, data_devolucao, valor) VALUES
(10001, 5501, '2021-02-24', '2021-05-26', 3.50)
GO
INSERT INTO locacao (dvdNum, clienteNum_cadastro, data_locacao, data_devolucao, valor) VALUES
(10008, 5501, '2021-02-24', '2021-05-26', 3.50)

SELECT * FROM estrela

UPDATE estrela
SET nome_real = 'Miles Alexander Teller'
WHERE id = 9903

SELECT * FROM cliente

UPDATE cliente
SET cep = 08411150
WHERE num_cadastro = 5503

UPDATE cliente
SET cep = 02918190
WHERE num_cadastro = 5504

SELECT * FROM locacao

UPDATE locacao
SET valor = 3.25
WHERE data_locacao = '2021-02-18'
GO
UPDATE locacao
SET valor = 3.25
WHERE data_locacao = '2021-02-18'
GO
UPDATE locacao
SET valor = 3.10
WHERE data_locacao = '2021-02-18'


SELECT * FROM filme

DELETE filme
WHERE id = 1006