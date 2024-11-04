// ------------------ EJ 1 -----------------------
db.sales.aggregate([
    {
      $match: {
        "storeLocation": { $in: ["London", "Austin", "San Diego"] },
      "customer.age": { $gte: 18 },
      "items": {
        $elemMatch: {
          "price":{ $lte:1000},
          "tags": { $in: ["school", "kids"] }
        }
      }
      }
    },
    {
      $project: {
        _id: 0,
        sale: { $toString: "$_id" },
        saleDate: 1,
        storeLocation: 1,
        email: "$customer.email"
      }
    }
])

// ------------------ EJ 2 -----------------------
db.sales.aggregate([
    {
      $unwind: {
        path: "$items"
      }
    },
    {
      $match: {
        "storeLocation": "Seattle",
        "purchaseMethod": { $in: ["In store", "Phone"] },
        "saleDate": {
          $gte: new Date("2014-02-01"),
          $lte: new Date("2015-01-31")
        }
      }
    },
    {
      $group: {
        _id: { email: "$customer.email", satisfaction: "$customer.satisfaction" },
        totalAmount: { $sum: { $multiply: [{ $toDouble: "$items.price" }, "$items.quantity"] } }
      }
    },
    {
      $sort: {
        "_id.satisfaction": -1,
        "_id.email": 1
      }
    },
    {
      $project: {
        _id: 0,
        email: "$_id.email",
        satisfaction: "$_id.satisfaction",
        totalAmount: 1
      }
    }
])

// ------------------ EJ 3 -----------------------
db.createView(
    "salesInvoiced",
    "sales",
    [
        {
            $unwind: '$items'
        },
        {
            $group: {
              _id: {
                year: { $year: "$saleDate" },
                month: { $month: "$saleDate" }
              },
              minAmount: { $min: { $multiply: [{ $toDouble: "$items.price" }, "$items.quantity"] } },
              maxAmount: { $max: { $multiply: [{ $toDouble: "$items.price" }, "$items.quantity"] } },
              totalAmount: { $sum: { $multiply: [{ $toDouble: "$items.price" }, "$items.quantity"] } },
              avgAmount: { $avg: { $multiply: [{ $toDouble: "$items.price" }, "$items.quantity"] } }
            }
          },
          {
            $project: {
              _id: 0,
              year: "$_id.year",
              month: "$_id.month",
              minAmount: 1,
              maxAmount: 1,
              totalAmount: 1,
              avgAmount: 1
            }
          },
          {
            $sort: { year: 1, month: 1 }
          }
    ]
)

db.salesInvoiced.find()
db.salesInvoiced.drop()

// ------------------ EJ 4 -----------------------
db.sales.aggregate([
    {
        $lookup: {
            from: "storeObjectives",
            localField: "storeLocation",
            foreignField: "_id", 
            as: "result"
        }
    },
    {
        $unwind: {
            path: "$result",
            preserveNullAndEmptyArrays: false
        }
    },
    {
        $unwind: '$items'
    },
    {
        $group: {
            _id: "$storeLocation",
            totalSalesAmount: {
                $sum: { 
                    $multiply: [{ $toDouble: "$items.price" }, "$items.quantity"] 
                }
            },
            totalTransactions: { $sum: 1 },
            objective: { $first: "$result.objective" }
        }
    },
    {
        $addFields: {
            avgAmount: { $divide: ["$totalSalesAmount", "$totalTransactions"] },
            differenceAmount: { $subtract: [{ $divide: ["$totalSalesAmount", "$totalTransactions"] }, "$objective"] }
        }
    },
    {
        $project: {
            _id: 0, 
            storeLocation: "$_id",
            avgAmount: 1,
            objective: 1,
            differenceAmount: 1
        }
    }
])

// ------------------ EJ 6 -----------------------
db.sales.findOne()
//a
db.runCommand({
    collMod: "sales",
    validator: {
    $jsonSchema: {
        bsonType: "object",
        required: ["storeLocation", "customer"],
        properties: {
        storeLocation: {
            bsonType: "string",
            description: "El storeLocation debe ser un string"
        },
        purchaseMethod: {
            bsonType: "string",
            enum: ["In store","Phone","Online"],
            description: "El método de venta puede ser In store,Phone u Online"
        },
        saleDate: {
            bsonType: "date",
            description: "El campo saleDate debe de ser de tipo date"
        },
        customer:{
            bsonType: "object",
            required: ["email", "satisfaction"],
            properties: {
                gender: {
                    bsonType: "string",
                    enum: ["M","F","NB"],
                },
                age: {
                    bsonType: "int",
                    minimum: 18, 
                    maximum: 100,
                    description: "El campo age va desde 18 a 100 años"
                },
                email: {
                    bsonType: "string",
                    pattern:"^(.*)@(.*)\\.(.{2,4})$",
                    description: "El email debe ser un string que matchee con la expresión regular: ^(.*)@(.*)\\.(.{2,4})$"
                },
                satisfaction: {
                    bsonType: "int",
                    minimum: 1, 
                    maximum: 5,
                    description: "El campo satisfaction va desde 1 a 5 puntos"
                },
            }
        }
        },
    }
    },
    validationLevel: "moderate",
    validationAction: "error"
});
//b
// Falla por el método de venta
db.sales.insertOne(
    {
        "saleDate": new Date("2016-03-23T21:06:49.506Z"),
        "items": [
          {
            "name": "printer paper",
            "tags": [
              "office",
              "stationary"
            ],
            "price": {
              "$numberDecimal": "40.01"
            },
            "quantity": 2
          },
          {
            "name": "notepad",
            "tags": [
              "office",
              "writing",
              "school"
            ],
            "price": {
              "$numberDecimal": "35.29"
            },
            "quantity": 2
          },
        ],
        "storeLocation": "Denver",
        "customer": {
          "gender": "M",
          "age": 42,
          "email": "cauho@witwuta.sv",
          "satisfaction": 4
        },
        "couponUsed": true,
        "purchaseMethod": "Store"
      }
)
// No falla
db.sales.insertOne(
    {
        "saleDate": new Date("2016-03-23T21:06:49.506Z"),
        "items": [
          {
            "name": "printer paper",
            "tags": [
              "office",
              "stationary"
            ],
            "price": {
              "$numberDecimal": "40.01"
            },
            "quantity": 2
          },
          {
            "name": "notepad",
            "tags": [
              "office",
              "writing",
              "school"
            ],
            "price": {
              "$numberDecimal": "35.29"
            },
            "quantity": 2
          },
        ],
        "storeLocation": "Denver",
        "customer": {
          "gender": "M",
          "age": 42,
          "email": "cauho@witwuta.sv",
          "satisfaction": 4
        },
        "couponUsed": true,
        "purchaseMethod": "In store"
      }
)