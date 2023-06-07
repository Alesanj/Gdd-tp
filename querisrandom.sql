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

EXEC crear_tablas
exec migrar_tablas


SELECT DISTINCT LOCAL_NOMBRE, LOCAL_DIRECCION PRODUCTO_LOCAL_CODIGO FROM gd_esquema.Maestra where PRODUCTO_LOCAL_CODIGO IS NOT NULL 
ORDER BY LOCAL_NOMBRE

SELECT DISTINCT REPARTIDOR_DNI, LOCAL_NOMBRE, LOCAL_LOCALIDAD, PEDIDO_NRO FROM gd_esquema.Maestra WHERE REPARTIDOR_DNI IS NOT NULL ORDER BY  REPARTIDOR_DNI, LOCAL_NOMBRE
SELECT DISTINCT REPARTIDOR_DNI, LOCAL_NOMBRE, ENVIO_MENSAJERIA_LOCALIDAD, ENVIO_MENSAJERIA_NRO FROM gd_esquema.Maestra WHERE REPARTIDOR_DNI IS NOT NULL ORDER BY  REPARTIDOR_DNI, LOCAL_NOMBRE

SELECT DISTINCT REPARTIDOR_DNI, LOCAL_NOMBRE, LOCAL_LOCALIDAD, ENVIO_MENSAJERIA_LOCALIDAD FROM gd_esquema.Maestra WHERE REPARTIDOR_DNI IS NOT NULL ORDER BY  REPARTIDOR_DNI, LOCAL_NOMBRE

-- ESTA CONSULTA NOS DEVUELVE UNA ESPECIE "HISTORIAL", DE LAS LOCALIDADES DONDE ESTUVO TRABAJANDO EL REPARTIDOR, YA SEA POR PEDIDO O POR ENVIO, "LA MAS ACTUAL" ACTUAL DEBERIA SER LA LOCALIDAD ACTIVA, EL RESTO NO
-- PODEMOS USAR LA FECHA O FECHA DE ENTREGA COMO ULTIMO LUGAR DONDE ESTUVO EL REPARTIDOR

SELECT DISTINCT PEDIDO_NRO, REPARTIDOR_DNI, LOCAL_NOMBRE, LOCAL_LOCALIDAD, PEDIDO_FECHA ,PEDIDO_FECHA_ENTREGA FROM gd_esquema.Maestra WHERE REPARTIDOR_DNI IS NOT NULL ORDER BY  REPARTIDOR_DNI, LOCAL_NOMBRE

SELECT DISTINCT PEDIDO_NRO, REPARTIDOR_DNI, PEDIDO_FECHA, PEDIDO_FECHA_ENTREGA FROM gd_esquema.Maestra WHERE PEDIDO_NRO IS NOT NULL ORDER BY  PEDIDO_FECHA DESC
-- ESTA FUNCION NOS  ORDENA LOS PEDIDOS POR FECHA EN ORDEN DESCENDENTE Y SELECCIONANDO EL PRIMERO OBTENEMOS EL MAS ACTUAL 

SELECT * FROM(
SELECT DISTINCT PEDIDO_NRO AS NRO_OP,LOCAL_PROVINCIA AS PROVINCIA, LOCAL_LOCALIDAD AS LOCALIDAD, REPARTIDOR_DNI, PEDIDO_FECHA AS FECHA FROM gd_esquema.Maestra WHERE PEDIDO_NRO IS NOT NULL
UNION 
SELECT DISTINCT ENVIO_MENSAJERIA_NRO AS NRO_OP, ENVIO_MENSAJERIA_PROVINCIA AS PROVINCIA, ENVIO_MENSAJERIA_LOCALIDAD AS LOCALIDAD, REPARTIDOR_DNI, ENVIO_MENSAJERIA_FECHA AS FECHA FROM gd_esquema.Maestra WHERE ENVIO_MENSAJERIA_NRO IS NOT NULL
) T WHERE T.REPARTIDOR_DNI = 1295290
ORDER BY FECHA DESC 

SELECT * FROM NEW_MODEL.ALTA

-- ESTE UNION NOS DA LOS ENVIOS + LOS PEDIDOS CON SUS FECHAS, TODOS EN UNA SOLA TABLA, SI ORDENAMOS POR DESC OBTENDREMOS LA MAS ACTUAL


