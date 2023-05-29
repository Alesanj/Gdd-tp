USE GD1C2023
GO

-- CREACION DEL SCHEMA --

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'NEW_MODEL')
BEGIN
    EXEC('CREATE SCHEMA NEW_MODEL');
END

-- CREACION DE TABLAS --

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'dropear_tablas')
DROP PROCEDURE dropear_tablas
GO
CREATE PROCEDURE dropear_tablas
AS
BEGIN
BEGIN TRANSACTION
BEGIN TRY
IF OBJECT_ID('NEW_MODEL.MENSAJERIA', 'U') IS NOT NULL DROP TABLE NEW_MODEL.MENSAJERIA
IF OBJECT_ID('NEW_MODEL.ENVIO_MENSAJERIA', 'U') IS NOT NULL DROP TABLE NEW_MODEL.ENVIO_MENSAJERIA
IF OBJECT_ID('NEW_MODEL.MENSAJERIA_ESTADO', 'U') IS NOT NULL DROP TABLE NEW_MODEL.MENSAJERIA_ESTADO
IF OBJECT_ID('NEW_MODEL.PAQUETE', 'U') IS NOT NULL DROP TABLE NEW_MODEL.PAQUETE
IF OBJECT_ID('NEW_MODEL.TIPO_PAQUETE', 'U') IS NOT NULL DROP TABLE NEW_MODEL.TIPO_PAQUETE
IF OBJECT_ID('NEW_MODEL.CUPON_RECLAMO', 'U') IS NOT NULL DROP TABLE NEW_MODEL.CUPON_RECLAMO
IF OBJECT_ID('NEW_MODEL.CUPON', 'U') IS NOT NULL DROP TABLE NEW_MODEL.CUPON
IF OBJECT_ID('NEW_MODEL.CUPON_TIPO', 'U') IS NOT NULL DROP TABLE NEW_MODEL.CUPON_TIPO
IF OBJECT_ID('NEW_MODEL.RECLAMO', 'U') IS NOT NULL DROP TABLE NEW_MODEL.RECLAMO
IF OBJECT_ID('NEW_MODEL.OPERADOR', 'U') IS NOT NULL DROP TABLE NEW_MODEL.OPERADOR
IF OBJECT_ID('NEW_MODEL.ESTADO_RECLAMO', 'U') IS NOT NULL DROP TABLE NEW_MODEL.ESTADO_RECLAMO
IF OBJECT_ID('NEW_MODEL.TIPO_RECLAMO', 'U') IS NOT NULL DROP TABLE NEW_MODEL.TIPO_RECLAMO
IF OBJECT_ID('NEW_MODEL.ITEM', 'U') IS NOT NULL DROP TABLE NEW_MODEL.ITEM
IF OBJECT_ID('NEW_MODEL.LOCAL_PRODUCTO', 'U') IS NOT NULL DROP TABLE NEW_MODEL.LOCAL_PRODUCTO
IF OBJECT_ID('NEW_MODEL.PRODUCTO', 'U') IS NOT NULL DROP TABLE NEW_MODEL.PRODUCTO
IF OBJECT_ID('NEW_MODEL.HORARIO', 'U') IS NOT NULL DROP TABLE NEW_MODEL.HORARIO
IF OBJECT_ID('NEW_MODEL.DIA', 'U') IS NOT NULL DROP TABLE NEW_MODEL.DIA
IF OBJECT_ID('NEW_MODEL.LOCAL', 'U') IS NOT NULL DROP TABLE NEW_MODEL.LOCAL
IF OBJECT_ID('NEW_MODEL.TIPO_LOCAL', 'U') IS NOT NULL DROP TABLE NEW_MODEL.TIPO_LOCAL
IF OBJECT_ID('NEW_MODEL.CATEGORIA', 'U') IS NOT NULL DROP TABLE NEW_MODEL.CATEGORIA
IF OBJECT_ID('NEW_MODEL.PEDIDO', 'U') IS NOT NULL DROP TABLE NEW_MODEL.PEDIDO
IF OBJECT_ID('NEW_MODEL.MEDIO_PAGO', 'U') IS NOT NULL DROP TABLE NEW_MODEL.MEDIO_PAGO
IF OBJECT_ID('NEW_MODEL.MEDIO_PAGO_TIPO', 'U') IS NOT NULL DROP TABLE NEW_MODEL.MEDIO_PAGO_TIPO
IF OBJECT_ID('NEW_MODEL.PEDIDO_ESTADO', 'U') IS NOT NULL DROP TABLE NEW_MODEL.PEDIDO_ESTADO
IF OBJECT_ID('NEW_MODEL.PEDIDO_ENVIO', 'U') IS NOT NULL DROP TABLE NEW_MODEL.PEDIDO_ENVIO
IF OBJECT_ID('NEW_MODEL.DIRECCION_USUARIO', 'U') IS NOT NULL DROP TABLE NEW_MODEL.DIRECCION_USUARIO
IF OBJECT_ID('NEW_MODEL.ALTA', 'U') IS NOT NULL DROP TABLE NEW_MODEL.ALTA
IF OBJECT_ID('NEW_MODEL.REPARTIDOR', 'U') IS NOT NULL DROP TABLE NEW_MODEL.REPARTIDOR
IF OBJECT_ID('NEW_MODEL.TIPO_MOVILIDAD', 'U') IS NOT NULL DROP TABLE NEW_MODEL.TIPO_MOVILIDAD
IF OBJECT_ID('NEW_MODEL.USUARIO', 'U') IS NOT NULL DROP TABLE NEW_MODEL.USUARIO
IF OBJECT_ID('NEW_MODEL.LOCALIDAD', 'U') IS NOT NULL DROP TABLE NEW_MODEL.LOCALIDAD
IF OBJECT_ID('NEW_MODEL.PROVINCIA', 'U') IS NOT NULL DROP TABLE NEW_MODEL.PROVINCIA
PRINT('Tablas dropeadas')
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION;
THROW 50001, 'Error al hacer DROP TABLAS',1;
END CATCH
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'crear_tablas')
DROP PROCEDURE crear_tablas
GO
CREATE PROCEDURE crear_tablas
AS
BEGIN
	EXEC dropear_tablas;
	IF OBJECT_ID('NEW_MODEL.PROVINCIA', 'U') IS NULL
    CREATE TABLE NEW_MODEL.PROVINCIA(
	PROVINCIA_NRO int IDENTITY PRIMARY KEY,
	PROVINCIA_NOMBRE nvarchar(255) NOT NULL UNIQUE
	);

    IF OBJECT_ID('NEW_MODEL.LOCALIDAD', 'U') IS NULL
    CREATE TABLE NEW_MODEL.LOCALIDAD(
        LOCALIDAD_NRO int IDENTITY PRIMARY KEY,
        LOCALIDAD_PRIVINCIA_NRO int REFERENCES NEW_MODEL.PROVINCIA,
        LOCALIDAD_NOMBRE nvarchar(255) NOT NULL,
    );

    IF OBJECT_ID('NEW_MODEL.USUARIO', 'U') IS NULL
    CREATE TABLE NEW_MODEL.USUARIO(
        USUARIO_NRO int IDENTITY PRIMARY KEY,
        USUARIO_NOMBRE nvarchar(255) NOT NULL,
        USUARIO_APELLIDO nvarchar(255) NOT NULL,
        USUARIO_DNI decimaL(18,0) NOT NULL UNIQUE,
        USUARIO_FECHA_REGISTRO datetime2(3) NOT NULL,  
        USUARIO_TELEFONO decimal(18, 0) NOT NULL,
        USUARIO_MAIL nvarchar(255) NOT NULL UNIQUE,      
        USUARIO_FECHA_NAC date NOT NULL
    );

    IF OBJECT_ID('NEW_MODEL.TIPO_MOVILIDAD', 'U') IS NULL
    CREATE TABLE NEW_MODEL.TIPO_MOVILIDAD(
    TIPO_MOVILIDAD_NRO int IDENTITY PRIMARY KEY,
    TIPO_MOVILIDAD_NOMBRE nvarchar(50) NOT NULL UNIQUE
    );

    IF OBJECT_ID('NEW_MODEL.REPARTIDOR', 'U') IS NULL
    CREATE TABLE NEW_MODEL.REPARTIDOR(
        REPARTIDOR_NRO int IDENTITY PRIMARY KEY,
        REPARTIDOR_TIPO_MOVILIDAD_NRO int REFERENCES NEW_MODEL.TIPO_MOVILIDAD,
        REPARTIDOR_NOMBRE nvarchar(255) NOT NULL,
        REPARTIDOR_APELLIDO nvarchar(255) NOT NULL,
        REPARTIDOR_DNI decimal(18, 0) NOT NULL UNIQUE,
        REPARTIDOR_TELEFONO decimal(18, 0) NOT NULL,
        REPARTIDOR_DIRECCION nvarchar(255) NOT NULL,
        REPARTIDOR_EMAIL nvarchar(255) NOT NULL UNIQUE,
        REPARTIDOR_FECHA_NAC date NOT NULL,
    );

    IF OBJECT_ID('NEW_MODEL.ALTA', 'U') IS NULL
    CREATE TABLE NEW_MODEL.ALTA(
        ALTA_REPARTIDOR_NRO int REFERENCES NEW_MODEL.REPARTIDOR,
        ALTA_LOCALIDAD_NRO int REFERENCES NEW_MODEL.LOCALIDAD,
        ALTA_ACTIVA BIT NOT NULL,
        PRIMARY KEY(ALTA_REPARTIDOR_NRO,ALTA_LOCALIDAD_NRO)
    );

    IF OBJECT_ID('NEW_MODEL.DIRECCION_USUARIO', 'U') IS NULL
    CREATE TABLE NEW_MODEL.DIRECCION_USUARIO(
        DIRECCION_USUARIO_NRO int IDENTITY PRIMARY KEY,
        DIRECCION_USUARIO_USUARIO_NRO int REFERENCES NEW_MODEL.USUARIO NOT NULL,
        DIRECCION_USUARIO_LOCALIDAD_NRO int REFERENCES NEW_MODEL.LOCALIDAD NOT NULL,
        DIRECCION_USUARIO_NOMBRE nvarchar(50) NOT NULL,
        DIRECCION_USUARIO_DIRECCION nvarchar(255) NOT NULL,
    );


    IF OBJECT_ID('NEW_MODEL.PEDIDO_ENVIO', 'U') IS NULL
    CREATE TABLE NEW_MODEL.PEDIDO_ENVIO(
        PEDIDO_ENVIO_NRO int IDENTITY PRIMARY KEY,
        PEDIDO_ENVIO_REPARTIDOR_NRO int REFERENCES NEW_MODEL.REPARTIDOR,
        PEDIDO_ENVIO_DIRECCION_USUARIO_NRO int REFERENCES NEW_MODEL.DIRECCION_USUARIO NOT NULL,
        PEDIDO_ENVIO_PRECIO decimal(18, 2) DEFAULT 0 NOT NULL,
        PEDIDO_ENVIO_TARIFA_SERVICIO decimal(18, 2) DEFAULT 0 NOT NULL,
        PEDIDO_ENVIO_PROPINA decimal(18, 2) DEFAULT 0 NOT NULL
    );


    IF OBJECT_ID('NEW_MODEL.PEDIDO_ESTADO', 'U') IS NULL
    CREATE TABLE NEW_MODEL.PEDIDO_ESTADO(
        PEDIDO_ESTADO_NRO int IDENTITY PRIMARY KEY,
        PEDIDO_ESTADO nvarchar(50) NOT NULL UNIQUE
    );


    IF OBJECT_ID('NEW_MODEL.MEDIO_PAGO_TIPO', 'U') IS NULL
    CREATE TABLE NEW_MODEL.MEDIO_PAGO_TIPO(
        MEDIO_PAGO_TIPO_NRO int IDENTITY PRIMARY KEY,
        MEDIO_PAGO_TIPO nvarchar(50) NOT NULL UNIQUE
    );


    IF OBJECT_ID('NEW_MODEL.MEDIO_PAGO', 'U') IS NULL
    CREATE TABLE NEW_MODEL.MEDIO_PAGO(
        MEDIO_PAGO_NRO int IDENTITY PRIMARY KEY,
        MEDIO_PAGO_USUARIO_NRO int REFERENCES NEW_MODEL.USUARIO NOT NULL,
        MEDIO_PAGO_TIPO_NRO int REFERENCES NEW_MODEL.MEDIO_PAGO_TIPO NOT NULL,
        MEDIO_PAGO_NRO_TARJETA nvarchar(50) NULL,
        MEDIO_PAGO_MARCA_TARJETA nvarchar(100) NULL
    );


    IF OBJECT_ID('NEW_MODEL.PEDIDO', 'U') IS NULL
    CREATE TABLE NEW_MODEL.PEDIDO(
        PEDIDO_NRO int IDENTITY PRIMARY KEY,
        PEDIDO_PEDIDO_ENVIO_NRO int REFERENCES NEW_MODEL.PEDIDO_ENVIO NULL,
        PEDIDO_ESTADO_NRO int REFERENCES NEW_MODEL.PEDIDO_ESTADO NOT NULL,
        PEDIDO_MEDIO_PAGO_NRO int REFERENCES NEW_MODEL.MEDIO_PAGO NOT NULL,
        PEDIDO_USUARIO_NRO int REFERENCES NEW_MODEL.USUARIO NOT NULL,
        PEDIDO_TOTAL_CUPONES decimal(18, 2) DEFAULT 0 NOT NULL,
        PEDIDO_OBSERV nvarchar(255) NULL,
        PEDIDO_FECHA datetime NOT NULL,
        PEDIDO_FECHA_ENTREGA datetime NOT NULL,
        PEDIDO_TIEMPO_ESTIMADO_ENTREGA decimal(18, 2) NOT NULL,
        PEDIDO_CALIFICACION decimal(18, 0) NULL,
        PEDIDO_TOTAL_SERVICIO decimal(18, 2) NULL,
        PEDIDO_TOTAL_PRODUCTOS decimal(18, 2) NULL
    );

    IF OBJECT_ID('NEW_MODEL.CATEGORIA', 'U') IS NULL
    CREATE TABLE NEW_MODEL.CATEGORIA(
        CATEGORIA_NRO int IDENTITY PRIMARY KEY,
        CATEGORIA_NOMBRE nvarchar(50) NOT NULL UNIQUE,
    );

    IF OBJECT_ID('NEW_MODEL.TIPO_LOCAL', 'U') IS NULL
    CREATE TABLE NEW_MODEL.TIPO_LOCAL(
        TIPO_LOCAL_NRO int IDENTITY PRIMARY KEY,
        TIPO_LOCAL_CATEGORIA_NRO int REFERENCES NEW_MODEL.CATEGORIA NULL,
        TIPO_LOCAL_NOMBRE nvarchar(50) NOT NULL UNIQUE
    );


    IF OBJECT_ID('NEW_MODEL.LOCAL', 'U') IS NULL
    CREATE TABLE NEW_MODEL.LOCAL(
        LOCAL_NRO int IDENTITY PRIMARY KEY,
        LOCAL_TIPO_LOCAL_NRO int REFERENCES NEW_MODEL.TIPO_LOCAL,
        LOCAL_LOCALIDAD_NRO int REFERENCES NEW_MODEL.LOCALIDAD,
        LOCAL_NOMBRE nvarchar(100) NOT NULL,
        LOCAL_DESCRIPCION nvarchar(255) NOT NULL,
        LOCAL_DIRECCION nvarchar(255) NOT NULL,
    );

    IF OBJECT_ID('NEW_MODEL.DIA', 'U') IS NULL
    CREATE TABLE NEW_MODEL.DIA(
        DIA_NRO int IDENTITY PRIMARY KEY,
        DIA_NOMBRE nvarchar(50) NULL,

    );

    IF OBJECT_ID('NEW_MODEL.HORARIO', 'U') IS NULL
    CREATE TABLE NEW_MODEL.HORARIO(
        HORARIO_NRO int IDENTITY PRIMARY KEY,
        HORARIO_LOCAL_NRO int REFERENCES NEW_MODEL.LOCAL,
        HORARIO_DIA_NRO int REFERENCES NEW_MODEL.DIA,
        HORARIO_LOCAL_HORA_APERTURA decimal(18, 0) NULL,
        HORARIO_LOCAL_HORA_CIERRE decimal(18, 0) NULL,
    );


    IF OBJECT_ID('NEW_MODEL.PRODUCTO', 'U') IS NULL
    CREATE TABLE NEW_MODEL.PRODUCTO(
        PRDUCTO_NRO int IDENTITY PRIMARY KEY,
        PRODUCTO_CODIGO nvarchar(50) UNIQUE,
        PRODUCTO_NOMBRE nvarchar(50) NOT NULL,
        PRODUCTO_DESCRIPCION nvarchar(255) NOT NULL,
    );

    IF OBJECT_ID('NEW_MODEL.LOCAL_PRODUCTO', 'U') IS NULL
    CREATE TABLE NEW_MODEL.LOCAL_PRODUCTO(
        LOCAL_PRODUCTO_LOCAL_NRO int REFERENCES NEW_MODEL.LOCAL,
        LOCAL_PRODUCTO_PRODUCTO_NRO int REFERENCES NEW_MODEL.PRODUCTO,
        PRIMARY KEY(LOCAL_PRODUCTO_LOCAL_NRO, LOCAL_PRODUCTO_PRODUCTO_NRO)
    );

    IF OBJECT_ID('NEW_MODEL.ITEM', 'U') IS NULL
    CREATE TABLE NEW_MODEL.ITEM(
        ITEM_LOCAL_PRODUCTO_LOCAL_NRO int,
        ITEM_LOCAL_PRODUCTO_PRODUCTO_NRO int,
        ITEM_PEDIDO_NRO int REFERENCES NEW_MODEL.PEDIDO,
        ITEM_CANTIDAD decimal(18,0) DEFAULT 0 NOT NULL,
        ITEM_PRECIO decimal(18,2) DEFAULT 0 NOT NULL,
        ITEM_TOTAL decimal(18,2) DEFAULT 0 NOT NULL,
        FOREIGN KEY (ITEM_LOCAL_PRODUCTO_LOCAL_NRO, ITEM_LOCAL_PRODUCTO_PRODUCTO_NRO) REFERENCES NEW_MODEL.LOCAL_PRODUCTO(LOCAL_PRODUCTO_LOCAL_NRO, LOCAL_PRODUCTO_PRODUCTO_NRO),
        PRIMARY KEY(ITEM_LOCAL_PRODUCTO_LOCAL_NRO, ITEM_LOCAL_PRODUCTO_PRODUCTO_NRO,ITEM_PEDIDO_NRO)
    );

    IF OBJECT_ID('NEW_MODEL.TIPO_RECLAMO', 'U') IS NULL
    CREATE TABLE NEW_MODEL.TIPO_RECLAMO(
        TIPO_RECLAMO_NRO int IDENTITY PRIMARY KEY,
        TIPO_RECLAMO_NOMBRE nvarchar(50) NOT NULL
    );

    IF OBJECT_ID('NEW_MODEL.ESTADO_RECLAMO', 'U') IS NULL
    CREATE TABLE NEW_MODEL.ESTADO_RECLAMO(
        ESTADO_RECLAMO_NRO int IDENTITY PRIMARY KEY,
        ESTADO_RECLAMO_NOMBRE NVARCHAR(50) NOT NULL
    );

    IF OBJECT_ID('NEW_MODEL.OPERADOR', 'U') IS NULL
    CREATE TABLE NEW_MODEL.OPERADOR(
        OPERADOR_NRO int IDENTITY PRIMARY KEY,
        OPERADOR_RECLAMO_DNI_NUMERO int UNIQUE,
        OPERADOR_RECLAMO_NOMBRE nvarchar(255) NOT NULL,
        OPERADOR_RECLAMO_APELLIDO nvarchar(255) NOT NULL,
        OPERADOR_RECLAMO_TELEFONO decimal(18,0) NOT NULL,
        OPERADOR_RECLAMO_DIRECCION nvarchar(255) NOT NULL,
        OPERADOR_RECLAMO_MAIL nvarchar(255) NOT NULL,
        OPERADOR_RECLAMO_FECHA_NAC datetime NOT NULL
    );

    IF OBJECT_ID('NEW_MODEL.RECLAMO', 'U') IS NULL
    CREATE TABLE NEW_MODEL.RECLAMO(
        RECLAMO_NRO	int IDENTITY PRIMARY KEY,
        RECLAMO_USUARIO_NRO int REFERENCES NEW_MODEL.USUARIO,
        RECLAMO_PEDIDO_NRO int REFERENCES NEW_MODEL.PEDIDO,
        RECLAMO_TIPO_RECLAMO_NRO int REFERENCES NEW_MODEL.TIPO_RECLAMO,
        RECLAMO_ESTADO_RECLAMO_NRO int REFERENCES NEW_MODEL.ESTADO_RECLAMO,
        RECLAMO_OPERADOR_NRO int REFERENCES NEW_MODEL.OPERADOR,
        RECLAMO_FECHA datetime NOT NULL,
        RECLAMO_DESCRIPCION nvarchar(255) NOT NULL,
        RECLAMO_FECHA_SOLUCION datetime NULL,
        RECLAMO_SOLUCION nvarchar(255) NULL,
        RECLAMO_CALIFICACION decimal(18, 0) NOT NULL
    );

    IF OBJECT_ID('NEW_MODEL.CUPON_TIPO', 'U') IS NULL
    CREATE TABLE NEW_MODEL.CUPON_TIPO(
        CUPON_TIPO_NRO int IDENTITY PRIMARY KEY,
        CUPON_TIPO_NOMBRE nvarchar(50) NULL,
    );


    IF OBJECT_ID('NEW_MODEL.CUPON', 'U') IS NULL
    CREATE TABLE NEW_MODEL.CUPON(
        CUPON_NRO int IDENTITY PRIMARY KEY,                         
        CUPON_USUARIO_NRO int REFERENCES NEW_MODEL.USUARIO,
        CUPON_PEDIDO_NRO int REFERENCES NEW_MODEL.PEDIDO,
        CUPON_TIPO_NRO int REFERENCES NEW_MODEL.CUPON_TIPO,
        CUPON_MONTO decimal(18,2) NULL,
        CUPON_FECHA_ALTA datetime NULL,
        CUPON__FECHA_VENCIMIENTO datetime NULL
    );

    IF OBJECT_ID('NEW_MODEL.CUPON_RECLAMO', 'U') IS NULL
    CREATE TABLE NEW_MODEL.CUPON_RECLAMO(
        CUPON_RECLAMO_CUPON_NRO int REFERENCES NEW_MODEL.CUPON,
        CUPON_RECLAMO_RECLAMO_NRO int REFERENCES NEW_MODEL.RECLAMO,
        PRIMARY KEY(CUPON_RECLAMO_CUPON_NRO,CUPON_RECLAMO_RECLAMO_NRO)
    );

    IF OBJECT_ID('NEW_MODEL.TIPO_PAQUETE', 'U') IS NULL
    CREATE TABLE NEW_MODEL.TIPO_PAQUETE(
        TIPO_PAQUETE_NRO int IDENTITY PRIMARY KEY,
        TIPO_PAQUETE_NOMBRE  nvarchar(50) NOT NULL UNIQUE,     
        PAQUETE_ALTO_MAX decimal(18,2) NOT NULL,     
        PAQUETE_ANCHO_MAX decimal(18,2) NOT NULL,     
        PAQUETE_LARGO_MAX decimal(18,2) NOT NULL,     
        PAQUETE_PESO_MAX decimal(18,2) NOT NULL
    );

    IF OBJECT_ID('NEW_MODEL.PAQUETE', 'U') IS NULL
    CREATE TABLE NEW_MODEL.PAQUETE(
        PAQUETE_NRO int IDENTITY PRIMARY KEY,
        PAQUETE_TIPO_PAQUETE_NRO int REFERENCES NEW_MODEL.TIPO_PAQUETE,     
        TIPO_PAQUETE_PRECIO decimal(18,2) NULL
    );

    IF OBJECT_ID('NEW_MODEL.MENSAJERIA_ESTADO', 'U') IS NULL
    CREATE TABLE NEW_MODEL.MENSAJERIA_ESTADO(
        MENSAJERIA_ESTADO_NRO int IDENTITY PRIMARY KEY,
        ENVIO_MENSAJERIA_ESTADO nvarchar(50) NULL,
    );

    IF OBJECT_ID('NEW_MODEL.ENVIO_MENSAJERIA', 'U') IS NULL
    CREATE TABLE NEW_MODEL.ENVIO_MENSAJERIA(
        ENVIO_MENSAJERIA int IDENTITY PRIMARY KEY,
        ENVIO_MENSAJERIA_LOCALIDAD_NRO int REFERENCES NEW_MODEL.LOCALIDAD,
        ENVIO_MENSAJERIA_DIR_ORIG nvarchar(255) NULL,
        ENVIO_MENSAJERIA_DIR_DEST nvarchar(255) NULL,
        ENVIO_MENSAJERIA_TIEMPO_ESTIMADO decimal(18, 2) NULL,
        ENVIO_MENSAJERIA_KM decimal(18, 2) NULL,
        ENVIO_MENSAJERIA_PRECIO_ENVIO decimal(18, 2) NULL,
        ENVIO_MENSAJERIA_PROPINA decimal(18, 2) NULL,
        ENVIO_MENSAJERIA_VALOR_ASEGURADO decimal(18, 2) NULL,
        ENVIO_MENSAJERIA_PRECIO_SEGURO decimal(18, 2) NULL
    );
        
    IF OBJECT_ID('NEW_MODEL.MENSAJERIA', 'U') IS NULL
    CREATE TABLE NEW_MODEL.MENSAJERIA(
        MENSAJERIA_NRO int IDENTITY PRIMARY KEY,
        MENSAJERIA_USUARIO_NRO int REFERENCES NEW_MODEL.USUARIO,
        MENSAJERIA_REPARTIDOR_NRO int REFERENCES NEW_MODEL.REPARTIDOR,
        MENSAJERIA_MEDIO_PAGO_NRO int REFERENCES NEW_MODEL.MEDIO_PAGO,
        MENSAJERIA_PAQUETE_NRO int REFERENCES NEW_MODEL.PAQUETE,
        MENSAJERIA_ENVIO int REFERENCES NEW_MODEL.ENVIO_MENSAJERIA,
        MENSAJERIA_ESTADO int REFERENCES NEW_MODEL.MENSAJERIA_ESTADO,
        MENSAJERIA_TOTAL decimal(18, 2) NULL,
        MENSAJERIA_OBSERV nvarchar(255) NULL,
        ENVIO_MENSAJERIA_FECHA datetime NULL,
        ENVIO_MENSAJERIA_FECHA_ENTREGA datetime NULL,
        ENVIO_MENSAJERIA_TIEMPO_ESTIMADO decimal(18, 2) NULL,
        ENVIO_MENSAJERIA_CALIFICACION decimal(18, 0) NULL,    
    );
    PRINT('tablas creadas')
