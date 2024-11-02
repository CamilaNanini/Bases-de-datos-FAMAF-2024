// ----------------- Ej6 ----------------- 
// Relación entre movies y comment
// La relación es del tipo : One-To-Many; siendo que se usó una referencia en la colección comments 
// hacia movies, haciendo que varios comments se vinculen a una pelicula. 
// Se sabe que esto es así porque en la colección comments, el campo movie_id actúa como una clave de 
// referencia al campo _id de la colección movies, permitiendo vincular cada comentario con su película.

// ----------------- Ej7 ----------------- 
// Se planea hacer:
// 1
// Entidades: books,categories
// Relación: One-To-Many
// Estrategia: Documentos Anidados
// 2
// Entidades: orders, order_detail
// Relación: One-To-One
// Estrategia: Documentos Referenciados
// 3
// Entidades: order_detail, books
// Relación: Many-To-One
// Estrategia: Documentos Referenciados
