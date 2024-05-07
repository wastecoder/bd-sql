--//Criar banco de dados
CREATE DATABASE locadoraDB
GO
USE locadoraDB


--//Criar tabelas
CREATE TABLE filme(
	id				INT				NOT NULL,
	titulo			VARCHAR(40)		NOT NULL,
	ano				INT				NULL		CHECK(ano <= 2021)
	PRIMARY KEY(id)
)
CREATE TABLE estrela(
	id				INT				NOT NULL,
	nome			VARCHAR(50)		NOT NULL
	PRIMARY KEY(id)
)
GO
CREATE TABLE filme_estrela(
	fk_filme		INT				NOT NULL,
	fk_estrela		INT				NOT NULL
	PRIMARY KEY(fk_filme, fk_estrela),
	FOREIGN KEY(fk_filme) REFERENCES filme(id),
	FOREIGN KEY(fk_estrela) REFERENCES estrela(id)
)
GO
CREATE TABLE dvd(
	numero				INT			NOT NULL,
	data_fabricacao		DATE		NOT NULL	CHECK(data_fabricacao < GETDATE()),
	fk_filme			INT			NOT NULL
	PRIMARY KEY(numero)
	FOREIGN KEY(fk_filme) REFERENCES filme(id)
)
GO
CREATE TABLE cliente(
	num_cadastro	INT				NOT NULL,
	nome			VARCHAR(70)		NOT NULL,
	end_logradouro	VARCHAR(150)	NOT NULL,
	end_numero		INT				NOT NULL	CHECK(end_numero > 0),
	end_cep			CHAR(8)			NULL		CHECK(LEN(end_cep) = 8)
	PRIMARY KEY(num_cadastro)
)
GO
CREATE TABLE locacao(
	fk_dvd			INT				NOT NULL,
	fk_cliente		INT				NOT NULL,
	data_locacao	DATE			NOT NULL	DEFAULT(GETDATE()),
	data_devolucao	DATE			NOT NULL,
	valor			DECIMAL(7, 2)	NOT NULL	CHECK(valor > 0),
	PRIMARY KEY(fk_dvd, fk_cliente, data_locacao),
	FOREIGN KEY(fk_dvd) REFERENCES dvd(numero),
	FOREIGN KEY(fk_cliente) REFERENCES cliente(num_cadastro),
	CONSTRAINT check_devolucao_maior_que_locacao
		CHECK(data_devolucao > data_locacao)
)


--//Esquema
--A entidade estrela deveria ter o nome real da estrela, com 50 caracteres
ALTER TABLE estrela
ADD nome_real VARCHAR(50)
EXEC sp_help estrela


--Verificando um dos nomes de filme, percebeu-se que o nome do filme deveria
--ser um atributo com 80 caracteres
ALTER TABLE filme
ALTER COLUMN titulo VARCHAR(80)
EXEC sp_help filme


