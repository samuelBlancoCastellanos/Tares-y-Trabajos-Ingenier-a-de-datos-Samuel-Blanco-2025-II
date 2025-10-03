/*Sentencias de DDL*/
/*Creacion de base de datos*/
create database TiendaMascota;
/*Habilitar la base de datos*/

use TiendaMascota;
/*Creacion de tablas*/
create table Mascota(
idMascota int primary key,
nombreMascota varchar (15),
generoMascota varchar (15),
razaMascota varchar (15),
cantidad int (10)
);
create table Cliente(
cedulaCliente int primary key,
nombreCliente varchar (15),
apellidoCliente varchar (15),
direccionCliente varchar (10),
telefono int (10),
idMascotaFK int
);
create table Producto(
codigoProducto int primary key,
nombreProducto varchar (15),
marca varchar (15),
precio float,
cedulaClienteFK int
);
create table Vacuna(
codigoVacuna int primary key,
nombreVacuna varchar (15),
dosisVacuna int (10),
enfermedad varchar (15)
);
create table Mascota_Vacuna(
codigoVacunaFK int,
idMascotaFK int,
enfermedad varchar (15)
);

/*crear las relaciones*/
alter table Cliente
add constraint FClienteMascota
foreign key (idMascotaFK)
references Mascota(idMascota);

alter table Producto
add constraint FKProductoCliente
foreign key (cedulaClienteFK)
references Cliente(cedulaCliente);

alter table Mascota_Vacuna
add constraint FKMV
foreign key (idMascotaFK)
references Mascota(idMascota );

alter table Mascota_Vacuna
add constraint FKVM
foreign key (codigoVacunaFK)
references Vacuna(codigoVacuna);

insert into Mascota values (1,'Mateo','M','labrador',2);
INSERT INTO Mascota VALUES
(2,'Luna','F','Golden',1),
(4,'Toby','M','Bulldog',2);
insert into Mascota values(5,'murcielago','F','Pomerania',3),(3,'Marco','M','Pastor Aleman',1);
insert into Vacuna values (4,'Pentavalenta','3','inmuniza contra el moquillo'),(5,'Hexavalenta','1','inmuniza contra el adenovirus 1');
INSERT INTO Cliente (
    cedulaCliente,
    nombreCliente,
    apellidoCliente,
    direccionCliente,
    telefono,
    idMascotaFK
)
VALUES
    (1012345678, 'Carlos', 'Pérez', 'Cll10#20', 3124567890, 1),
    (1023456789, 'Ana', 'Gómez', 'Cra15#30', 3209876543, 2),
    (1034567890, 'Luis', 'Martínez', 'Av45#12', 3156543210, 3),
    (1045678901, 'María', 'Fernández', 'Cll22#11', 3001122334, 4),
    (1056789012, 'Jorge', 'Ramírez', 'Cra9#45', 3112233445, 5);
ALTER TABLE Cliente MODIFY telefono VARCHAR(15);



#UPDTAES CLASE VIERNES 3 DE OCTUBRE APRENDER A HACER UPDATES Y DELETE

select * from Mascota;
update Mascota set nombreMascota="Mateo" where idMascota=1;

start transaction;
delete from Mascota where idMascota=1;
rollback;

show variables like 'autocommit';
show binary logs;

/* Views - Triggers - procedimientos 

*/

create view vistaCliente as select cedulaCliente, nombreCliente, idMascotaFK Cliente;
