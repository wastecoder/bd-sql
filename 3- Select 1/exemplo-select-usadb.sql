--Selecionar database criado
USE selects


--Exibir registros das tabelas
SELECT * FROM funcionario
SELECT * FROM projeto
SELECT * FROM funcproj


DELETE funcionario 
WHERE id >= 5


--Apenas SQL SERVER: Reinicia o IDENTITY para um valor definido
DBCC CHECKIDENT ('funcionario', RESEED, 4);


--Inserir dados: funcionario
INSERT INTO funcionario
VALUES
('Fulano','da Silva Jr.','R. Voluntários da Patria',8150,NULL,'05423110','11','32549874','1990-09-09',1235.00),
('João','dos Santos','R. Anhaia',150,NULL,'03425000','11','45879852','1973-08-19',2352.00),
('Maria','dos Santos','R. Pedro de Toledo',18,NULL,'04426000','11','32568974','1982-05-03',4550.00)



--//Funções importantes (GETDATE(), CAST, CONVERT)
--AS é um ALIAS (apelido)
SELECT GETDATE() AS data_hora_hoje


--CAST converte tipos padrão SQL
--SELECT CAST(valor AS novo_tipo)
SELECT CAST('12' AS INT) AS char_to_int
SELECT CAST('E12' AS INT) AS char_to_int
SELECT CAST(12 AS VARCHAR(2)) AS int_to_char
SELECT CAST(12.05 AS VARCHAR(2)) AS float_to_char
SELECT CAST(12.05 AS VARCHAR(5)) AS float_to_char


--SQL Server CONVERT()
--SELECT CONVERT(novo_tipo, valor)
SELECT CONVERT(INT, '12') AS char_to_int
SELECT CONVERT(INT, 'E12') AS char_to_int
SELECT CONVERT(VARCHAR(2), 12) AS int_to_char
SELECT CONVERT(VARCHAR(2), 12.05) AS float_to_char
SELECT CONVERT(VARCHAR(5), 12.05) AS float_to_char


--Para datas SELECT CONVERT(novo_tipo, DATE ou DATETIME, código)
SELECT GETDATE() AS data_hora_hoje

--Código 103 ==> Retona CHAR ou VARCHAR no formato dd/mm/aaaa
SELECT CONVERT(CHAR(10), GETDATE(), 103) AS data_hoje_BR
SELECT CONVERT(CHAR(11), GETDATE(), 100) AS data_hoje_US --Codigo 100 = mm/dd/yyyy

--Código 108 ==> Retona CHAR ou VARCHAR do DATETIME no formato HH:mm:ss:ddd
SELECT CONVERT(CHAR(8), GETDATE(), 108) AS agora

--Gerar saída 1 coluna data e 1 coluna hora
SELECT CONVERT(CHAR(10), GETDATE(), 103) AS data_hoje_BR, 
		CONVERT(CHAR(8), GETDATE(), 108) AS agora



UPDATE funcionario
SET sobrenome = 'Dos Santos Jr.'
WHERE id = 5



--//Consultas
--Select Simples funcionario
SELECT id, nome, sobrenome, ddd, telefone --Não precisam ser todas as colunas
FROM funcionario


--Select Simples funcionario(s) Fulano
SELECT id, nome, sobrenome, ddd, telefone
FROM funcionario
WHERE nome = 'Fulano'


--Select Simples funcionario(s) Fulano Silva
SELECT id, nome, sobrenome, ddd, telefone
FROM funcionario
WHERE nome = 'Fulano' AND sobrenome = 'Silva'


SELECT id, nome, sobrenome, ddd, telefone
FROM funcionario
WHERE nome = 'Fulano' AND sobrenome LIKE '%Silva'


--Select Simples funcionario(s) Souza
SELECT id, nome, sobrenome, ddd, telefone
FROM funcionario
WHERE sobrenome LIKE '%Souza%'
--%x ==> qualquer coisa antes de X
--x% ==> qualquer coisa depois de X



--Id e Nome Concatenado de quem não tem telefone
--+ concatena conteúdo das colunas
--Para testes com NULL se usa IS no lugar de = ou IS NOT no lugar de != (<>) 
SELECT id, nome + ' ' + sobrenome AS nome_completo
FROM funcionario
WHERE telefone IS NULL


