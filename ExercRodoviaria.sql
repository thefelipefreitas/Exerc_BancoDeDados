CREATE DATABASE rodoviaria
GO
USE rodoviaria

CREATE TABLE motorista (
codigo				INT				NOT NULL,
nome				VARCHAR(75)		NOT NULL,
idade				INT				NOT NULL,
naturalidade		VARCHAR(60)		NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE onibus (
placa			VARCHAR(10)			NOT NULL,
marca			VARCHAR(30)		NOT NULL,
ano				INT				NOT NULL,
descricao		VARCHAR(80)		NOT NULL
PRIMARY KEY (placa)
)
GO
CREATE TABLE viagem (
codigo			INT				NOT NULL,
onibus			VARCHAR(10)		NOT NULL,
motorista		INT				NOT NULL,
hr_saida		CHAR(7)			NOT NULL,
hr_chegada		CHAR(7)			NOT NULL,
destino			VARCHAR(50)		NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (onibus) REFERENCES onibus(placa),
FOREIGN KEY (motorista) REFERENCES motorista(codigo)
)

-- Consultar, da tabela viagem, todas as horas de chegada e saída, convertidas em formato HH:mm (108) e seus destinos									
SELECT CONVERT(VARCHAR(6), v.hr_chegada, 108) AS hora_chegada,
		CONVERT(VARCHAR(6), v.hr_saida, 108) AS hora_saida
FROM viagem v

-- Consultar, com subquery, o nome do motorista que viaja para Sorocaba					
SELECT mot.nome
FROM motorista mot
INNER JOIN viagem
ON mot.codigo = viagem.motorista
WHERE viagem.destino IN
(
SELECT viagem.destino
FROM viagem
WHERE destino = 'Sorocaba'
)

-- Consultar, com subquery, a descrição do ônibus que vai para o Rio de Janeiro						
SELECT bus.descricao
FROM onibus bus
INNER JOIN viagem
ON bus.placa = viagem.onibus
WHERE viagem.destino IN
(
SELECT viagem.destino
FROM viagem
WHERE destino = 'Rio de Janeiro'
)

--Consultar, com Subquery, a descrição, a marca e o ano do ônibus dirigido por Luiz Carlos							
SELECT bus.descricao, bus.marca, bus.ano
FROM onibus bus
INNER JOIN viagem
ON bus.placa = viagem.onibus
INNER JOIN motorista motor
ON viagem.motorista = motor.codigo
WHERE motor.nome IN
(
SELECT motor.nome
FROM motorista motor
WHERE motor.nome LIKE 'Luiz C%'
)

--Consultar o nome, a idade e a naturalidade dos motoristas com mais de 30 anos						
SELECT motor.nome, motor.idade, motor.naturalidade
FROM motorista motor
WHERE motor.idade > 30