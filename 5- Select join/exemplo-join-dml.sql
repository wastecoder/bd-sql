USE aulajoin10
 
SELECT * FROM alunomateria
SELECT * FROM alunos
SELECT * FROM materias
SELECT * FROM alunomateria
SELECT * FROM avaliacoes
SELECT * FROM notas
SELECT * FROM materias
 
/*
INNER JOIN
SQL 2
SELECT tab1.col1, tab1.col2, tab2.col1, tab3.col1, tab3.col2
FROM tabela1 tab1 
INNER JOIN tabela2 tab2
ON tab1.PK = tab2.FK
INNER JOIN tabela3 tab3
ON tab3.PK = tab2.FK
WHERE condições
 
SQL 3
SELECT tab1.col1, tab1.col2, tab2.col1, tab3.col1, tab3.col2
FROM tabela1 tab1, tabela2 tab2, tabela3 tab3
WHERE tab1.PK = tab2.FK
	AND tab3.PK = tab2.FK
	AND condições
*/
 
/*
OUTER JOIN
SELECT tab1.col1, tab1.col2
FROM tabela1 tab1 LEFT OUTER JOIN tabela2 tab2
ON tab1.PK = tab2.FK
WHERE tab2.FK IS NULL
 
SELECT tab1.col1, tab1.col2
FROM tabela2 tab2 RIGHT OUTER JOIN tabela1 tab1
ON tab1.PK = tab2.FK
WHERE tab2.FK IS NULL
*/
 
--Criar listas de chamadas (RA tem um (-) antes do último 
--digito), 
--ordenados pelo nome, caso o nome tenha mais de 30 caract.
--mostrar 29 e um ponto(.) no final 
--SQL 2
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra,
		CASE WHEN (LEN(al.nome) > 30)
			THEN SUBSTRING(al.nome,1,29)+'.'
			ELSE al.nome
		END AS nome,
		mat.nome AS nome_materia
FROM alunos al 
INNER JOIN alunomateria am
ON al.ra = am.ra_aluno
INNER JOIN materias mat
ON mat.id = am.id_materia
WHERE mat.nome LIKE 'Banco%'
ORDER BY al.nome ASC
 
--SQL 3
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra,
		CASE WHEN (LEN(al.nome) > 30)
			THEN SUBSTRING(al.nome,1,29)+'.'
			ELSE al.nome
		END AS nome,
		mat.nome AS nome_materia
FROM alunos al, alunomateria am, materias mat
WHERE al.ra = am.ra_aluno
	AND mat.id = am.id_materia
	AND mat.nome LIKE 'Banco%'
ORDER BY al.nome ASC
 
-- Pegar as notas da turma 
--SQL 2
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra,
		CASE WHEN (LEN(al.nome) > 30)
			THEN SUBSTRING(al.nome,1,29)+'.'
			ELSE al.nome
		END AS nome,
		mat.id AS id_materia,
		mat.nome AS nome_materia,
		av.tipo,
		av.peso,
		nt.nota
FROM alunos al
INNER JOIN notas nt 
ON al.ra = nt.ra_aluno
INNER JOIN materias mat
ON mat.id = nt.id_materia
INNER JOIN avaliacoes av 
ON av.id = nt.id_avaliacao
WHERE mat.nome LIKE 'Banco%'
	AND av.tipo = 'P1'
ORDER BY av.tipo ASC, al.nome ASC
 
--SQL 3
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra,
		CASE WHEN (LEN(al.nome) > 30)
			THEN SUBSTRING(al.nome,1,29)+'.'
			ELSE al.nome
		END AS nome,
		mat.id AS id_materia,
		mat.nome AS nome_materia,
		av.tipo,
		av.peso,
		nt.nota
FROM alunos al, materias mat, avaliacoes av, notas nt
WHERE al.ra = nt.ra_aluno
	AND mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
	AND mat.nome LIKE 'Banco%'
--	AND av.tipo = 'P1'
ORDER BY av.tipo ASC, al.nome ASC
 
 
-- Matérias que não tem notas cadastradas
SELECT mat.nome
FROM materias mat LEFT OUTER JOIN notas nt
ON mat.id = nt.id_materia
WHERE nt.id_materia IS NULL
 
SELECT mat.nome
FROM notas nt RIGHT OUTER JOIN materias mat
ON mat.id = nt.id_materia
WHERE nt.id_materia IS NULL
 
 
--Exercicios (Tentar fazer no formato SQL2 e SQL3)
--Fazer uma consulta que retorne o RA mascarado, 
--o nome do aluno, a nota já com o peso aplicado
--da disciplina Banco de Dados
--Mascara RA (9 digitos - ultimo digito)
--SQL 2
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra,
	al.nome, 
	CAST(n.nota * av.peso AS DECIMAL(7,2)) AS nota_peso, 
	av.tipo
FROM notas n
INNER JOIN alunos al
ON n.ra_aluno = al.ra
INNER JOIN materias mat
ON n.id_materia = mat.id
INNER JOIN avaliacoes av
ON n.id_avaliacao = av.id
WHERE mat.nome LIKE '%Banco%'
ORDER BY av.tipo, al.nome

--SQL 3
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra,
	al.nome, 
	CAST(n.nota * av.peso AS DECIMAL(7,2)) AS nota_peso, 
	av.tipo
FROM notas n, alunos al, materias mat, avaliacoes av
WHERE n.ra_aluno = al.ra AND n.id_materia = mat.id 
	AND n.id_avaliacao = av.id AND mat.nome LIKE '%Banco%'
ORDER BY av.tipo, al.nome


-- Fazer uma consulta que retorne o RA mascarado e o 
--nome dos alunos que não estão matriculados 
--em nenhuma matéria
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra,
	al.nome
FROM alunos al 
LEFT OUTER JOIN alunomateria am
ON al.ra = am.ra_aluno
WHERE am.ra_aluno IS NULL
ORDER BY al.nome


--Fazer uma consulta que retorne o RA mascarado, 
--o nome dos alunos, o nome da matéria, 
--a nota, o tipo da avaliação, dos alunos que tiraram 
--Notas abaixo da média(6.0) em P1 ou P2, 
--ordenados por matéria e nome do aluno
--SQL 2
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra,
	al.nome, n.nota, av.tipo, mat.nome
FROM notas n
INNER JOIN alunos al
ON n.ra_aluno = al.ra
INNER JOIN materias mat
ON n.id_materia = mat.id
INNER JOIN avaliacoes av
ON n.id_avaliacao = av.id
WHERE n.nota < 6 
AND (av.tipo = 'P1' OR av.tipo = 'P2')
ORDER BY mat.nome, al.nome

--SQL 3
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra,
	al.nome, n.nota, av.tipo, mat.nome
FROM notas n, alunos al, materias mat, avaliacoes av 
WHERE n.ra_aluno = al.ra AND n.id_materia = mat.id
	AND n.id_avaliacao = av.id AND n.nota < 6 
	AND (av.tipo = 'P1' OR av.tipo = 'P2')
ORDER BY mat.nome, al.nome
