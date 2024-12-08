
use feeast;

ALTER TABLE renta ADD estado VARCHAR(20) NOT NULL DEFAULT 'Pendiente';
ALTER TABLE renta ADD comentario VARCHAR(250);
ALTER TABLE renta MODIFY COLUMN estado varchar(20) not null DEFAULT 'Pendiente' AFTER compensacion;
ALTER TABLE renta MODIFY COLUMN comentario varchar(250) null DEFAULT '-' AFTER estado;
ALTER TABLE renta MODIFY COLUMN compensacion decimal(10,0) null DEFAULT 0;

alter table cliente MODIFY COLUMN fechaRegistro DATETIME default current_timestamp();

insert into cliente (username, nombreCliente, CURP, correo, password)
values ('admin', 'admincato', '', 'admincato@gmail.com', 'j');


insert into direccion (direccion, ciudad, estado, codigoPostal, idCliente)
values ('Agrupamiento J # 40', 'Ciudad de México', 'CDMX', '07980', 1),
		('47B', 'Ciudad de México', 'CDMX', '48592', 4), 
		('E33', 'Nezahualcoyotl', 'EdoMex', '48573', 2),
        ('2', 'Naucalpan', 'EdoMex', '42473', 2),
        ('25', 'Ecatepec', 'EdoMex', '22455', 3);
        

insert into cliente (username, nombreCliente, CURP, correo, password)
values ('shiro', 'Shiroi Konig', '572847284858285928', 'shirok@gmail.com', 's'),
	   ('raziek', 'Raziek Djevel', '666666661111111111', 'shirok@gmail.com', 's'),
       ('marietta', 'Malie Decart', '777777777777777777', 'marietd@gmail.com', 'm'),
       ('doby', 'Dobereiner Stanislav', 'EEE8472848DDDDD9FF', 'dobys@gmail.com', 'd');
       
       
insert into renta (fecha, hora, precio, idDireccion, idCliente)
values #(DATE(current_timestamp()), TIME(current_timestamp()), 420.53, 3, 3);
		#(DATE(current_timestamp()), TIME(current_timestamp()), 120.21, 2, 4);
        (DATE(current_timestamp()), TIME(current_timestamp()), 230.59, 4, 2);
        (DATE(current_timestamp()), TIME(current_timestamp()), 740.25, 5, 3);
;


delete  from renta where idRenta = 4;

#	values (current_timestamp(), 'anfiteatro', 4646, 200), (4, 3, 4, '2024-12-20 9:00:00', 'lavanderia', 7383, 33);
#values (1, 1, 1, '2024-12-25 11:00:00', 'Hospital', 4000, 200), (2, 2, 2, '2024-12-24 10:00:00', 'Hotel', 3000, 100);

insert into tipoitem (nombre) values ('silla'), ('mantel'), ('mesa'), ('vaso'), ('inflable');

insert into item (nombreItem, ancho, alto, largo, precio, cantidadDisponible, cantidadTotal, idTipo) 
values  ('silla negra plegable',     35, 150, 35, 12, 22, 30, 1),
		('silla blanca no plegable', 35, 120, 40, 10, 30, 30, 1),
		('mantel rojo satinado',     150, 0, 300, 25, 10, 15, 2),
        ('vaso de unicel mediano',   10, 13, 10, 2, 400, 400, 4);
        
insert into tipo_item_renta (tipo) values ('Renta'), ('Compensacion');

insert into item_renta (idRenta, idItem, cantItem, idTipoItemRenta) 
values (6, 3, 4, 1), (6, 2, 14, 1), (7, 2, 3, 2), (7, 4, 200, 2), (8, 2, 10, 1);


-- Paso 1: Quitar AUTO_INCREMENT
ALTER TABLE item_renta MODIFY idItemRenta  INT NOT NULL;
-- Paso 1: Eliminar la clave primaria existente
ALTER TABLE item_renta DROP PRIMARY KEY;
-- Paso 2: Definir una nueva clave primaria (solo el campo que deseas mantener como clave primaria) Recupera el auto incremento
ALTER TABLE item_renta MODIFY idItemRenta  INT NOT NULL auto_increment primary key;
-- Paso 3: Agregar restricción de unicidad para los dos campos
ALTER TABLE item_renta ADD CONSTRAINT cItemRenta UNIQUE (idRenta, idItem);


