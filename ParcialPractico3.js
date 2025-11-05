#TALLER 
use Disquera

#RETO 1

db.Bandas.insertOne({
  name: "The Beatles",
  pais: "Reino Unido",
  albums: [
    { title: "Abbey Road", year: 1969, rating: 9.8, sales: 31000000 },
    { title: "Revolver", year: 1966, rating: 9.5, sales: 27000000 },
    { title: "Sgt. Pepper's Lonely Hearts Club Band", year: 1967, rating: 9.7, sales: 32000000 }
  ],
  members: ["John Lennon", "Paul McCartney", "George Harrison", "Ringo Starr"]
})

db.Bandas.insertOne({
  name: "Queen",
  pais: "Reino Unido",
  albums: [
    { title: "A Night at the Opera", year: 1975, rating: 9.6, sales: 25000000 },
    { title: "News of the World", year: 1977, rating: 9.2, sales: 15000000 },
    { title: "The Game", year: 1980, rating: 9.0, sales: 11000000 }
  ],
  members: ["Freddie Mercury", "Brian May", "Roger Taylor", "John Deacon"]
})

db.Bandas.insertOne({
  name: "Daft Punk",
  pais: "Francia",
  albums: [
    { title: "Discovery", year: 2001, rating: 9.4, sales: 11000000 },
    { title: "Random Access Memories", year: 2013, rating: 9.7, sales: 12000000 },
    { title: "Homework", year: 1997, rating: 8.9, sales: 9000000 }
  ],
  members: ["Thomas Bangalter", "Guy-Manuel de Homem-Christo"]
})

#RETO 2 
db.bandas.aggregate([{$unwind: "$albums" },{$group: {_id: "$name", albumcount: { $sum: 1 }, totalSales:{$sum:"$albums.sales"}}}, {$sort: {albumcount: -1}}])

#RETO 3

db.Bandas.aggregate ([{$unwind: "$albums"}, {$project: {Banda:"$name",title:"$albums.title", sales:"albums.sales"}},{$sort}]