--Inserir dados: filme
INSERT INTO filme VALUES (1001, 'Whiplash', 2015)
INSERT INTO filme VALUES (1002, 'Birdman', 2015)
INSERT INTO filme VALUES (1003, 'Interestelar', 2014)
INSERT INTO filme VALUES (1004, 'A Culpa é das Estrelas', 2014)
INSERT INTO filme VALUES (1005, 'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014)
INSERT INTO filme VALUES (1006, 'Sing', 2016)
SELECT * FROM filme


--Inserir dados: estrela
INSERT INTO estrela VALUES (9901, 'Michael Keaton', 'Michael John Douglas')
INSERT INTO estrela VALUES (9902, 'Emma Stone', 'Emily Jean Stone')
INSERT INTO estrela VALUES (9903, 'Miles Teller', NULL)
INSERT INTO estrela VALUES (9904, 'Steve Carell', 'Steven John Carell')
INSERT INTO estrela VALUES (9905, 'Jennifer Garner', 'Jennifer Anne Garner')
SELECT * FROM estrela


--Inserir dados: filme_estrela
INSERT INTO filme_estrela VALUES (1002, 9901)
INSERT INTO filme_estrela VALUES (1002, 9902)
INSERT INTO filme_estrela VALUES (1001, 9903)
INSERT INTO filme_estrela VALUES (1005, 9904)
INSERT INTO filme_estrela VALUES (1005, 9905)
SELECT * FROM filme_estrela


--Inserir dados: dvd
INSERT INTO dvd VALUES (10001, '2020-12-02', 1001)
INSERT INTO dvd VALUES (10002, '2019-10-18', 1002)
INSERT INTO dvd VALUES (10003, '2020-04-03', 1003)
INSERT INTO dvd VALUES (10004, '2020-12-02', 1001)
INSERT INTO dvd VALUES (10005, '2019-10-18', 1004)
INSERT INTO dvd VALUES (10006, '2020-04-03', 1002)
INSERT INTO dvd VALUES (10007, '2020-12-02', 1005)
INSERT INTO dvd VALUES (10008, '2019-10-18', 1002)
INSERT INTO dvd VALUES (10009, '2020-04-03', 1003)
SELECT * FROM dvd


--Inserir dados: cliente
INSERT INTO cliente VALUES (5501, 'Matilde Luz', 'Rua Síria', 150, '03086040')
INSERT INTO cliente VALUES (5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110')
INSERT INTO cliente VALUES (5503, 'Daniel Ramalho', 'Rua Itajutiba', 169, NULL)
INSERT INTO cliente VALUES (5504, 'Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL)
INSERT INTO cliente VALUES (5505, 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')
SELECT * FROM cliente


--Inserir dados: locacao
INSERT INTO locacao VALUES (10001, 5502, '2021-02-18', '2021-02-21', 3.50)
INSERT INTO locacao VALUES (10009, 5502, '2021-02-18', '2021-02-21', 3.50)
INSERT INTO locacao VALUES (10002, 5503, '2021-02-18', '2021-02-19', 3.50)
INSERT INTO locacao VALUES (10002, 5505, '2021-02-20', '2021-02-23', 3.00)
INSERT INTO locacao VALUES (10004, 5505, '2021-02-20', '2021-02-23', 3.00)
INSERT INTO locacao VALUES (10005, 5505, '2021-02-20', '2021-02-23', 3.00)
INSERT INTO locacao VALUES (10001, 5501, '2021-02-24', '2021-02-26', 3.50)
INSERT INTO locacao VALUES (10008, 5501, '2021-02-24', '2021-02-26', 3.50)
SELECT * FROM locacao



--//Operacoes com dados
--Os CEP dos clientes 5503 e 5504 são 08411150 e 02918190 respectivamente
UPDATE cliente
SET end_cep = '08411150'
WHERE num_cadastro = 5503

UPDATE cliente
SET end_cep = '02918190'
WHERE num_cadastro = 5504

SELECT * FROM cliente
WHERE num_cadastro = 5503 OR num_cadastro = 5504


--A locação de 2021-02-18 do cliente 5502 teve o valor de 3.25 para cada DVD alugado
UPDATE locacao
SET valor = 3.25
WHERE fk_cliente = 5502 AND data_locacao = '2021-02-18'

SELECT * FROM locacao
WHERE fk_cliente = 5502 AND data_locacao = '2021-02-18'


--A locação de 2021-02-24 do cliente 5501 teve o valor de 3.10 para cada DVD alugado
UPDATE locacao
SET valor = 3.10
WHERE fk_cliente = 5501 AND data_locacao = '2021-02-24'

SELECT * FROM locacao
WHERE fk_cliente = 5501 AND data_locacao = '2021-02-24'


--O DVD 10005 foi fabricado em 2019-07-14
UPDATE dvd
SET data_fabricacao = '2019-07-14'
WHERE numero = 10005

SELECT * FROM dvd
WHERE numero = 10005


--O nome real de Miles Teller é Miles Alexander Teller
UPDATE estrela
SET nome_real = 'Miles Alexander Teller'
WHERE nome = 'Miles Teller'

SELECT * FROM estrela
WHERE nome = 'Miles Teller'


--O filme Sing não tem DVD cadastrado e deve ser excluído
DELETE FROM filme
WHERE id = 1006

SELECT * FROM filme
WHERE titulo = 'Sing'



--//Consultas dos dados
--Fazer um select que retorne os nomes dos filmes de 2014
SELECT titulo AS filmes_de_2014
FROM filme
WHERE ano = 2014


--Fazer um select que retorne o id e o ano do filme Birdman
SELECT id, ano
FROM filme
WHERE titulo = 'Birdman'


--Fazer um select que retorne o id e o ano do filme que tem o nome terminado por plash
SELECT id, ano
FROM filme
WHERE titulo LIKE '%plash'


--Fazer um select que retorne o id, o nome e o nome_real da estrela cujo nome começa com Steve
SELECT id, nome, nome_real
FROM estrela
WHERE nome LIKE 'Steve%'


--Fazer um select que retorne FilmeId e a data_fabricação em formato (DD/MM/YYYY)
--(apelidar de fab) dos filmes fabricados a partir de 01-01-2020
SELECT	fk_filme AS FilmeID,
		CONVERT(VARCHAR(10), data_fabricacao, 103) AS fab
FROM dvd
WHERE data_fabricacao >= '2020-01-01'


--Fazer um select que retorne DVDnum, data_locacao, data_devolucao, valor e valor com
--multa de acréscimo de 2.00 da locação do cliente 5505
SELECT	fk_dvd AS DVDnum,
		data_locacao,
		data_devolucao,
		valor,
		CAST(valor + 2.00 AS DECIMAL(7,2)) AS multa
FROM locacao
WHERE fk_cliente = 5505


--Fazer um select que retorne Logradouro, num e CEP de Matilde Luz
SELECT	end_logradouro as logradouro,
		end_numero AS num,
		end_cep AS CEP
FROM cliente
WHERE nome = 'Matilde Luz'


--Fazer um select que retorne Nome real de Michael Keaton
SELECT nome_real
FROM estrela
WHERE nome = 'Michael Keaton'


--Fazer um select que retorne o num_cadastro, o nome e o endereço completo, concatenando
--(logradouro, numero e CEP), apelido end_comp, dos clientes cujo ID é maior ou igual 5503
SELECT	num_cadastro,
		nome,
		end_logradouro + ', ' + CAST(end_numero AS VARCHAR(5)) + ' - ' + end_cep AS end_comp
		--CONCAT(end_logradouro, ', ', end_numero, ' - ', end_cep) AS end_comp
FROM cliente
WHERE num_cadastro >= 5503
