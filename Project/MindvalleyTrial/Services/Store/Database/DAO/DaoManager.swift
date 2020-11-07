import Foundation
import CoreData


enum DaoError: Error {
    
    /// Thrown when client attempts to add to DB existing entity.
    case addingExistingEntity(entity: Any)
    
    case attemptToDeleteNonExistingEntity(entityId: String, type: Any.Type)
    
    case unknown(message: String?, underlyingError: Error)
}


/// Class is thread safe and can be used from any thread.
internal class DaoManager {
    
    static let shared: DaoManager = {
        return DaoManager()
    }()
    
    /// Main contexts is used for read operations.
    /// All changes in store are automatically merged to mainContext.
    /// All write operations are perfomed in background context.
    var mainContext: NSManagedObjectContext {
        return coreDataStack.mainContext
    }
    
    /// Context for performing writing into DB.
    var backgroundContext: NSManagedObjectContext {
        return coreDataStack.backgroundContext
    }
    
    // MARK: - Private properties -
    
    private let coreDataStack = DataMigrationManager.shared.stack
    
}

