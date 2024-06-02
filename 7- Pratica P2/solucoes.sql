USE ex9

SELECT * FROM editora
SELECT * FROM estoque
SELECT * FROM compra
SELECT * FROM autor


--1) Consultar nome, valor unitário, nome da editora e
--nome do autor doslivros do estoque que foram vendidos. Não podem haver repetições.
SELECT DISTINCT
    es.nome AS nome_livro,
    es.valor AS valor_unitario,
    ed.nome AS nome_editora,
    au.nome AS nome_autor
FROM estoque es, compra co, autor au, editora ed
WHERE
    es.codigo = co.codEstoque AND
    es.codAutor = au.codigo AND
    es.codEditora = ed.codigo

 
--2) Consultar nome do livro, quantidade comprada e valor de compra da compra 15051
SELECT 
    es.nome AS nome_livro,
    co.qtdComprada AS quantidade_comprada,
    co.valor AS valor_compra
FROM
    compra co
INNER JOIN
    estoque es ON co.codEstoque = es.codigo
WHERE
    co.codigo = 15051;


--3) Consultar Nome do livro e site da editora dos livros da Makron books 
--(Caso o site tenha mais de 10 dígitos, remover o www.).  
SELECT
    es.nome AS nome_livro,
    CASE WHEN (LEN(ed.site) > 10)
        THEN SUBSTRING(ed.site, 5, LEN(ed.site))
        ELSE ed.site
    END AS site_editora
FROM
estoque es INNER JOIN editora ed
	ON es.codEditora = ed.codigo
WHERE
	ed.nome = 'Makron books'


--4) Consultar nome do livro e Breve Biografia do David Halliday    
SELECT
    es.nome AS nome_livro,
    au.biografia AS biografia_autor
FROM estoque es, autor au
WHERE
    es.codAutor = au.codigo
    AND au.nome = 'David Halliday'


--5) Consultar código de compra e quantidade comprada do livro Sistemas Operacionais Modernos
SELECT
    co.codigo AS cod_compra,
    co.qtdComprada AS qtd_comprada/*,
    es.nome AS nome_livro*/
FROM
compra co INNER JOIN estoque es
	ON co.codEstoque = es.codigo
WHERE
	es.nome = 'Sistemas Operacionais Modernos'


--6) Consultar quais livros não foram vendidos 
SELECT
    es.nome AS livros_nao_vendidos
FROM
estoque es LEFT JOIN compra co
	ON co.codEstoque = es.codigo
WHERE
	co.codEstoque IS NULL


--7) Consultar quais livros foram vendidos e não estão cadastrados.
--Caso o nome dos livros terminem com espaço, fazer o trim apropriado.
SELECT
    RTRIM(LTRIM(es.nome)) AS nome_livro,
    es.quantidade AS qtd_estoque,
    co.qtdComprada AS qtd_comprada
FROM
compra co LEFT JOIN estoque es
	ON co.codEstoque = es.codigo
WHERE
	co.codEstoque IS NULL


--8) Consultar Nome e site da editora que não tem Livros no estoque
--(Caso o site tenha mais de 10 dígitos, remover o www.)
SELECT
    ed.nome AS nome_editora,
    CASE WHEN LEN(ed.site) > 10
		--THEN SUBSTRING(site, 5, LEN(site))
		THEN REPLACE(ed.site, 'www.', '') --Use isso ou o acima
        ELSE ed.site
    END AS site_editora
FROM
editora ed LEFT JOIN estoque es
	ON ed.codigo = es.codEditora
WHERE
	es.codEditora IS NULL


--9) Consultar Nome e biografia do autor que não tem Livros no estoque
--(Caso a biografia inicie com Doutorado, substituir por Ph.D.) 
SELECT
    au.nome AS nome_autor,
    REPLACE(au.biografia, 'Doutorado', 'Ph.D.') AS biografia_autor
FROM
autor au LEFT JOIN estoque es
	ON au.codigo = es.codAutor
WHERE
	es.codAutor IS NULL


--10) Consultar o nome do Autor, e o maior valor de Livro no estoque.
--Ordenar por valor descendente 
SELECT
    au.nome AS nome_autor,
    MAX(es.valor) AS maior_valor_livro
FROM
autor au INNER JOIN estoque es
	ON au.codigo = es.codAutor
GROUP BY au.nome
ORDER BY maior_valor_livro DESC


--11) Consultar o código da compra, o total de livros comprados e
--a soma dos valores gastos. Ordenar por Código da Compra ascendente.
SELECT
    co.codigo AS codigo_compra,
    SUM(co.qtdComprada) AS total_livros_comprados,
    SUM(co.valor) AS soma_valores_gastos
FROM compra co
GROUP BY co.codigo
ORDER BY Codigo_Compra ASC


--12) Consultar o nome da editora e a média de preços dos livros em estoque.
--Ordenar pela Média de Valores ascendente.    
SELECT
    ed.nome AS nome_editora,
    AVG(es.valor) AS media_precos
FROM
estoque es INNER JOIN editora ed
	ON es.codEditora = ed.codigo
GROUP BY ed.nome
ORDER BY media_precos ASC


--13) Consultar o nome do Livro, a quantidade em estoque o nome da editora, o site da editora
--(Caso o site tenha mais de 10 dígitos, remover o www.), criar uma coluna status onde:    
--  Caso tenha menos de 5 livros em estoque, escrever Produto em Ponto de Pedido
--  Caso tenha entre 5 e 10 livros em estoque, escrever Produto Acabando
--  Caso tenha mais de 10 livros em estoque, escrever Estoque Suficiente
--  A Ordenação deve ser por Quantidade ascendente
SELECT
    es.nome AS nome_livro,
    es.quantidade AS quantidade_estoque,
    ed.nome AS nome_editora,
    CASE WHEN LEN(ed.site) > 10
		THEN REPLACE(ed.site, 'www.', '')
        ELSE ed.site
    END AS site_editora,
    CASE
        WHEN es.quantidade < 5
			THEN 'Produto em Ponto de Pedido'
        WHEN es.quantidade BETWEEN 5 AND 10
			THEN 'Produto Acabando'
        ELSE 'Estoque Suficiente'
    END AS status
FROM
estoque es INNER JOIN editora ed
	ON es.codEditora = ed.codigo
ORDER BY quantidade_estoque ASC


--14) Para montar um relatório, é necessário montar uma consulta com a seguinte saída:
--Código do Livro, Nome do Livro, Nome do Autor, Info Editora (Nome da Editora + Site) de todos os livros  
--  Só pode concatenar sites que não são nulos
SELECT
    es.codigo AS codigo_do_livro,
    es.nome AS nome_do_livro,
    au.nome AS nome_do_autor,
	CASE WHEN ed.site IS NOT NULL
		THEN CONCAT(ed.nome, ' - ', ed.site)
		ELSE ed.nome
	END AS info_editora
FROM
    estoque es
INNER JOIN
    autor au ON es.codAutor = au.codigo
INNER JOIN
    editora ed ON es.codEditora = ed.codigo


--15) Consultar Codigo da compra, quantos dias da compra até hoje e quantos meses da compra até hoje
SELECT
    codigo AS codigo_compra,
    DATEDIFF(DAY, dataCompra, GETDATE()) AS dias_desde_compra,
    DATEDIFF(MONTH, dataCompra, GETDATE()) AS meses_desde_compra
FROM
    compra


--16) Consultar o código da compra e a soma dos valores gastos das compras que somam mais de 200.00
SELECT
    codigo AS codigo_compra,
    SUM(valor) AS total_gasto
FROM compra
GROUP BY codigo
HAVING SUM(valor) > 200.00
