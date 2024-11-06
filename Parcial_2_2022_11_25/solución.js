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