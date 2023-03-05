---Trigger disparada após update, grava dados alterados em uma tabela de auditoria, constando em cada linha os registros anteriores e o dado alterado
--Usaremos uma tabela cliente para exemplificar:




---tabela de cliente

CREATE TABLE cliente_audit (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(50) NULL,
    idade INT NULL,
   );


--Tabela de auditoria

   CREATE TABLE cliente_audit (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,
    nome_anterior VARCHAR(50) NULL,
    idade_anterior INT NULL,
    nome_novo VARCHAR(50) NULL,
    idade_nova INT NULL,
    usuario VARCHAR(50) NULL,
    data_hora DATETIME NOT NULL DEFAULT GETDATE()
);


--Trigger grava registro de auditoria após update exceto se o update for executado pelo usuário 'usuariexcessao'
CREATE TRIGGER trg_cliente_audit
ON cliente
AFTER UPDATE
AS
BEGIN
    DECLARE @username VARCHAR(50)
    SET @username = SUSER_SNAME()

    IF @username <> 'usuarioexcessao'
    BEGIN
        INSERT INTO cliente_audit (id_cliente, nome_anterior, idade_anterior, nome_novo, idade_nova, data_hora, usuario)
        SELECT i.id_cliente, d.nome, d.idade, i.nome, i.idade, GETDATE(), @username
        FROM inserted i
        INNER JOIN deleted d ON i.id_cliente = d.id_cliente;
    END
END