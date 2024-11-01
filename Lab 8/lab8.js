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
    {year:{$gte:1950 , $lte:1959}}
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
db.comments.aggregate(
    {
        $group: {
        _id: { name: "$name",email: "$email" },
        count: {$sum: 1}
        }
    },
    {
        $project: {
            _id : 0,
            name: "$_id.name",
            email: "$_id.email",
            count: 1,
        }
    },
    {
        $sort: {
            count: -1
        }
    },
    {
        $limit: 10
    }
)

// ------------------ Ej7 --------------------
db.movies.aggregate(
    {
        $match: {
            year: { $gte: 1980, $lte: 1989 }
        }
    },
    {
        $group: {
            _id: "$year",
            avg: { $avg: "$imdb.rating" },
            min: { $min: "$imdb.rating" },
            max: { $max: "$imdb.rating" }
        }
    },
    {
        $sort: {
            avg: -1
        }
    }
)

// ------------------ Ej8 --------------------
db.movies.aggregate([
    {
        $lookup: {
            from: "comments",
            localField: "_id",
            foreignField: "movie_id",
            as: "movieComments"
        }
    },
    {
        $project: {
            _id: 0,
            title: 1,
            year: 1,
            commentsCount: { $size: "$movieComments" } 
        }
    },
    {
        $sort: { commentsCount: -1 }
    },
    {
        $limit: 10 
    }
])

// ------------------ Ej9 --------------------
db.createView(
    "fiveGenders",
    "movies",
    [
        {
            $lookup: {
                from: 'comments',
                localField: '_id',
                foreignField: 'movie_id',
                as: 'comments'
            }
        },
        {
            $unwind: '$genres'
        },
        {
            $group: {
                _id: '$genres',
                comment_count: { $sum: { $size: '$comments' } }
            }
        },
        {
            $sort: { comment_count: -1 }
        },
        {
            $limit: 5
        },
        {
            $project: { _id: 0, genre: '$_id', comment_count: 1 }
        }
    ]
)

db.fiveGenders.find()
db.fiveGenders.drop()

// ------------------ Ej10 --------------------
db.movies.aggregate([
    {
        $match: {
            directors: "Jules Bass" 
        }
    },
    {
        $unwind: "$cast" 
    },
    {
        $group: {
            _id: "$cast",
            movies: { $addToSet: { title: "$title", year: "$year" } }, 
            movieCount: { $sum: 1 }
        }
    },
    {
        $match: { movieCount: { $gte: 2 } }
    },
    {
        $project: {
            actorName: "$_id",
            movies: 1
        }
    }
])

// ------------------ Ej11 --------------------
db.comments.aggregate([
    {
        $lookup: {
            from: "movies",
            localField: "movie_id",
            foreignField: "_id",
            let: { comment_date: "$date" }, 
            pipeline:[
                { $match: { $expr: {
                    $and:{ 
                    $eq: [{ $month: "$$comment_date" }, { $month: "$released" }],
                    $eq: [{ $year: "$$comment_date" }, { $year: "$released" }]
                    }
                }}}, 
            ],
            as: "movieDetails"
        }
    },
    {
        $unwind: "$movieDetails" 
    },
    {
        $project: {
            name: 1,
            email: 1,
            commentDate: "$createdAt",
            movieTitle: "$movieDetails.title",
            releaseDate: "$movieDetails.releaseDate"
        }
    },
    {
        $project: {
            name: 1,
            email: 1,
            date: 1,
            movie_date: '$movieDetails.released',
            movie_title: '$movieDetails.title',
            _id: 0
        } 
    }
])

// ------------------ Ej12 --------------------
//a
db.restaurants.findOne()
db.restaurants.aggregate([
    {
        $unwind: "$grades"
    },
    {
        $group: {
            _id: "$restaurant_id",
            name: {$first: "$name"},
            max: {$max:"$grades.score"},
            min: {$min:"$grades.score"},
            total_score: {$sum: "$grades.score"}
        }
    },
    {
        $project: {
            _id:1,
            name:1,
            max:1,
            min:1,
            total_score:1
        }
    }
])

//b
db.restaurants.aggregate([
    {
        $project: {
            _id:0,
            restaurant_id:1,
            name:1,
            max: {$max:"$grades.score"},
            min: {$min:"$grades.score"},
            total_score: {$sum: "$grades.score"}
        }
    }
])

//c
db.restaurants.aggregate([
    {
        $project: {
            _id: 0,
            restaurant_id: 1,
            name: 1,
            max: { $max: "$grades.score" },
            min: { $min: "$grades.score" },
            total_score: {
                $reduce: {
                    input: "$grades",
                    initialValue: { sum: 0 },
                    in: {
                        sum: { $add: ["$$value.sum", "$$this.score"] }
                    }
                }
            }
        }
    }
])

//d
db.restaurants.find({},{
    _id: 0,
            restaurant_id: 1,
            name: 1,
            max: { $max: "$grades.score" },
            min: { $min: "$grades.score" },
            total_score: {
                $reduce: {
                    input: "$grades",
                    initialValue: { sum: 0 },
                    in: {
                        sum: { $add: ["$$value.sum", "$$this.score"] }
                    }
                }
            }
})

// ------------------ Ej13 --------------------
db.restaurants.updateMany(
    {},
    [{
        $addFields: {
            average_score: {
                $avg: "$grades.score"
            }
        }
    },
    {
        $addFields: {
            grade: {
                $switch: {
                    branches: [
                        {case:{ $and : [ { $gte : [ "$average_score",0 ] },
                                { $lte : [ "$average_score",13 ] } ] },
                            then: "A"
                        },
                        {case:{ $and : [ { $gte : [ "$average_score",14 ] },
                                { $lte : [ "$average_score",27 ] } ] },
                            then: "B"
                        },
                        {case:{ $gte : [ 28, "$average_score" ] },
                            then: "C"
                        },
                    ],
                    default: "",
                }
            }
        }
    }
    ]
)  

//Borrar un campo
db.restaurants.updateMany(
    {},
    { $unset: { average_score: "" } }
);
