USE selects

SELECT * FROM funcionario
SELECT * FROM projeto
SELECT * FROM funcproj


--Fun��es importantes
--SUBSTRING ==> SUBSTRING(varchar, pos. inicial, qtd caract.) retorna varchar
SELECT 'Banco de Dados' AS frase
SELECT SUBSTRING('Banco de Dados', 1, 5) AS frase	--Retorna 'Banco'
SELECT SUBSTRING('Banco de Dados', 7, 2) AS frase	--Retorna 'de'
SELECT SUBSTRING('Banco de Dados', 10, 5) AS frase	--Retorna 'Dados'


--TRIM ==> TRIM(varchar)

--LTRIM & RTRIM
--LTRIM ==> LTRIM(varchar) ==> retorna varchar sem espa�os � esquerda
--RTRIM ==> RTRIM(varchar) ==> retorna varchar sem espa�os � direita
SELECT RTRIM(SUBSTRING('Banco de Dados', 1, 6)) AS frase		--Retorna 'Banco ' >> 'Banco'
SELECT LTRIM(RTRIM(SUBSTRING('Banco de Dados', 6, 4))) AS frase	--Retorna ' de ' >> 'de'
SELECT LTRIM(SUBSTRING('Banco de Dados', 9, 6)) AS frase		--Retorna ' Dados' >> 'Dados'


--DATAS
--DAY, MONTH, YEAR ==> retorna o n�mero do dia/m�s/ano da data
--DATEPART == retorna dia, m�s, ano, dia da semana, dia do ano e muito mais a partir de uma data
--DATEDIFF, DATEADD ==> faz opera��es com datas
SELECT GETDATE() AS agora
SELECT DAY(GETDATE()) AS dia_hoje
SELECT MONTH(GETDATE()) AS mes_hoje
SELECT YEAR(GETDATE()) AS ano_hoje

SELECT DAY(GETDATE()) AS dia_hoje,
	MONTH(GETDATE()) AS mes_hoje,
	YEAR(GETDATE()) AS ano_hoje

SELECT DAY(GETDATE()) + 1 AS dia_amanha
SELECT DATEPART(WEEKDAY, GETDATE()) AS dia_semana
SELECT DATEPART(WEEKDAY, '2024-05-06') AS dia_semana
SELECT DATEPART(WEEK, GETDATE()) AS semana_ano
SELECT DATEPART(DAYOFYEAR, GETDATE()) AS dia_ano
SELECT DATEPART(DAY, GETDATE()) AS dia_hoje
SELECT DATEPART(MONTH, GETDATE()) AS mes_hoje
SELECT DATEPART(YEAR, GETDATE()) AS ano_hoje

--DATEADD ==> DATEADD(TIPO, INT, DATE) >> tipo retorno = DATETIME
SELECT CONVERT(CHAR(10), DATEADD(DAY, 7, GETDATE()), 103) AS devolucao
SELECT CONVERT(CHAR(10), DATEADD(DAY, -1, GETDATE()), 103) AS ontem
SELECT CONVERT(CHAR(10), DATEADD(DAY, 40, GETDATE()), 103) AS daqui_40_dias

--DATEDIFF == DATEDIFF(TIPO, DATE, DATE) >> tipo retorno = INT
SELECT DATEDIFF(DAY, GETDATE(), '2024-05-14') AS qtd_dias
SELECT DATEDIFF(DAY, '2024-05-14', GETDATE()) AS qtd_dias



----------------------------------------------------------------------

--Consultar id, nome completo e CEP mascarado (XXXXX-XXX) do funcion�rio
SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
		SUBSTRING(cep, 1, 5) + '-' + SUBSTRING(cep, 6, 3) AS cep
FROM funcionario
ORDER BY nome ASC, sobrenome ASC


--Consultar id, nome completo e telefone mascarado, com ddd (XX)XXXX-XXXX
--dos funcion�rios
SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
		'('+ddd+')'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4) AS tel_numero
FROM funcionario


--Caso seja celular? (Telefone iniciam com 6, 7, 8 e 9 ==> Acrescenta 9)
--CASE ==> Parecido com um Switch .. Case
--Alias vai no in�cio
SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
		tel_numero = CASE(SUBSTRING(telefone,1,1))
		WHEN '6' THEN
			'('+ddd+')9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
		WHEN '7' THEN
			'('+ddd+')9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
		WHEN '8' THEN
			'('+ddd+')9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
		WHEN '9' THEN
			'('+ddd+')9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
		ELSE
			'('+ddd+')'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
		END
FROM funcionario

--De outro jeito
--CASE == Parecido com IF
--Alias vai no fim
SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
		CASE WHEN (CAST(SUBSTRING(telefone,1,1) AS INT) >= 6)
			THEN '('+ddd+')9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
			ELSE '('+ddd+')'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
		END AS tel_numero
