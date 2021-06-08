CREATE DATABASE amostra
GO
USE amostra
GO
CREATE TABLE departamento (
depto_no CHAR(2) NOT NULL,
depto_nome VARCHAR(25) NOT NULL,
localizacao CHAR(30) NULL
PRIMARY KEY (depto_no))
GO
CREATE TABLE projeto (
proj_no CHAR(2) NOT NULL,
proj_nome VARCHAR(15) NOT NULL,
orcamento DECIMAL(9,2) NULL
PRIMARY KEY (proj_no))
GO
CREATE TABLE empregado (
emp_no INT NOT NULL, 
emp_pri_nome VARCHAR(20) NOT NULL,
emp_ult_nome VARCHAR(20) NOT NULL,
depto_no CHAR(2) NOT NULL
PRIMARY KEY (emp_no)
FOREIGN KEY (depto_no) REFERENCES departamento(depto_no))
GO
CREATE TABLE emp_proj (
emp_no INTEGER NOT NULL,
proj_no CHAR(2) NOT NULL,
trabalho VARCHAR(15) NULL,
data_inicio DATETIME NULL
PRIMARY KEY (emp_no,proj_no)
FOREIGN KEY (emp_no) REFERENCES empregado(emp_no),
FOREIGN KEY (proj_no) REFERENCES projeto(proj_no))

INSERT INTO departamento VALUES ('d1', 'pesquisa','Dallas')
INSERT INTO departamento VALUES ('d2', 'contabilidade', 'Seattle')
INSERT INTO departamento VALUES ('d3', 'marketing', 'Dallas')
INSERT INTO departamento VALUES ('d4', 'TI', 'Seattle')
INSERT INTO projeto VALUES ('p1', 'Apollo', 120000.00)
INSERT INTO projeto VALUES ('p2', 'Gemini', 95000.00)
INSERT INTO projeto VALUES ('p3', 'Mercury', 186500.00)
INSERT INTO projeto VALUES ('p4', 'Juno', 18750.00)
INSERT INTO empregado VALUES(25348, 'Matthew', 'Smith','d3')
INSERT INTO empregado VALUES(10102, 'Ann', 'Jones','d3')
INSERT INTO empregado VALUES(18316, 'John', 'Barrimore', 'd1')
INSERT INTO empregado VALUES(29346, 'James', 'James', 'd2')
INSERT INTO empregado VALUES(9031, 'Elsa', 'Bertoni', 'd2')
INSERT INTO empregado VALUES(2581, 'Elke', 'Hansel', 'd2')
INSERT INTO empregado VALUES(28559, 'Sybill', 'Moser', 'd1')
INSERT INTO emp_proj VALUES (10102,'p1', 'analista', '2006-10-01')
INSERT INTO emp_proj VALUES (10102, 'p3', 'gerente', '2008-01-01')
INSERT INTO emp_proj VALUES (25348, 'p2', 'escriturário', '2007-02-15')
INSERT INTO emp_proj VALUES (18316, 'p2', NULL, '2006-06-01')
INSERT INTO emp_proj VALUES (29346, 'p2', NULL, '2006-12-15')
INSERT INTO emp_proj VALUES (2581, 'p3', 'analista', '2007-10-15')
INSERT INTO emp_proj VALUES (9031, 'p1', 'gerente', '2007-04-15')
INSERT INTO emp_proj VALUES (28559, 'p1', NULL, '2007-08-01')
INSERT INTO emp_proj VALUES (28559, 'p2', 'escriturário', '2008-02-01')
INSERT INTO emp_proj VALUES (9031, 'p3', 'escriturário', '2006-11-15')  
INSERT INTO emp_proj VALUES (29346, 'p1','escriturário', '2007-01-04')

SELECT * FROM departamento
SELECT * FROM projeto
SELECT * FROM empregado
SELECT * FROM emp_proj

-- 1) Consultar o nome completo (concatenado), o trabalho e o nome do projeto e a data em padrão BR (DD/MM/YYYY),
-- do funcionário mais velho em projetos dentre os cadastrados
SELECT emp.emp_pri_nome + ' ' + emp.emp_ult_nome AS nome_completo_func,
		emp_proj.trabalho, proj.proj_nome AS nome_projeto,
		CONVERT(CHAR(10), emp_proj.data_inicio, 103) AS data_projeto
FROM empregado emp, emp_proj, projeto proj
WHERE emp.emp_no = emp_proj.emp_no
		AND proj.proj_no = emp_proj.proj_no
		AND emp_proj.data_inicio IN
		(
			SELECT MIN(emp_proj.data_inicio)
			FROM emp_proj
		)

-- 2) Consultar quantos funcionários estão cadastrados em cada projeto (nome de coluna 'quantidade')
-- e o nome do projeto, ordenado de maneira descrescente pelo nome do projeto
SELECT COUNT(emp_proj.emp_no) AS quantidade, proj.proj_nome
FROM emp_proj, projeto proj
WHERE emp_proj.proj_no = proj.proj_no
GROUP BY proj.proj_nome
ORDER BY proj.proj_nome DESC

-- 3) Consultar o nome completo do empregado (concatenado como nome_completo) e a quantidade de projetos
-- em que ele está alocado (nome de coluna deve ser 'quantidade'), ordenados de forma ascendente pelo nome_completo
SELECT emp.emp_pri_nome + ' ' + emp.emp_ult_nome AS nome_completo_func,
		COUNT(emp_proj.emp_no) AS quantidade
FROM empregado emp, emp_proj
WHERE emp.emp_no = emp_proj.emp_no
GROUP BY emp_pri_nome, emp_ult_nome
ORDER BY nome_completo_func ASC

-- 4) Consultar o nome do projeto, o orçamento (budget) do projeto e a quantidade de funcionários (nome de coluna 'quantidade').
-- Se a quantidade de funcionários for maior que três, o orçamento deve ter uma redução de 10% do valor original,
-- se a quantidade de funcionários for menor ou igual, o orçamento deve ter um acréscimo 25% do valor original.
SELECT proj.proj_nome AS nome_projeto, proj.orcamento, COUNT(emp_proj.emp_no) AS quantidade,
		CASE
			WHEN COUNT(emp_proj.emp_no) > 3
			THEN (proj.orcamento * 0.90)
			WHEN COUNT(emp_proj.emp_no) <= 3
			THEN (proj.orcamento * 1.25)
		END AS novo_orcamento
FROM projeto proj, emp_proj
WHERE proj.proj_no = emp_proj.proj_no
GROUP BY proj.proj_nome, proj.orcamento