--Id, Nome Concatenado e telefone (sem ddd) de quem tem telefone
SELECT id, 
		nome + ' ' + sobrenome AS nome_completo,
		telefone AS tel
FROM funcionario
WHERE telefone IS NOT NULL


--Nome Concatenado e telefone (sem ddd) de quem tem telefone em ordem alfabética
SELECT id, 
		nome + ' ' + sobrenome AS nome_completo,
		telefone AS tel
FROM funcionario
WHERE telefone IS NOT NULL
ORDER BY nome ASC --ASC Ascendente, DESC Descrescente

--Usando múltiplas colunas para ordenação
SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
		telefone AS tel
FROM funcionario
WHERE telefone IS NOT NULL
ORDER BY nome ASC, sobrenome ASC --ASC Ascendente, DESC Descrescente


--Id, Nome completo, Endereco completo (Rua, nº e CEP), 
--ddd e telefone, ordem alfabética crescente
SELECT id, 
		nome + ' ' + sobrenome AS nome_completo,
		logradouro + ', ' + CAST(numero AS VARCHAR(5)) + ' - CEP: ' + cep AS end_comp
		--CONCAT(logradouro, ', ', numero, ' - CEP: ', cep) AS end_comp
FROM funcionario
ORDER BY nome ASC, sobrenome ASC


--Id, Nome completo, Endereco completo (Rua, nº e CEP), data_nasc (BR), 
--ordem alfabética decrescente
SELECT id, 
		nome + ' ' + sobrenome AS nome_completo,
		logradouro + ', ' + CAST(numero AS VARCHAR(5)) + ' - CEP: ' + cep AS end_comp,
		--CONCAT(logradouro, ', ', numero, ' - CEP: ', cep) AS end_comp
		CONVERT(CHAR(10), data_nasc, 103) AS data_nasc
FROM funcionario
ORDER BY nome DESC, sobrenome DESC

--Datas distintas (BR) de inicio de trabalhos
--DISTINCT - Remove da exibição da consulta registros inteiramente iguais
SELECT DISTINCT CONVERT(CHAR(10), data_inicio, 103) AS data_inicio
FROM funcproj


--Se o nome no AS for diferente da coluna em uma coluna de CHAR ou VARCHAR,
--não irá ordenar adequadamente com o ASC ou DESC
SELECT CONVERT(CHAR(10), data_inicio, 103) AS data_inicio
FROM funcproj
ORDER BY data_inicio ASC, data_fim ASC

SELECT CONVERT(CHAR(10), data_inicio, 103) AS inicio
FROM funcproj
ORDER BY data_inicio ASC, data_fim ASC


--Id, nome_completo e 15% de aumento para Cicrano
SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
--		salario,
		CAST(salario * 1.15 AS DECIMAL(7,2)) AS novo_salario--salario + salario * 0.15
FROM funcionario
WHERE nome = 'Cicrano'

/* Para efetivar a atualização
UPDATE funcionario
SET salario = salario * 1.15
WHERE id = 2 --nome = 'Cicrano'
*/



--Id, Nome completo e salario de quem ganha mais que 3000
SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
		salario
FROM funcionario
WHERE salario > 3000.00 --salario >= 3000.00


--Id, Nome completo e salario de quem ganha menos que 2000
SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
		salario
FROM funcionario
WHERE salario < 2000.00 --salario <= 2000.00


--Id, Nome completo e salario de quem ganha entre 2000 e 3000
SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
		salario
FROM funcionario
WHERE salario >= 2000.00 AND salario <= 3000.00


--Substitui a consulta acima com BETWEEN
SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
		salario
FROM funcionario
WHERE salario BETWEEN 2000.00 AND 3000.00


--Id, Nome completo e salario de quem ganha menos que 2000 ou mais que 3000
SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
		salario
FROM funcionario
WHERE salario <= 2000.00 OR salario >= 3000.00

--Substitui a consulta acima com NOT BETWEEN
SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
		salario
FROM funcionario
WHERE salario NOT BETWEEN 2000.00 AND 3000.00



--PASTEBIN: https://pastebin.com/RCcne8Er
