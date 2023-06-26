USE GD1C2023
GO

-- CREACION DEL SCHEMA --

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'BI_MODEL')
EXEC('CREATE SCHEMA BI_MODEL');


-- LIMPIAR CACHE --
IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'limpiar_cache')
DROP PROCEDURE limpiar_cache
GO
CREATE PROCEDURE limpiar_cache
AS
BEGIN
DBCC FREEPROCCACHE WITH NO_INFOMSGS
DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS
END
GO

-- ELIMINACION PREVENTIVA

IF OBJECT_ID('BI_MODEL.HECHO_ENVIO', 'U') IS NOT NULL DROP TABLE BI_MODEL.HECHO_ENVIO
IF OBJECT_ID('BI_MODEL.HECHO_MENSAJERIA', 'U') IS NOT NULL DROP TABLE BI_MODEL.HECHO_MENSAJERIA
IF OBJECT_ID('BI_MODEL.HECHO_CUPON', 'U') IS NOT NULL DROP TABLE BI_MODEL.HECHO_CUPON
IF OBJECT_ID('BI_MODEL.HECHO_RECLAMO', 'U') IS NOT NULL DROP TABLE BI_MODEL.HECHO_RECLAMO
IF OBJECT_ID('BI_MODEL.HECHO_PEDIDO', 'U') IS NOT NULL DROP TABLE BI_MODEL.HECHO_PEDIDO

IF OBJECT_ID('BI_MODEL.CUPON_TIPO', 'U') IS NOT NULL DROP TABLE BI_MODEL.CUPON_TIPO
IF OBJECT_ID('BI_MODEL.ESTADO_RECLAMO', 'U') IS NOT NULL DROP TABLE BI_MODEL.ESTADO_RECLAMO
IF OBJECT_ID('BI_MODEL.TIPO_RECLAMO', 'U') IS NOT NULL DROP TABLE BI_MODEL.TIPO_RECLAMO
IF OBJECT_ID('BI_MODEL.MENSAJERIA_ESTADO', 'U') IS NOT NULL DROP TABLE BI_MODEL.MENSAJERIA_ESTADO
IF OBJECT_ID('BI_MODEL.PEDIDO_ESTADO', 'U') IS NOT NULL DROP TABLE BI_MODEL.PEDIDO_ESTADO
IF OBJECT_ID('BI_MODEL.TIPO_PAQUETE', 'U') IS NOT NULL DROP TABLE BI_MODEL.TIPO_PAQUETE
IF OBJECT_ID('BI_MODEL.TIPO_MOVILIDAD', 'U') IS NOT NULL DROP TABLE BI_MODEL.TIPO_MOVILIDAD
IF OBJECT_ID('BI_MODEL.TIPO_LOCAL', 'U') IS NOT NULL DROP TABLE BI_MODEL.TIPO_LOCAL
IF OBJECT_ID('BI_MODEL.CATEGORIA', 'U') IS NOT NULL DROP TABLE BI_MODEL.CATEGORIA
IF OBJECT_ID('BI_MODEL.LOCAL', 'U') IS NOT NULL DROP TABLE BI_MODEL.LOCAL
IF OBJECT_ID('BI_MODEL.TIPO_MEDIO_PAGO', 'U') IS NOT NULL DROP TABLE BI_MODEL.TIPO_MEDIO_PAGO
IF OBJECT_ID('BI_MODEL.RANGO_ETARIO', 'U') IS NOT NULL DROP TABLE BI_MODEL.RANGO_ETARIO
IF OBJECT_ID('BI_MODEL.LOCALIDAD', 'U') IS NOT NULL DROP TABLE BI_MODEL.LOCALIDAD
IF OBJECT_ID('BI_MODEL.PROVINCIA', 'U') IS NOT NULL DROP TABLE BI_MODEL.PROVINCIA
IF OBJECT_ID('BI_MODEL.RANGO_HORARIO', 'U') IS NOT NULL DROP TABLE BI_MODEL.RANGO_HORARIO
IF OBJECT_ID('BI_MODEL.DIA', 'U') IS NOT NULL DROP TABLE BI_MODEL.DIA
IF OBJECT_ID('BI_MODEL.TIPO_ENVIO', 'U') IS NOT NULL DROP TABLE BI_MODEL.TIPO_ENVIO
IF OBJECT_ID('BI_MODEL.TIEMPO', 'U') IS NOT NULL DROP TABLE BI_MODEL.TIEMPO


-- DROPS VIEWS
IF EXISTS(SELECT 1 FROM sys.views WHERE name='MAYOR_CANTIDAD_PEDIDOS_DIA_FRANJA_LOCALIDAD_CATEGORIA_MES' AND type='v')
	DROP VIEW BI_MODEL.MAYOR_CANTIDAD_PEDIDOS_DIA_FRANJA_LOCALIDAD_CATEGORIA_MES
GO

IF EXISTS(SELECT 1 FROM sys.views WHERE name='MONTO_TOTAL_NO_COBRADO_X_PEDIDO_CANCELADO_SEGUN_DIA_FRANJA_HORARIA' AND type='v')
	DROP VIEW BI_MODEL.MONTO_TOTAL_NO_COBRADO_X_PEDIDO_CANCELADO_SEGUN_DIA_FRANJA_HORARIA
GO

IF EXISTS(SELECT 1 FROM sys.views WHERE name='PROMEDIO_CALIFICACION_MENSUAL_LOCAL' AND type='v')
	DROP VIEW BI_MODEL.PROMEDIO_CALIFICACION_MENSUAL_LOCAL
GO

IF EXISTS(SELECT 1 FROM sys.views WHERE name='VALOR_PROMEDIO_MENSUAL_PEDIDOS_EN_CADA_LOCALIDAD' AND type='v')
	DROP VIEW BI_MODEL.VALOR_PROMEDIO_MENSUAL_PEDIDOS_EN_CADA_LOCALIDAD
GO

IF EXISTS(SELECT 1 FROM sys.views WHERE name='DESVIO_PROMEDIO_TIEMPO_ENTREGA_POR_MOVILIDAD_POR_DIA_POR_HORARIO' AND type='v')
	DROP VIEW BI_MODEL.DESVIO_PROMEDIO_TIEMPO_ENTREGA_POR_MOVILIDAD_POR_DIA_POR_HORARIO
GO

IF EXISTS(SELECT 1 FROM sys.views WHERE name='PORCENTAJE_DE_CADA_TIPO_ENTREGA_SEGUN_EDAD_REPARTIDOR_Y_LOCALIDAD' AND type='v')
	DROP VIEW BI_MODEL.PORCENTAJE_DE_CADA_TIPO_ENTREGA_SEGUN_EDAD_REPARTIDOR_Y_LOCALIDAD
GO

IF EXISTS(SELECT 1 FROM sys.views WHERE name='MONTO_TOTAL_CUPONE_POR_RANGO_ETARIO_POR_MES' AND type='v')
	DROP VIEW BI_MODEL.MONTO_TOTAL_CUPONE_POR_RANGO_ETARIO_POR_MES
GO

IF EXISTS(SELECT 1 FROM sys.views WHERE name='MONTO_MENSUAL_CUPONES_DE_RECLAMOS' AND type='v')
	DROP VIEW BI_MODEL.MONTO_MENSUAL_CUPONES_DE_RECLAMOS
GO

IF EXISTS(SELECT 1 FROM sys.views WHERE name='PROMEDIO_VALOR_ASEGURADO_X_TIPO_PAQUETE_X_MES' AND type='v')
	DROP VIEW BI_MODEL.PROMEDIO_VALOR_ASEGURADO_X_TIPO_PAQUETE_X_MES
GO

IF EXISTS(SELECT 1 FROM sys.views WHERE name='RECLAMOS_MENSUALES_LOCALES_DIA_RANGO' AND type='v')
	DROP VIEW BI_MODEL.RECLAMOS_MENSUALES_LOCALES_DIA_RANGO
GO

IF EXISTS(SELECT 1 FROM sys.views WHERE name='TIEMPO_PROMEDIO_RECLAMO_SEGUN_TIPO_Y_OPERADOR' AND type='v')
	DROP VIEW BI_MODEL.TIEMPO_PROMEDIO_RECLAMO_SEGUN_TIPO_Y_OPERADOR
GO

-- CREACION TABLAS - DIMENSIONES --
CREATE TABLE BI_MODEL.TIEMPO(
	FECHA NVARCHAR(7) PRIMARY KEY,
	ANIO int,
	MES int,
);

CREATE TABLE BI_MODEL.TIPO_ENVIO(
	TIPO_NRO int PRIMARY KEY,
	TIPO nvarchar(50)
);
CREATE TABLE BI_MODEL.DIA(
	DIA_NRO int PRIMARY KEY,
	DIA nvarchar(50)
);

CREATE TABLE BI_MODEL.RANGO_HORARIO(
	RANGO_HORARIO_NRO int IDENTITY PRIMARY KEY,
	RANGO_HORARIO_INICIO decimal(18, 0),
	RANGO_HORARIO_FIN decimal(18, 0)
);

