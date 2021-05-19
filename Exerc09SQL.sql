USE ex01DDLDML

SELECT * FROM users_has_projects
SELECT * FROM projects
SELECT * FROM users

--Consultar quantos projetos não tem usuários associados a ele. A coluna deve chamar 'qty_projects_no_users'
SELECT COUNT(proj.id) AS qty_projects_no_users, proj.pname AS proj_name
FROM projects proj
LEFT OUTER JOIN users_has_projects uhp
ON proj.id = uhp.projects_id
WHERE uhp.users_id IS NULL
GROUP BY proj.id, proj.pname

--Id e nome do projeto, qty_users_project (quantidade de usuários por projeto) em ordem alfabética crescente pelo nome do projeto.
SELECT proj.id AS id_proj, proj.pname AS name_proj, COUNT(users.uname) AS total_func
FROM projects proj, users_has_projects uhp, users
WHERE proj.id = uhp.projects_id 
           AND users.id = uhp.users_id
GROUP BY proj.pname, proj.id

