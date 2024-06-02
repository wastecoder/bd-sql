USE projectsDB

SELECT * FROM users
SELECT * FROM users_has_projects
SELECT * FROM projects


--Consultar:
--1) Quantos projetos n�o tem usu�rios associados a ele.
--A coluna deve chamar qty_projects_no_users
SELECT
	COUNT(p.id) AS qty_projects_no_users
FROM
projects p LEFT JOIN users_has_projects	uhp
	ON p.id = uhp.projects_id
WHERE uhp.projects_id IS NULL;


--2) Id do projeto, nome do projeto, qty_users_project (quantidade de usu�rios
--por projeto) em ordem alfab�tica crescente pelo nome do projeto
SELECT
	pr.id,
	pr.name,
	COUNT(usrp.users_id) as qty_users_project
FROM
projects pr INNER JOIN users_has_projects usrp
	ON pr.id = usrp.projects_id
GROUP BY pr.id, pr.name
ORDER BY pr.name DESC
