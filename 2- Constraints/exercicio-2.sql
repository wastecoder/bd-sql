CREATE DATABASE maternidadeDB
GO
USE maternidadeDB


CREATE TABLE mae (
	id_mae				INT				NOT NULL	IDENTITY(1001, 1),
	nome				VARCHAR(60)		NOT NULL,
	end_logradouro		VARCHAR(100)	NOT NULL,
	end_numero			INT				NOT NULL	CHECK(end_numero > 0),
	end_cep				CHAR(8)			NOT NULL	CHECK(LEN(end_cep) = 8),
	end_complemento		VARCHAR(200)	NOT NULL,
	telefone			CHAR(10)		NOT NULL	CHECK(LEN(telefone) = 10),
	data_nascimento		DATE			NOT NULL
	PRIMARY KEY (id_mae)
)
GO
CREATE TABLE medico (
	crm_numero			INT				NOT NULL,
	crm_uf				CHAR(2)			NOT NULL,
	nome				VARCHAR(60)		NOT NULL,
	celular				CHAR(11)		NOT NULL	UNIQUE			CHECK(LEN(celular) = 11),
	especialidade		VARCHAR(30)		NOT NULL
	PRIMARY KEY (crm_numero, crm_uf)
)
GO
CREATE TABLE bebe (
	id_bebe				INT				NOT NULL	PRIMARY KEY		IDENTITY(1, 1),
	nome				VARCHAR(60)		NOT NULL,
	data_nascimento		DATE			NOT NULL	DEFAULT GETDATE(),
	altura				DECIMAL(7,2)	NOT NULL	CHECK (altura > 0),
	peso				DECIMAL(4,3)	NOT NULL	CHECK (peso > 0),
	id_mae				INT				NOT NULL	REFERENCES mae(id_mae)
	--PRIMARY KEY (id_bebe)
	--FOREIGN KEY (id_mae) REFERENCES mae(id_mae)
)
GO
CREATE TABLE bebe_medico (
	id_bebe				INT				NOT NULL,
	crm_numero			INT				NOT NULL,
	crm_uf				CHAR(2)			NOT NULL
	PRIMARY KEY (id_bebe, crm_numero, crm_uf)
	FOREIGN KEY (id_bebe) REFERENCES bebe(id_bebe),
	FOREIGN KEY (crm_numero, crm_uf) REFERENCES medico(crm_numero, crm_uf),
)


EXEC sp_help mae
EXEC sp_help medico
EXEC sp_help bebe
EXEC sp_help bebe_medico
