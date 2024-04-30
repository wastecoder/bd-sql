/*Um campeonato de basquete tem times que s�o cadastrados por um 
id �nico, que come�a em 4001 e incrementa de 1 em 1, o nome do time 
que tamb�m deve ser �nico, a cidade, a data e hora de cria��o do time. 
Um time tem muitos jogadores, por�m 1 jogador s� pode jogar em 1 time 
e os jogadores s�o cadastrados por um c�digo �nico que inicia 
em 900101, incrementa de 1 em 1, o nome do jogador deve ser �nico 
tamb�m, sexo pode apenas ser M ou F, mas a maioria dos jogadores � 
Homem, altura com 2 casas decimais e a data de nascimento 
(apenas jogadores nascidos at� 31/12/1999). 
Jogadores do sexo masculino devem ter, no m�nimo 1.70 de altura e 
do sexo feminino, 1.60).

CONSTRAINTS - RESTRI��ES
	Auto incremento - IDENTITY(X,Y)
	IDENTITY = IDENTITY(1,1)
	�nico - UNIQUE
	Valor Padr�o - DEFAULT(X)
	Valida��o - CHECK()
	PK
	FK
*/

CREATE DATABASE aulaconstraintstimes
GO
USE aulaconstraintstimes


CREATE TABLE times (
	id					INT				NOT NULL	IDENTITY(4001,1),
	nome				VARCHAR(50)		NOT NULL	UNIQUE,
	cidade				VARCHAR(80)		NOT NULL,
	dt_hr_criacao		DATETIME		NOT NULL
	PRIMARY KEY(id)
)

EXEC sp_help times


INSERT INTO times (nome, cidade, dt_hr_criacao) VALUES
('Hawks', 'Paulinia', '2003-09-04 15:18:00')
--('Hawks', 'Paulinia', '04/09/2003 15:18:00')

INSERT INTO times (nome, cidade, dt_hr_criacao) VALUES
('Bulls', 'Itu', '2000-04-17 19:18:00')

INSERT INTO times (nome, cidade, dt_hr_criacao) VALUES
('Bills', 'Santo Andr�', '2002-01-19 21:00:00')

SELECT * FROM times


CREATE TABLE jogador (
	codigo				INT				NOT NULL	IDENTITY(900101, 1),
	nome				VARCHAR(50)		NOT NULL	UNIQUE,
	sexo				CHAR(1)			NOT NULL	CHECK(UPPER(sexo)='M' OR UPPER(sexo)='F')		DEFAULT('M'),
	altura				DECIMAL(4,2)	NOT NULL,
	dt_nasc				DATE			NOT NULL	CHECK(dt_nasc <= '1999-12-31'),
	id_time				INT				NOT NULL		
	PRIMARY KEY (codigo)
	FOREIGN KEY (id_time) REFERENCES times(id),
	CONSTRAINT chk_sx_alt
		CHECK ((UPPER(sexo) = 'M' AND altura >= 1.70) OR
				(UPPER(sexo) = 'F' AND altura >= 1.60)
			  )
)

EXEC sp_help jogador

SELECT * FROM jogador


INSERT INTO jogador (nome, altura, dt_nasc, id_time) VALUES
('L. Bird', 2.15, '1999-02-02', 4001)

INSERT INTO jogador (nome, altura, dt_nasc, id_time) VALUES
('M. Johnson', 1.92, '1997-04-25', 4001)

INSERT INTO jogador (nome, altura, dt_nasc, id_time) VALUES
('M. Jordan', 1.94, '1998-08-25', 4001)

INSERT INTO jogador (nome, altura, dt_nasc, id_time) VALUES
('C. Barkley', 1.90, '1995-12-01', 4002)

INSERT INTO jogador (nome, altura, dt_nasc, id_time) VALUES
('S. Pippen', 1.97, '1997-10-01', 4002)


DELETE jogador

--TRUNCATE TABLE tabela (DROP TABLE tabela seguido CREATE TABLE tabela)
TRUNCATE TABLE jogador 

--Exclusivo SQL SERVER - Reinicia o IDENTITY para um valor definido
--Ao adicionar pode dar erro pela PK j� existir. Solu��o: adicionar novamente
DBCC CHECKIDENT('jogador', 'RESEED', 900100)
