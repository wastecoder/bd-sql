USE aulajoin10

SELECT * FROM alunos
SELECT * FROM materias
SELECT * FROM avaliacoes
SELECT * FROM notas ORDER by id_materia, id_avaliacao
SELECT * FROM alunomateria

/*Funções de Agregação
SUM(), AVG(), COUNT(), MAX(), MIN() 

GROUP BY - Cláusula de Agregação
HAVING - Filtro para Funções de Agregação
*/


--Consultar a média das notas de cada avaliação por matéria
--Select Média aritmética a partir da soma com filtro de Avaliação e Matéria

--Select Média aritmética com filtro de Avaliação e Matéria

--Agrupando por matéria e tipo de avaliação
SELECT
	mat.nome,
	av.tipo,
	CAST(AVG(nt.nota) AS DECIMAL(4,1)) AS media
FROM alunos al, avaliacoes av, materias mat, notas nt
WHERE
	al.ra = nt.ra_aluno
	AND mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
GROUP BY mat.nome, av.tipo
ORDER BY mat.nome ASC, av.tipo ASC

SELECT
	mat.nome,
	av.tipo,
	CAST(AVG(nt.nota) AS DECIMAL(4,1)) AS media
FROM alunos al 
INNER JOIN
	notas nt ON al.ra = nt.ra_aluno
INNER JOIN
	materias mat ON mat.id = nt.id_materia
INNER JOIN
	avaliacoes av ON av.id = nt.id_avaliacao
GROUP BY mat.nome, av.tipo
ORDER BY mat.nome ASC, av.tipo ASC


--Consultar o RA do aluno (mascarado), a nota final dos alunos, 
--de alguma matéria e uma coluna conceito 
--(aprovado caso nota >= 6, reprovado, caso contrário)
SELECT
	SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra,
	al.nome,
	CAST(SUM(nt.nota * av.peso) AS DECIMAL(4,1)) AS nota_final,
	CASE WHEN (SUM(nt.nota * av.peso) >= 6.0)
		THEN 'AP'
		ELSE 'REP'
	END AS situacao
FROM alunos al, avaliacoes av, materias mat, notas nt
WHERE al.ra = nt.ra_aluno
	AND mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
	AND mat.nome LIKE 'Banco%'
GROUP BY al.ra, al.nome
ORDER BY al.nome ASC

SELECT
	SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra,
	al.nome,
	CAST(SUM(nt.nota * av.peso) AS DECIMAL(4,1)) AS nota_final,
	CASE WHEN (SUM(nt.nota * av.peso) >= 6.0)
		THEN 'AP'
		ELSE 'REP'
	END AS situacao
FROM alunos al 
INNER JOIN
	notas nt ON al.ra = nt.ra_aluno
INNER JOIN
	materias mat ON mat.id = nt.id_materia
INNER JOIN
	avaliacoes av ON av.id = nt.id_avaliacao
WHERE mat.nome LIKE 'Banco%'
GROUP BY al.ra, al.nome
ORDER BY al.nome ASC


--Consultar nome da matéria e quantos alunos estão matriculados
SELECT
	mat.nome,
	COUNT(al.ra) AS qtd_matriculados
FROM alunos al, alunomateria am, materias mat
WHERE
	al.ra = am.ra_aluno
	AND mat.id = am.id_materia
GROUP BY mat.nome

SELECT
	mat.nome,
	COUNT(al.ra) AS qtd_matriculados
FROM alunos al 
INNER JOIN
	alunomateria am ON al.ra = am.ra_aluno
INNER JOIN
	materias mat ON mat.id = am.id_materia
GROUP BY mat.nome


--Consultar quantos alunos não estão matriculados
SELECT
	COUNT(al.ra) AS qtd_nao_matriculados
FROM
	alunos al LEFT OUTER JOIN alunomateria am
ON al.ra = am.ra_aluno
WHERE am.ra_aluno IS NULL

SELECT
	COUNT(al.ra) AS qtd_nao_matriculados
FROM
	alunomateria am RIGHT OUTER JOIN alunos al 
ON al.ra = am.ra_aluno
WHERE am.ra_aluno IS NULL


--Consultar quais alunos estão aprovados em alguma matéria 
--(nota final >= 6,0)
SELECT
	SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra,
	al.nome,
	CAST(SUM(nt.nota * av.peso) AS DECIMAL(4,1)) AS nota_final,
	CASE WHEN (SUM(nt.nota * av.peso) >= 6.0)
		THEN 'AP'
		ELSE 'REP'
	END AS situacao
FROM alunos al, avaliacoes av, materias mat, notas nt
WHERE
	al.ra = nt.ra_aluno
	AND mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
	AND mat.nome LIKE 'Banco%'
GROUP BY al.ra, al.nome
HAVING SUM(av.peso * nt.nota) >= 6.0
ORDER BY al.nome ASC

SELECT
	SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra,
	al.nome,
	CAST(SUM(nt.nota * av.peso) AS DECIMAL(4,1)) AS nota_final,
	CASE WHEN (SUM(nt.nota * av.peso) >= 6.0)
		THEN 'AP'
		ELSE 'REP'
	END AS situacao
