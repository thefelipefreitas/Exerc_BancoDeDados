USE ex01DDLDML

--Retorne id, nome, email, username e caso a senha seja diferente de '123mudar', mostrar '********', caso contrário, mostrar a própria senha.
SELECT id, uname, email, username, 
		CASE
			WHEN upassword = '123mudar' THEN upassword
			ELSE
				'********'
		END AS upassword
FROM users

--Considerando que o projeto '10001' durou 15 dias. Mostre o nome do projeto, descrição, data, data_final do projeto realizado por usuário de e-mail 'aparecido@empresa.com'
SELECT pname AS proj_name,
		pdescription AS proj_desc,
		CONVERT(CHAR(10), pdate, 103) AS proj_date,
		CONVERT(CHAR(10), DATEADD (DAY, 15, pdate), 103) AS final_date
FROM projects
WHERE id IN 
(
	SELECT projects_id
	FROM users_has_projects
	WHERE users_id IN
	(
		SELECT id
		FROM users
		WHERE email = 'aparecido@empresa.com'
	)
)

--Retorne o nome e o email dos usuários que estão envolvidos no projeto de nome 'Auditoria'
SELECT uname, email
FROM users
WHERE id IN
(
	SELECT users_id
	FROM users_has_projects
	WHERE projects_id IN
	(
		SELECT id 
		FROM projects
		WHERE pname = 'Auditoria'
	)
)

--Considerando que o custo diário do projeto, cujo nome tem o termo Manutenção, é de 79.85 e ele deve finalizar 16/09/2014, consultar, nome, descrição, data, data_final e custo_total do projeto
SELECT pname AS proj_name,
		pdescription AS proj_desc,
		CONVERT(CHAR(10), pdate, 103) AS proj_date,
		CONVERT(CHAR(10), '2014-09-16', 103) AS final_date,
		CAST(DATEDIFF(DAY, pdate, '2014-09-16') AS DECIMAL(7,2)) * 79.85 AS custo_total
FROM projects
WHERE pname LIKE '%Manutenção%'
