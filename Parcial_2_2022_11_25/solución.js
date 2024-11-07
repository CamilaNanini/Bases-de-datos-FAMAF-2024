db.restaurants.findOne({cuisine: "Bakery"},{})
// ---------------- EJ 1 -----------
db.restaurants.find(
    {
        cuisine: "Italian",
        grades: { 
            $elemMatch: { 
                grade:"A",
                score:{ $gte: 10 }
            } 
        }
    },
    {
        _id:0,
        name:1,
        borough:1
    }
).sort({
    borough:1,
    name:1,
})
// ---------------- EJ 2 -----------
db.restaurants.updateMany(
    {
      cuisine: { $in: ["Bakery", "Coffee"] }
    },
    [{
      $addFields: {
        discounts: {
          day: { $cond: { if: { $eq: ["$borough", "Manhattan"] }, then: "Monday", else: "Tuesday" } },
          amount: { $cond: { if: { $eq: ["$borough", "Manhattan"] }, then: "10%", else: "5%" } }
        }
      }
    }]
)
db.restaurants.updateMany(
    {},
    { $unset: { discounts: "" } }
);
// ---------------- EJ 3 -----------
db.restaurants.countDocuments(
    {
      $expr: {
        $and: [
          { $gte: [
            { $convert: { input: "$address.zipcode", to: "int", onError: 0, onNull: 0 } }, 10000] },
          { $lte: [
            { $convert: { input: "$address.zipcode", to: "int", onError: 0, onNull: 0 } }, 11000] }
        ]
      }
    }
)
// ---------------- EJ 4 -----------
db.restaurants.aggregate([
  {
      $unwind: "$grades"
  },
  {
      $match: {
          "grades.date": {
              $gte : new Date ("2013-07-01T00:00:00Z"),
              $lt : new Date ("2013-12-31T23:59:59Z")
          }
      }
  },
  {
      $group: {
      _id: {
          cuisine: "$cuisine",  
          grade: "$grades.grade"
      },
      distinctCount: { $sum: 1 }

      }
  },
  {
      $sort: {
          "_id.cuisine": 1,
          "_id.grade": 1
      }
  },
  {
      $project: {
          _id: 1, 
          distinctCount: 1  
      }
  }
]);
// ---------------- EJ 5 ----------------
db.restaurants.aggregate([
    {
        $unwind: "$grades"
    },
    {
        $addFields: {
            gradeInNumbers: {
                $switch: {
                    branches: [
                        {case: {$eq:["$grades.grade","A"]},then: 5},
                        {case: {$eq:["$grades.grade","B"]},then: 4},
                        {case: {$eq:["$grades.grade","C"]},then: 3},
                        {case: {$eq:["$grades.grade","D"]},then: 2},
                    ],
                    default: 1,
                }
            }
        }
    },
    {
        $group: {
            _id: { cuisine: "$cuisine" },
            maxGrade: { $max: "$gradeInNumbers" },
            minGrade: { $min: "$gradeInNumbers" },
            avgGrade: { $avg: "$gradeInNumbers" }
        }
    },
    {
        $sort:{
            avgGrade:-1,
        }
    },
    {
        $project: {
            _id:0,
            cuisine: "$_id.cuisine", 
            maxGrade:1,
            minGrade:1,
            avgGrade:1
        }
    }
  ]);

  
