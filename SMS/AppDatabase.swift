import GRDB

/// A type responsible for initializing the application database.
///
/// See AppDelegate.setupDatabase()
struct AppDatabase {
    
    /// Crea una base de datos totalmente inicializada en la ruta
    static func openDatabase(atPath path: String) throws -> DatabaseQueue {
        // establece la conexión a la base de datos
        dbQueue = try DatabaseQueue(path: path)
        
        // Usa DatabaseMigrator para definir el esquema de la base de datos
        try migrator.migrate(dbQueue)
        
        return dbQueue
    }
    
    /// La DatabaseMigrator que define el esquema de la base de datos
    static var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("createPersonas") { db in
            // Crea la tabla
            try db.create(table: "personas") { t in
                // Un entero como una auto generada clave primaria, que referencia el objeto a un ID único
                t.column("id", .integer).primaryKey()
                
                // Acá de ordena la tabla alfabéticamente de acuerdo a los nombres de las personas
                t.column("nombre", .text).notNull().collate(.localizedCaseInsensitiveCompare)
                
                t.column("edad", .integer).notNull()
            }
        }
        
        migrator.registerMigration("fixtures") { db in
            // Llena la base de datos con datos al azar
            for _ in 0..<8 {
                try Person(nombre: Person.nombreRandom(),edad: Person.edadRandom()).insert(db)
            }
        }

//        // Migrations for future application versions will be inserted here:
//        migrator.registerMigration(...) { db in
//            ...
//        }
        
        return migrator
    }
}
