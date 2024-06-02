USE projectsDB


--Fazer:
--A) Adicionar User: (6; Joao; Ti_joao; 123mudar; joao@empresa.com)
INSERT INTO users (name, username, password, email) VALUES ('Joao', 'Ti_joao', '123mudar', 'joao@empresa.com')
SELECT * FROM users

--b) Adicionar Project: (10004; Atualização de Sistemas; Modificação de Sistemas Operacionais nos PC's; 12/09/2014)
INSERT INTO projects (name, description, date) VALUES('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PCs', '2014-09-12')
SELECT * FROM projects


--C) Consultar
--1) Id, Name e Email de Users; Id, Name, Description e Data de Projects,
--dos usuários que participaram do projeto Name Re-folha
SELECT
    u.id AS user_id, 
    u.name AS user_name, 
    u.email AS user_email, 
    p.id AS project_id, 
    p.name AS project_name, 
    p.description AS project_description, 
    p.date AS project_date
FROM
    users u
INNER JOIN
    users_has_projects up ON u.id = up.users_id
INNER JOIN
    projects p ON up.projects_id = p.id
WHERE
    p.name = 'Re-folha'

--2) Name dos Projects que não tem Users
SELECT 
    p.name AS project_name
FROM 
    projects p LEFT JOIN users_has_projects up
ON p.id = up.projects_id
WHERE up.users_id IS NULL

--3) Name dos Users que não tem Projects
SELECT 
    u.name AS user_name
FROM 
    users u LEFT JOIN users_has_projects up
ON u.id = up.users_id
WHERE up.projects_id IS NULL