FROM funcionario


--Consultar id, nome completo, com endere�o completo (poss�vel NULL) dos funcion�rios
--NULL + qualquer_tipo_dado = NULL
SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
		logradouro + ',' + CAST(numero AS VARCHAR(5)) + ' - ' + bairro AS end_completo
		--CONCAT(logradouro , ',', numero, ' - ', bairro) AS endereco
FROM funcionario

SELECT * FROM funcionario

--Corrigir com CASE
SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
		CASE WHEN (bairro IS NOT NULL)
			THEN logradouro + ',' + CAST(numero AS VARCHAR(5)) + ' - ' + bairro
			ELSE logradouro + ',' + CAST(numero AS VARCHAR(5))
		END AS end_completo 
FROM funcionario


--Consultar id, nome completo, endere�o completo, cep mascarado, 
--telefone com ddd mascarado e valida��o de celular dos funcion�rio
SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
		CASE WHEN (bairro IS NOT NULL)
			THEN logradouro + ',' + CAST(numero AS VARCHAR(5)) + ' - ' + bairro
			ELSE logradouro + ',' + CAST(numero AS VARCHAR(5))
		END AS end_completo,
		SUBSTRING(cep, 1, 5) + '-' + SUBSTRING(cep, 6, 3) AS cep,
				CASE WHEN (CAST(SUBSTRING(telefone,1,1) AS INT) >= 6)
			THEN '('+ddd+')9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
			ELSE '('+ddd+')'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
		END AS tel
FROM funcionario
ORDER BY nome ASC, sobrenome ASC


--Quantos dias trabalhados, por funcion�rio em cada projeto
--DATEDIFF
SELECT id_funcionario,
		codigo_projeto,
		DATEDIFF(DAY, data_inicio, data_fim) AS dias_trabalhados
FROM funcproj


--Funcionario 3 do projeto 1003 pediu mais 3 dias para finalizar o projeto, 
--qual ser� sua nova data final, convertida (BR) ?
--DATEADD
SELECT CONVERT(CHAR(10), data_fim, 103) AS data_fim, 
		CONVERT(CHAR(10), DATEADD(DAY, 3, data_fim), 103) AS nova_data_fim
FROM funcproj
WHERE id_funcionario = 3 AND codigo_projeto = 1003

--Quais codigos de projetos distintos tem menos de 10 dias trabalhados
--DATEDIFF
SELECT DISTINCT codigo_projeto
FROM funcproj
WHERE DATEDIFF(DAY, data_inicio, data_fim) < 10

--Quais codigos de projetos distintos tem mais de 10 dias trabalhados
SELECT DISTINCT codigo_projeto
FROM funcproj
WHERE DATEDIFF(DAY, data_inicio, data_fim) >= 10


--Nomes e descri��es de projetos distintos tem menos de 10 dias trabalhados
--SUBQUERY - SUBSELECT - SUBCONSULTA
--C�digo dos projetos com menos de 10 dias
SELECT DISTINCT codigo_projeto
FROM funcproj
WHERE DATEDIFF(DAY, data_inicio, data_fim) < 10

--Nome e descri��o dos projetos com menos de 10 dias
SELECT nome, 
		descricao
FROM projeto
WHERE codigo = 1002 OR codigo = 1003

--Nome e descri��o do 2� ao 5� projeto (1� n�o)
SELECT nome, 
		descricao
FROM projeto
WHERE codigo IN (1002, 1003, 1004, 1005)

--Nome e descri��o dos projetos que n�o s�o do 2� ao 5� (1� sim)
SELECT nome, 
		descricao
FROM projeto
WHERE codigo NOT IN (1002, 1003, 1004, 1005)

SELECT nome, 
		descricao
FROM projeto
WHERE codigo IN
(
	SELECT DISTINCT codigo_projeto
	FROM funcproj
	WHERE DATEDIFF(DAY, data_inicio, data_fim) < 10
)


--Nomes completos dos Funcion�rios que est�o no
--projeto Modifica��o do M�dulo de Cadastro
SELECT nome + ' ' + sobrenome AS nome_completo
FROM funcionario
WHERE id IN
(
	SELECT id_funcionario
	FROM funcproj
	WHERE codigo_projeto IN
	(
		SELECT codigo
		FROM projeto
		WHERE nome LIKE 'Modif%'
	)
)


--id, Nomes completos e Idade, em anos (considere se fez ou ainda far�
--anivers�rio esse ano), dos funcion�rios
SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
		DATEDIFF(DAY, data_nasc, GETDATE()) / 365 AS idade
FROM funcionario
