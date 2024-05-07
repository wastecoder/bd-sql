--Cria database e tabelas
CREATE DATABASE selects
GO
USE selects
GO
CREATE table funcionario(
	id 				INT  			NOT NULL 	IDENTITY,
	nome 			VARCHAR(100) 	NOT NULL,
	sobrenome	 	VARCHAR(200) 	NOT NULL,
	logradouro 		VARCHAR(200) 	NOT NULL,
	numero			INT 			NOT NULL 	CHECK(numero > 0),
	bairro 			VARCHAR(100) 	NULL,
	cep				CHAR(8) 		NULL 		CHECK(LEN(cep) = 8),
	ddd 			CHAR(2) 		NULL 		DEFAULT('11'),
	telefone 		CHAR(8)			NULL		CHECK(LEN(telefone) = 8),
	data_nasc	 	DATE 			NOT NULL 	CHECK(data_nasc < GETDATE()),
	salario 		DECIMAL(7,2) 	NOT NULL
	PRIMARY KEY (id)
)
GO
CREATE table projeto(
	codigo 			INT 			NOT NULL	IDENTITY(1001,1),
	nome			VARCHAR(200)  	NOT NULL 	UNIQUE,
	descricao	 	VARCHAR(300) 	NULL
	PRIMARY KEY(codigo)
)
GO
CREATE table funcproj(
	id_funcionario 	INT				NOT NULL,
	codigo_projeto 	INT				NOT NULL,
	data_inicio		DATE			NOT NULL,
	data_fim 		DATE			NOT NULL,
	CONSTRAINT chk_dt CHECK(data_fim > data_inicio),
	PRIMARY KEY (id_funcionario, codigo_projeto),
	FOREIGN KEY (id_funcionario) references funcionario (id),
	FOREIGN KEY (codigo_projeto) references projeto (codigo)
)


--Exibe os dados da tabela (para antes/depois)
SELECT * FROM funcionario
SELECT * FROM projeto
SELECT * FROM funcproj


--Inserir dados: funcionario, projeto, funcproj
INSERT INTO funcionario (nome, sobrenome, logradouro, numero, bairro, cep, ddd, telefone, data_nasc, salario) VALUES
('Fulano', 'da Silva', 'R. Voluntários da Patria', 8150, 'Santana', '05423110', '11', '76895248', '15/05/1974', 4350.00),
('Cicrano', 'De Souza', 'R. Anhaia', 353, 'Barra Funda', '03598770', '11', '99568741', '25/08/1984', 1552.00),
('Beltrano', 'Dos Santos',	'R. ABC', 1100, 'Artur Alvim', '05448000', '11', '25639854', '02/06/1963', 2250.00),
('Tirano', 'De Souza', 'Avenida Águia de Haia', 4430, 'Artur Alvim', '05448000', NULL, NULL, '15/10/1975', 2804.00)
GO
INSERT INTO funcionario
VALUES 
('Fulano', 'da Silva Jr.', 'R. Voluntários da Patria', 8150, NULL, '05423110', '11', '32549874', '09/09/1990', 1235.00),
('João', 'dos Santos', 'R. Anhaia', 150, NULL, '03425000', '11', '45879852', '19/08/1973', 2352.00),
('Maria', 'dos Santos', 'R. Pedro de Toledo', 18, NULL, '04426000', '11', '32568974', '03/05/1982', 4550.00)
GO
INSERT INTO projeto VALUES
('Implantação de Sistemas', 'Colocar o sistema no ar'),
('Modificação do módulo de cadastro', 'Modificar CRUD'),
('Teste de Sistema de Cadastro', NULL)
GO
INSERT INTO funcproj VALUES
(1, 1001, '18/04/2022', '30/04/2022'),
(3, 1001, '18/04/2022', '30/04/2022'),
(1, 1002, '06/05/2022', '10/05/2022'),
(2, 1002, '06/05/2022', '10/05/2022'),
(3, 1003, '11/05/2022', '13/05/2022')


--PASTEBIN: https://pastebin.com/8W0WFS6n