END
GO

-- CREACION FUNCIONES
IF OBJECT_ID('obtenerProvincia', 'FN') IS NOT NULL
DROP FUNCTION obtenerProvincia;
GO
CREATE FUNCTION obtenerProvincia(@provinciaNombre nvarchar(255)) RETURNS int 
AS
BEGIN
	DECLARE @provinciaNro int;
	SELECT @provinciaNro = PROVINCIA_NRO FROM NEW_MODEL.PROVINCIA WHERE PROVINCIA_NOMBRE = @provinciaNombre;
	RETURN @provinciaNro;
END
GO

IF OBJECT_ID('obtenerTipoMovilidad', 'FN') IS NOT NULL
DROP FUNCTION obtenerTipoMovilidad;
GO
CREATE FUNCTION obtenerTipoMovilidad(@TipoMovilidadNombre nvarchar(50)) RETURNS int 
AS
    BEGIN
        DECLARE @TipoMovilidadId int;
        SELECT @TipoMovilidadId = TIPO_MOVILIDAD_NRO FROM NEW_MODEL.TIPO_MOVILIDAD WHERE TIPO_MOVILIDAD_NOMBRE = @TipoMovilidadNombre;
        RETURN @TipoMovilidadId;
    END
GO

IF OBJECT_ID('obtenerUsuarioNro', 'FN') IS NOT NULL
DROP FUNCTION obtenerUsuarioNro;
GO
CREATE FUNCTION obtenerUsuarioNro(@usuarioDni decimal(18,0)) RETURNS int
 AS
	BEGIN
		DECLARE @usuario_nro int;
		SELECT @usuario_nro = USUARIO_NRO FROM NEW_MODEL.USUARIO WHERE USUARIO_DNI  = @usuarioDni AND USUARIO_NRO IS NOT NULL;
		RETURN @usuario_nro;
	END
