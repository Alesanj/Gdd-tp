USE GD1C2023
GO

SELECT *
FROM sys.objects
WHERE type IN ('FN', 'IF', 'TF') 

SELECT *
FROM sys.procedures

EXEC borrar_todo

exec crear_tablas
exec migrar_tablas

SELECT DISTINCT PRODUCTO_LOCAL_CODIGO, PRODUCTO_LOCAL_NOMBRE, PRODUCTO_LOCAL_DESCRIPCION, PRODUCTO_LOCAL_PRECIO,PRODUCTO_CANTIDAD FROM gd_esquema.Maestra
        WHERE PRODUCTO_LOCAL_CODIGO IS NOT NULL

		SELECT DISTINCT PRODUCTO_LOCAL_CODIGO FROM gd_esquema.Maestra
        WHERE PRODUCTO_LOCAL_CODIGO IS NOT NULL

		SELECT DISTINCT PRODUCTO_LOCAL_CODIGO, PRODUCTO_LOCAL_DESCRIPCION FROM gd_esquema.Maestra WHERE PRODUCTO_LOCAL_CODIGO IS NOT NULL 
SELECT * FROM gd_esquema.Maestra WHERE PRODUCTO_LOCAL_CODIGO IS NOT NULL ORDER BY PRODUCTO_LOCAL_CODIGO

SELECT * FROM NEW_MODEL.PRODUCTO
SELECT * FROM NEW_MODEL.[LOCAL]
SELECT * FROM NEW_MODEL.HORARIO
SELECT HORARIO_NRO, LOCAL_NOMBRE, DIA_NOMBRE, HORARIO_LOCAL_HORA_APERTURA, HORARIO_LOCAL_HORA_CIERRE FROM NEW_MODEL.HORARIO JOIN NEW_MODEL.[LOCAL] ON LOCAL_NRO = HORARIO_LOCAL_NRO JOIN NEW_MODEL.DIA ON DIA_NRO = HORARIO_DIA_NRO 
order by LOCAL_NOMBRE 


exec crear_tablas

select * from NEW_MODEL.DIA
SELECT DISTINCT dbo.obtenerLocalNro(LOCAL_NOMBRE,LOCAL_DIRECCION) AS HORARIO_LOCAL_NRO, dbo.obtenerDiaNro(HORARIO_LOCAL_DIA) AS HORARIO_LOCAL_DIA, HORARIO_LOCAL_HORA_APERTURA,HORARIO_LOCAL_HORA_CIERRE
FROM gd_esquema.Maestra WHERE LOCAL_NOMBRE IS NOT NULL 


SELECT DISTINCT LOCAL_NOMBRE, LOCAL_DIRECCION, HORARIO_LOCAL_DIA,HORARIO_LOCAL_HORA_APERTURA,HORARIO_LOCAL_HORA_CIERRE 
FROM gd_esquema.Maestra WHERE LOCAL_NOMBRE IS NOT NULL 

PRINT (dbo.obtenerLocalNro('Local n° 1','Avenida Independencia2874'))
PRINT (dbo.obtenerDiaNro('Domingo'))

 SELECT DISTINCT dbo.obtenerTipoLocalNro(LOCAL_TIPO),dbo.obtenerLocalidadNro(LOCAL_PROVINCIA,LOCAL_LOCALIDAD), LOCAL_NOMBRE, LOCAL_DESCRIPCION, LOCAL_DIRECCION
FROM gd_esquema.Maestra WHERE LOCAL_NOMBRE IS NOT NULL 

SELECT * FROM NEW_MODEL.[LOCAL] ORDER BY LOCAL_NOMBRE
SELECT * FROM NEW_MODEL.[PRODUCTO]


exec crear_tablas