use TiendaMascota;

/* Punto 1: Incluir en la tabla vacuna el campo de vigencia de la vacuna, crear una función para saber si la vacuna está vigente o está vencida
Punto 2: Crear una función para mostrar el nombre de la mascota, raza y nombre del dueño
3. crear trigger que impade que se elimine un cliente si tiene una mascota registrada
4. trigger que cuando se elimine un cliente lo guarde en una tabla que se llame clientesEliminados
5. en la tabla cliente van a agregar un campo que se llame fecha de actualizacion y crear un trigger cada vez que se actualice un cliente se actualice automaticamente 
ese campo de fecha
*/

alter table vacuna add vigencia date;
update vacuna set vigencia = '2025-12-31' where codigovacuna = 4;
update vacuna set vigencia = '2023-06-30' where codigovacuna = 5;

delimiter //
create function estado_vacuna(fecha date)
returns varchar(15)
begin
    if fecha >= curdate() then
        return 'vigente';
    else
        return 'vencida';
    end if;
end //
delimiter ;

select nombrevacuna, vigencia, estado_vacuna(vigencia) as estado
from vacuna;

/* punto 2: función para mostrar nombre de mascota, raza y dueño */

delimiter //
create function info_mascota(cedula int)
returns varchar(100)
begin
    declare texto varchar(100);
    select concat('mascota: ', m.nombremascota, ', raza: ', m.razamascota, ', dueño: ', c.nombrecliente)
    into texto
    from mascota m, cliente c
    where m.idmascota = c.idmascotafk
    and c.cedulacliente = cedula;
    return texto;
end //
delimiter ;

select info_mascota(1012345678);

delimiter //
create trigger no_borrar_cliente
before delete on cliente
for each row
begin
    if old.idmascotafk is not null then
        signal sqlstate '45000'
        set message_text = 'no se puede eliminar el cliente porque tiene una mascota registrada';
    end if;
end //
delimiter ;

create table clienteseeliminados(
    cedula int,
    nombre varchar(20),
    apellido varchar(20),
    direccion varchar(30),
    telefono varchar(15),
    fechabaja date
);

delimiter //
create trigger guardar_cliente_eliminado
after delete on cliente
for each row
begin
    insert into clienteseeliminados
    values (old.cedulacliente, old.nombrecliente, old.apellidocliente, old.direccioncliente, old.telefono, curdate());
end //
delimiter ;

alter table cliente add fechaactualizacion date;

delimiter //
create trigger actualizar_fecha_cliente
before update on cliente
for each row
begin
    set new.fechaactualizacion = curdate();
end //
delimiter ;

update cliente set nombrecliente = 'carlitos' where cedulacliente = 1012345678;
select * from cliente;

delete from cliente where cedulacliente = 1012345678;
select * from clienteseeliminados;