GO  

IF OBJECT_ID('obtenerLocalidadNro', 'FN') IS NOT NULL
DROP FUNCTION  obtenerLocalidadNro;
GO
CREATE FUNCTION  obtenerLocalidadNro(@provincia nvarchar(255),@localidad nvarchar(255)) RETURNS int
AS
	BEGIN
		DECLARE @localidad_nro int;
		DECLARE @provincianro int;
		SET @provincianro = dbo.obtenerProvincia(@provincia);
		SELECT @localidad_nro = LOCALIDAD_NRO FROM NEW_MODEL.LOCALIDAD WHERE LOCALIDAD_PRIVINCIA_NRO = @provincianro AND @localidad = LOCALIDAD_NOMBRE AND LOCALIDAD_NRO IS NOT NULL;
		RETURN @localidad_nro;
	END
GO

IF OBJECT_ID('obtenerCategoriaNro', 'FN') IS NOT NULL
DROP FUNCTION obtenerCategoriaNro;
GO
CREATE FUNCTION  obtenerCategoriaNro(@categoria nvarchar(50)) RETURNS int
AS
	BEGIN
		DECLARE @categoriaNro int;
		SELECT @categoriaNro = CATEGORIA_NRO FROM NEW_MODEL.CATEGORIA WHERE CATEGORIA_NOMBRE = @categoria;
		RETURN @categoriaNro;
	END
