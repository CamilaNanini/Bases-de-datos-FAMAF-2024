// Select the database to use.
use('restaurantdb');
// // --------------- Ejercicio 10 -----------------
db.restaurants.find({
        "grades":{
            $elemMatch:{
                "date":{$gt:new Date("2014-01-01"),$lte:new Date("2015-12-31")},
                "score":{$gt:70,$lte:90}},
        }
    },
    {
        "restaurant_id":1,"grades.score":1
    }
)

// // --------------- Ejercicio 11 -----------------
db.restaurants.updateOne({ 
    "restaurant_id": "50018608" 
    }, 
    { $push: { 
        grades: { 
            $each:[              
                {   "date": ISODate("2019-10-10T00:00:00Z"),
                    "grade": "A",
                    "score": 18
                },
                {   "date": ISODate("2020-02-25T00:00:00Z"),
                    "grade": "A",
                    "score": 21
                }
                ]
            } 
        }
    }
)
 