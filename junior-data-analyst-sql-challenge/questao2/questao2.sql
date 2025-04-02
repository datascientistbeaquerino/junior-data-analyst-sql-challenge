SELECT
    d.nome AS departamento,
    COUNT(DISTINCT e.matr) AS quantidade_empregados,
    ROUND(COALESCE(AVG(v.valor), 0), 2) AS media_salarial,
    ROUND(COALESCE(MAX(v.valor), 0), 2) AS maior_salarial,
    ROUND(COALESCE(MIN(v.valor), 0), 2) AS menor_salarial
FROM empregado e
JOIN emp_venc ev ON e.matr = ev.matr
JOIN vencimento v ON ev.cod_venc = v.cod_venc
JOIN departamento d ON e.gerencia_cod_dep = d.cod_dep
WHERE v.tipo = 'V'
GROUP BY d.nome
ORDER BY media_salarial DESC, d.nome ASC;