FROM alunos al 
INNER JOIN notas nt
	ON al.ra = nt.ra_aluno
INNER JOIN materias mat
	ON mat.id = nt.id_materia
INNER JOIN avaliacoes av
	ON av.id = nt.id_avaliacao
WHERE mat.nome LIKE 'Banco%'
GROUP BY al.ra, al.nome
HAVING SUM(av.peso * nt.nota) >= 6.0
ORDER BY al.nome ASC


--Consultar quantos alunos estão aprovados em alguma matéria
--(nota final >= 6,0)
SELECT
	COUNT(ra) AS qtd_aprovados
FROM alunos
WHERE ra IN 
(
	SELECT
		al.ra 
	FROM alunos al, avaliacoes av, materias mat, notas nt
	WHERE
		al.ra = nt.ra_aluno
		AND mat.id = nt.id_materia
		AND av.id = nt.id_avaliacao
		AND mat.nome LIKE 'Banco%'
	GROUP BY al.ra, al.nome
	HAVING SUM(av.peso * nt.nota) >= 6.0
)

SELECT
	COUNT(ra) AS qtd_aprovados
FROM alunos
WHERE ra IN 
(
	SELECT
		al.ra
	FROM alunos al 
	INNER JOIN
		notas nt ON al.ra = nt.ra_aluno
	INNER JOIN
		materias mat ON mat.id = nt.id_materia
	INNER JOIN
		avaliacoes av ON av.id = nt.id_avaliacao
	WHERE mat.nome LIKE 'Banco%'
	GROUP BY al.ra, al.nome
	HAVING SUM(av.peso * nt.nota) >= 6.0
)

--Consultar quantos alunos estão reprovados em alguma matéria
--(nota final < 6,0)
SELECT COUNT(ra) AS qtd_aprovados
FROM alunos
WHERE ra IN 
(
	SELECT al.ra 
	FROM alunos al, avaliacoes av, materias mat, notas nt
	WHERE
		al.ra = nt.ra_aluno
		AND mat.id = nt.id_materia
		AND av.id = nt.id_avaliacao
		AND mat.nome LIKE 'Banco%'
	GROUP BY al.ra, al.nome
	HAVING SUM(av.peso * nt.nota) < 6.0
)

SELECT
	COUNT(ra) AS qtd_aprovados
FROM alunos
WHERE ra IN 
(
	SELECT
		al.ra
	FROM alunos al 
	INNER JOIN
		notas nt ON al.ra = nt.ra_aluno
	INNER JOIN
		materias mat ON mat.id = nt.id_materia
	INNER JOIN
		avaliacoes av ON av.id = nt.id_avaliacao
	WHERE mat.nome LIKE 'Banco%'
	GROUP BY al.ra, al.nome
	HAVING SUM(av.peso * nt.nota) < 6.0
)

--Consultar a maior e menor notas das avaliações das matérias
SELECT
	mat.nome, 
	av.tipo,
	MIN(nt.nota) AS menor_nota, 
	MAX(nt.nota) AS maior_nota
FROM alunos al, avaliacoes av, materias mat, notas nt
WHERE
	al.ra = nt.ra_aluno
	AND mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
GROUP BY mat.nome, av.tipo
ORDER BY mat.nome ASC, av.tipo ASC

SELECT
	mat.nome, 
	av.tipo,
	MIN(nt.nota) AS menor_nota, 
	MAX(nt.nota) AS maior_nota
FROM alunos al 
INNER JOIN
	notas nt ON al.ra = nt.ra_aluno
INNER JOIN
	materias mat ON mat.id = nt.id_materia
INNER JOIN
	avaliacoes av ON av.id = nt.id_avaliacao
GROUP BY mat.nome, av.tipo
ORDER BY mat.nome ASC, av.tipo ASC


--Consultar a menor notas das avaliações das matérias
--que não sejam zero
SELECT
	mat.nome, 
	av.tipo,
	MIN(nt.nota) AS menor_nota, 
	MAX(nt.nota) AS maior_nota
FROM alunos al, avaliacoes av, materias mat, notas nt
WHERE
	al.ra = nt.ra_aluno
	AND mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
	AND nt.nota > 0.0
GROUP BY mat.nome, av.tipo
ORDER BY mat.nome ASC, av.tipo ASC
 
SELECT
	mat.nome, 
	av.tipo,
	MIN(nt.nota) AS menor_nota, 
	MAX(nt.nota) AS maior_nota
FROM alunos al 
INNER JOIN
	notas nt ON al.ra = nt.ra_aluno
INNER JOIN
	materias mat ON mat.id = nt.id_materia
INNER JOIN
	avaliacoes av ON av.id = nt.id_avaliacao
WHERE nt.nota > 0.0
GROUP BY mat.nome, av.tipo
ORDER BY mat.nome ASC, av.tipo ASC


--Retornar nome da matéria, tipo da avaliação e as 2 maiores notas
SELECT
	TOP 2 --Exibe os primeiros X resultados da busca
	SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra,
	al.nome,
	mat.nome AS materia,
	av.tipo,
	nt.nota
