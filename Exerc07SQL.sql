USE ex01DDLDML

SELECT * FROM users
SELECT * FROM projects
SELECT * FROM users_has_projects

INSERT INTO users (uname, username, upassword, email) VALUES
('Joao', 'Ti_joao', '123mudar', 'joao@empresa.com')

INSERT INTO projects (pname, pdescription, pdate) VALUES
('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PC´s', '2014-09-14')

--Id, Name, Description e Data Project. Id, Name e Email de Users dos usuários que participaram do projeto 'Re-folha'
SELECT users.id AS id_user,
	   users.uname AS name_user, 
	   users.email AS email_user,
	   projects.id AS id_project, 
	   projects.pname AS name_project, 
	   projects.pdescription AS descr_project, 
	   projects.pdate AS date_project
FROM users_has_projects
INNER JOIN projects
ON users_has_projects.projects_id = projects.id
INNER JOIN users
ON users_has_projects.users_id = users.id
WHERE pname LIKE '%folha'

--Name dos Projects que não tem Users
SELECT pname
FROM projects
LEFT OUTER JOIN users_has_projects
ON projects.id = users_has_projects.projects_id 
WHERE users_has_projects.users_id IS NULL

--Name dos Users que não tem Projects
SELECT uname
FROM users
LEFT OUTER JOIN users_has_projects
ON users.id = users_has_projects.users_id
WHERE users_has_projects.projects_id IS NULL

