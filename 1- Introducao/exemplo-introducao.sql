--Criar database
CREATE DATABASE primeiraaula2024


--Ativar database
USE primeiraaula2024


--Excluir database
USE master
GO
DROP DATABASE primeiraaula2024


--CTRL + R recolhe ou exibe a aba de mensagens
--Criar e ativar a database
CREATE DATABASE primeiraaula2024
GO
USE primeiraaula2024
 
--Comandos DDL para Tabelas - CREATE, ALTER, DROP
/*
CREATE TABLE nome (
Atributo1		TIPO		NULIDADE,
Atributo2		TIPO		NULIDADE,
...
AtributoN		TIPO		NULIDADE
PRIMARY KEY(Atributo1, Atributo2)
FOREIGN KEY(Atributo4) REFERENCES tabela2(PK),
FOREIGN KEY(Atributo5) REFERENCES tabela4(PK)
)
 
*Começar sempre pelas tabelas que não tem FK
*/
CREATE TABLE cliente (
	id_cliente			INT				NOT NULL,
	nome_cliente		VARCHAR(100)	NOT NULL,
	uf					CHAR(2)			NULL
	PRIMARY KEY(id_cliente)
)
GO
CREATE TABLE pedido (
	num_pedido			INT				NOT NULL,
	data_emissao		DATE			NOT NULL,
	data_entrega		DATE			NULL,
	clienteid_cliente	INT				NOT NULL
	PRIMARY KEY(num_pedido)
	FOREIGN KEY(clienteid_cliente) REFERENCES cliente (id_cliente)
)
GO
CREATE TABLE produto (
	id_produto			INT				NOT NULL,
	nome_produto		VARCHAR(50)		NOT NULL,
	valor_unitario		DECIMAL(4,2)	NOT NULL,
	un_medida			VARCHAR(5)		NULL
PRIMARY KEY(id_produto)
)
GO
CREATE TABLE pedido_produto (
	pedidonum_pedido	INT				NOT NULL,
	produtoid_produto	INT				NOT NULL,
	quantidade			INT				NOT NULL,
	valor_venda			DECIMAL(4,2)	NOT NULL
	PRIMARY KEY(pedidonum_pedido, produtoid_produto)
	FOREIGN KEY(pedidonum_pedido) REFERENCES pedido(num_pedido),
	FOREIGN KEY(produtoid_produto) REFERENCES produto(id_produto)
)


--Verificar dados de uma tabela
--EXEC sp_help nome
EXEC sp_help cliente
EXEC sp_help pedido
EXEC sp_help produto
EXEC sp_help pedido_produto


--Excluir uma tabela
--DROP TABLE nome
DROP TABLE produto


--Modificar uma tabela
--ALTER TABLE nome
--operação
ALTER TABLE produto
ALTER COLUMN un_medida VARCHAR(8) NULL

ALTER TABLE cliente
ADD cidade VARCHAR(80) NOT NULL --NOT NULL só funcionou pq a tabela não tem dados

ALTER TABLE cliente
DROP COLUMN cidade


/* Adicionar PK e FK depois de criar uma tabela sem PK ou FK
ALTER TABLE nome
ADD PRIMARY KEY(coluna)

ALTER TABLE nome
ADD FOREIGN KEY (coluna) REFERENCES tabela(PK)
*/
ALTER TABLE cliente
ADD cidade VARCHAR(80) NULL


--Renomear coluna ou tabela
--Para coluna:
--EXEC sp_rename 'dbo.tabela.coluna', 'novo_nome_coluna', 'COLUMN'
--Para tabela:
--EXEC sp_rename 'dbo.tabela', 'novo_nome_tabela'
EXEC sp_rename 'dbo.cliente.cidade', 'cid', 'COLUMN'

ALTER TABLE cliente
DROP COLUMN cid


--Comandos DML para Dados - INSERT, UPDATE e DELETE
--INSERT INTO nome(atr1, atr2, ..., atrtN) VALUES (v1, v2, ..., vN)
INSERT INTO cliente(id_cliente, nome_cliente, uf) VALUES
(1001, 'Fulano de Tal', 'SP')

INSERT INTO cliente(id_cliente, nome_cliente) VALUES
(1002, 'Beltrano de Tal')

INSERT INTO cliente VALUES
(1003, 'Cicrano de Tal', NULL)

INSERT INTO cliente (uf, id_cliente, nome_cliente) VALUES
(NULL, 1004, 'Fulano2 de Tal')

INSERT INTO pedido VALUES
(100001, '2024-04-10', '2024-04-12', 1002),
(100002, '2024-04-11', '2024-04-12', 1004),
(100003, '2024-04-10', '2024-04-13', 1001)

SELECT * FROM cliente
SELECT * FROM pedido


--Modificação de dados
/*
UPDATE tabela
SET coluna = novo_valor
filtro (Para UPDATE recomenda-se a PK)
*/
UPDATE pedido 
SET data_entrega = '2024-04-14'
--WHERE num_pedido = 100003
WHERE clienteid_cliente = 1001

UPDATE cliente
SET nome_cliente = 'Fulano Dois de Tal', uf = 'PR'
WHERE id_cliente = 1004


--Excluir registros
/*
DELETE tabela
filtro
*/
DELETE cliente
WHERE id_cliente = 1001
