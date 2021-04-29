DROP TABLE UnidadeFederativa;
DROP TABLE Municipio;

CREATE TABLE UnidadeFederativa
(
unidadefederativa_id int,
sigla varchar(2),
nome varchar(255),
codigo int
);

CREATE TABLE Municipio
(
municipio_id int,
codigo int,
nome varchar(255),
unidade_federativa varchar(2)
);
