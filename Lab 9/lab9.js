// ----------------- Ej1 ----------------- 
db.runCommand({
    collMod: "users",
    validator: {
    $jsonSchema: {
        bsonType: "object",
        required: ["name","email","password"],
        properties: {
        name: {
            bsonType: "string",
            maxItems: 30,
            description: "El name debe ser un string de hasta 30 caracteres"
        },
        email1: {
            bsonType: "string",
            pattern:"^(.*)@(.*)\\.(.{2,4})$",
            description: "El email debe ser un string que matchee con la expresión regular: ^(.*)@(.*)\\.(.{2,4})$"
        },
        password: {
            bsonType: "string",
            maxItems: 50,
            description: "El password debe ser un string de hasta 50 caracteres"
        },
        },
    }
    },
    validationLevel: "strict",
    validationAction: "error"
});

// ----------------- Ej2 ----------------- 
db.getCollectionInfos( { name: "users" } )

// ----------------- Ej3 ----------------- 
db.runCommand({
    collMod: "theaters",
    validator: {
    $jsonSchema: {
        bsonType: "object",
        required: ["theaterId","location"],
        properties: {
        theaterId: {
            bsonType: "int",
            description: "El theaterId debe ser un integer"
        },
        location: {
            bsonType: "object",
            required: [ "address" ],
            properties: {
                "address": { 
                    bsonType: "object",
                    required: [ "street1", "city", "state", "zipcode" ],
                    properties: {
                        street1:{bsonType: "string"}, 
                        city:{bsonType: "string"}, 
                        state:{bsonType: "string"}, 
                        zipcode:{bsonType: "string"}, 
                    }
                },
                "geo": { 
                    bsonType: "object",
                    properties: {
                        type:{
                            bsonType: "string",
                            enum: ["Point", null]
                        }, 
                        coordinates: {
                            bsonType: "array",
                            minItems: 2,
                            maxItems: 2,
                            items: {
                                    bsonType: "double"
                                }
                            },
                    }
                }
            }
        },
        },
    }
    },
    validationLevel: "moderate",
    validationAction: "warn"
});