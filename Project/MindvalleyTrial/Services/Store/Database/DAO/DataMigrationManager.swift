import Foundation

class DataMigrationManager {
    
    static let shared = DataMigrationManager()
    
    private let coreDataModelName = "MindvalleyTrial"
    
    var stack: CoreDataStack {
        performMigrations()
        return CoreDataStack(modelName: coreDataModelName)
    }
    
    private func performMigrations() {
        
    }
}


