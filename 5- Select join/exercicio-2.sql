USE locadoraDB


--1) Consultar num_cadastro do cliente, nome do cliente, data_locacao (Formato
--dd/mm/aaaa), Qtd_dias_alugado (total de dias que o filme ficou alugado), titulo do
--filme, ano do filme da locação do cliente cujo nome inicia com Matilde
SELECT 
    c.num_cadastro AS num_cadastro, 
    c.nome AS nome_cliente, 
    CONVERT(CHAR(10), l.data_locacao, 103) AS data_locacao, 
    DATEDIFF(day, l.data_locacao, l.data_devolucao) AS Qtd_dias_alugado, 
    f.titulo AS titulo_filme, 
    f.ano AS ano_filme
FROM 
    Cliente c
INNER JOIN 
    Locacao l ON c.num_cadastro = l.fk_cliente
INNER JOIN 
    DVD d ON l.fk_dvd = d.numero
INNER JOIN 
    Filme f ON d.fk_filme = f.id
WHERE 
    c.nome LIKE 'Matilde%';


--2) Consultar nome da estrela, nome_real da estrela, título do filme
--dos filmes cadastrados do ano de 2015
SELECT 
    e.nome AS nome_estrela, 
    e.nome_real AS nome_real_estrela, 
    f.titulo AS titulo_filme
FROM 
    Estrela e
JOIN 
    Filme_Estrela fe ON e.id = fe.fk_estrela
JOIN 
    Filme f ON fe.fk_filme = f.id
WHERE 
    f.ano = 2015;


--3) Consultar título do filme, data_fabricação do dvd (formato dd/mm/aaaa), caso a
--diferença do ano do filme com o ano atual seja maior que 6, deve aparecer a diferença
--do ano com o ano atual concatenado com a palavra anos (Exemplo: 7 anos), caso
--contrário só a diferença (Exemplo: 4).
SELECT 
    f.titulo AS titulo_filme, 
    FORMAT(d.data_fabricacao, 'dd/MM/yyyy') AS data_fabricacao, --Outra forma de ter dd/mm/aaaa
    CASE 
        WHEN YEAR(GETDATE()) - f.ano > 6 
        THEN CAST(YEAR(GETDATE()) - f.ano AS VARCHAR) + ' anos' 
        ELSE CAST(YEAR(GETDATE()) - f.ano AS VARCHAR)
    END AS diferenca_anos
FROM 
    Filme f
JOIN 
    DVD d ON f.id = d.fk_filme
WHERE 
    YEAR(GETDATE()) - f.ano > 0;