select * from renta;
select * from tipo_item_renta;
select * from item;
# delete from item where idItem > 4;
select * from item_renta;

describe item;
describe tipoitem;
describe item_renta;
describe tipo_item_renta;
describe renta;


SELECT * FROM item_renta ir INNER JOIN renta r INNER JOIN item i INNER JOIN tipoitem ti
	WHERE r.idRenta = ir.idRenta AND i.idItem = ir.idItem 
	AND ti.idTipoItem = i.idTipo AND r.idRenta = 6;

SELECT fecha, hora, i.precio, compensacion, comentario, cantitem,
	nombreItem, ancho, alto, largo, r.precio 
	FROM item_renta AS ir, renta AS r, item AS i, tipoitem AS ti
	WHERE r.idRenta = ir.idRenta AND i.idItem = ir.idItem 
	AND ti.idTipoItem = i.idTipo AND r.idRenta = 6;

select * from renta;
SELECT 
    idRenta,
    fecha,
    hora,
    precio,
    compensacion,
    estado
FROM
    renta
WHERE
    estado = 'Pendiente'
        OR estado = 'Aceptado'
ORDER BY fecha ASC , hora ASC;
    



SELECT idRenta, fecha, hora, precio, compensacion, estado
	FROM renta WHERE estado = 'Pendiente' or estado = 'Aceptado'
	ORDER BY fecha ASC, hora ASC;
    
    
SELECT idRenta, fecha, hora, precio, compensacion, estado FROM renta WHERE estado = 'Pendiente' or estado = 'Aceptado' ORDER BY fecha ASC, hora ASC;


update renta set estado = 'Pendiente' where idRenta = 2;

UPDATE renta SET comentario = ? WHERE idRenta = ?;

#DEFAULT 0 DEFAULT -

describe direccion;
describe cliente;
describe renta;
select version();

SELECT * FROM cliente WHERE username = 'doby' AND password = 'd';

SELECT * FROM renta ;

/*
set @fechaHora = "2025-03-23 23:03:23";
set @fechaComp = "2027-2-3 23:03:23";

select date(@fechaHora) as Fecha, date(@fechaHora) as hora where time(@fechaHora) = time(@fechaComp);
*/

SELECT 
    i.idItem,
    i.nombreItem,
    ti.Nombre,
    rri.cantItem
FROM relrentaitem rri INNER JOIN item i INNER JOIN tipoItem ti
WHERE rri.idItem = i.idItem AND i.idTipo = ti.idTipoItem
    AND rri.idRenta = 1 
    ORDER BY cantItem DESC;
    
    
    
    
SELECT idRenta, fecha, hora, precio, compensacion, estado 
	FROM renta WHERE estado = 'Pendiente' or estado = 'Aceptado' 
	ORDER BY fecha ASC, hora ASC;

SELECT idRenta, nombreCliente, fecha, hora, precio, compensacion, estado 
	FROM renta r INNER JOIN cliente c 
    ON r.idCliente = c.idCliente 
    WHERE estado = 'Pendiente' or estado = 'Aceptado'
	ORDER BY fecha ASC, hora ASC;
#  "SELECT idRenta, fecha, hora, precio, compensacion, estado FROM renta WHERE estado = 'Pendiente' or estado = 'Aceptado' ORDER BY fecha ASC, hora ASC";

SELECT * FROM Cliente;

SELECT idRenta, nombreCliente AS Cliente, fecha AS Fecha, 
                             hora AS Hora, precio AS Precio, compensacion AS Compensacion, estado AS Estado 
                             FROM renta r INNER JOIN cliente c  
                             ON r.idCliente = c.idCliente 
                             WHERE Estado = 'Pendiente' or Estado = 'Aceptado'
                             ORDER BY Fecha ASC, Hora ASC;

describe renta;




