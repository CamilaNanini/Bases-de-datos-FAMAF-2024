// ------------------ Ej1 --------------------
db.theaters.aggregate([
    {
        $group: {
            _id: '$location.address.state',
            theatersCount: { $sum: 1 }
        }
    }
])

// ------------------ Ej2 --------------------
db.theaters.aggregate([
    {
        $group: {
            _id: '$location.address.state',
            theatersCount: { $sum: 1 }
        }
    },
    { 
        $match: { 
            "theatersCount": { $gte: 2 } 
        } 
    },
    {
        $count: 'theatersCount'
    }
])

// ------------------ Ej3 --------------------
db.movies.find(
    {directors:{$eq : "Louis Lumière"}},
    {directors:1}
).count()

db.movies.aggregate([
    { 
        $unwind: '$directors',
    },
    {
        $group : {
            _id : '$directors',
            filmsCount: { $sum: 1 }
        }
    },
    {
        $match: { 
            _id : { $eq: "Louis Lumière" } 
        }
    }
])

// ------------------ Ej4 --------------------
db.movies.find(
    {year:{$gte:1950 , $lte:1951}}
).count()

db.movies.aggregate([
    {
        $match: { 
            year : { $gte:1950 , $lte :1959 } 
        }
    },
    {
        $count: 'moviesCount'
    }
])

// ------------------ Ej5 --------------------
// Listar los 10 géneros con mayor cantidad de películas (tener en cuenta que las películas pueden tener más 
// de un género). Devolver el género y la cantidad de películas. Hint: unwind puede ser de utilidad
db.movies.aggregate([
    { 
        $unwind: '$genres',
    },
    {
        $group : {
            _id : '$genres',
            genereCount: { $sum: 1 }
        }
    },
    {
        $limit: 10
    }
])

// ------------------ Ej6 --------------------
// Top 10 de usuarios con mayor cantidad de comentarios, mostrando Nombre, Email y Cantidad de Comentarios.

// ------------------ Ej7 --------------------
// Ratings de IMDB promedio, mínimo y máximo por año de las películas estrenadas en los años 80 (desde 1980 
// hasta 1989), ordenados de mayor a menor por promedio del año.
