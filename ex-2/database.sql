-- Criando as tabelas

CREATE TABLE DEPTO (
    coddepto INT PRIMARY KEY,
    nomedepto VARCHAR(100) NOT NULL
);

CREATE TABLE TITULACAO (
    codtit INT PRIMARY KEY,
    nometit VARCHAR(100) NOT NULL
);

CREATE TABLE PREDIO (
    codpredio INT PRIMARY KEY,
    descricaopredio VARCHAR(255)
);

CREATE TABLE PROFESSOR (
    codprof INT PRIMARY KEY,
    coddepto INT,
    codtit INT,
    nomeprof VARCHAR(100) NOT NULL,
    FOREIGN KEY (coddepto) REFERENCES DEPTO(coddepto),
    FOREIGN KEY (codtit) REFERENCES TITULACAO(codtit)
);

CREATE TABLE DISCIPLINA (
    coddepto INT,
    numdisc INT,
    nomedisc VARCHAR(100) NOT NULL,
    creditosdisc INT,
    PRIMARY KEY (coddepto, numdisc),
    FOREIGN KEY (coddepto) REFERENCES DEPTO(coddepto)
);

CREATE TABLE SALA (
    codpredio INT,
    numsala INT,
    descricaosala VARCHAR(255),
    capacidade INT,
    PRIMARY KEY (codpredio, numsala),
    FOREIGN KEY (codpredio) REFERENCES PREDIO(codpredio)
);

CREATE TABLE PREREQ (
    coddepto INT,
    numdisc INT,
    coddeptoprereq INT,
    numdiscprereq INT,
    PRIMARY KEY (coddepto, numdisc, coddeptoprereq, numdiscprereq),
    FOREIGN KEY (coddepto, numdisc) REFERENCES DISCIPLINA(coddepto, numdisc),
    FOREIGN KEY (coddeptoprereq, numdiscprereq) REFERENCES DISCIPLINA(coddepto, numdisc)
);

CREATE TABLE TURMA (
    coddepto INT,
    numdisc INT,
    anosem VARCHAR(10), -- ano e semestre '2023.1'
    siglatur VARCHAR(10),
    capacidade INT,
    PRIMARY KEY (coddepto, numdisc, anosem, siglatur),
    FOREIGN KEY (coddepto, numdisc) REFERENCES DISCIPLINA(coddepto, numdisc)
);

CREATE TABLE PROFTURMA (
    coddepto INT,
    numdisc INT,
    anosem VARCHAR(10),
    siglatur VARCHAR(10),
    codprof INT,
    PRIMARY KEY (coddepto, numdisc, anosem, siglatur, codprof),
    FOREIGN KEY (coddepto, numdisc, anosem, siglatur) REFERENCES TURMA(coddepto, numdisc, anosem, siglatur),
    FOREIGN KEY (codprof) REFERENCES PROFESSOR(codprof)
);

CREATE TABLE HORARIO (
    coddepto INT,
    numdisc INT,
    anosem VARCHAR(10),
    siglatur VARCHAR(10),
    diasem INT, -- 1 a 7 para dias da semana
    horainicio TIME,
    codpredio INT,
    numsala INT,
    numhoras INT,
    PRIMARY KEY (coddepto, numdisc, anosem, siglatur, diasem, horainicio),
    FOREIGN KEY (coddepto, numdisc, anosem, siglatur) REFERENCES TURMA(coddepto, numdisc, anosem, siglatur),
    FOREIGN KEY (codpredio, numsala) REFERENCES SALA(codpredio, numsala)
);

-- Inserção de dados teste

INSERT INTO DEPTO (coddepto, nomedepto) VALUES 
(1, 'Departamento de Computação'),
(2, 'Departamento de Matemática');

INSERT INTO TITULACAO (codtit, nometit) VALUES 
(1, 'Mestre'),
(2, 'Doutor'),
(3, 'Especialista');

INSERT INTO PREDIO (codpredio, descricaopredio) VALUES 
(1, 'Prédio Principal de Exatas'),
(2, 'Anexo de Laboratórios');

INSERT INTO PROFESSOR (codprof, coddepto, codtit, nomeprof) VALUES 
(101, 1, 2, 'Alan Turing'),
(102, 2, 2, 'Ada Lovelace'),
(103, 1, 1, 'Grace Hopper');

INSERT INTO DISCIPLINA (coddepto, numdisc, nomedisc, creditosdisc) VALUES 
(1, 10, 'Algoritmos e Lógica', 4),
(1, 11, 'Estrutura de Dados', 4),
(2, 20, 'Cálculo I', 6);

INSERT INTO SALA (codpredio, numsala, descricaosala, capacidade) VALUES 
(1, 101, 'Sala Teórica 101', 40),
(1, 102, 'Sala Teórica 102', 40),
(1, 103, 'Sala de Reuniões', 15),
(2, 201, 'Laboratório de Informática A', 30),
(2, 202, 'Laboratório de Hardware', 25);

INSERT INTO PREREQ (coddepto, numdisc, coddeptoprereq, numdiscprereq) VALUES 
(1, 11, 1, 10); 

INSERT INTO TURMA (coddepto, numdisc, anosem, siglatur, capacidade) VALUES 
(1, 10, '2026.1', 'T1', 30),
(1, 11, '2026.1', 'T2', 30),
(2, 20, '2026.1', 'M1', 40);

INSERT INTO PROFTURMA (coddepto, numdisc, anosem, siglatur, codprof) VALUES 
(1, 10, '2026.1', 'T1', 101),
(1, 11, '2026.1', 'T2', 101),
(2, 20, '2026.1', 'M1', 102),
(1, 10, '2026.1', 'T1', 103);

INSERT INTO HORARIO (coddepto, numdisc, anosem, siglatur, diasem, horainicio, codpredio, numsala, numhoras) VALUES 
(1, 10, '2026.1', 'T1', 2, '08:00:00', 2, 201, 2),
(1, 10, '2026.1', 'T1', 4, '08:00:00', 2, 201, 2),
(1, 11, '2026.1', 'T2', 3, '10:00:00', 2, 201, 2),
(1, 11, '2026.1', 'T2', 5, '10:00:00', 2, 201, 2),
(2, 20, '2026.1', 'M1', 2, '14:00:00', 1, 101, 2),
(2, 20, '2026.1', 'M1', 4, '14:00:00', 1, 101, 2),
(2, 20, '2026.1', 'M1', 6, '14:00:00', 1, 101, 2);