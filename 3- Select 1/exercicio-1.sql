--Criar banco de dados
CREATE DATABASE projectsDB
GO
USE projectsDB


--Criar tabelas
CREATE TABLE projects(
	id				INT				NOT NULL	IDENTITY(10001, 1),
	name			VARCHAR(45)		NOT NULL,
	description		VARCHAR(45)		NULL,
	date			DATE			NOT NULL	CHECK(date > '2014-09-01')
	PRIMARY KEY(id)
)
GO
CREATE TABLE users(
	id				INT				NOT NULL	IDENTITY(1, 1),
	name			VARCHAR(45)		NOT NULL,
	username		VARCHAR(45)		NOT NULL	UNIQUE,
	password		VARCHAR(45)		NOT NULL	DEFAULT('123mudar'),
	email			VARCHAR(45)		NOT NULL
	PRIMARY KEY(id)
)
GO
CREATE TABLE  users_has_projects(
	projects_id		INT				NOT NULL,
	users_id		INT				NOT NULL
	PRIMARY KEY(projects_id, users_id)
	FOREIGN KEY (projects_id) REFERENCES projects(id),
	FOREIGN KEY (users_id) REFERENCES users(id)
)


--Modificar a coluna username da tabela Users para varchar(10)
--Da erro porque precisa remover a unicidade da coluna username antes, depois adicionar de novo
ALTER TABLE users
ALTER COLUMN username VARCHAR(10)
EXEC sp_help users


--Modificar a coluna password da tabela Users para varchar(8)
ALTER TABLE users
ALTER COLUMN password VARCHAR(8)
EXEC sp_help users


--Inserir dados: Users
INSERT INTO users (name, username, password, email) VALUES ('Maria', 'Rh_maria', '123mudar', 'maria@empresa.com')
INSERT INTO users (name, username, password, email) VALUES ('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com')
INSERT INTO users (name, username, password, email) VALUES ('Ana', 'Rh_ana', '123mudar', 'ana@empresa.com')
INSERT INTO users (name, username, password, email) VALUES ('Clara', 'Ti_clara', '123mudar', 'clara@empresa.com')
INSERT INTO users (name, username, password, email) VALUES ('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')
SELECT * FROM users


--Inserir dados: Projects
INSERT INTO projects (name, description, date) VALUES('Re-folha', 'Refatoração das Folhas', '2014-09-05')
INSERT INTO projects (name, description, date) VALUES('Manutenção PCs', 'Manutenção PCs', '2014-09-06')
INSERT INTO projects (name, description, date) VALUES('Auditoria', NULL, '2014-09-07')
SELECT * FROM projects


--Inserir dados: users_has_projects
INSERT INTO users_has_projects VALUES(10001, 1)
INSERT INTO users_has_projects VALUES(10001, 5)
INSERT INTO users_has_projects VALUES(10003, 3)
INSERT INTO users_has_projects VALUES(10002, 4)
INSERT INTO users_has_projects VALUES(10002, 2)
SELECT * FROM users_has_projects


--O projeto de Manutenção atrasou, mudar a data para 12/09/2014
UPDATE projects
SET date = '2014-09-12'
WHERE id = 10002
SELECT * FROM projects WHERE ID = 10002


--O username de aparecido (usar o nome como condição de mudança) está feio, mudar para Rh_cido
UPDATE users
SET username = 'Rh_cido'
WHERE name = 'Aparecido'
SELECT * FROM users WHERE name = 'Aparecido'


--Mudar o password do username Rh_maria (usar o username como condição de mudança) para 888@*,
-- mas a condição deve verificar se o password dela ainda é 123mudar
UPDATE users
SET password = '888@*'
WHERE username = 'Rh_maria' AND password = '123mudar'
SELECT * FROM users WHERE username = 'Rh_maria'


--O user de id 2 não participa mais do projeto 10002, removê-lo da associativa
DELETE users_has_projects
WHERE users_id = 2 AND projects_id = 10002
SELECT * FROM users_has_projects WHERE users_id = 2