CREATE TABLE BI_MODEL.PROVINCIA(
	PROVINCIA_NRO int PRIMARY KEY,
	PROVINCIA_NOMBRE nvarchar(255) NOT NULL UNIQUE
);


CREATE TABLE BI_MODEL.LOCALIDAD(
	LOCALIDAD_NRO int PRIMARY KEY,
	LOCALIDAD_PRIVINCIA_NRO int REFERENCES BI_MODEL.PROVINCIA,
	LOCALIDAD_NOMBRE nvarchar(255) NOT NULL,
);

CREATE TABLE BI_MODEL.RANGO_ETARIO(
	RANGO_ETARIO_NRO int PRIMARY KEY,
	RANGO_ETARIO nvarchar(20)
);

CREATE TABLE BI_MODEL.TIPO_MEDIO_PAGO(
	TIPO_MEDIO_PAGO_NRO int PRIMARY KEY,
	TIPO_MEDIO_PAGO nvarchar(50)
);

CREATE TABLE BI_MODEL.LOCAL(
	LOCAL_NRO int PRIMARY KEY,
	LOCAL_NOMBRE nvarchar(100)
);

CREATE TABLE BI_MODEL.CATEGORIA(
	CATEGORIA_NRO int PRIMARY KEY,
	CATEGORIA_NOMBRE nvarchar(50) NOT NULL UNIQUE,
);

CREATE TABLE BI_MODEL.TIPO_LOCAL(
	TIPO_LOCAL_NRO int PRIMARY KEY,
	TIPO_LOCAL_CATEGORIA_NRO int REFERENCES BI_MODEL.CATEGORIA NULL,
	TIPO_LOCAL_NOMBRE nvarchar(50) NOT NULL UNIQUE
);

CREATE TABLE BI_MODEL.TIPO_MOVILIDAD(
	TIPO_MOVILIDAD_NRO int PRIMARY KEY,
	TIPO_MOVILIDAD nvarchar(50) UNIQUE NOT NULL
);

	CREATE TABLE BI_MODEL.TIPO_PAQUETE(
	TIPO_PAQUETE_NRO int PRIMARY KEY,
	TIPO_PAQUETE_NOMBRE  nvarchar(50) NOT NULL UNIQUE,     
);

CREATE TABLE BI_MODEL.PEDIDO_ESTADO(
	PEDIDO_ESTADO_NRO int PRIMARY KEY,
	PEDIDO_ESTADO nvarchar(50) NOT NULL UNIQUE
);

CREATE TABLE BI_MODEL.MENSAJERIA_ESTADO(
	MENSAJERIA_ESTADO_NRO int PRIMARY KEY,
	ENVIO_MENSAJERIA_ESTADO nvarchar(50) NOT NULL UNIQUE,
);

CREATE TABLE BI_MODEL.ESTADO_RECLAMO(
	ESTADO_RECLAMO_NRO int PRIMARY KEY,
	ESTADO_RECLAMO_NOMBRE NVARCHAR(50) NOT NULL UNIQUE,
);

CREATE TABLE BI_MODEL.TIPO_RECLAMO(
	TIPO_RECLAMO_NRO int PRIMARY KEY,
	TIPO_RECLAMO_NOMBRE nvarchar(50) NOT NULL UNIQUE
);

CREATE TABLE BI_MODEL.CUPON_TIPO(
	CUPON_TIPO_NRO int PRIMARY KEY,
	CUPON_TIPO nvarchar(50) NOT NULL UNIQUE
);

-- TABLAS HECHOS --
CREATE TABLE BI_MODEL.HECHO_PEDIDO(
	ID_HECHO_PEDIDO int IDENTITY PRIMARY KEY,
	HECHO_PEDIDO_DIA_NRO int REFERENCES BI_MODEL.DIA,
	HECHO_PEDIDO_RANGO_NRO int REFERENCES BI_MODEL.RANGO_HORARIO,
	HECHO_PEDIDO_LOCALIDAD_NRO int REFERENCES BI_MODEL.LOCALIDAD,
	HECHO_PEDIDO_CATEGORIA_NRO int REFERENCES BI_MODEL.CATEGORIA,
	HECHO_PEDIDO_PEDIDO_ESTADO_NRO int REFERENCES BI_MODEL.PEDIDO_ESTADO,
	HECHO_PEDIDO_LOCAL_NRO int REFERENCES BI_MODEL.LOCAL,
	HECHO_PEDIDO_TIEMPO NVARCHAR(7) REFERENCES BI_MODEL.TIEMPO,
	HECHO_PEDIDO_CANTIDAD_PEDIDOS int,
	HECHO_PEDIDO_MONTO_PEDIDOS_CANCELADOS decimal(18,2),
	HECHO_PEDIDO_PROMEDIO_CALIFICACION decimal(18,2)
);

CREATE TABLE BI_MODEL.HECHO_RECLAMO(
	ID_HECHO_RECLAMO int IDENTITY PRIMARY KEY,
	HECHO_RECLAMO_TIEMPO NVARCHAR(7) REFERENCES BI_MODEL.TIEMPO,
	HECHO_RECLAMO_LOCAL_NRO int REFERENCES BI_MODEL.LOCAL,
	HECHO_RECLAMO_DIA_NRO int REFERENCES BI_MODEL.DIA,
	HECHO_RECLAMO_RANGO_HORARIO_NRO int REFERENCES BI_MODEL.RANGO_HORARIO,
	HECHO_RECLAMO_TIPO_RECLAMO_NRO int REFERENCES BI_MODEL.TIPO_RECLAMO,
	HECHO_RECLAMO_RANGO_ETARIO_NRO int REFERENCES BI_MODEL.RANGO_ETARIO,
	HECHO_RECLAMO_CANTIDAD_RECLAMOS int,
	HECHO_RECLAMO_TIEMPO_PROMEDIO_RESOLUCION int,
);

CREATE TABLE BI_MODEL.HECHO_CUPON(
	ID_HECHO_CUPON int IDENTITY PRIMARY KEY,
	HECHO_CUPON_TIEMPO NVARCHAR(7) REFERENCES BI_MODEL.TIEMPO,
	HECHO_CUPON_RANGO_ETARIO_NRO int REFERENCES BI_MODEL.RANGO_ETARIO,
	HECHO_CUPON_CUPON_TIPO_NRO int REFERENCES BI_MODEL.CUPON_TIPO,
	HECHO_CUPON_MONTO_TOTAL decimal(18,2) NOT NULL,
	-- HECHO_CUPON_MONTO_GENERADO_POR_RECLAMO decimal(18,2) NOT NULL
);

CREATE TABLE BI_MODEL.HECHO_ENVIO(
	ID_HECHO_ENVIO int IDENTITY PRIMARY KEY,
	HECHO_ENVIO_TIEMPO NVARCHAR(7) REFERENCES BI_MODEL.TIEMPO,
	HECHO_ENVIO_DIA_NRO int REFERENCES BI_MODEL.DIA,
	HECHO_ENVIO_RANGO_NRO int REFERENCES BI_MODEL.RANGO_HORARIO,
	HECHO_ENVIO_LOCALIDAD_NRO int REFERENCES BI_MODEL.LOCALIDAD,
	HECHO_ENVIO_RANGO_ETARIO_NRO int REFERENCES BI_MODEL.RANGO_ETARIO,
	HECHO_ENVIO_TIPO_MOVILIDAD_NRO int REFERENCES BI_MODEL.TIPO_MOVILIDAD,
	HECHO_ENVIO_TIPO_ENVIO int REFERENCES BI_MODEL.TIPO_ENVIO,
	HECHO_ENVIO_VALOR_PROMEDIO decimal(18,2),
	HECHO_ENVIO_DESVIO_PROMEDIO decimal(18,2),
	HECHO_ENVIO_PORCENTAJE decimal(10,5),
	);

CREATE TABLE BI_MODEL.HECHO_MENSAJERIA(
	ID_HECHO_MENSAJERIA int IDENTITY PRIMARY KEY,
	HECHO_MENSAJERIA_DIA_NRO int REFERENCES BI_MODEL.DIA ,
	HECHO_MENSAJERIA_TIEMPO NVARCHAR(7) REFERENCES BI_MODEL.TIEMPO,
	HECHO_MENSAJERIA_RANGO_NRO int REFERENCES BI_MODEL.RANGO_HORARIO,
	HECHO_MENSAJERIA_LOCALIDAD_NRO int REFERENCES BI_MODEL.LOCALIDAD,
	HECHO_MENSAJERIA_TIPO_PAQUETE int REFERENCES BI_MODEL.TIPO_PAQUETE,
	HECHO_MENSAJERIA_ESTADO_NRO int REFERENCES BI_MODEL.MENSAJERIA_ESTADO,
	HECHO_MENSAJERIA_CANTIDAD_MENSAJES int ,
	HECHO_MENSAJERIA_VALOR_ASEGURADO_PROMEDIO decimal(18,2),
	);

