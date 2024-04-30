CREATE DATABASE mecanica
GO
USE mecanica


CREATE TABLE cliente (
	id					INT				NOT NULL	IDENTITY(3401, 15),
	nome				VARCHAR(100)	NOT NULL,
	end_logradouro		VARCHAR(200)	NOT NULL,
	end_numero			INT				NOT NULL	CHECK(end_numero > 0),
	end_cep				CHAR(8)			NOT NULL	CHECK(LEN(end_cep) = 8),
	end_complemento		VARCHAR(255)	NOT NULL
	PRIMARY KEY (id)
)
GO
CREATE TABLE telefone_cliente (
	id_cliente			INT				NOT NULL	REFERENCES cliente(id),
	telefone			VARCHAR(11)		NOT NULL	CHECK(LEN(telefone) = 10 OR LEN(telefone) = 11)
	PRIMARY KEY (id_cliente, telefone)
)
GO
CREATE TABLE veiculo (
	placa				CHAR(7)			NOT NULL	CHECK(LEN(placa) = 7),
	marca				VARCHAR(30)		NOT NULL,
	modelo				VARCHAR(30)		NOT NULL,
	cor					VARCHAR(15)		NOT NULL,
	ano_fabricacao		INT				NOT NULL	CHECK(ano_fabricacao > 1997),
	ano_modelo			INT				NOT NULL	CHECK(ano_modelo > 1997),
	data_aquisicao		DATE			NOT NULL,
	id_cliente			INT				NOT NULL
	PRIMARY KEY (placa)
	FOREIGN KEY (id_cliente) REFERENCES cliente(id),
	CONSTRAINT check_ano_fabricacao_modelo
		CHECK	(ano_modelo = ano_fabricacao OR
				ano_modelo = (1 + ano_fabricacao))
)
GO
CREATE TABLE categoria (
	id					INT				NOT NULL	IDENTITY(1, 1),
	categoria			VARCHAR(10)		NOT NULL,
	valor_hora			DECIMAL(4, 2)	NOT NULL
	PRIMARY KEY (id),
	CONSTRAINT check_categoria_valorhora
		CHECK	((UPPER(categoria) = 'ESTAGI�RIO' AND valor_hora > 15) OR
				(UPPER(categoria) = 'N�VEL 1' AND valor_hora > 25) OR
				(UPPER(categoria) = 'N�VEL 2' AND valor_hora > 35) OR
				(UPPER(categoria) = 'N�VEL 3' AND valor_hora > 50))
)
GO
CREATE TABLE funcionario (
	id					INT				NOT NULL	IDENTITY(101, 1),
	nome				VARCHAR(100)	NOT NULL,
	end_logradouro		VARCHAR(200)	NOT NULL,
	end_numero			INT				NOT NULL	CHECK(end_numero > 0),
	end_cep				CHAR(8)			NOT NULL	CHECK(LEN(end_cep) = 8),
	end_complemento		VARCHAR(255)	NOT NULL,
	telefone			CHAR(11)		NOT NULL	CHECK(LEN(telefone) = 10 OR LEN(telefone) = 11),
	catego_habilitacao	VARCHAR(2)		NOT NULL	CHECK((UPPER(catego_habilitacao) = 'A') OR
													(UPPER(catego_habilitacao) = 'B') OR
													(UPPER(catego_habilitacao) = 'C') OR
													(UPPER(catego_habilitacao) = 'D') OR
													(UPPER(catego_habilitacao) = 'E')),
	id_categoria		INT				NOT NULL
	PRIMARY KEY (id)
	FOREIGN KEY (id_categoria) REFERENCES categoria(id)
)
GO
CREATE TABLE peca (
	id					INT				NOT NULL	IDENTITY(3411, 7),
	nome				VARCHAR(30)		NOT NULL	UNIQUE,
	preco				DECIMAL(4, 2)	NOT NULL	CHECK(preco > 0),
	estoque				INT				NOT NULL	CHECK(estoque >= 10)
	PRIMARY KEY (id)
)
GO
CREATE TABLE reparo (
	placa_veiculo		CHAR(7)			NOT NULL,
	id_funcionario		INT				NOT NULL,
	id_peca				INT				NOT NULL,
	data_reparo			DATE			NOT NULL	DEFAULT GETDATE(),
	custo_total			DECIMAL(4, 2)	NOT NULL	CHECK(custo_total > 0),
	tempo				INT				NOT NULL	CHECK(tempo > 0),
	PRIMARY KEY (placa_veiculo, id_funcionario, id_peca, data_reparo),
	FOREIGN KEY (placa_veiculo) REFERENCES veiculo(placa),
	FOREIGN KEY (id_funcionario) REFERENCES funcionario(id),
	FOREIGN KEY (id_peca) REFERENCES peca(id),
)


EXEC sp_help cliente
EXEC sp_help telefone_cliente
EXEC sp_help veiculo
EXEC sp_help categoria
EXEC sp_help funcionario
EXEC sp_help peca
EXEC sp_help reparo