CREATE TABLE #temp (
    REPARTIDOR_DNI nvarchar(255),
    LOCALIDAD nvarchar(255),
)

insert into #temp (REPARTIDOR_DNI,LOCALIDAD)
SELECT DISTINCT REPARTIDOR_DNI, LOCAL_LOCALIDAD AS LOCALIDAD FROM gd_esquema.Maestra WHERE PEDIDO_NRO IS NOT NULL
UNION
SELECT DISTINCT REPARTIDOR_DNI, ENVIO_MENSAJERIA_LOCALIDAD AS LOCALIDAD FROM gd_esquema.Maestra WHERE ENVIO_MENSAJERIA_NRO IS NOT NULL

select * from NEW_MODEL.USUARIO
SELECT * FROM #temp
SELECT DISTINCT * FROM #temp

DROP TABLE #temp

SELECT DISTINCT MEDIO_PAGO_TIPO FROM gd_esquema.Maestra
exec crear_tablas

SELECT * FROM NEW_MODEL.TARJETA
SELECT * FROM NEW_MODEL.MEDIO_PAGO

SELECT DISTINCT PEDIDO_NRO, MEDIO_PAGO_TIPO,MARCA_TARJETA FROM gd_esquema.Maestra WHERE PEDIDO_NRO IS NOT NULL
UNION
SELECT DISTINCT ENVIO_MENSAJERIA_NRO, MEDIO_PAGO_TIPO,MARCA_TARJETA,MEDIO_PAGO_NRO_TARJETA FROM gd_esquema.Maestra WHERE ENVIO_MENSAJERIA_NRO IS NOT NULL

SELECT
    MEDIO_PAGO_TIPO,
    MARCA_TARJETA,
    MEDIO_PAGO_NRO_TARJETA
FROM (
    SELECT DISTINCT PEDIDO_NRO, MEDIO_PAGO_TIPO, MARCA_TARJETA, MEDIO_PAGO_NRO_TARJETA
    FROM gd_esquema.Maestra WHERE PEDIDO_NRO IS NOT NULL
) pagos
    
WHERE
    PEDIDO_NRO IS NOT NULL;


SELECT DISTINCT MEDIO_PAGO_TIPO,MARCA_TARJETA,MEDIO_PAGO_NRO_TARJETA FROM gd_esquema.Maestra WHERE PEDIDO_NRO IS NOT NULL
UNION
SELECT DISTINCT MEDIO_PAGO_TIPO,MARCA_TARJETA,MEDIO_PAGO_NRO_TARJETA FROM gd_esquema.Maestra WHERE ENVIO_MENSAJERIA_NRO IS NOT NULL

SELECT * FROM NEW_MODEL.PEDIDO_ESTADO

EXEC borrar_todo
exec crear

SELECT * FROM NEW_MODEL.PEDIDO_ENVIO

SELECT DISTINCT PEDIDO_NRO, dbo.obtenerPedidoEnvioNro(dbo.obtenerRepartidorNro(82881808), '2023-02-10 14:00:00.087'), dbo.obtenerPedidoEstadoNro('Estado Mensajeria Entregado'), dbo.obtenerUsuarioNro(18172074), PEDIDO_TOTAL_CUPONES, PEDIDO_TOTAL_SERVICIO, PEDIDO_PROPINA, PEDIDO_PRECIO_ENVIO, PEDIDO_TARIFA_SERVICIO, PEDIDO_TOTAL_PRODUCTOS, PEDIDO_CALIFICACION, PEDIDO_TIEMPO_ESTIMADO_ENTREGA FROM gd_esquema.Maestra
WHERE PEDIDO_NRO IS NOT NULL

SELECT DISTINCT PEDIDO_NRO, (
    SELECT PEDIDO_ENVIO_NRO 
    FROM NEW_MODEL.PEDIDO_ENVIO 
    WHERE PEDIDO_ENVIO_REPARTIDOR_NRO = 237 AND PEDIDO_ENVIO_FECHA = CONVERT(datetime, '2023-02-10 14:00:00.087', 121))
   , PEDIDO_TOTAL_CUPONES, PEDIDO_TOTAL_SERVICIO, PEDIDO_PROPINA, PEDIDO_PRECIO_ENVIO, PEDIDO_TARIFA_SERVICIO, PEDIDO_TOTAL_PRODUCTOS, PEDIDO_CALIFICACION, PEDIDO_TIEMPO_ESTIMADO_ENTREGA FROM gd_esquema.Maestra