GO

IF OBJECT_ID('obtenerTipoLocalNro', 'FN') IS NOT NULL
DROP FUNCTION obtenerTipoLocalNro;
GO
CREATE FUNCTION  obtenerTipoLocalNro(@tipoLocal nvarchar(50)) RETURNS int
AS
	BEGIN
		DECLARE @tipoLocalNro int;
		SELECT @tipoLocalNro = TIPO_LOCAL_NRO FROM NEW_MODEL.TIPO_LOCAL WHERE TIPO_LOCAL_NOMBRE = @tipoLocal;
		RETURN @tipoLocalNro;
	END
GO

IF OBJECT_ID('obtenerLocalNro', 'FN') IS NOT NULL
DROP FUNCTION obtenerLocalNro;
GO
CREATE FUNCTION  obtenerLocalNro(@localNombre nvarchar(50), @localDireccion nvarchar(255)) RETURNS int
AS
	BEGIN
		DECLARE @localNro int;
		SELECT @localNro = LOCAL_NRO FROM NEW_MODEL.LOCAL WHERE LOCAL_NOMBRE = @localNombre AND LOCAL_DIRECCION = @localDireccion;
		RETURN @localNro;
	END
GO

IF OBJECT_ID('obtenerDiaNro', 'FN') IS NOT NULL
DROP FUNCTION obtenerDiaNro;
GO
CREATE FUNCTION  obtenerDiaNro(@diaNombre nvarchar(50)) RETURNS int
AS
	BEGIN
		DECLARE @diaNro int;
		SELECT @diaNro = DIA_NRO FROM NEW_MODEL.DIA WHERE DIA_NOMBRE = @diaNombre;
		RETURN @diaNro;
	END