IF OBJECT_ID('obtenerRangoHorarioNro', 'FN') IS NOT NULL
DROP FUNCTION obtenerRangoHorarioNro;
GO
CREATE FUNCTION obtenerRangoHorarioNro(@fecha datetime) RETURNS int 
AS
BEGIN
	DECLARE @hora int;
	SET @hora = DATEPART(hour, @fecha);

	DECLARE @rangoHorarioNro int;
	SELECT @rangoHorarioNro = RANGO_HORARIO_NRO FROM BI_MODEL.RANGO_HORARIO WHERE @hora >= RANGO_HORARIO_INICIO AND @hora <RANGO_HORARIO_FIN ;
	RETURN @rangoHorarioNro;
END
GO

IF OBJECT_ID('obtenerRangoEtarioNro', 'FN') IS NOT NULL
DROP FUNCTION obtenerRangoEtarioNro;
GO
CREATE FUNCTION obtenerRangoEtarioNro(@fechaNac date) RETURNS int 
AS
BEGIN
    DECLARE @rangoEtario int

    SELECT 
        @rangoEtario = CASE 
            WHEN DATEDIFF(YEAR, @fechaNac, GETDATE()) < 25 THEN 1
            WHEN DATEDIFF(YEAR, @fechaNac, GETDATE()) BETWEEN 25 AND 34 THEN 2
            WHEN DATEDIFF(YEAR, @fechaNac, GETDATE()) BETWEEN 35 AND 54 THEN 3
            WHEN DATEDIFF(YEAR, @fechaNac, GETDATE()) >= 55 THEN 4
        END

    RETURN @rangoEtario
END
GO

IF OBJECT_ID('transformaPorcentajePedido', 'FN') IS NOT NULL
DROP FUNCTION transformaPorcentajePedido;
GO
CREATE FUNCTION transformaPorcentajePedido(@cant int) RETURNS decimal(10,5) 
AS
BEGIN
    DECLARE @pctj decimal(10,5);
	SET @pctj = CAST(@cant AS decimal(10,5)) * 100 /  CAST((SELECT COUNT(PEDIDO_NRO) FROM NEW_MODEL.PEDIDO) AS decimal(10,5));
    RETURN @pctj;
END
GO

IF OBJECT_ID('transformaPorcentajeEnvio', 'FN') IS NOT NULL
DROP FUNCTION transformaPorcentajeEnvio;
GO
CREATE FUNCTION transformaPorcentajeEnvio(@cant int) RETURNS decimal(10,5) 
AS
BEGIN
    DECLARE @pctj decimal(10,5);
    SET @pctj = CAST(@cant AS decimal(10,5)) * 100 /  CAST((SELECT COUNT(ENVIO_MENSAJERIA_NRO) FROM NEW_MODEL.ENVIO_MENSAJERIA) AS decimal(10,5));
    RETURN @pctj;
END
GO


IF OBJECT_ID('calcularTimepoEntrega', 'FN') IS NOT NULL
DROP FUNCTION calcularTimepoEntrega;
GO
CREATE FUNCTION calcularTimepoEntrega( @fecha datetime,@fechaEntrega datetime) RETURNS decimal(18,2) 
AS
	BEGIN
		declare @fechaDec decimal(18,2);
		declare @fechaDeResta datetime;
		SET @fechaDeResta = @fechaEntrega - @fecha;
		SET @fechaDec = CONVERT(DECIMAL(18,2), DATEPART(MINUTE, @fechaDeResta)) / 60
		RETURN @fechaDec
    
	END
GO