WHERE PEDIDO_NRO IS NOT NULL
ORDER BY 2

SELECT DISTINCT * FROM NEW_MODEL.PEDIDO_ENVIO WHERE PEDIDO_ENVIO_REPARTIDOR_NRO = 456 AND CAST(PEDIDO_ENVIO_FECHA as DATE) = '2014-02-07' ORDER BY PEDIDO_ENVIO_FECHA
print(dbo.obtenerPedidoEnvioNro(dbo.obtenerRepartidorNro(82881808), '2023-02-03 08:30:00.203'))
print(dbo.obtenerRepartidorNro(82881808))
                
SELECT * FROM NEW_MODEL.PEDIDO_ENVIO
WHERE PEDIDO_ENVIO_FECHA = CONVERT(datetime, '2023-02-10 14:00:00.087', 121)

EXEC borrar_todo

SELECT DISTINCT PEDIDO_NRO, MEDIO_PAGO_TIPO,MARCA_TARJETA,MEDIO_PAGO_NRO_TARJETA FROM gd_esquema.Maestra WHERE PEDIDO_NRO IS NOT NULL

SELECT DISTINCT
            PEDIDO_NRO,
            dbo.obtenerMedioPagoTipoNro(MEDIO_PAGO_TIPO),
        CASE
            WHEN MEDIO_PAGO_TIPO = 'Efectivo' THEN NULL
            ELSE dbo.obtenerTarjetaNro(dbo.obtenerMarcaTarjetaNro(MARCA_TARJETA),MEDIO_PAGO_NRO_TARJETA)
        END
        FROM gd_esquema.Maestra

        exec crear_tablas

        SELECT * FROM NEW_MODEL.PEDIDO_ENVIO


INSERT INTO NEW_MODEL.PEDIDO(PEDIDO_NRO, PEDIDO_ENVIO_NRO, PEDIDO_ESTADO_NRO, PEDIDO_USUARIO_NRO, PEDIDO_TOTAL_CUPONES, PEDIDO_TOTAL_SERVICIO, PEDIDO_TOTAL_PRODUCTOS, PEDIDO_CALIFICACION, PEDIDO_TIEMPO_ESTIMADO)
SELECT DISTINCT PEDIDO_NRO, dbo.obtenerPedidoEnvioNro(dbo.obtenerRepartidorNro(REPARTIDOR_DNI), PEDIDO_FECHA), dbo.obtenerPedidoEstadoNro(PEDIDO_ESTADO), dbo.obtenerUsuarioNro(USUARIO_DNI), PEDIDO_TOTAL_CUPONES, PEDIDO_TOTAL_SERVICIO, PEDIDO_TOTAL_PRODUCTOS, PEDIDO_CALIFICACION , PEDIDO_TIEMPO_ESTIMADO_ENTREGA FROM gd_esquema.Maestra
WHERE PEDIDO_NRO IS NOT NULL

SELECT DISTINCT PEDIDO_NRO, (REPARTIDOR_DNI), PEDIDO_FECHA, PEDIDO_ESTADO, (USUARIO_DNI), PEDIDO_TOTAL_CUPONES, PEDIDO_TOTAL_SERVICIO, PEDIDO_TOTAL_PRODUCTOS, PEDIDO_CALIFICACION , PEDIDO_TIEMPO_ESTIMADO_ENTREGA FROM gd_esquema.Maestra
WHERE PEDIDO_NRO IS NOT NULL

SELECT DISTINCT PEDIDO_NRO, dbo.obtenerPedidoEnvioNro(dbo.obtenerRepartidorNro(REPARTIDOR_DNI), PEDIDO_FECHA), dbo.obtenerPedidoEstadoNro(PEDIDO_ESTADO), dbo.obtenerUsuarioNro(USUARIO_DNI), PEDIDO_TOTAL_CUPONES, PEDIDO_TOTAL_SERVICIO, PEDIDO_TOTAL_PRODUCTOS, PEDIDO_CALIFICACION , PEDIDO_TIEMPO_ESTIMADO_ENTREGA FROM gd_esquema.Maestra
WHERE PEDIDO_NRO IS NOT NULL