GO

-- CREACION DE PROCEDURESSS
IF OBJECT_ID('MIGRAR_PROVINCIAS', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_PROVINCIAS;
GO
CREATE PROCEDURE MIGRAR_PROVINCIAS
AS
    BEGIN
        INSERT INTO NEW_MODEL.PROVINCIA(PROVINCIA_NOMBRE)
		(SELECT DISTINCT DIRECCION_USUARIO_PROVINCIA AS PROVINCIA_NOMBRE FROM gd_esquema.Maestra WHERE DIRECCION_USUARIO_PROVINCIA IS NOT NULL
		UNION
		SELECT DISTINCT ENVIO_MENSAJERIA_PROVINCIA AS PROVINCIA_NOMBRE FROM gd_esquema.Maestra WHERE ENVIO_MENSAJERIA_PROVINCIA IS NOT NULL
		UNION
		SELECT DISTINCT LOCAL_PROVINCIA AS PROVINCIA_NOMBRE FROM gd_esquema.Maestra  WHERE LOCAL_PROVINCIA IS NOT NULL
		)
        PRINT('PROVINCIAS MIGRADAS')
    END
GO

IF OBJECT_ID('MIGRAR_LOCALIDADES', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_LOCALIDADES;
GO
CREATE PROCEDURE MIGRAR_LOCALIDADES
AS
    BEGIN
        INSERT INTO NEW_MODEL.LOCALIDAD(LOCALIDAD_PRIVINCIA_NRO, LOCALIDAD_NOMBRE)
		SELECT DISTINCT dbo.obtenerProvincia(DIRECCION_USUARIO_PROVINCIA) AS LOCALIDAD_PROVINCIA_NRO, DIRECCION_USUARIO_LOCALIDAD AS LOCALIDAD_NOMBRE FROM gd_esquema.Maestra WHERE DIRECCION_USUARIO_LOCALIDAD IS NOT NULL
		UNION
		SELECT DISTINCT dbo.obtenerProvincia(ENVIO_MENSAJERIA_PROVINCIA) AS LOCALIDAD_PROVINCIA_NRO, ENVIO_MENSAJERIA_LOCALIDAD AS LOCALIDAD_NOMBRE FROM gd_esquema.Maestra WHERE ENVIO_MENSAJERIA_LOCALIDAD IS NOT NULL
		UNION
		SELECT DISTINCT dbo.obtenerProvincia(LOCAL_PROVINCIA), LOCAL_LOCALIDAD AS LOCALIDAD_NOMBRE FROM gd_esquema.Maestra WHERE LOCAL_LOCALIDAD IS NOT NULL;
        PRINT('LOCALIDADES MIGRADAS')
    END
GO

IF OBJECT_ID('MIGRAR_USUARIOS', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_USUARIOS;
GO
CREATE PROCEDURE MIGRAR_USUARIOS
AS
    BEGIN
        INSERT INTO NEW_MODEL.USUARIO(USUARIO_NOMBRE, USUARIO_APELLIDO, USUARIO_DNI, USUARIO_FECHA_REGISTRO, USUARIO_TELEFONO,USUARIO_MAIL, USUARIO_FECHA_NAC)
        SELECT DISTINCT USUARIO_NOMBRE, USUARIO_APELLIDO, USUARIO_DNI, USUARIO_FECHA_REGISTRO, USUARIO_TELEFONO,USUARIO_MAIL, USUARIO_FECHA_NAC
        FROM gd_esquema.Maestra
        PRINT('USUARIOS MIGRADAS')
    END
GO

IF OBJECT_ID('MIGRAR_TIPO_MOVILIDAD', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_TIPO_MOVILIDAD;
GO
CREATE PROCEDURE MIGRAR_TIPO_MOVILIDAD
AS
    BEGIN
        INSERT INTO NEW_MODEL.TIPO_MOVILIDAD(TIPO_MOVILIDAD_NOMBRE)
        SELECT DISTINCT REPARTIDOR_TIPO_MOVILIDAD
        FROM gd_esquema.Maestra
        PRINT('TIPO MOVILIDADES MIGRADAS')
    END
GO


IF OBJECT_ID('MIGRAR_REPARTIDOR', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_REPARTIDOR;
GO
CREATE PROCEDURE MIGRAR_REPARTIDOR
AS
    BEGIN
        INSERT INTO NEW_MODEL.REPARTIDOR(REPARTIDOR_TIPO_MOVILIDAD_NRO ,REPARTIDOR_NOMBRE , REPARTIDOR_APELLIDO ,REPARTIDOR_DNI,REPARTIDOR_TELEFONO, REPARTIDOR_DIRECCION ,REPARTIDOR_EMAIL ,REPARTIDOR_FECHA_NAC)
        SELECT DISTINCT dbo.obtenerTipoMovilidad(REPARTIDOR_TIPO_MOVILIDAD) AS REPARTIDOR_TIPO_MOVILIDAD_NRO ,REPARTIDOR_NOMBRE , REPARTIDOR_APELLIDO ,REPARTIDOR_DNI,REPARTIDOR_TELEFONO,REPARTIDOR_DIRECION AS REPARTIDOR_DIRECCION,REPARTIDOR_EMAIL ,REPARTIDOR_FECHA_NAC 
        FROM gd_esquema.Maestra
        PRINT('REPARTIDORES MIGRADAS')
    END
GO

IF OBJECT_ID('MIGRAR_DIRECCION_USUARIO', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_DIRECCION_USUARIO;
GO
CREATE PROCEDURE MIGRAR_DIRECCION_USUARIO 
AS
    BEGIN
        INSERT INTO NEW_MODEL.DIRECCION_USUARIO(DIRECCION_USUARIO_USUARIO_NRO,DIRECCION_USUARIO_LOCALIDAD_NRO,DIRECCION_USUARIO_NOMBRE,DIRECCION_USUARIO_DIRECCION)
 	    SELECT DISTINCT dbo.obtenerUsuarioNro(USUARIO_DNI),dbo.obtenerLocalidadNro(DIRECCION_USUARIO_PROVINCIA,DIRECCION_USUARIO_LOCALIDAD),DIRECCION_USUARIO_NOMBRE,DIRECCION_USUARIO_DIRECCION FROM gd_esquema.Maestra
 	    WHERE DIRECCION_USUARIO_DIRECCION IS NOT NULL
        PRINT('DIRECCIONES_USUARIO MIGRADAS')
    END
GO

IF OBJECT_ID('MIGRAR_TIPO_LOCAL', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_TIPO_LOCAL;
GO
CREATE PROCEDURE MIGRAR_TIPO_LOCAL 
AS
    BEGIN
        INSERT INTO NEW_MODEL.TIPO_LOCAL(TIPO_LOCAL_CATEGORIA_NRO, TIPO_LOCAL_NOMBRE)
        SELECT DISTINCT dbo.obtenerCategoriaNro(NULL) AS TIPO_LOCAL_CATEGORIA_NRO, LOCAL_TIPO AS TIPO_LOCAL_NOMBRE FROM gd_esquema.Maestra WHERE LOCAL_TIPO IS NOT NULL
        PRINT('TIPO_LOCAL MIGRADAS')
    END
GO

IF OBJECT_ID('MIGRAR_LOCAL', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_LOCAL;
GO
CREATE PROCEDURE MIGRAR_LOCAL 
AS
    BEGIN
        INSERT INTO NEW_MODEL.LOCAL(LOCAL_TIPO_LOCAL_NRO,LOCAL_LOCALIDAD_NRO,LOCAL_NOMBRE,LOCAL_DESCRIPCION,LOCAL_DIRECCION)
        SELECT DISTINCT dbo.obtenerTipoLocalNro(LOCAL_TIPO),dbo.obtenerLocalidadNro(LOCAL_PROVINCIA,LOCAL_LOCALIDAD), LOCAL_NOMBRE, LOCAL_DESCRIPCION, LOCAL_DIRECCION
        FROM gd_esquema.Maestra
        WHERE LOCAL_NOMBRE IS NOT NULL

        PRINT('LOCAL MIGRADAS')
    END
GO

IF OBJECT_ID('MIGRAR_DIA', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_DIA;
GO
CREATE PROCEDURE MIGRAR_DIA 
AS
    BEGIN
        INSERT INTO NEW_MODEL.DIA(DIA_NOMBRE)
        SELECT DISTINCT HORARIO_LOCAL_DIA AS DIA_NOMBRE
        FROM gd_esquema.Maestra
        WHERE HORARIO_LOCAL_DIA IS NOT NULL

        PRINT('DIA MIGRADAS')
    END
GO

IF OBJECT_ID('MIGRAR_HORARIO', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_HORARIO;
GO
CREATE PROCEDURE MIGRAR_HORARIO 
AS
    BEGIN
        INSERT INTO NEW_MODEL.HORARIO(HORARIO_LOCAL_NRO,HORARIO_DIA_NRO,HORARIO_LOCAL_HORA_APERTURA,HORARIO_LOCAL_HORA_CIERRE)
        SELECT DISTINCT dbo.obtenerLocalNro(LOCAL_NOMBRE,LOCAL_DIRECCION) AS HORARIO_LOCAL_NRO, dbo.obtenerDiaNro(HORARIO_LOCAL_DIA) AS HORARIO_LOCAL_DIA, HORARIO_LOCAL_HORA_APERTURA,HORARIO_LOCAL_HORA_CIERRE
        FROM gd_esquema.Maestra

        PRINT('HORARIO MIGRADAS')
    END
GO

IF OBJECT_ID('MIGRAR_PRODUCTO', 'P') IS NOT NULL
    DROP PROCEDURE MIGRAR_PRODUCTO;
GO
CREATE PROCEDURE MIGRAR_PRODUCTO 
AS
    BEGIN
        INSERT INTO NEW_MODEL.PRODUCTO(PRODUCTO_CODIGO,PRODUCTO_NOMBRE,PRODUCTO_DESCRIPCION)
        SELECT DISTINCT PRODUCTO_LOCAL_CODIGO, PRODUCTO_LOCAL_NOMBRE, PRODUCTO_LOCAL_DESCRIPCION FROM gd_esquema.Maestra
        WHERE PRODUCTO_LOCAL_CODIGO IS NOT NULL

        PRINT('PRODUCTO MIGRADAS')
    END
GO


 -- MIGRACION 
IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_tablas')
DROP PROCEDURE migrar_tablas
GO
CREATE PROCEDURE migrar_tablas
AS BEGIN
BEGIN TRANSACTION
BEGIN TRY
EXEC MIGRAR_PROVINCIAS;
EXEC MIGRAR_LOCALIDADES;
EXEC MIGRAR_USUARIOS;
EXEC MIGRAR_TIPO_MOVILIDAD;
EXEC MIGRAR_REPARTIDOR;
EXEC MIGRAR_DIRECCION_USUARIO;
EXEC MIGRAR_TIPO_LOCAL;
EXEC MIGRAR_LOCAL;
EXEC MIGRAR_DIA;
EXEC MIGRAR_HORARIO;
EXEC MIGRAR_PRODUCTO;

PRINT 'Tablas migradas correctamente.';
COMMIT TRANSACTION
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION;
THROW 50001, 'No se migraron las tablas',1;
END CATCH
END
GO

-- BORRAR TODO
IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'borrar_todo')
DROP PROCEDURE borrar_todo
GO
CREATE PROCEDURE borrar_todo
AS BEGIN

EXEC dropear_tablas

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'MIGRAR_PROVINCIAS')
DROP PROCEDURE MIGRAR_PROVINCIAS

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'MIGRAR_LOCALIDADES')
DROP PROCEDURE MIGRAR_LOCALIDADES

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'MIGRAR_TIPO_MOVILIDAD')
DROP PROCEDURE MIGRAR_TIPO_MOVILIDAD

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'MIGRAR_REPARTIDOR')
DROP PROCEDURE MIGRAR_REPARTIDOR

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'MIGRAR_DIRECCION_USUARIO')
DROP PROCEDURE MIGRAR_DIRECCION_USUARIO
    
IF EXISTS(SELECT [name] FROM sys.all_objects WHERE [name] = 'MIGRAR_LOCALIDADES')
DROP PROCEDURE MIGRAR_LOCALIDADES

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'MIGRAR_USUARIOS')
DROP PROCEDURE MIGRAR_USUARIOS

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'MIGRAR_TIPO_MOVILIDAD')
DROP PROCEDURE MIGRAR_TIPO_MOVILIDAD

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'MIGRAR_REPARTIDOR')
DROP PROCEDURE MIGRAR_REPARTIDOR

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'MIGRAR_TIPO_LOCAL')
DROP PROCEDURE MIGRAR_TIPO_LOCAL

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'MIGRAR_LOCAL')
DROP PROCEDURE MIGRAR_LOCAL

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'MIGRAR_DIA')
DROP PROCEDURE MIGRAR_DIA

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'MIGRAR_HORARIO')
DROP PROCEDURE MIGRAR_HORARIO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'MIGRAR_PRODUCTO')
DROP PROCEDURE MIGRAR_PRODUCTO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'crear_tablas')
DROP PROCEDURE crear_tablas

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_tablas')
DROP PROCEDURE migrar_tablas

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'dropear_tablas')
DROP PROCEDURE dropear_tablas

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'borrar_todo')
DROP PROCEDURE borrar_todo

