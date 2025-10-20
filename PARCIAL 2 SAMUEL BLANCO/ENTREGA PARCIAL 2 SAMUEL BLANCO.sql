#NUMERO 7 SAMUEL BLANCO CASTELLANOS PARCIAL 2 SQL
#ME CORRESPONDE EL RETO 7 

#CREO Y PONGO PARA USAR LA BASE DE DATOS
CREATE database BD_TECHNOVA;
USE BD_TECHNOVA;

#CREO LAS TABLAS ASIGNADAS POR EL EJERCICIO
CREATE TABLE Departamento ( 
id_departamento INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL, 
presupuesto DECIMAL(12,2) CHECK (presupuesto > 0) );

CREATE TABLE Empleado ( 
id_empleado INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(100), 
cargo VARCHAR(50), salario DECIMAL(10,2) CHECK (salario > 0), 
id_departamento INT, 
fecha_ingreso DATE, 
FOREIGN KEY (id_departamento) 
REFERENCES Departamento(id_departamento) );

CREATE TABLE Proyecto ( 
id_proyecto INT AUTO_INCREMENT PRIMARY KEY, 
nombre VARCHAR(100), fecha_inicio DATE, 
presupuesto DECIMAL(12,2), 
id_departamento INT, 
FOREIGN KEY (id_departamento) 
REFERENCES Departamento(id_departamento) );

CREATE TABLE Asignacion ( 
id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
id_empleado INT,
id_proyecto INT, 
horas_trabajadas INT CHECK (horas_trabajadas >= 0), 
FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado),
 FOREIGN KEY (id_proyecto) REFERENCES Proyecto(id_proyecto) );
 
 #TENGO Departamento, Proyecto, Asignacion, Empleado solo quiero verlos despues de crearlos
describe departamento;
describe Empleado;
describe Proyecto;
describe Asignacion;

#INSERTARE LOS DATOS SOLICITADOS POR EL EJERCICIO: (mínimo 3 departamentos, 5 empleados, 3 proyectos y 5 asignaciones).

insert into departamento (id_departamento, nombre, presupuesto) #ME DI CUENTA QUE ID_DEPARTAMENTO ES AUTOINCREMENT
VALUES
('', 'Financiero', 200000000),
('', 'Legal', '400000000'),
('', 'Marketing', '800000000');

insert into Empleado (id_empleado, nombre, cargo, salario, id_departamento, fecha_ingreso)
VALUES
('', 'Tatiana Cabrera', 'Jefe financiera', 10000000, 1, '2020-10-12'),
('', 'Samuel Blanco', 'Abogado jefe', 30000000, 2, '1990-20-15'),
('', 'Esteban Solano', 'Subordinado Financiero', 5000000, 1, '2025-03-10'),
('', 'Maria Jose Bello', 'Directora Marketing', 20000000, 3, '2023-11-20'),
('', 'Isabella Guerrero', 'Diseñadora Grafica', 2000000, 3, '2025-04-15');

#METI MAL LA FECHA DE SAMUEL, para no eliminar hice esa modificacion
UPDATE Empleado SET fecha_ingreso = '1990-10-15' WHERE id_empleado = 2;

insert into Proyecto (id_proyecto, nombre, fecha_inicio, presupuesto, id_departamento)
VALUES
('', 'Demanda que tiene la empresa', '2023-04-10', 4000000000, 2),
('', 'Campaña de Marketing', '2025-10-12', 1000000000, 3),
('', 'Cambio de estrategia Financiera', '2024-10-20', 50000000000, 1);

#METI MAL Lel presupuesto, para no eliminar hice esa modificacion
UPDATE Proyecto SET presupuesto = 50000000 WHERE id_proyecto = 3;

insert into Asignacion (id_asignacion, id_empleado, id_proyecto, horas_trabajadas)
VALUES
('', 1, 3, 30),
('', 2, 1, 10),
('', 3, 3, 20),
('', 4, 2, 15),
('', 5, 2, 40);

#VISUALIZAR CAMPOS
SELECT *
FROM Departamento;
SELECT *
FROM Empleado;
SELECT *
FROM Proyecto;
SELECT *
FROM asignacion;



#ESTE ES MI RETO A RESOLVER UNA VEZ CARGADA LA BASE Y LOS REGISTROS
#No permitir eliminar empleados con horas registradas en proyectos. 
#• Trigger: BEFORE DELETE en Empleado. 
#• Función: TotalHorasEmpleado(id)
#• Procedimiento: IntentarEliminarEmpleado(id) 
#• Transacción: si tiene horas asignadas → ROLLBACK.

#PRIMERO VOY A CREAR LA FUNCION
DELIMITER //
create function TotalHorasEmpleado(p_id_empleado int)
returns int
deterministic
BEGIN
    declare total INT;
    select SUM(horas_trabajadas)
    into total
    from Asignacion
    where id_empleado = p_id_empleado;
    RETURN total;
END //
DELIMITER ;


#VOY A HACER EL PROCEDIMIENTO SE QUE TENGO QUE HACER UNA CONSULTA PARA DETERMINAR SI ELIMINAR O NO EL EMPLEADO O EL REGISTRO SEGUNDA LAS
#HORAS A TRABAJR. LO MEJOR ES HACER UN IF.

DELIMITER //
create procedure IntentarEliminarEmpleado(IN p_id_empleado INT)
BEGIN
    Declare totalHoras INT;
    set totalHoras = TotalHorasEmpleado(p_id_empleado); #REVISE SEGUN LA FUNCION QUE CREE EN EL PASO ANTERIOR
    if totalHoras > 0 then
        select CONCAT('No se puede eliminar el empleado con ID ', p_id_empleado,' porque tiene ', totalHoras, ' horas registradas.') as Mensaje;
        ROLLBACK; #AQUI PUSE EL ROLLBACK
    else
        DELETE FROM Empleado WHERE id_empleado = p_id_empleado;
        END IF;
        
END //
DELIMITER ;

#CREACION DEL TRIGGER
DELIMITER //
Create trigger trg_prevent_delete_empleado
before delete on Empleado
for each row
BEGIN
    declare totalHoras int;
    set totalHoras = TotalHorasEmpleado(old.id_empleado);
    if totalHoras > 0 then
        SIGNAL SQLSTATE '45000' #ESTA LA SAQUE DEL SCRIPT QUE ESTOY USANDO EN EL PARCIAL, ALGUNA VEZ USE ESTA PARA MANDAR MENSAJES 
        SET MESSAGE_TEXT = 'No se puede eliminar el empleado: tiene horas registradas en proyectos.';
    END IF;
END //
DELIMITER ;

#AQUI INTENTO ELIMINAR
CALL IntentarEliminarEmpleado(2);

#INSERTARE UNO SIN ASIGNACION
INSERT INTO Empleado (nombre, cargo, salario, id_departamento, fecha_ingreso)
VALUES ('Nuevo Empleado', 'Asistente', 1500000, 1, '2025-01-10');

SELECT *
from Empleado;
#ELIMINO ESE EMPLEADO CORRECTAMENTE
CALL IntentarEliminarEmpleado(6);


