// Select the database to use.
use('mflix');

// // ------------ Ejercicio 1 ---------------
// db.users.insertMany([
//     {"name": "User 1",
//     "email": "User_1@fakegmail.com",
//     "password": "$2b$jhduyhtkV7XL.qlfqCr8CwOxK.mZWS"
//     },
//     {"name": "User 2",
//     "email": "User_2@fakegmail.com",
//     "password": "$2bjhhtkV7XL.qlfqCr8CwOxK.mZWS"
//     },
//     {"name": "User 3",
//     "email": "User_3@fakegmail.com",
//     "password": "$2bjhhtkV7XL.qlfqCrRGAUHDF8CwOxK.mZWS"
//     },
//     {"name": "User 4",
//     "email": "User_4@fakegmail.com",
//     "password": "$2bfdajfqCrRGAUHDF8CwOxK.mZWS"
//     },
//     {"name": "User 5",
//     "email": "User_5@fakegmail.com",
//     "password": "$2b<fjytHGJSagargAUHDF8CwOxK.mZWS"
//     }
// ])

// db.comments.insertMany([
//     {"name": "User 1",
//     "email": "User_1@fakegmail.com",
//     "movie_id": ObjectId("573a1390f29313caabcd418c"),
//     "text": "Harum efa non ifensadre vel et. Veniam molestias vdawptas architecto error",
//     "date": new Date("2011-12-01T22:18:54Z")
//     },
//     {"name": "User 2",
//     "email": "User_2@fakegmail.com",
//     "movie_id": ObjectId("573a1390f29313caabcd418c"),
//     "text": "Harum efa non ifensadre vel et. Veniam molestias vdawptas architecto error",
//     "date": new Date("2021-10-01T22:18:54Z")
//     },
//     {"name": "User 3",
//     "email": "User_3@fakegmail.com",
//     "movie_id": ObjectId("573a1390f29313caabcd418c"),
//     "text": "Harum efa non ifensadre vel et. Veniam molestias vdawptas architecto error",
//     "date": new Date("2008-02-01T22:18:54Z")
//     },
//     {"name": "User 4",
//     "email": "User_4@fakegmail.com",
//     "movie_id": ObjectId("573a1390f29313caabcd418c"),
//     "text": "Harum efa non ifensadre vel et. Veniam molestias vdawptas architecto error",
//     "date": new Date("2010-06-01T22:18:54Z")
//     },
//     {"name": "User 5",
//     "email": "User_5@fakegmail.com",
//     "movie_id": ObjectId("573a1390f29313caabcd418c"),
//     "text": "Harum efa non ifensadre vel et. Veniam molestias vdawptas architecto error",
//     "date": new Date("2011-05-01T22:18:54Z")
//     }
// ])

// // ------------ Ejercicio 2 ---------------
// db.movies.find(
//     {"imdb.rating":{$type:"double"},"year":{$gt:1989,$lt:2000}},
//     {"title":1,"year":1,"cast":1,"directors":1,"imdb.rating":1}
// ).sort({"imdb.rating":-1}).limit(10)

// // ------------ Ejercicio 3 ---------------
// db.comments.find(
//     {
//         "movie_id": ObjectId("573a1399f29313caabcee886"),
//         "date": { $gte: new Date('2014-01-01T00:00:00Z'),$lte:new Date('2016-12-31T23:59:59Z')}
//     },
//     { "name": 1, "email": 1, "text": 1, "date": 1 }
// ).sort({"date":-1}).count()

// // ------------ Ejercicio 4 ---------------
// db.comments.find(
//     {"email":'patricia_good@fakegmail.com'},
//     {"name": 1, "movie_id": 1, "text": 1, "date": 1}
// ).sort({"date":-1}).limit(3)

// // ------------ Ejercicio 5 ---------------
// No hay languages??
// db.movies.find(
//     {"genres":{$all:["Drama","Action"]},
//      $or:[{"imdb.rating":{$gt:9}},{"runtime":{$gte:180}}]
//     },
//     {"title":1,"genres":1,"released":1,"imdb.votes":1}
// ).sort({"released":1,"imdb.votes":-1})

// // ------------ Ejercicio 6 ---------------
// db.theaters.find(
//     {"location.address.state":{$in:["CA", "NY", "TX"]},
//      "location.address.city":/F/
//     },
//     {"theaterId":1,"location.address.state":1,"location.address.city":1,"location.geo.coordinates":1}
// ).sort({"location.address.state":-1,"location.address.city":1})

// // ------------ Ejercicio 7 ---------------
// db.comments.updateMany(
//     {_id:ObjectId("5b72236520a3277c015b3b73")},
//     {$set:{"text":"mi mejor comentario"},
//      $currentDate:{"date":true}
//     }
// )

// // ------------ Ejercicio 8 ---------------
// db.users.updateOne(
//     { "email":'joel.macdonel@fakegmail.com'}, 
//     { $set: { "password" : "some password" } },
//     { upsert: true }
// )

// // ------------ Ejercicio 9 ---------------
// db.comments.deleteMany(
//     {"email":'victor_patel@fakegmail.com',
//      "date" :{$gte:new Date("1980-01-01"),$lte:new Date("1980-12-01")}
//     },
//     {}
// )