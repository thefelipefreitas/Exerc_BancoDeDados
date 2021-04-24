INSERT INTO users (uname, username, email) VALUES
('Maria', 'Rh_maria', 'maria@empresa.com')

SELECT * FROM users

INSERT INTO users (uname, username, upassword, email) VALUES
('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com')

INSERT INTO users (uname, username, email) VALUES
('Ana', 'Rh_ana', 'ana@empresa.com')

INSERT INTO users (uname, username, email) VALUES
('Clara', 'Ti_clara', 'clara@empresa.com')

INSERT INTO users (uname, username, upassword, email) VALUES
('Aparecido', 'Rh_cido', '55@!cido', 'aparecido@empresa.com')

SELECT * FROM users

INSERT INTO projects (pname, pdescription, pdate) VALUES
('Re-folha', 'Refatoração das folhas', '2014-09-05')

SELECT * FROM projects

INSERT INTO projects (pname, pdescription, pdate) VALUES
('Manutenção PC´s', 'Manutenção PC´s', '2014-09-06')

INSERT INTO projects (pname, pdescription, pdate) VALUES
('Auditoria', ' ', '2014-09-07')

SELECT * FROM projects

INSERT INTO users_has_projects (users_id, projects_id) VALUES
(1, 10001)

INSERT INTO users_has_projects (users_id, projects_id) VALUES
(5, 10001)

INSERT INTO users_has_projects (users_id, projects_id) VALUES
(3, 10003)

INSERT INTO users_has_projects (users_id, projects_id) VALUES
(4, 10002)

INSERT INTO users_has_projects (users_id, projects_id) VALUES
(2, 10002)

SELECT * FROM users_has_projects
SELECT * FROM projects

UPDATE projects
SET pdate = '2014-09-12'
WHERE id = 10002

DELETE users_has_projects
WHERE users_id = 2
