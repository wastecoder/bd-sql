--Seleciona o banco de dados
USE projectsDB


--Fazer uma consulta que retorne id, nome, email, username e caso a senha seja diferente
--de 123mudar, mostrar ******** (8 asteriscos), caso contrário, mostrar a própria senha.
SELECT
	id,
	name,
	email,
	username,
	CASE WHEN (password = '123mudar')
		THEN '********'
		ELSE password
	END AS passmod
FROM users


--Considerando que o projeto 10001 durou 15 dias, fazer uma consulta que mostre o nome
--do projeto, descrição, data, data_final do projeto realizado por usuário de e-mail
--aparecido@empresa.com
SELECT
	id,
	name,
	description,
	CONVERT(CHAR(10), date, 103) AS data_proj,
	CONVERT(CHAR(10), DATEADD(DAY, 15, date), 103) AS data_final
FROM projects
WHERE id IN
(
    SELECT DISTINCT projects_id
    FROM users_has_projects
    WHERE users_id IN
    (
        SELECT id
        FROM users
        WHERE email LIKE 'aparecido@empresa.com'
    )
)


--Fazer uma consulta que retorne o nome e o email dos usuários
--que estão envolvidos no projeto de nome Auditoria
SELECT
	name,
	email
FROM users
WHERE id IN
(
    SELECT DISTINCT users_id
    FROM users_has_projects
    WHERE projects_id IN
    (
        SELECT id
        FROM projects
        WHERE name LIKE 'Auditoria'
    )
)


--Considerando que o custo diário do projeto, cujo nome tem o termo Manutenção, é de 79.85
--e ele deve finalizar 16/09/2014, consultar, nome, descrição, data, data_final e custo_total
--do projeto
SELECT
	name,
	description, 
	CONVERT(CHAR(10), date, 103) AS data_proj,
	CONVERT(CHAR(10), '16/09/2014', 103) AS data_final,
	DATEDIFF(DAY, date, '16/09/2014') * 79.85 AS dias
FROM projects
WHERE name LIKE '%Manutenção%'