IF OBJECT_ID('BI_MIGRAR_TIEMPO', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_TIEMPO;
GO
CREATE PROCEDURE BI_MIGRAR_TIEMPO
AS
	BEGIN
		INSERT INTO BI_MODEL.TIEMPO(FECHA,ANIO,MES)
		SELECT * FROM(
			SELECT DISTINCT FORMAT(PEDIDO_ENVIO_FECHA, 'yyyy-MM') AS FECHA, 
							YEAR(PEDIDO_ENVIO_FECHA) AS ANIO, 
							MONTH(PEDIDO_ENVIO_FECHA) AS MES
			FROM NEW_MODEL.PEDIDO_ENVIO 
			UNION
			SELECT DISTINCT FORMAT(ENVIO_MENSAJERIA_FECHA, 'yyyy-MM') AS FECHA, 
							YEAR(ENVIO_MENSAJERIA_FECHA) AS ANIO, 
							MONTH(ENVIO_MENSAJERIA_FECHA) AS MES
			FROM NEW_MODEL.ENVIO_MENSAJERIA
			) A ORDER BY 1 DESC
	END
GO

IF OBJECT_ID('BI_MIGRAR_TIPO_ENVIO', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_TIPO_ENVIO;
GO
CREATE PROCEDURE BI_MIGRAR_TIPO_ENVIO
AS
	BEGIN
		INSERT INTO BI_MODEL.TIPO_ENVIO
		VALUES  (1, 'Mensajeria'), 
				(2, 'Pedido') 
	END
GO


IF OBJECT_ID('BI_MIGRAR_DIA', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_DIA;
GO
CREATE PROCEDURE BI_MIGRAR_DIA
AS
	BEGIN
		INSERT INTO BI_MODEL.DIA(DIA_NRO,DIA)
		VALUES  (1, 'Lunes'), 
				(2, 'Martes'), 
				(3, 'Miercoles'), 
				(4, 'Jueves'), 
				(5, 'Viernes'), 
				(6, 'Sabado'),
				(7, 'Domingo')
	END
GO

IF OBJECT_ID('BI_MIGRAR_RANGO_HORARIO', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_RANGO_HORARIO;
GO
CREATE PROCEDURE BI_MIGRAR_RANGO_HORARIO
AS
	BEGIN
		DECLARE @horaInicio decimal(18, 0) = '8';
		DECLARE @horaFin decimal(18, 0) = '24';
		DECLARE @horaActual decimal(18, 0) = @horaInicio;

		WHILE @horaActual < @horaFin
		BEGIN
			INSERT INTO BI_MODEL.RANGO_HORARIO(RANGO_HORARIO_INICIO,RANGO_HORARIO_FIN) VALUES (@horaActual,@horaActual+2);
			SET @horaActual = @horaActual + 2;
		END
	END
GO

IF OBJECT_ID('BI_MIGRAR_PROVINCIA', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_PROVINCIA;
GO
CREATE PROCEDURE BI_MIGRAR_PROVINCIA
AS
	BEGIN
		INSERT INTO BI_MODEL.PROVINCIA(PROVINCIA_NRO,PROVINCIA_NOMBRE)
			SELECT PROVINCIA_NRO,PROVINCIA_NOMBRE
			FROM NEW_MODEL.PROVINCIA 

	END
GO

IF OBJECT_ID('BI_MIGRAR_LOCALIDAD', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_LOCALIDAD;
GO
CREATE PROCEDURE BI_MIGRAR_LOCALIDAD
AS
	BEGIN
		INSERT INTO BI_MODEL.LOCALIDAD(LOCALIDAD_NRO,LOCALIDAD_PRIVINCIA_NRO,LOCALIDAD_NOMBRE)
			SELECT 	LOCALIDAD_NRO ,
					LOCALIDAD_PRIVINCIA_NRO,
					LOCALIDAD_NOMBRE
			FROM NEW_MODEL.LOCALIDAD 

	END
GO



IF OBJECT_ID('BI_MIGRAR_RANGO_ETARIO', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_RANGO_ETARIO;
GO
CREATE PROCEDURE BI_MIGRAR_RANGO_ETARIO
AS
	BEGIN
		INSERT INTO BI_MODEL.RANGO_ETARIO(RANGO_ETARIO_NRO,RANGO_ETARIO)
		VALUES 	(1, 'Menores a 25 años'), 
				(2, 'Entre 25 a 35 años'), 
				(3, 'Entre 35 a 55 años'), 
				(4, 'Mayores a 55 años')
	END
GO

IF OBJECT_ID('BI_MIGRAR_TIPO_MEDIO_PAGO', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_TIPO_MEDIO_PAGO;
GO
CREATE PROCEDURE BI_MIGRAR_TIPO_MEDIO_PAGO
AS
	BEGIN
		INSERT INTO BI_MODEL.TIPO_MEDIO_PAGO(TIPO_MEDIO_PAGO_NRO,TIPO_MEDIO_PAGO)
		SELECT DISTINCT MEDIO_PAGO_NRO, MEDIO_PAGO FROM NEW_MODEL.MEDIO_PAGO
	END
GO

IF OBJECT_ID('BI_MIGRAR_LOCAL', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_LOCAL;
GO
CREATE PROCEDURE BI_MIGRAR_LOCAL 
AS
    BEGIN
        INSERT INTO BI_MODEL.LOCAL(LOCAL_NRO,LOCAL_NOMBRE)
        SELECT LOCAL_NRO,LOCAL_NOMBRE FROM NEW_MODEL.LOCAL
    END
GO

IF OBJECT_ID('BI_MIGRAR_CATEGORIA', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_CATEGORIA;
GO
CREATE PROCEDURE BI_MIGRAR_CATEGORIA 
AS
    BEGIN
        INSERT INTO BI_MODEL.CATEGORIA(CATEGORIA_NRO, CATEGORIA_NOMBRE)
        VALUES
		(1, 'Parrilla'),
		(2, 'Heladeria'),
		(3, 'Kiosco'),
		(4, 'Supermercado')
    END
GO

IF OBJECT_ID('BI_MIGRAR_TIPO_LOCAL', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_TIPO_LOCAL;
GO
CREATE PROCEDURE BI_MIGRAR_TIPO_LOCAL 
AS
    BEGIN
        INSERT INTO BI_MODEL.TIPO_LOCAL(TIPO_LOCAL_NRO,TIPO_LOCAL_CATEGORIA_NRO,TIPO_LOCAL_NOMBRE)
        SELECT TIPO_LOCAL_NRO, TIPO_LOCAL_CATEGORIA_NRO, TIPO_LOCAL_NOMBRE FROM NEW_MODEL.TIPO_LOCAL;

		UPDATE BI_MODEL.TIPO_LOCAL
		SET TIPO_LOCAL_CATEGORIA_NRO = 1 WHERE TIPO_LOCAL_NRO = 1

		UPDATE BI_MODEL.TIPO_LOCAL
		SET TIPO_LOCAL_CATEGORIA_NRO = 3 WHERE TIPO_LOCAL_NRO = 2

    END
GO


IF OBJECT_ID('BI_MIGRAR_TIPO_MOVILIDAD', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_TIPO_MOVILIDAD;
GO
CREATE PROCEDURE BI_MIGRAR_TIPO_MOVILIDAD 
AS
    BEGIN
        INSERT INTO BI_MODEL.TIPO_MOVILIDAD(TIPO_MOVILIDAD_NRO, TIPO_MOVILIDAD)
        SELECT TIPO_MOVILIDAD_NRO, TIPO_MOVILIDAD_NOMBRE FROM NEW_MODEL.TIPO_MOVILIDAD;
    END
GO

IF OBJECT_ID('BI_MIGRAR_TIPO_PAQUETE', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_TIPO_PAQUETE;
GO
CREATE PROCEDURE BI_MIGRAR_TIPO_PAQUETE 
AS
    BEGIN
        INSERT INTO BI_MODEL.TIPO_PAQUETE(TIPO_PAQUETE_NRO, TIPO_PAQUETE_NOMBRE)
        SELECT TIPO_PAQUETE_NRO, TIPO_PAQUETE_NOMBRE FROM NEW_MODEL.TIPO_PAQUETE;
    END
GO

IF OBJECT_ID('BI_MIGRAR_PEDIDO_ESTADO', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_PEDIDO_ESTADO;
GO
CREATE PROCEDURE BI_MIGRAR_PEDIDO_ESTADO 
AS
    BEGIN
        INSERT INTO BI_MODEL.PEDIDO_ESTADO(PEDIDO_ESTADO_NRO, PEDIDO_ESTADO)
        SELECT PEDIDO_ESTADO_NRO, PEDIDO_ESTADO FROM NEW_MODEL.PEDIDO_ESTADO;
    END
GO

IF OBJECT_ID('BI_MIGRAR_MENSAJERIA_ESTADO', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_MENSAJERIA_ESTADO;
GO
CREATE PROCEDURE BI_MIGRAR_MENSAJERIA_ESTADO 
AS
    BEGIN
        INSERT INTO BI_MODEL.MENSAJERIA_ESTADO(MENSAJERIA_ESTADO_NRO, ENVIO_MENSAJERIA_ESTADO)
        SELECT MENSAJERIA_ESTADO_NRO, ENVIO_MENSAJERIA_ESTADO FROM NEW_MODEL.MENSAJERIA_ESTADO;
    END
GO

IF OBJECT_ID('BI_MIGRAR_ESTADO_RECLAMO', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_ESTADO_RECLAMO;
GO
CREATE PROCEDURE BI_MIGRAR_ESTADO_RECLAMO 
AS
    BEGIN
        INSERT INTO BI_MODEL.ESTADO_RECLAMO(ESTADO_RECLAMO_NRO, ESTADO_RECLAMO_NOMBRE)
        SELECT ESTADO_RECLAMO_NRO, ESTADO_RECLAMO_NOMBRE FROM NEW_MODEL.ESTADO_RECLAMO;
    END
GO


IF OBJECT_ID('BI_MIGRAR_TIPO_RECLAMO', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_TIPO_RECLAMO;
GO
CREATE PROCEDURE BI_MIGRAR_TIPO_RECLAMO 
AS
    BEGIN
		INSERT INTO BI_MODEL.TIPO_RECLAMO(TIPO_RECLAMO_NRO,TIPO_RECLAMO_NOMBRE)
		SELECT TIPO_RECLAMO_NRO, TIPO_RECLAMO_NOMBRE FROM NEW_MODEL.TIPO_RECLAMO
    END
GO

IF OBJECT_ID('BI_MIGRAR_TIPO_CUPON', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_TIPO_CUPON;
GO
CREATE PROCEDURE BI_MIGRAR_TIPO_CUPON 
AS
    BEGIN
		INSERT INTO BI_MODEL.CUPON_TIPO(CUPON_TIPO_NRO,CUPON_TIPO)
		SELECT CUPON_TIPO_NRO, CUPON_TIPO FROM NEW_MODEL.CUPON_TIPO
    END
GO

IF OBJECT_ID('BI_MIGRAR_HECHO_PEDIDO', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_HECHO_PEDIDO;
GO
CREATE PROCEDURE BI_MIGRAR_HECHO_PEDIDO 
AS
    BEGIN
        INSERT INTO BI_MODEL.HECHO_PEDIDO(
			HECHO_PEDIDO_DIA_NRO,
			HECHO_PEDIDO_RANGO_NRO,
			HECHO_PEDIDO_LOCALIDAD_NRO,
			HECHO_PEDIDO_LOCAL_NRO,
			HECHO_PEDIDO_CATEGORIA_NRO,
			HECHO_PEDIDO_PEDIDO_ESTADO_NRO,
			HECHO_PEDIDO_TIEMPO,
			HECHO_PEDIDO_CANTIDAD_PEDIDOS ,
			HECHO_PEDIDO_MONTO_PEDIDOS_CANCELADOS,
			HECHO_PEDIDO_PROMEDIO_CALIFICACION
		)
		-- SELECT AVG(PROMEDIO_CALIFICACION) FROM (
			SELECT 	
				DATEPART(WEEKDAY,t_pedido_envio.PEDIDO_ENVIO_FECHA) AS DIA_NRO,
				dbo.obtenerRangoHorarioNro(t_pedido_envio.PEDIDO_ENVIO_FECHA) AS RANGO,
				t_localidad.LOCALIDAD_NRO AS LOCALIDAD,
				t_local.LOCAL_NRO AS LOCAL,
				t_categoria.CATEGORIA_NRO AS CATEGORIA,
				t_pedido_estado.PEDIDO_ESTADO_NRO AS PEDIDO_ESTADO,
				t_tiempo.FECHA AS TIEMPO ,
				COUNT(DISTINCT t_pedido.PEDIDO_NRO) AS CANT_PEDIDOS,
				SUM(DISTINCT t_pedido.PEDIDO_TOTAL) AS MONTO_PEDIDOS_CANCELADOS,
				AVG(DISTINCT t_pedido.PEDIDO_CALIFICACION) AS PROMEDIO_CALIFICACION
			FROM NEW_MODEL.PEDIDO t_pedido
			JOIN NEW_MODEL.PEDIDO_ENVIO t_pedido_envio ON t_pedido_envio.PEDIDO_ENVIO_NRO = t_pedido.PEDIDO_ENVIO_NRO
			JOIN BI_MODEL.RANGO_HORARIO t_rango_horario ON t_rango_horario.RANGO_HORARIO_NRO = dbo.obtenerRangoHorarioNro(t_pedido_envio.PEDIDO_ENVIO_FECHA)
			JOIN NEW_MODEL.DIRECCION_USUARIO t_direccion_usuario ON t_direccion_usuario.DIRECCION_USUARIO_NRO = t_pedido_envio.PEDIDO_ENVIO_DIRECCION_USUARIO_NRO
			JOIN NEW_MODEL.LOCALIDAD t_localidad ON t_localidad.LOCALIDAD_NRO = t_direccion_usuario.DIRECCION_USUARIO_LOCALIDAD_NRO
			JOIN NEW_MODEL.ITEM t_item ON t_item.ITEM_PEDIDO_NRO = t_pedido.PEDIDO_NRO
			JOIN NEW_MODEL.LOCAL t_local ON t_local.LOCAL_NRO = t_item.ITEM_LOCAL_PRODUCTO_LOCAL_NRO
			JOIN BI_MODEL.TIPO_LOCAL t_tipo_local ON t_tipo_local.TIPO_LOCAL_NRO = t_local.LOCAL_TIPO_LOCAL_NRO
			JOIN BI_MODEL.CATEGORIA t_categoria ON t_categoria.CATEGORIA_NRO = t_tipo_local.TIPO_LOCAL_CATEGORIA_NRO
			JOIN BI_MODEL.TIEMPO t_tiempo ON t_tiempo.MES = MONTH(t_pedido_envio.PEDIDO_ENVIO_FECHA)
			JOIN NEW_MODEL.PEDIDO_ESTADO t_pedido_estado ON t_pedido_estado.PEDIDO_ESTADO_NRO = t_pedido.PEDIDO_ESTADO_NRO
			GROUP BY DATEPART(WEEKDAY,t_pedido_envio.PEDIDO_ENVIO_FECHA), dbo.obtenerRangoHorarioNro(t_pedido_envio.PEDIDO_ENVIO_FECHA), t_localidad.LOCALIDAD_NRO, t_local.LOCAL_NRO, t_categoria.CATEGORIA_NRO, t_tiempo.FECHA, t_pedido_estado.PEDIDO_ESTADO_NRO
			-- order by LOCALIDAD,LOCAL
			-- ) T WHERE PEDIDO_ESTADO = 2
			-- 61257 PEDIDOS TOTALES
			-- 69131875.21 MONTO TOTAL CANCELADOS
			-- 2.993274 DE PROMEDIO TODAS LAS CALIFICACIONNES

			-- SELECT AVG(PEDIDO_CALIFICACION) FROM NEW_MODEL.PEDIDO 
    END
GO

IF OBJECT_ID('BI_MIGRAR_HECHO_RECLAMO', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_HECHO_RECLAMO;
GO
CREATE PROCEDURE BI_MIGRAR_HECHO_RECLAMO 
AS
    BEGIN
        INSERT INTO BI_MODEL.HECHO_RECLAMO(
			HECHO_RECLAMO_TIEMPO,
			HECHO_RECLAMO_LOCAL_NRO,
			HECHO_RECLAMO_DIA_NRO,
			HECHO_RECLAMO_RANGO_HORARIO_NRO,
			HECHO_RECLAMO_TIPO_RECLAMO_NRO,
			HECHO_RECLAMO_RANGO_ETARIO_NRO,
			HECHO_RECLAMO_CANTIDAD_RECLAMOS,
			HECHO_RECLAMO_TIEMPO_PROMEDIO_RESOLUCION
		)
			-- SELECT SUM(CANTIDAD_RECLAMOS) FROM (
			SELECT	
					t_tiempo.FECHA AS FECHA,
					t_local.LOCAL_NRO AS LOCAL,
					t_dia.DIA_NRO AS DIA ,
					dbo.obtenerRangoHorarioNro(t_reclamo.RECLAMO_FECHA) AS RANGO_HORARIO,
					t_tipo_reclamo.TIPO_RECLAMO_NRO,
					t_rango_etario.RANGO_ETARIO_NRO ,
					COUNT(DISTINCT RECLAMO_NRO) AS CANTIDAD_RECLAMOS,
					AVG(DISTINCT DATEDIFF(MINUTE,t_reclamo.RECLAMO_FECHA, t_reclamo.RECLAMO_FECHA_SOLUCION)) AS TIEMPO_PROMEDIO_RESOLUCION
			FROM NEW_MODEL.RECLAMO t_reclamo
			JOIN BI_MODEL.TIEMPO t_tiempo ON t_tiempo.MES = MONTH(t_reclamo.RECLAMO_FECHA)
			JOIN NEW_MODEL.PEDIDO t_pedido ON t_pedido.PEDIDO_NRO = t_reclamo.RECLAMO_PEDIDO_NRO
			JOIN NEW_MODEL.ITEM t_item ON t_item.ITEM_PEDIDO_NRO = t_pedido.PEDIDO_NRO
			JOIN BI_MODEL.LOCAL t_local ON t_local.LOCAL_NRO = t_item.ITEM_LOCAL_PRODUCTO_LOCAL_NRO 
			JOIN BI_MODEL.DIA t_dia ON t_dia.DIA_NRO = DATEPART(WEEKDAY,t_reclamo.RECLAMO_FECHA)
			JOIN BI_MODEL.RANGO_HORARIO t_rango_horario ON t_rango_horario.RANGO_HORARIO_NRO = dbo.obtenerRangoHorarioNro(t_reclamo.RECLAMO_FECHA)
			JOIN BI_MODEL.TIPO_RECLAMO t_tipo_reclamo ON t_tipo_reclamo.TIPO_RECLAMO_NRO = t_reclamo.RECLAMO_TIPO_RECLAMO_NRO
			JOIN NEW_MODEL.OPERADOR t_operador ON t_operador.OPERADOR_NRO = t_reclamo.RECLAMO_OPERADOR_NRO
			JOIN BI_MODEL.RANGO_ETARIO t_rango_etario ON t_rango_etario.RANGO_ETARIO_NRO = dbo.obtenerRangoEtarioNro(t_operador.OPERADOR_RECLAMO_FECHA_NAC)
			GROUP BY t_tiempo.FECHA, t_local.LOCAL_NRO, t_dia.DIA_NRO, dbo.obtenerRangoHorarioNro(t_reclamo.RECLAMO_FECHA), t_tipo_reclamo.TIPO_RECLAMO_NRO, t_rango_etario.RANGO_ETARIO_NRO
			-- ORDER BY LOCAL,MES,DIA
			-- ) T
			-- 11161 RECLAMOS TOTALES
	END
GO

IF OBJECT_ID('BI_MIGRAR_HECHO_CUPON', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_HECHO_CUPON;
	PRINT('ASD')
GO
CREATE PROCEDURE BI_MIGRAR_HECHO_CUPON 
AS
    BEGIN
        INSERT INTO BI_MODEL.HECHO_CUPON(
			HECHO_CUPON_TIEMPO,
			HECHO_CUPON_RANGO_ETARIO_NRO,
			HECHO_CUPON_CUPON_TIPO_NRO,
			HECHO_CUPON_MONTO_TOTAL
			-- HECHO_CUPON_MONTO_GENERADO_POR_RECLAMO
		)
			-- SELECT SUM(MONTO_TOTAL) FROM (
			SELECT	
					t_tiempo.FECHA,
					t_rango_etario.RANGO_ETARIO_NRO,
					t_cupon_tipo.CUPON_TIPO_NRO ,
					sum(t_cupon.CUPON_MONTO) AS MONTO_TOTAL
			FROM NEW_MODEL.CUPON t_cupon
			JOIN NEW_MODEL.CUPON_APLICADO t_cupon_aplicado ON t_cupon_aplicado.CUPON_APLICADO_CUPON_NRO = t_cupon.CUPON_NRO AND t_cupon_aplicado.CUPON_APLICADO_CUPON_TIPO_NRO = t_cupon.CUPON_TIPO_NRO
			JOIN BI_MODEL.TIEMPO t_tiempo ON t_tiempo.MES = MONTH(t_cupon_aplicado.CUPON_APLICADO_FECHA)
			JOIN NEW_MODEL.USUARIO t_usuario ON t_usuario.USUARIO_NRO = t_cupon.CUPON_USUARIO_NRO
			JOIN BI_MODEL.RANGO_ETARIO t_rango_etario ON t_rango_etario.RANGO_ETARIO_NRO = dbo.obtenerRangoEtarioNro(t_usuario.USUARIO_FECHA_NAC)
			JOIN BI_MODEL.CUPON_TIPO t_cupon_tipo ON t_cupon_tipo.CUPON_TIPO_NRO = t_cupon.CUPON_TIPO_NRO
			GROUP BY t_tiempo.FECHA, t_rango_etario.RANGO_ETARIO_NRO, t_cupon_tipo.CUPON_TIPO_NRO
			-- ORDER BY MES
			-- ) T
			-- 31440 CUPONES TOTALES
			-- 46768296.66 MONTO TOTAL UTILIZADO
			-- SELECT SUM(CUPON_MONTO) FROM NEW_MODEL.CUPON
	END
GO

IF OBJECT_ID('BI_MIGRAR_HECHO_ENVIOS', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_HECHO_ENVIOS;
	PRINT('ASD')
GO
CREATE PROCEDURE BI_MIGRAR_HECHO_ENVIOS 
AS
    BEGIN
        INSERT INTO BI_MODEL.HECHO_ENVIO(
			HECHO_ENVIO_DIA_NRO,
			HECHO_ENVIO_TIEMPO,
			HECHO_ENVIO_RANGO_NRO,
			HECHO_ENVIO_LOCALIDAD_NRO,
			HECHO_ENVIO_RANGO_ETARIO_NRO,
			HECHO_ENVIO_TIPO_MOVILIDAD_NRO,
			HECHO_ENVIO_TIPO_ENVIO,
			HECHO_ENVIO_VALOR_PROMEDIO,
			HECHO_ENVIO_PORCENTAJE,
			HECHO_ENVIO_DESVIO_PROMEDIO
		)
		SELECT 
			DATEPART(WEEKDAY,t_envio_mensajeria.ENVIO_MENSAJERIA_FECHA) AS DIA_NRO,
			t_tiempo.FECHA AS FECHA,
			dbo.obtenerRangoHorarioNro(t_envio_mensajeria.ENVIO_MENSAJERIA_FECHA) AS RANGO,
			t_envio_mensajeria.ENVIO_MENSAJERIA_LOCALIDAD_NRO AS LOCALIDAD,
			t_etario.RANGO_ETARIO_NRO AS RANGO_ETARIO,
			t_tipo_movilidad.TIPO_MOVILIDAD_NRO AS TIPO_MOVILIDAD,
			1 AS TIPO,
			AVG(DISTINCT t_mensajeria.MENSAJERIA_PRECIO_ENVIO) AS VALOR_PROMEDIO,
			(COUNT(t_mensajeria.MENSAJERIA_ENVIO_NRO) * 100.0) / (SELECT COUNT(MENSAJERIA_NRO) FROM NEW_MODEL.MENSAJERIA) AS PORCENTAJE,
			AVG(t_mensajeria.MENSAJERIA_TIEMPO_ESTIMADO)-(AVG(dbo.calcularTimepoEntrega(t_envio_mensajeria.ENVIO_MENSAJERIA_FECHA_ENTREGA,t_envio_mensajeria.ENVIO_MENSAJERIA_FECHA))) AS DESVIO_PROMEDIO
		FROM NEW_MODEL.MENSAJERIA t_mensajeria
		JOIN NEW_MODEL.ENVIO_MENSAJERIA t_envio_mensajeria ON t_envio_mensajeria.ENVIO_MENSAJERIA_NRO = t_mensajeria.MENSAJERIA_ENVIO_NRO
		JOIN BI_MODEL.RANGO_HORARIO t_rango_horario ON t_rango_horario.RANGO_HORARIO_NRO = dbo.obtenerRangoHorarioNro(t_envio_mensajeria.ENVIO_MENSAJERIA_FECHA)
		JOIN NEW_MODEL.REPARTIDOR t_repartidor ON t_envio_mensajeria.ENVIO_MENSAJERIA_REPARTIDOR_NRO = t_repartidor.REPARTIDOR_NRO
		JOIN NEW_MODEL.TIPO_MOVILIDAD t_tipo_movilidad ON t_repartidor.REPARTIDOR_TIPO_MOVILIDAD_NRO = t_tipo_movilidad.TIPO_MOVILIDAD_NRO
		JOIN BI_MODEL.RANGO_ETARIO t_etario ON dbo.obtenerRangoEtarioNro(t_repartidor.REPARTIDOR_FECHA_NAC) = t_etario.RANGO_ETARIO_NRO
		JOIN BI_MODEL.TIEMPO t_tiempo ON t_tiempo.MES = MONTH(t_envio_mensajeria.ENVIO_MENSAJERIA_FECHA_ENTREGA)
		GROUP BY DATEPART(WEEKDAY,t_envio_mensajeria.ENVIO_MENSAJERIA_FECHA), t_tiempo.FECHA, dbo.obtenerRangoHorarioNro(t_envio_mensajeria.ENVIO_MENSAJERIA_FECHA), t_envio_mensajeria.ENVIO_MENSAJERIA_LOCALIDAD_NRO, t_etario.RANGO_ETARIO_NRO, t_tipo_movilidad.TIPO_MOVILIDAD_NRO 
		UNION
		SELECT 	
			DATEPART(WEEKDAY,t_envio_pedido.PEDIDO_ENVIO_FECHA) AS DIA_NRO,
			t_tiempo.FECHA AS FECHA,
			dbo.obtenerRangoHorarioNro(t_envio_pedido.PEDIDO_ENVIO_FECHA) AS RANGO,
			t_direccion.DIRECCION_USUARIO_LOCALIDAD_NRO AS LOCALIDAD,
			t_etario.RANGO_ETARIO_NRO AS RANGO_ETARIO,
			t_tipo_movilidad.TIPO_MOVILIDAD_NRO AS TIPO_MOVILIDAD,
			2 AS TIPO,
			AVG(t_pedido.PEDIDO_PRECIO_ENVIO) AS VALOR_PROMEDIO,
			(COUNT(t_envio_pedido.PEDIDO_ENVIO_NRO) * 100.0) / (SELECT COUNT(PEDIDO_ENVIO_NRO) FROM NEW_MODEL.PEDIDO_ENVIO) AS PORCENTAJE,
			AVG(t_pedido.PEDIDO_TIEMPO_ESTIMADO)-(AVG(dbo.calcularTimepoEntrega(t_envio_pedido.PEDIDO_ENVIO_FECHA_ENTREGA,t_envio_pedido.PEDIDO_ENVIO_FECHA))) AS DESVIO_PROMEDIO,
			COUNT(t_pedido.PEDIDO_NRO) AS CANTIDAD

		FROM NEW_MODEL.PEDIDO t_pedido
		JOIN NEW_MODEL.PEDIDO_ENVIO t_envio_pedido ON t_envio_pedido.PEDIDO_ENVIO_NRO = t_pedido.PEDIDO_ENVIO_NRO
		JOIN BI_MODEL.RANGO_HORARIO t_rango_horario ON t_rango_horario.RANGO_HORARIO_NRO = dbo.obtenerRangoHorarioNro(t_envio_pedido.PEDIDO_ENVIO_FECHA)
		JOIN NEW_MODEL.DIRECCION_USUARIO t_direccion ON t_envio_pedido.PEDIDO_ENVIO_DIRECCION_USUARIO_NRO = t_direccion.DIRECCION_USUARIO_NRO
		JOIN NEW_MODEL.REPARTIDOR t_repartidor ON t_envio_pedido.PEDIDO_ENVIO_REPARTIDOR_NRO = t_repartidor.REPARTIDOR_NRO
		JOIN NEW_MODEL.TIPO_MOVILIDAD t_tipo_movilidad ON t_repartidor.REPARTIDOR_TIPO_MOVILIDAD_NRO = t_tipo_movilidad.TIPO_MOVILIDAD_NRO
		JOIN BI_MODEL.RANGO_ETARIO t_etario ON dbo.obtenerRangoEtarioNro(t_repartidor.REPARTIDOR_FECHA_NAC) = t_etario.RANGO_ETARIO_NRO
		JOIN BI_MODEL.TIEMPO t_tiempo ON t_tiempo.MES = MONTH(t_envio_pedido.PEDIDO_ENVIO_FECHA)
		GROUP BY DATEPART(WEEKDAY,t_envio_pedido.PEDIDO_ENVIO_FECHA), t_tiempo.FECHA, dbo.obtenerRangoHorarioNro(t_envio_pedido.PEDIDO_ENVIO_FECHA), t_direccion.DIRECCION_USUARIO_LOCALIDAD_NRO, t_etario.RANGO_ETARIO_NRO, t_tipo_movilidad.TIPO_MOVILIDAD_NRO
	END
GO

IF OBJECT_ID('BI_MIGRAR_HECHO_MENSAJERIA', 'P') IS NOT NULL
    DROP PROCEDURE BI_MIGRAR_HECHO_MENSAJERIA;
GO
CREATE PROCEDURE BI_MIGRAR_HECHO_MENSAJERIA 
AS
    BEGIN
        INSERT INTO BI_MODEL.HECHO_MENSAJERIA(
			HECHO_MENSAJERIA_DIA_NRO,
			HECHO_MENSAJERIA_TIEMPO,
			HECHO_MENSAJERIA_RANGO_NRO,
			HECHO_MENSAJERIA_LOCALIDAD_NRO,
			HECHO_MENSAJERIA_TIPO_PAQUETE,
			HECHO_MENSAJERIA_ESTADO_NRO,
			HECHO_MENSAJERIA_CANTIDAD_MENSAJES ,
			HECHO_MENSAJERIA_VALOR_ASEGURADO_PROMEDIO
		)
		SELECT 	
			DATEPART(WEEKDAY,t_envio_mensajeria.ENVIO_MENSAJERIA_FECHA) AS DIA_NRO,
			t_tiempo.FECHA AS FECHA,
			dbo.obtenerRangoHorarioNro(t_envio_mensajeria.ENVIO_MENSAJERIA_FECHA) AS RANGO,
			t_envio_mensajeria.ENVIO_MENSAJERIA_LOCALIDAD_NRO AS LOCALIDAD,
			t_tipo_paquete.TIPO_PAQUETE_NRO AS TIPO_PAQUETE,
			t_estado.MENSAJERIA_ESTADO_NRO AS ESTADO_NRO,
			COUNT(DISTINCT t_mensajeria.MENSAJERIA_NRO) AS CANT_MENSAJES,
			AVG(DISTINCT t_mensajeria.MENSAJERIA_VALOR_ASEGURADO) AS ASEGURADO_PROMEDIO
		FROM NEW_MODEL.MENSAJERIA t_mensajeria
		JOIN NEW_MODEL.ENVIO_MENSAJERIA t_envio_mensajeria ON t_envio_mensajeria.ENVIO_MENSAJERIA_NRO = t_mensajeria.MENSAJERIA_ENVIO_NRO
		JOIN BI_MODEL.RANGO_HORARIO t_rango_horario ON t_rango_horario.RANGO_HORARIO_NRO = dbo.obtenerRangoHorarioNro(t_envio_mensajeria.ENVIO_MENSAJERIA_FECHA)
		--tipo paquete
		JOIN NEW_MODEL.PAQUETE t_paquete ON t_mensajeria.MENSAJERIA_PAQUETE_NRO = t_paquete.PAQUETE_NRO
		JOIN NEW_MODEL.TIPO_PAQUETE t_tipo_paquete ON t_paquete.PAQUETE_TIPO_PAQUETE_NRO = t_tipo_paquete.TIPO_PAQUETE_NRO
		-- estado
		JOIN NEW_MODEL.MENSAJERIA_ESTADO t_estado ON t_mensajeria.MENSAJERIA_ESTADO = t_estado.MENSAJERIA_ESTADO_NRO
		JOIN BI_MODEL.TIEMPO t_tiempo ON t_tiempo.MES = MONTH(t_envio_mensajeria.ENVIO_MENSAJERIA_FECHA_ENTREGA)
		GROUP BY DATEPART(WEEKDAY,t_envio_mensajeria.ENVIO_MENSAJERIA_FECHA), t_tiempo.FECHA , dbo.obtenerRangoHorarioNro(t_envio_mensajeria.ENVIO_MENSAJERIA_FECHA), t_envio_mensajeria.ENVIO_MENSAJERIA_LOCALIDAD_NRO, t_tipo_paquete.TIPO_PAQUETE_NRO, t_estado.MENSAJERIA_ESTADO_NRO
	END
GO

CREATE VIEW BI_MODEL.MAYOR_CANTIDAD_PEDIDOS_DIA_FRANJA_LOCALIDAD_CATEGORIA_MES AS
SELECT TOP 1 T.DIA , T.RANGO_HORARIO, CANTIDAD_PEDIDOS FROM (
	SELECT	t_dia.DIA AS DIA,
		CONCAT(t_rango_horario.RANGO_HORARIO_INICIO,'hs. - ',t_rango_horario.RANGO_HORARIO_FIN,'hs.') AS RANGO_HORARIO,
		t_localidad.LOCALIDAD_NOMBRE AS LOCALIDAD,
		t_categoria.CATEGORIA_NOMBRE AS CATEGORIA,
		t_tiempo.MES AS MES,
		t_tiempo.ANIO AS ANIO,
		SUM(t_hecho_pedido.HECHO_PEDIDO_CANTIDAD_PEDIDOS) AS CANTIDAD_PEDIDOS
FROM BI_MODEL.HECHO_PEDIDO t_hecho_pedido
JOIN BI_MODEL.DIA t_dia ON t_dia.DIA_NRO = t_hecho_pedido.HECHO_PEDIDO_DIA_NRO
JOIN BI_MODEL.RANGO_HORARIO t_rango_horario ON t_rango_horario.RANGO_HORARIO_NRO = t_hecho_pedido.HECHO_PEDIDO_RANGO_NRO
JOIN BI_MODEL.LOCALIDAD t_localidad ON t_localidad.LOCALIDAD_NRO = t_hecho_pedido.HECHO_PEDIDO_LOCALIDAD_NRO
JOIN BI_MODEL.CATEGORIA t_categoria ON t_categoria.CATEGORIA_NRO = t_hecho_pedido.HECHO_PEDIDO_CATEGORIA_NRO
JOIN BI_MODEL.TIEMPO t_tiempo ON t_tiempo.FECHA = t_hecho_pedido.HECHO_PEDIDO_TIEMPO
GROUP BY t_dia.DIA,
		t_rango_horario.RANGO_HORARIO_INICIO, t_rango_horario.RANGO_HORARIO_FIN , t_localidad.LOCALIDAD_NOMBRE, t_categoria.CATEGORIA_NOMBRE, t_tiempo.MES, t_tiempo.ANIO
) AS T
ORDER BY CANTIDAD_PEDIDOS DESC
GO

CREATE VIEW BI_MODEL.MONTO_TOTAL_NO_COBRADO_X_PEDIDO_CANCELADO_SEGUN_DIA_FRANJA_HORARIA AS
SELECT
    SUM(HECHO_PEDIDO_MONTO_PEDIDOS_CANCELADOS) AS MONTO_PEDIDOS_CANCELADOS,
    t_dia.DIA AS DIA,
    CONCAT(t_horario.RANGO_HORARIO_INICIO,' - ',t_horario.RANGO_HORARIO_FIN) AS RANGO_HORARIO
FROM BI_MODEL.HECHO_PEDIDO
    JOIN BI_MODEL.DIA t_dia ON t_dia.DIA_NRO = HECHO_PEDIDO_DIA_NRO
    JOIN BI_MODEL.RANGO_HORARIO t_horario ON t_horario.RANGO_HORARIO_NRO = RANGO_HORARIO_NRO
GROUP BY t_dia.DIA, t_horario.RANGO_HORARIO_INICIO,t_horario.RANGO_HORARIO_FIN
GO

CREATE VIEW BI_MODEL.PROMEDIO_CALIFICACION_MENSUAL_LOCAL AS
SELECT 
    SUM(HECHO_PEDIDO_PROMEDIO_CALIFICACION)/COUNT(HECHO_PEDIDO_PROMEDIO_CALIFICACION) AS PROMEDIO_CALIFICACION,
    t_local.LOCAL_NOMBRE AS LOCAL,
    t_tiempo.MES AS MES
FROM BI_MODEL.HECHO_PEDIDO
    JOIN BI_MODEL.LOCAL t_local ON t_local.LOCAL_NRO = HECHO_PEDIDO_LOCAL_NRO
    JOIN BI_MODEL.TIEMPO t_tiempo ON t_tiempo.FECHA = HECHO_PEDIDO_TIEMPO
GROUP BY t_tiempo.MES,t_local.LOCAL_NOMBRE
GO

CREATE VIEW BI_MODEL.VALOR_PROMEDIO_MENSUAL_PEDIDOS_EN_CADA_LOCALIDAD AS
    SELECT (SUM(HECHO_ENVIO_VALOR_PROMEDIO)/COUNT(HECHO_ENVIO_VALOR_PROMEDIO)) AS PROMEDIO_PRECIO_ENVIO,
    t_tiempo.mes AS MES_NRO,
    t_localidad.LOCALIDAD_NOMBRE AS LOCALIDAD
    FROM BI_MODEL.HECHO_ENVIO h_envio
    JOIN BI_MODEL.LOCALIDAD t_localidad on t_localidad.LOCALIDAD_NRO = h_envio.HECHO_ENVIO_LOCALIDAD_NRO
    JOIN BI_MODEL.TIEMPO t_tiempo ON t_tiempo.FECHA = HECHO_ENVIO_TIEMPO
    WHERE HECHO_ENVIO_TIPO_ENVIO = 2
    GROUP BY t_tiempo.mes ,t_localidad.LOCALIDAD_NOMBRE
GO
    


CREATE VIEW BI_MODEL.DESVIO_PROMEDIO_TIEMPO_ENTREGA_POR_MOVILIDAD_POR_DIA_POR_HORARIO AS
    SELECT  (SUM(HECHO_ENVIO_DESVIO_PROMEDIO)/COUNT(HECHO_ENVIO_DESVIO_PROMEDIO)) AS DESVIO_PROMEDIO,
    t_dia.DIA AS DIA,
    t_movilidad.TIPO_MOVILIDAD AS TIPO_MOVILIDAD,
    CONCAT(t_horario.RANGO_HORARIO_INICIO,' - ',t_horario.RANGO_HORARIO_FIN) AS RANGO_HORARIO
    FROM BI_MODEL.HECHO_ENVIO h_envio
        JOIN BI_MODEL.DIA t_dia ON h_envio.HECHO_ENVIO_DIA_NRO = t_dia.DIA_NRO
        JOIN BI_MODEL.TIPO_MOVILIDAD t_movilidad ON t_movilidad.TIPO_MOVILIDAD_NRO = h_envio.HECHO_ENVIO_TIPO_MOVILIDAD_NRO
        JOIN BI_MODEL.RANGO_HORARIO t_horario ON h_envio.HECHO_ENVIO_RANGO_NRO = t_horario.RANGO_HORARIO_NRO
    GROUP BY t_dia.DIA, t_movilidad.TIPO_MOVILIDAD,t_horario.RANGO_HORARIO_INICIO,t_horario.RANGO_HORARIO_FIN
GO


CREATE VIEW BI_MODEL.PORCENTAJE_DE_CADA_TIPO_ENTREGA_SEGUN_EDAD_REPARTIDOR_Y_LOCALIDAD AS
SELECT 
    (SUM(HECHO_ENVIO_PORCENTAJE)) AS PORCENTAJE_PEDIDOS,
    t_etario.RANGO_ETARIO AS RANGO_ETARIO_REPARTIDOR,
    t_localidad.LOCALIDAD_NOMBRE AS LOCALIDAD
FROM
    BI_MODEL.HECHO_ENVIO h_envio
    JOIN BI_MODEL.RANGO_ETARIO t_etario ON h_envio.HECHO_ENVIO_RANGO_ETARIO_NRO = t_etario.RANGO_ETARIO_NRO
    JOIN BI_MODEL.LOCALIDAD t_localidad ON h_envio.HECHO_ENVIO_LOCALIDAD_NRO = t_localidad.LOCALIDAD_NRO
WHERE
    HECHO_ENVIO_TIPO_ENVIO = 2
GROUP BY
    t_etario.RANGO_ETARIO, t_localidad.LOCALIDAD_NOMBRE

UNION

SELECT 
    (SUM(HECHO_ENVIO_PORCENTAJE)) AS PORCENTAJE_MENSAJERIA,
    t_etario.RANGO_ETARIO AS RANGO_ETARIO_REPARTIDOR,
    t_localidad.LOCALIDAD_NOMBRE AS LOCALIDAD
FROM
    BI_MODEL.HECHO_ENVIO h_envio
    JOIN BI_MODEL.RANGO_ETARIO t_etario ON h_envio.HECHO_ENVIO_RANGO_ETARIO_NRO = t_etario.RANGO_ETARIO_NRO
    JOIN BI_MODEL.LOCALIDAD t_localidad ON h_envio.HECHO_ENVIO_LOCALIDAD_NRO = t_localidad.LOCALIDAD_NRO
WHERE
    HECHO_ENVIO_TIPO_ENVIO = 1
GROUP BY
    t_etario.RANGO_ETARIO, t_localidad.LOCALIDAD_NOMBRE;
GO

CREATE VIEW BI_MODEL.MONTO_TOTAL_CUPONE_POR_RANGO_ETARIO_POR_MES AS
SELECT 
    SUM(HECHO_CUPON_MONTO_TOTAL) AS MONTO_TOTAL,
    HECHO_CUPON_RANGO_ETARIO_NRO AS RANGO_ETARIO_USUARIO,
    HECHO_CUPON_TIEMPO AS MES
FROM BI_MODEL.HECHO_CUPON
GROUP BY HECHO_CUPON_RANGO_ETARIO_NRO,HECHO_CUPON_TIEMPO
GO

CREATE VIEW BI_MODEL.MONTO_MENSUAL_CUPONES_DE_RECLAMOS AS
SELECT
    SUM(HECHO_CUPON_MONTO_TOTAL) AS MONTO_MENSUAL,
    HECHO_CUPON_TIEMPO AS MES 
    
FROM BI_MODEL.HECHO_CUPON 
WHERE HECHO_CUPON_CUPON_TIPO_NRO = 2
GROUP BY HECHO_CUPON_TIEMPO
GO

CREATE VIEW BI_MODEL.PROMEDIO_VALOR_ASEGURADO_X_TIPO_PAQUETE_X_MES AS
    SELECT (SUM(HECHO_MENSAJERIA_VALOR_ASEGURADO_PROMEDIO)/COUNT(HECHO_MENSAJERIA_VALOR_ASEGURADO_PROMEDIO)) AS PROMEDIO_VALOR_ASEGURADO,
    t_paquete.TIPO_PAQUETE_NOMBRE AS TIPO_PAQUETE,
    t_tiempo.mes AS MES_NRO
     FROM BI_MODEL.HECHO_MENSAJERIA 
        JOIN BI_MODEL.TIPO_PAQUETE t_paquete ON t_paquete.TIPO_PAQUETE_NRO = HECHO_MENSAJERIA_TIPO_PAQUETE
        JOIN BI_MODEL.TIEMPO t_tiempo ON t_tiempo.FECHA = HECHO_MENSAJERIA_TIEMPO
    GROUP BY t_tiempo.mes, t_paquete.TIPO_PAQUETE_NOMBRE;
GO

CREATE VIEW BI_MODEL.RECLAMOS_MENSUALES_LOCALES_DIA_RANGO AS
SELECT 
    SUM(HECHO_RECLAMO_CANTIDAD_RECLAMOS) AS CANT_RECLAMOS,
    t_local.LOCAL_NOMBRE AS LOCAL,
    t_dia.DIA AS DIA,
    t_tiempo.MES AS MES_NRO,
    CONCAT(t_horario.RANGO_HORARIO_INICIO,' - ',t_horario.RANGO_HORARIO_FIN) AS RANGO_HORARIO
FROM BI_MODEL.HECHO_RECLAMO h_reclamo
    JOIN BI_MODEL.TIEMPO t_tiempo ON t_tiempo.FECHA = h_reclamo.HECHO_RECLAMO_TIEMPO
    JOIN BI_MODEL.DIA t_dia ON t_dia.DIA_NRO = HECHO_RECLAMO_DIA_NRO
    JOIN BI_MODEL.LOCAL t_local ON t_local.LOCAL_NRO = HECHO_RECLAMO_LOCAL_NRO
    JOIN BI_MODEL.RANGO_HORARIO t_horario ON t_horario.RANGO_HORARIO_NRO = HECHO_RECLAMO_RANGO_HORARIO_NRO
GROUP BY t_tiempo.MES,t_dia.DIA,t_horario.RANGO_HORARIO_INICIO,t_horario.RANGO_HORARIO_FIN,t_local.LOCAL_NOMBRE
GO

CREATE VIEW BI_MODEL.TIEMPO_PROMEDIO_RECLAMO_SEGUN_TIPO_Y_OPERADOR AS
SELECT    
    SUM(HECHO_RECLAMO_TIEMPO_PROMEDIO_RESOLUCION)/COUNT(HECHO_RECLAMO_TIEMPO_PROMEDIO_RESOLUCION) AS PROMEDIO_TIEMPO_MINUTOS_RESOLUCION,
    t_tiempo.MES AS MES_NRO,
    t_etario.RANGO_ETARIO AS RANGO_ETARIO_OPERADOR,
    t_tipo.TIPO_RECLAMO_NOMBRE AS TIPO_RECLAMO
FROM BI_MODEL.HECHO_RECLAMO h_reclamo
    JOIN BI_MODEL.TIEMPO t_tiempo ON t_tiempo.FECHA = h_reclamo.HECHO_RECLAMO_TIEMPO
    JOIN BI_MODEL.RANGO_ETARIO t_etario ON t_etario.RANGO_ETARIO_NRO = h_reclamo.HECHO_RECLAMO_RANGO_ETARIO_NRO
    JOIN BI_MODEL.TIPO_RECLAMO t_tipo ON t_tipo.TIPO_RECLAMO_NRO = h_reclamo.HECHO_RECLAMO_TIPO_RECLAMO_NRO
GROUP BY t_tiempo.MES,t_tipo.TIPO_RECLAMO_NOMBRE,t_etario.RANGO_ETARIO
GO

IF OBJECT_ID('migrar_bi', 'P') IS NOT NULL
    DROP PROCEDURE migrar_bi;
GO
CREATE PROCEDURE migrar_bi
AS
BEGIN
	BEGIN TRANSACTION
BEGIN TRY
EXEC BI_MIGRAR_TIEMPO;
EXEC BI_MIGRAR_DIA;
EXEC BI_MIGRAR_RANGO_HORARIO;
EXEC BI_MIGRAR_PROVINCIA;
EXEC BI_MIGRAR_LOCALIDAD;
EXEC BI_MIGRAR_RANGO_ETARIO;
EXEC BI_MIGRAR_TIPO_MEDIO_PAGO;
EXEC BI_MIGRAR_LOCAL;
EXEC BI_MIGRAR_CATEGORIA;
EXEC BI_MIGRAR_TIPO_LOCAL;
EXEC BI_MIGRAR_TIPO_MOVILIDAD;
EXEC BI_MIGRAR_TIPO_PAQUETE;
EXEC BI_MIGRAR_PEDIDO_ESTADO;
EXEC BI_MIGRAR_MENSAJERIA_ESTADO;
EXEC BI_MIGRAR_ESTADO_RECLAMO;
EXEC BI_MIGRAR_TIPO_RECLAMO;
EXEC BI_MIGRAR_TIPO_CUPON;
EXEC BI_MIGRAR_TIPO_ENVIO;
EXEC BI_MIGRAR_HECHO_PEDIDO
EXEC BI_MIGRAR_HECHO_RECLAMO;
EXEC BI_MIGRAR_HECHO_CUPON;
EXEC BI_MIGRAR_HECHO_MENSAJERIA;
EXEC BI_MIGRAR_HECHO_ENVIOS;
mostrar_procedures
PRINT '--- Tablas BI migradas correctamente --';
COMMIT TRANSACTION
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION;
THROW 50001, 'No se migraron las tablas BI',1;
END CATCH

END
GO