PRINT(dbo.obtenerPedidoEnvioNro(dbo.obtenerRepartidorNro(82881808), CONVERT(datetime, '2023-02-10 14:00:00.087', 121)))
PRINT(dbo.obtenerRepartidorNro(82881808))
PRINT(dbo.obtenerPedidoEstadoNro('Estado Mensajeria Entregado'))
PRINT(dbo.obtenerUsuarioNro(18172074))

SELECT DISTINCT PEDIDO_NRO, dbo.obtenerPedidoEnvioNro(456, PEDIDO_FECHA), PEDIDO_TOTAL_CUPONES, PEDIDO_TOTAL_SERVICIO, PEDIDO_TOTAL_PRODUCTOS, PEDIDO_CALIFICACION , PEDIDO_TIEMPO_ESTIMADO_ENTREGA FROM gd_esquema.Maestra
WHERE PEDIDO_NRO IS NOT NULL

SELECT DISTINCT
    m.PEDIDO_NRO,
    pe.PEDIDO_ENVIO_NRO,
    m.PEDIDO_TOTAL_CUPONES,
    m.PEDIDO_TOTAL_SERVICIO,
    m.PEDIDO_TOTAL_PRODUCTOS,
    m.PEDIDO_CALIFICACION,
    m.PEDIDO_TIEMPO_ESTIMADO_ENTREGA
FROM
    gd_esquema.Maestra m
JOIN
    NEW_MODEL.PEDIDO_ENVIO pe ON pe.PEDIDO_ENVIO_REPARTIDOR_NRO = 456
                               AND CONVERT(datetime, pe.PEDIDO_ENVIO_FECHA, 121) = CONVERT(datetime, m.PEDIDO_FECHA, 121)
WHERE
    m.PEDIDO_NRO IS NOT NULL;


SELECT * FROM NEW_MODEL.PEDIDO_ENVIO WHERE PEDIDO_ENVIO_REPARTIDOR_NRO = 456 AND PEDIDO_ENVIO_FECHA = '2023-02-10 14:00:00.087'

SELECT * FROM NEW_MODEL.PEDIDO_ENVIO WHERE PEDIDO_ENVIO_REPARTIDOR_NRO = 456 AND PEDIDO_ENVIO_FECHA = CONVERT(datetime, '2023-02-10 14:00:00.087', 121)

SELECT DISTINCT PEDIDO_NRO,PEDIDO_FECHA, PEDIDO_TOTAL_CUPONES, PEDIDO_TOTAL_SERVICIO, PEDIDO_TOTAL_PRODUCTOS, PEDIDO_CALIFICACION , PEDIDO_TIEMPO_ESTIMADO_ENTREGA FROM gd_esquema.Maestra
WHERE PEDIDO_NRO IS NOT NULL AND REPARTIDOR_DNI = 82881808 AND PEDIDO_FECHA = CONVERT(datetime, '2023-02-10 14:00:00.087', 121) ORDER BY PEDIDO_FECHA



exec borrar_todo

exec mostrar_funciones
exec mostrar_procedures


	SELECT DISTINCT ENVIO_MENSAJERIA_NRO,dbo.obtenerUsuarioNro(USUARIO_DNI),dbo.obtenerMensajeriaNro(ENVIO_MENSAJERIA_DIR_DEST,ENVIO_MENSAJERIA_FECHA,ENVIO_MENSAJERIA_KM),dbo.obtenerPaqueteNro(PAQUETE_TIPO),dbo.obtenerEstadoNro(ENVIO_MENSAJERIA_ESTADO),ENVIO_MENSAJERIA_PRECIO_SEGURO,ENVIO_MENSAJERIA_PRECIO_ENVIO,ENVIO_MENSAJERIA_PROPINA ,ENVIO_MENSAJERIA_TOTAL ,ENVIO_MENSAJERIA_VALOR_ASEGURADO ,ENVIO_MENSAJERIA_CALIFICACION,ENVIO_MENSAJERIA_TIEMPO_ESTIMADO
 FROM gd_esquema.Maestra
	WHERE ENVIO_MENSAJERIA_NRO IS NOT NULL AND ENVIO_MENSAJERIA_TOTAL IS NOT NULL AND ENVIO_MENSAJERIA_PRECIO_SEGURO = 389.03