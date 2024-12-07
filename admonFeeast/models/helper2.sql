use feeast;

SELECT * FROM renta ORDER BY fechaHoraRenta ASC;

SELECT * FROM renta 
WHERE estado = 'Pendiente' or estado = 'Aceptado'
ORDER BY fechaHoraRenta ASC;


insert into cliente (idCliente, idDireccion, nombreCliente, correo, CURP, fechaRegistro, password, correoSec)
values (3, 3, 'Marietta', 'marietta@gmail.com', '181818181818181818', current_timestamp(), '1', 'natur@gmail.com'),
	   (4, 4, 'Ar<ovizp', 'arlq@gmail.com', '999999999999999999', current_timestamp(), '10', 'notget@gmail.com');
#values(2, 2, 'shiro', 'shiro@gmail.com', "222222222CARACTERS", null, "0", "rev@gmail.com");

insert into direccion (idDireccion, numeroVivienda, calle, codigoPostal, numeroInterior)
values(3, 122, 'Fontana', 74625, 3), (4, 657, 'Aluro',75523, 8);
#values (1, '3', 'Lancaida', 33200, 1), (2, '56', 'Doberenier', 25542, 2);

describe renta;

insert into renta (idRenta, Cliente_idCliente, idDireccion, fechaHoraRenta, ubicRenta, precio, compensacion)
values (3, 4, 3, current_timestamp(), 'anfiteatro', 4646, 200), (4, 3, 4, '2024-12-20 9:00:00', 'lavanderia', 7383, 33);
#values (1, 1, 1, '2024-12-25 11:00:00', 'Hospital', 4000, 200), (2, 2, 2, '2024-12-24 10:00:00', 'Hotel', 3000, 100);


SELECT 
    i.idItem,
    i.nombreItem,
    ti.Nombre,
    rri.cantItem
FROM relrentaitem rri INNER JOIN item i INNER JOIN tipoItem ti
WHERE rri.idItem = i.idItem AND i.idTipo = ti.idTipoItem
    AND rri.idRenta = 1 
    ORDER BY cantItem DESC;

describe tipoItem;
describe Item;
describe relRentaItem;


