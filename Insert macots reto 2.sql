create database Refugio;
use Refugio;

create table Mascota(
   codigo_mas int auto_increment primary key,
   nombre varchar(100),
   raza varchar(100),
   genero varchar(20),
   tipo_mas varchar(200)
);

insert into Mascota (nombre, raza, genero, algo_mas)
values 
('Luna', 'Criollo', 'Hembra', 'Vacunada, 2 años'),
('Max', 'Labrador', 'Macho', 'Entrenado en obediencia básica'),
('Kira', 'Bulldog', 'Hembra', 'Necesita medicación diaria'),
('Rocky', 'Pastor Alemán', 'Macho', 'Adoptado recientemente'),
('Milo', 'Poodle', 'Macho', 'Muy juguetón y sociable');
