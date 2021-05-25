CREATE DATABASE ExSQLAula1
GO
USE ExSQLAula1

CREATE TABLE clientes (
cod		    	INT				NOT NULL,
nome			VARCHAR(50)	    NOT NULL, 
logradouro		VARCHAR(100)    NULL, 
numero			INT				NULL,
telefone		CHAR(9)			NULL
PRIMARY KEY (cod)
)
GO
CREATE TABLE autores (
cod			INT				NOT NULL,
nome		VARCHAR(70)	    NOT NULL,
pais		VARCHAR(15)	    NOT NULL,
biografia	VARCHAR(200)	NOT NULL
PRIMARY KEY (cod)
)
GO
CREATE TABLE corredor (
cod     INT				NOT NULL,
tipo	VARCHAR(50)		NOT NULL
PRIMARY KEY (cod)
)
GO
CREATE TABLE livros (
cod				INT			  NOT NULL,
cod_autor		INT			  NOT NULL,
cod_corredor	INT		   	  NOT NULL,
nome			VARCHAR(50)	  NOT NULL,
pag				INT			  NOT NULL,
idioma			VARCHAR(30)	  NOT NULL
PRIMARY KEY (cod)
FOREIGN KEY (cod_autor) REFERENCES autores(cod),
FOREIGN KEY (cod_corredor) REFERENCES corredor(cod)
)
GO
CREATE TABLE emprestimo (
cod_cli		INT			NOT NULL,
data_emp	DATETIME	NOT NULL,
cod_livro	INT			NOT NULL
PRIMARY KEY (cod_cli, data_emp, cod_livro)
FOREIGN KEY (cod_cli) REFERENCES clientes(cod),
FOREIGN KEY (cod_livro) REFERENCES livros(cod)
)

SELECT * FROM autores
SELECT * FROM clientes
SELECT * FROM corredor
SELECT * FROM livros
SELECT * FROM emprestimo

--1) Consulta que retorne o nome do cliente e a data do empréstimo formatada padrão BR (dd/mm/yyyy)
SELECT DISTINCT cli.nome AS nome_cliente, 
	   CONVERT(VARCHAR(10), emp.data_emp, 103) AS data_emprestimo
FROM clientes cli
INNER JOIN emprestimo emp
ON emp.cod_cli = cli.cod

--2) Consulta que retorne Nome do autor e Quantos livros foram escritos por Cada autor, ordenado pelo número de livros. Se o nome do autor tiver mais de 25 caracteres, mostrar só os 13 primeiros.
SELECT	CASE 
			WHEN LEN(aut.nome) > 25    
			THEN  SUBSTRING(aut.nome, 1, 13) + '.'
			ELSE  aut.nome
		END AS nome_autor,
	    COUNT(liv.cod_autor) AS qtd_livros
FROM autores aut
INNER JOIN livros liv
ON aut.cod = liv.cod_autor
GROUP BY aut.nome
ORDER BY qtd_livros DESC

--3) Consulta que retorne o nome do autor e o país de origem do livro com maior número de páginas cadastrados no sistema.
SELECT aut.nome AS nome_autor, aut.pais AS pais_autor, liv.nome AS nome_livro, liv.pag AS pag_livro
FROM autores aut
INNER JOIN livros liv
ON aut.cod = liv.cod_autor
WHERE liv.pag IN
(
	SELECT MAX(pag)
	FROM livros
)

--4) Consulta que retorne nome e endereço concatenado dos clientes que tem livros emprestados.
SELECT DISTINCT cli.nome AS nome_cliente,
	   cli.logradouro + ',' + CAST(cli.numero AS VARCHAR(4)) AS endereco_cliente
FROM clientes cli
INNER JOIN emprestimo emp
ON cli.cod = emp.cod_cli

--5) Nome dos Clientes, sem repetir e, concatenados como	enderço_telefone, o logradouro, o numero e o telefone) dos clientes que NÃO pegaram livros.
--Se o logradouro e o número forem nulos e o telefone não for nulo, mostrar só o telefone. 
--Se o telefone for nulo e o logradouro e o número não forem nulos, mostrar só logradouro e número.
--Se os três existirem, mostrar os três.
--O telefone deve estar mascarado XXXXX-XXXX	

