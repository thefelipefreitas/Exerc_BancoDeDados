CREATE DATABASE hospital
GO
USE hospital

CREATE TABLE pacientes (
cpf			BIGINT			NOT NULL,
nome		VARCHAR(50)		NOT NULL,
rua			VARCHAR(100)	NULL,
num			INT				NULL,
bairro		VARCHAR(50)		NULL,
telefone	CHAR(9)			NULL
PRIMARY KEY (cpf)
)
GO
CREATE TABLE medicos (
cod					INT				NOT NULL,
nome				VARCHAR(50)		NOT NULL,
especialidade		VARCHAR(30)		NOT NULL
PRIMARY KEY (cod)
)
GO
CREATE TABLE prontuarios (
data_consul		DATETIME		NOT NULL,
cpf_paciente	BIGINT			NOT NULL,
cod_medico		INT				NOT NULL,
diagnostico		VARCHAR(100)	NOT NULL,
medicamento		VARCHAR(60)		NOT NULL
PRIMARY KEY (data_consul, cpf_paciente, cod_medico)
FOREIGN KEY (cpf_paciente) REFERENCES pacientes(cpf),
FOREIGN KEY (cod_medico) REFERENCES medicos(cod)
)

SELECT * FROM pacientes
SELECT * FROM medicos
SELECT * FROM prontuarios

--Consultar:
--Qual a especialidade de Carolina Oliveira		
SELECT med.especialidade
FROM medicos med
WHERE med.nome LIKE 'Carol%'

--Qual medicamento receitado para reumatismo			
SELECT pron.medicamento
FROM prontuarios pron
WHERE pron.diagnostico LIKE 'Reum%'

--Consultar em Subqueries:
--Diagnóstico e Medicamento do paciente José Rubens em suas consultas				
SELECT pron.diagnostico, pron.medicamento
FROM prontuarios pron, pacientes pac
WHERE pron.cpf_paciente = pac.cpf
		AND pac.nome LIKE 'José R%'

--Nome e especialidade do(s) Médico(s) que atenderam José Rubens. Caso a especialidade tenha mais de 3 letras, mostrar apenas as 3 primeiras letras concatenada com um ponto final (.)													
SELECT med.nome AS nome_medico,
			CASE
				WHEN LEN(med.especialidade) > 3
				THEN SUBSTRING(med.especialidade, 1, 3) + '.'
			END AS especialidade
FROM medicos med, prontuarios pron, pacientes pac
WHERE med.cod = pron.cod_medico
		AND pron.cpf_paciente = pac.cpf
		AND pac.nome LIKE 'José%'

--CPF (Com a máscara XXX.XXX.XXX-XX), Nome, Endereço completo (Rua, nº - Bairro), Telefone (Caso nulo, mostrar um traço (-)) dos pacientes do médico Vinicius												
SELECT  SUBSTRING(CAST(pac.cpf AS VARCHAR(11)), 1, 3) + '.' + 
		SUBSTRING(CAST(pac.cpf AS VARCHAR(11)), 4, 3) + '.' +
		SUBSTRING(CAST(pac.cpf AS VARCHAR(11)), 7, 3) + '-' +
		SUBSTRING(CAST(pac.cpf AS VARCHAR(11)), 10, 2) AS cpf_paciente,
		pac.nome AS nome_paciente, pac.rua + ', ' + CAST(pac.num AS VARCHAR(6)) + ' - ' + pac.bairro AS endereco_paciente,
		CASE
			WHEN (pac.telefone IS NULL)
			THEN '-'
			ELSE pac.telefone
		END AS telefone_paciente
FROM pacientes pac, prontuarios pron, medicos med
WHERE pac.cpf = pron.cpf_paciente
		AND pron.cod_medico = med.cod
		AND med.nome LIKE 'Vini%'

--Quantos dias fazem da consulta de Maria Rita até hoje			
SELECT DATEDIFF(DAY, pron.data_consul, GETDATE()) AS qtd_dias
FROM prontuarios pron
INNER JOIN pacientes pac
ON pron.cpf_paciente = pac.cpf
WHERE pac.nome LIKE 'Maria%'

--Alterar o telefone da paciente Maria Rita, para 98345621			
UPDATE pacientes
SET telefone = 98345621
WHERE nome LIKE 'Maria%'

--Alterar o Endereço de Joana de Souza para Voluntários da Pátria, 1980, Jd. Aeroporto					
UPDATE pacientes
SET rua = 'Voluntários da Pátria', num = 1980, bairro = 'Jd. Aeroporto'
WHERE nome LIKE 'Joan%'