IF EXISTS(SELECT [name] FROM sys.all_objects WHERE [name] = 'obtenerProvincia')
DROP FUNCTION obtenerProvincia

IF EXISTS(SELECT [name] FROM sys.all_objects WHERE [name] = 'obtenerLocalidadNro')
DROP FUNCTION obtenerLocalidadNro

IF EXISTS(SELECT [name] FROM sys.all_objects WHERE [name] = 'obtenerProvincia')
DROP FUNCTION obtenerProvincia

IF EXISTS(SELECT [name] FROM sys.all_objects WHERE [name] = 'obtenerTipoMovilidad')
DROP FUNCTION obtenerTipoMovilidad
    
IF EXISTS(SELECT [name] FROM sys.all_objects WHERE [name] = 'obtenerUsuarioNro')
DROP FUNCTION obtenerUsuarioNro

IF EXISTS(SELECT [name] FROM sys.all_objects WHERE [name] = 'obtenerCategoriaNro')
DROP FUNCTION obtenerCategoriaNro

IF EXISTS(SELECT [name] FROM sys.all_objects WHERE [name] = 'obtenerTipoLocalNro')
DROP FUNCTION obtenerTipoLocalNro

IF EXISTS(SELECT [name] FROM sys.all_objects WHERE [name] = 'obtenerLocalNro')
DROP FUNCTION obtenerLocalNro

IF EXISTS(SELECT [name] FROM sys.all_objects WHERE [name] = 'obtenerDiaNro')
DROP FUNCTION obtenerDiaNro

END
GO