FROM alunos al, avaliacoes av, materias mat, notas nt
WHERE
	al.ra = nt.ra_aluno
	AND mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
	AND av.tipo = 'P1'
	AND mat.nome LIKE 'Banco%'
ORDER BY nt.nota DESC

SELECT
	TOP 2
	SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra,
	al.nome,
	mat.nome AS materia,
	av.tipo,
	nt.nota
FROM alunos al 
INNER JOIN
	notas nt ON al.ra = nt.ra_aluno
INNER JOIN
	materias mat ON mat.id = nt.id_materia
INNER JOIN
	avaliacoes av ON av.id = nt.id_avaliacao
WHERE
	av.tipo = 'P1'
	AND mat.nome LIKE 'Banco%'
ORDER BY nt.nota DESC


--Fazer uma consulta que retorne o RA formatado e o nome dos 
--alunos que tem a menor nota da P1 de banco de dados
SELECT
	SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra,
	al.nome,
	nt.nota
FROM alunos al, notas nt, materias mat, avaliacoes av
WHERE
	al.ra = nt.ra_aluno
	AND mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
	AND mat.nome LIKE 'Banco%'
	AND av.tipo = 'P1'
	AND nt.nota IN
(
	SELECT
		MIN(nt.nota)
	FROM avaliacoes av, materias mat, notas nt
	WHERE
		mat.id = nt.id_materia
		AND av.id = nt.id_avaliacao
		AND av.tipo = 'P1'
		AND mat.nome LIKE 'Banco%'
)

SELECT
	SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra,
	al.nome,
	nt.nota
FROM alunos al
INNER JOIN
	notas nt ON al.ra = nt.ra_aluno
INNER JOIN
	materias mat ON mat.id = nt.id_materia
INNER JOIN
	avaliacoes av ON av.id = nt.id_avaliacao
WHERE
	mat.nome LIKE 'Banco%'
	AND av.tipo = 'P1'
	AND nt.nota IN
(
	SELECT
		MIN(nt.nota)
	FROM materias mat
	INNER JOIN
		notas nt ON mat.id = nt.id_materia
	INNER JOIN
		avaliacoes av ON av.id = nt.id_avaliacao
	WHERE
		av.id = nt.id_avaliacao
		AND av.tipo = 'P1'
		AND mat.nome LIKE 'Banco%'
)


--Exercícios de aula: 
--1)
--Montar a seguinte tabela de saída:
--(ra formatado, nome, nota_final, conceito, 
--faltante(quanto faltou para passar (null 
--para aprovados)), min_exame (quanto precisa 
--tirar no exame para passar (null para 
--alunos com notas maior que 6,0 e menor que
--3,0)))
--exame : nota_final + nota_exame / 2 >= 6.0
--12 - nota_final = nota mínima no exame
SELECT
	SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra, 10, 1) AS ra,
	al.nome,
	CAST(SUM(av.peso * nt.nota) AS DECIMAL(4,1)) AS nota_final,
	CASE WHEN SUM(av.peso * nt.nota) >= 6
		THEN 
			'APROVADO'
		ELSE
			'REPROVADO'
	END AS conceito,
	CASE WHEN SUM(av.peso * nt.nota) >= 6.0
		THEN 
			NULL
		ELSE 
			CAST(6.0 - SUM(av.peso * nt.nota) AS DECIMAL(4,1))
	END AS faltante,
	CASE WHEN (SUM(av.peso * nt.nota) >= 6.0 OR SUM(av.peso * nt.nota) < 3.0)
		THEN
			NULL
		ELSE 
			CAST(12.0 - SUM(av.peso * nt.nota) AS DECIMAL(4,1))
	END AS min_exame
FROM alunos al, notas nt, materias mat, avaliacoes av
WHERE
	al.ra = nt.ra_aluno
	AND mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
	AND mat.nome = 'Banco de Dados'
GROUP BY al.ra, al.nome, mat.nome
ORDER BY al.nome


--2)
-- Montar a seguinte tabela de saída:
--(ra formatado, nome, nota)
--para os alunos que tem a maior e a menor 
--nota de uma disciplina e 
--uma avaliação a definir na clausula WHERE.
--P2 | Banco de Dados
SELECT
	SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra, 10, 1) AS ra,
	al.nome,
	nt.nota
FROM alunos al, notas nt, materias mat, avaliacoes av
WHERE
	al.ra = nt.ra_aluno
	AND mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
	AND mat.nome = 'Banco de Dados'
	AND (nt.nota IN
	(
		SELECT
			MIN(nt.nota)
		FROM materias mat, notas nt, avaliacoes av
		WHERE
			nt.id_materia = mat.id
			AND av.id = nt.id_avaliacao
			AND mat.nome = 'Banco de Dados'
			AND av.tipo = 'P2'
			AND nt.nota > 0.0
	)
		OR nt.nota IN 
	(
		SELECT
			MAX(nt.nota)
		FROM materias mat, notas nt, avaliacoes av
		WHERE
			nt.id_materia = mat.id
			AND av.id = nt.id_avaliacao
			AND mat.nome = 'Banco de Dados'
			AND av.tipo = 'P2'
	)
)
ORDER BY nt.nota, al.nome
