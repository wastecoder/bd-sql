--Criar o banco de dados
CREATE DATABASE clinicaDB


--Usar o banco de dados criado
USE clinicaDB


--Criar as tabelas
CREATE TABLE paciente (
    num_beneficiario		INT				NOT NULL,
    nome					VARCHAR(100)	NOT NULL,
    logradouro				VARCHAR(200)	NOT NULL,
    numero					INT				NOT NULL,
    cep						CHAR(8)			NOT NULL,
    complemento				VARCHAR(255)	NOT NULL,
    telefone				VARCHAR(11)		NOT NULL
    PRIMARY KEY(num_beneficiario)
)
GO
CREATE TABLE especialidade (
    id						INT				NOT NULL,
    especialidade			VARCHAR(100)	NOT NULL
    PRIMARY KEY(ID)
)
GO
CREATE TABLE medico (
    codigo					INT				NOT NULL,
    nome					VARCHAR(100)	NOT NULL,
    logradouro				VARCHAR(200)	NOT NULL,
    numero					INT				NOT NULL,
    cep						CHAR(8)			NOT NULL,
    complemento				VARCHAR(255)	NOT NULL,
    contato					VARCHAR(11)		NOT NULL,
    especialidadeID			INT				NOT NULL
    PRIMARY KEY(codigo)
    FOREIGN KEY(especialidadeID) REFERENCES especialidade (ID)
)
GO
CREATE TABLE consulta (
    pacientenum_beneficiario	INT				NOT NULL,
    medicocodigo				INT				NOT NULL,
    data_hora					TIMESTAMP		NOT NULL,
    observacao					VARCHAR(255)	NOT NULL
    PRIMARY KEY (pacientenum_beneficiario, medicocodigo, data_hora)
    FOREIGN KEY(medicocodigo) REFERENCES medico(codigo),
    FOREIGN KEY(pacientenum_beneficiario) REFERENCES paciente(num_beneficiario)
)


--Inserir os dados: paciente
INSERT INTO paciente VALUES (99901, 'Washington Silva', 'R. Anhaia', 150, '02345000', 'Casa', '922229999')
INSERT INTO paciente VALUES (99902, 'Luis Ricardo', 'R. Voluntários da Patria', 2251, '03254010', 'Bloco B. Apto 25', '923450987')
INSERT INTO paciente VALUES (99903, 'Maria Elisa', 'Av. Aguia de Haia', 1188, '06987020', 'Apto 1208', '012348765')
INSERT INTO paciente VALUES (99904, 'José Araujo', 'R. XV de Novemebro', 18, '03678000', 'Casa', '945674312')
INSERT INTO paciente VALUES (99905, 'Joana Paula', 'R. 7 de Abril', 97, '01214000', 'Conjunto 3 - Apto 801', '912095674')

SELECT * FROM paciente


--Inserir os dados: especialidade
INSERT INTO especialidade VALUES (1, 'Otorrinolaringologista')
INSERT INTO especialidade VALUES (2, 'Urologista')
INSERT INTO especialidade VALUES (3, 'Geriatria')
INSERT INTO especialidade VALUES (4, 'Pediatria')

SELECT * FROM especialidade


--Inserir os dados: medico
INSERT INTO medico VALUES (100001, 'Ana Paula', 'R. 7 de Setembro', 2566, '03698000', 'Casa', '915689456', 1)
INSERT INTO medico VALUES (100002, 'Maria Aparecida', 'Av. Brasil', 32, '02145070', 'Casa', '923235454', 1)
INSERT INTO medico VALUES (100003, 'Lucas Borges', 'Av. do Estado', 3210, '05241000', 'Apto 205', '963698585', 2)
INSERT INTO medico VALUES (100004, 'Gabriel Oliveira', 'Av. Dom Helder Camara', 350, '03145000', 'Apto 602', '932458745', 3)

SELECT * FROM medico


--Inserir os dados: consulta
INSERT INTO consulta (pacientenum_beneficiario, medicocodigo, data_hora, observacao)
VALUES (99901, 100002, DEFAULT, 'Infecção urinária')
INSERT INTO consulta (pacientenum_beneficiario, medicocodigo, observacao)
VALUES (99902, 100003, 'Gripe')
INSERT INTO consulta (pacientenum_beneficiario, medicocodigo, observacao)
VALUES (99901, 100001, 'Infecção garganta')

SELECT * FROM consulta


--Adicionar coluna dia_atendimento para médico
ALTER TABLE medico
ADD dia_atendimento INT

SELECT * FROM medico


--Inserindo dados: atualizando a coluna dia_atendimento
UPDATE medico
SET dia_atendimento = 2
WHERE codigo = 100001

UPDATE medico
SET dia_atendimento = 4
WHERE codigo = 100002

UPDATE medico
SET dia_atendimento = 2
WHERE codigo = 100003

UPDATE medico
SET dia_atendimento = 5
WHERE codigo = 100004

SELECT * FROM medico


--Remover registro/tupla: pediatria (id 4)
DELETE FROM especialidade
WHERE ID = 4

SELECT * FROM especialidade


--Atualizar coluna: dia_atendimento para dia_semana_atendimento
EXEC sp_rename 'medico.dia_atendimento', 'dia_semana_atendimento', 'COLUMN'

SELECT * FROM medico


--Atualizar registro: médico Lucas Borges
UPDATE medico
SET	logradouro =	'Av. Bras Leme',
	numero =		'876',
	complemento =	'apto 504',
	cep =			'02122000'
WHERE nome =		'Lucas Borges'

SELECT * FROM medico WHERE nome = 'Lucas Borges'


--Atualizar coluna: alterar o tamanho de observacao para 200
ALTER TABLE consulta
ALTER COLUMN observacao VARCHAR(200);

EXEC sp_help consulta
