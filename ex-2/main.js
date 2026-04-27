const mysql = require("mysql2/promise");

async function fazerBusca() {
    try {
        const conexao = await mysql.createConnection({
            host: "localhost",
            user: "root",
            password: "",
            database: "ex-2",
        });

        console.log('Conectado ao banco com sucesso!');

        const [data] = await conexao.execute(
            `SELECT 
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
            ORDER BY PR.descricaopredio, S.numsala;`
        );

        const lista = data.reduce((acc, e) => {
            !e.Dia_Semana && acc.livres.push(e);
            e.Dia_Semana && acc.ocupadas.push(e);
            return acc
        },{livres: [], ocupadas: []})
        
        console.log(lista);

        await conexao.end();
    } catch (erro) {
        console.error('Ocorreu um erro:', erro);
    }
}

// Executa a função buscando por algo específico
fazerBusca();
