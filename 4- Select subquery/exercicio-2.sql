--Seleciona o banco de dados
USE locadoraDB


--Fazer uma consulta que retorne ID, Ano, nome do Filme (Caso o nome do filme tenha
--mais de 10 caracteres, para caber no campo da tela, mostrar os 10 primeiros
--caracteres, seguidos de reticências ...) dos filmes cujos DVDs foram fabricados
--depois de 01/01/2020
SELECT
	id,
	ano,
	CASE WHEN (LEN(titulo) > 10)
		THEN SUBSTRING(titulo, 1, 10) + '...'
		ELSE titulo
	END AS titulo
FROM filme
WHERE id IN
(
    SELECT fk_filme
    FROM dvd
	WHERE data_fabricacao > '2020-01-01'
)
 
--Fazer uma consulta que retorne num, data_fabricacao, qtd_meses_desde_fabricacao
--(Quantos meses desde que o dvd foi fabricado até hoje) do filme Interestelar
SELECT
	numero,
	data_fabricacao,
	DATEDIFF(MONTH, data_fabricacao, GETDATE()) AS qtd_meses_desde_fabricacao
FROM dvd
WHERE fk_filme IN
(
    SELECT id
    FROM filme
    WHERE titulo = 'Interestelar'
)


--Fazer uma consulta que retorne num_dvd, data_locacao, data_devolucao,
--dias_alugado(Total de dias que o dvd ficou alugado) e valor das locações
--da cliente que tem, no nome, o termo Rosa
SELECT
	fk_dvd,
	data_locacao,
	data_devolucao,
	DATEDIFF(DAY, data_locacao, data_devolucao) AS dias_alugados,
	valor
FROM locacao
WHERE fk_cliente IN
(
    SELECT num_cadastro
    FROM cliente
    WHERE nome LIKE '%Rosa%'
)


--Nome, endereço_completo (logradouro e número concatenados),
--cep (formato XXXXX-XXX) dos clientes que alugaram DVD de num 10002.
SELECT
	nome,
	CONCAT(end_logradouro, ', ', end_numero) AS endereco_completo,
	SUBSTRING(end_cep, 1, 5) + '-' + SUBSTRING(end_cep, 6, 3) AS cep
FROM cliente
WHERE num_cadastro IN
(
    SELECT fk_cliente
    FROM locacao
    WHERE fk_dvd = 10002
)
