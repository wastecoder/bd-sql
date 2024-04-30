CREATE DATABASE livrariadb
GO
USE livrariadb


CREATE TABLE autor (
	id_autor    INT                 NOT NULL    IDENTITY(2351, 1),
	nome        VARCHAR(100)        NOT NULL    UNIQUE,
	data_nasc   DATE                NOT NULL,
	pais_nasc   VARCHAR(100)        NOT NULL    CHECK(pais_nasc = 'Brasil' OR pais_nasc = 'Estados Unidos' OR pais_nasc = 'Inglaterra' OR pais_nasc = 'Alemanha'),
	biografia   VARCHAR(255)        NOT NULL
	PRIMARY KEY(id_autor)
)
GO
CREATE TABLE livro (
	codigo      INT                 NOT NULL    IDENTITY(100001, 100),
	nome        VARCHAR(1200)       NOT NULL,
	lingua      VARCHAR(10)         NOT NULL    DEFAULT('PT-BR'),
	ano         INT                 NOT NULL    CHECK(ano > 1990)
	PRIMARY KEY(codigo)
)
GO
CREATE TABLE edicao (
	isbn            CHAR(13)            NOT NULL    CHECK(LEN(isbn) = 13),
	preco           DECIMAL(4, 2)       NOT NULL    CHECK(preco > 0),
	ano             INT                 NOT NULL    CHECK(ano > 1993),
	numero_paginas  INT                 NOT NULL    CHECK(numero_paginas < 15),
	qtd_estoque     INT                 NOT NULL
	PRIMARY KEY (isbn)
)
GO
CREATE TABLE editora (
	id_editora          INT             NOT NULL    IDENTITY(491, 16),
	nome                VARCHAR(70)     NOT NULL    UNIQUE,
	telefone            VARCHAR(10)     NOT NULL    CHECK(LEN(telefone) = 10),
	end_logradouro      VARCHAR(200)    NOT NULL,
	end_numero          INT             NOT NULL    CHECK(end_numero > 0),
	end_cep             CHAR(8)         NOT NULL    CHECK(LEN(end_cep) = 8),
	end_complemento     VARCHAR(255)    NOT NULL
	PRIMARY KEY (id_editora)
)
GO
CREATE TABLE livro_autor (
	livrocodigo         INT             NOT NULL,
	autorcodigo         INT             NOT NULL
	PRIMARY KEY (livrocodigo, autorcodigo)
	FOREIGN KEY (livrocodigo) REFERENCES livro(codigo),
	FOREIGN KEY (autorcodigo) REFERENCES autor(id_autor)
)
GO
CREATE TABLE editora_edicao_livro (
	editoraid           INT             NOT NULL,
	edicaoisbn          CHAR(13)        NOT NULL,
	livrocodigo         INT             NOT NULL
	PRIMARY KEY (editoraid, edicaoisbn, livrocodigo)
	FOREIGN KEY (editoraid) REFERENCES editora(id_editora),
	FOREIGN KEY (edicaoisbn) REFERENCES edicao(isbn),
	FOREIGN KEY (livrocodigo) REFERENCES livro(codigo)
)


EXEC sp_help autor
EXEC sp_help livro
EXEC sp_help edicao
EXEC sp_help editora
EXEC sp_help livro_autor
EXEC sp_help editora_edicao_livro
