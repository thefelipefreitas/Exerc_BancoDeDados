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
SELECT DISTINCT cli.nome AS nome_cliente, 
		CASE 
			WHEN (cli.logradouro IS NULL AND cli.numero IS NULL AND cli.telefone IS NOT NULL)    
			THEN SUBSTRING(cli.telefone, 1, 5) + '-' + SUBSTRING(cli.telefone, 6, 9) 
			ELSE 
				CASE 
					WHEN (cli.telefone IS NULL AND cli.logradouro IS NOT NULL AND cli.numero IS NOT NULL)    
					THEN cli.logradouro + ',' + CAST(cli.numero AS VARCHAR(4)) 
						ELSE 
							cli.logradouro + ',' + CAST(cli.numero AS VARCHAR(4)) + 
							SUBSTRING(cli.telefone, 1, 5) + '-' + SUBSTRING(cli.telefone, 6, 9)
			END
		END AS cliente
FROM clientes cli
LEFT OUTER JOIN emprestimo emp
ON cli.cod = emp.cod_cli
WHERE emp.cod_cli IS NULL

--6) Consulta que retorne quantos livros não foram emprestados	
SELECT COUNT(liv.cod) AS qtd_livros_nao_emprestados
FROM livros liv
LEFT OUTER JOIN emprestimo emp
ON liv.cod = emp.cod_livro
WHERE emp.cod_cli IS NULL

--7) Consulta que retorne Nome do Autor, Tipo do corredor e quantos livros, ordenados por quantidade de livro.
SELECT aut.nome AS nome_autor, corr.tipo AS tipo_corredor, COUNT(liv.cod) AS qtd_livros
FROM autores aut, corredor corr, livros liv
WHERE aut.cod = liv.cod_autor
		AND liv.cod_corredor = corr.cod
GROUP BY aut.nome, corr.tipo
ORDER BY qtd_livros DESC
		
--8) Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do cliente,
--o nome do livro, o total de dias que cada um está com o livro e,
--uma coluna que apresente, caso o número de dias seja superior a 4, 
--apresente 'Atrasado', caso contrário, apresente 'No Prazo'
SELECT cli.nome AS nome_cliente, liv.nome AS nome_livro,
		DATEDIFF(DAY, emp.data_emp, '2012-05-18') AS qtd_dias_alugado,
		CASE 
			WHEN DATEDIFF(DAY, emp.data_emp, '2012-05-18') > 4
			THEN 'Atrasado'
			ELSE 'No Prazo'
		END AS status
FROM clientes cli, livros liv, emprestimo emp
WHERE cli.cod = emp.cod_cli
		AND liv.cod = emp.cod_livro

--9) Consulta que retorne cod de corredores, tipo de corredores e quantos livros tem em cada corredor.
SELECT corr.cod AS codigo_corredor, corr.tipo AS tipo_corredor, 
		COUNT(liv.cod_corredor) AS qtd_livros
FROM livros liv
INNER JOIN corredor corr
ON liv.cod_corredor = corr.cod 
GROUP BY corr.cod, corr.tipo, liv.cod_corredor

--10) Consulta que retorne o Nome dos autores cuja quantidade de livros cadastrado é maior ou igual a 2.	
SELECT aut.nome AS nome_autor
FROM autores aut
INNER JOIN livros liv
ON aut.cod = liv.cod_autor
GROUP BY aut.nome
HAVING COUNT(liv.cod_autor) >= 2

--11) Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do cliente, o nome do livro dos empréstimos que tem 7 dias ou mais.
SELECT cli.nome AS nome_cliente, liv.nome AS nome_livro
FROM clientes cli, livros liv, emprestimo emp
WHERE cli.cod = emp.cod_cli
		AND liv.cod = emp.cod_livro
		AND DATEDIFF(DAY, emp.data_emp, '2012-05-18') >= 7



