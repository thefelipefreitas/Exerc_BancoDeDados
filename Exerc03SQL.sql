CREATE DATABASE ex03Constraints
GO
USE ex03Constraints

CREATE TABLE livro (
codigo_livro    INT            NOT NULL       IDENTITY(1,1),
nome            VARCHAR(70)    NULL,
lingua          VARCHAR(15)    NULL           DEFAULT('PT-BR'),
ano             INT            NULL           CHECK(ano < 1990)
PRIMARY KEY (codigo_livro)
)
GO
CREATE TABLE autor (
codigo_autor     INT            NOT NULL       IDENTITY(10001,1),
nome			 VARCHAR(60)    NULL           UNIQUE,
nascimento       DATE           NULL,
pais             VARCHAR(50)    NULL           CHECK(pais = 'Brasil' OR pais = 'Alemanha'),
biografia        VARCHAR(200)   NULL
PRIMARY KEY (codigo_autor)
)
GO
CREATE TABLE livro_autor (
livroCodigo_livro     INT    NOT NULL,
autorCodigo_autor     INT    NOT NULL
PRIMARY KEY (livroCodigo_livro, autorCodigo_autor)
FOREIGN KEY (livroCodigo_livro) REFERENCES livro (codigo_livro),
FOREIGN KEY (autorCodigo_autor) REFERENCES autor (codigo_autor)
)
GO
CREATE TABLE edicoes (
isbn                  INT            NOT NULL,
preco                 DECIMAL(7,2)   NULL             CHECK(preco < 0),
ano                   INT            NULL             CHECK(ano < 1993),
num_paginas           INT            NULL             CHECK(num_paginas < 0),
qtd_estoque           INT            NULL,
livroCodigo_livro     INT            NOT NULL
PRIMARY KEY (isbn)
FOREIGN KEY (livroCodigo_livro) REFERENCES livro (codigo_livro)
)
GO
CREATE TABLE editora (
codigo_editora     INT             NOT NULL          IDENTITY(5501,1),
nome               VARCHAR(60)     NULL              UNIQUE,
logradouro		   VARCHAR(70)     NULL,
numero			   INT             NULL              CHECK(numero < 0),
cep                INT             NULL,
telefone           INT             NULL
PRIMARY KEY (codigo_editora)
)
GO
CREATE TABLE edicoes_editora (
edicoesISBN               INT     NOT NULL,
editoraCodigo_editora     INT     NOT NULL
PRIMARY KEY (edicoesISBN, editoraCodigo_editora)
FOREIGN KEY (edicoesISBN) REFERENCES edicoes (isbn),
FOREIGN KEY (editoraCodigo_editora) REFERENCES editora (codigo_editora)
)