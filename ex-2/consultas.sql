-- Consultas no Banco

-- Quantidade de horas que cada professor tem comprometido em aulas

SELECT 
	P.codprof as Codigo_Professor,
    P.nomeprof AS Professor,
    SUM(H.numhoras) AS Total_Horas_Comprometidas
FROM PROFESSOR P
JOIN PROFTURMA PT ON P.codprof = PT.codprof
JOIN HORARIO H ON PT.coddepto = H.coddepto 
               AND PT.numdisc = H.numdisc 
               AND PT.anosem = H.anosem 
               AND PT.siglatur = H.siglatur
GROUP BY P.nomeprof, P.codprof
ORDER BY Codigo_Professor ASC;

-- Lista de salas com horários livres e ocupados
-- OBS: exercício inteiro em main.js

SELECT 
    PR.descricaopredio AS Predio,
    S.numsala AS Sala,
    COALESCE(H.diasem, 0) AS Dia_Semana,
    COALESCE(H.horainicio, 0) AS Hora_Inicio,
    COALESCE(H.numhoras, 0) AS Duracao,
    COALESCE(H.siglatur, 'SEM TURMA') AS Status_Turma
FROM SALA S
JOIN PREDIO PR ON S.codpredio = PR.codpredio
LEFT JOIN HORARIO H ON S.codpredio = H.codpredio 
                    AND S.numsala = H.numsala
                    AND H.anosem = '2026.1'
ORDER BY PR.descricaopredio, S.numsala;