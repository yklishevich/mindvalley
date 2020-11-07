import CoreData

/// All changes are exprected to be done in `backgroundContext`. `mainContext` will pull them automatically from persistent store.
class CoreDataStack {
    
    /// Main context must be used only for reading data. For writing background context must be used.
    lazy var mainContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.storeContainer.persistentStoreCoordinator
        moc.automaticallyMergesChangesFromParent = true
        return moc
    }()
    
    /// Only background context must be used for write operations.
    /// For reading main context may be used, especially if read operation does not load main thread.
    lazy var backgroundContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.storeContainer.persistentStoreCoordinator
        return moc
    }()
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: Properties
    private let modelName: String
    
    // MARK: Initializers
    init(modelName: String) {
        self.modelName = modelName
    }
}
