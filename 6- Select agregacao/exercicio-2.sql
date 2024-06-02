USE locadoraDB


--1) Consultar, num_cadastro do cliente, nome do cliente, titulo do filme,
-- data_fabricação do dvd, valor da locação, dos dvds que tem a maior
--data de fabricação dentre todos os cadastrados.
SELECT 
    c.num_cadastro, 
    c.nome AS nome_cliente, 
    f.titulo AS titulo_filme, 
    d.data_fabricacao, 
    l.valor
FROM 
    Cliente c
INNER JOIN 
    Locacao l ON c.num_cadastro = l.fk_cliente
INNER JOIN 
    DVD d ON l.fk_dvd = d.numero
INNER JOIN 
    Filme f ON d.fk_filme = f.id
WHERE d.data_fabricacao =
	(
		SELECT
			MAX(data_fabricacao)
		FROM DVD
	)


--2) Consultar Consultar, num_cadastro do cliente, nome do cliente,
--data de locação (Formato DD/MM/AAAA) e a quantidade de DVD´s alugados
--por cliente (Chamar essa coluna de qtd), por data de locação
SELECT 
    c.num_cadastro, 
    c.nome AS nome_cliente, 
    CONVERT(VARCHAR, l.data_locacao, 103) AS data_locacao, 
    COUNT(l.fk_dvd) AS qtd
FROM 
Cliente c INNER JOIN Locacao l
	ON c.num_cadastro = l.fk_cliente
GROUP BY 
    c.num_cadastro, 
    c.nome, 
    l.data_locacao
ORDER BY l.data_locacao


--3) Consultar Consultar, num_cadastro do cliente, nome do cliente,
--data de locação (Formato DD/MM/AAAA) e a valor total de todos os
--dvds alugados (Chamar essa coluna de valor_total), por data de locação
SELECT 
    c.num_cadastro, 
    c.nome AS nome_cliente, 
    CONVERT(VARCHAR, l.data_locacao, 103) AS data_locacao, 
    SUM(l.valor) AS valor_total
FROM 
Cliente c INNER JOIN Locacao l
	ON c.num_cadastro = l.fk_cliente
GROUP BY 
    c.num_cadastro, 
    c.nome, 
    l.data_locacao
ORDER BY l.data_locacao;



--4) Consultar Consultar, num_cadastro do cliente, nome do cliente,
--Endereço concatenado de logradouro e numero como Endereco, data de locação
--(Formato DD/MM/AAAA) dos clientes que alugaram mais de 2 filmes simultaneamente
SELECT 
    c.num_cadastro, 
    c.nome AS nome_cliente, 
    c.end_logradouro + ', ' + CAST(c.num_cadastro AS VARCHAR) AS Endereco, 
    CONVERT(VARCHAR, l.data_locacao, 103) AS data_locacao
FROM 
Cliente c INNER JOIN Locacao l
	ON c.num_cadastro = l.fk_cliente
GROUP BY 
    c.num_cadastro, 
    c.nome, 
    c.end_logradouro, 
    c.num_cadastro, 
    l.data_locacao
HAVING COUNT(l.fk_dvd) > 2
ORDER BY l.data_locacao;
