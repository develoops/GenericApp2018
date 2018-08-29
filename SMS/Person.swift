import GRDB

class Person: Record {
    var id: Int64?
    var nombre: String
    var edad: Int
    
    init(nombre: String, edad: Int) {
        self.nombre = nombre
        self.edad = edad
        super.init()
    }
    
    // MARK: Record overrides
    
    override class var databaseTableName: String {
        return "personas"
    }
    
    required init(row: Row) {
        id = row["id"]
        nombre = row["nombre"]
        edad = row["edad"]
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["nombre"] = nombre
        container["edad"] = edad
    }
    
    override func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
    // MARK: Random
    
    private static let nombres = ["Arturo", "Anita", "Barbara", "Bernardo", "Daniel", "Carlos", "David", "James", "Jaime", "Elena", "Virgen", "Alfredo", "Gilbertp", "George", "Henry", "Hussein", "Ignacio", "Irene", "Julia", "Jack", "Karl", "Kristel", "Luis", "Lisa", "Masisi", "María", "Noemí", "Nicol", "Ofelia", "Orson", "Pascal", "Patricia", "Farsante", "Quinn", "Raúñ", "Rachel", "Stephan", "Susana", "Tristan", "Tatiana", "Ursula", "Usain", "Victor", "Violeta", "William", "Agustin"]
    
    class func nombreRandom() -> String {
        return nombres[Int(arc4random_uniform(UInt32(nombres.count)))]
    }
    
    class func edadRandom() -> Int {
        return  Int(arc4random_uniform(101))
    }

}
