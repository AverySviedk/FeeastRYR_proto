drop database if exists feeast;
use feeast;
select * from cliente;
describe cliente;


ALTER TABLE renta ADD estado VARCHAR(20) NOT NULL DEFAULT 'Pendiente';

insert into cliente (idCliente, idDireccion, nombreCliente, correo, CURP, fechaRegistro, password, correoSec)
values(1, 1, 'admin', 'alquilercatoaragon@gmail.com', "DIECIOCHOCARACTERS", null, "admoncat", "danirep@gmail.com");

SELECT * FROM cliente WHERE correo = 'alquilercatoaragon@gmail.com' AND password = 'admoncat';

insert into cliente (idCliente, idDireccion, nombreCliente, correo, CURP, fechaRegistro, password, correoSec)
values(2, 2, 'shiro', 'shiro@gmail.com', "222222222CARACTERS", null, "0", "rev@gmail.com");

describe renta;

insert into renta (idRenta, Cliente_idCliente, idDireccion, fechaHoraRenta, ubicRenta, precio, compensacion)
values (1, 1, 1, '2024-12-25 11:00:00', 'Hospital', 4000, 200), (2, 2, 2, '2024-12-24 10:00:00', 'Hotel', 3000, 100);

insert into direccion (idDireccion, numeroVivienda, calle, codigoPostal, numeroInterior)
values (1, '3', 'Lancaida', 33200, 1), (2, '56', 'Doberenier', 25542, 2);

UPDATE renta SET estado = "Aceptado" WHERE idRenta = 1;

select * from renta;
delete from renta where idRenta = 1 or idRenta = 2;

describe direccion;

SELECT * FROM renta ORDER BY fechaHoraRenta ASC;



show columns from renta;