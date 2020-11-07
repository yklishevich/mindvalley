//
//  CategoryDao.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 28.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation
import CoreData

class CategoryDao {
    
    let managedContext: NSManagedObjectContext
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    @discardableResult
    func addOrUpdate(_ category: Category) throws -> Category {
        do {
            if let cdCategory = try readCDCategory(byName: category.name) {
                cdCategory.update(with: category)
                return Category(with: cdCategory)
            }
            else {
                let cdCategory = CDCategory(context: managedContext)
                cdCategory.update(with: category)
                return Category(with: cdCategory)
            }
        }
        catch {
            throw DaoError.unknown(
                message: "Error in \(type(of: self)).\(#function)",
                underlyingError: error
            )
        }
    }
    
    func readAllCategories() throws -> [Category] {
        do {
            let fetchRequest: NSFetchRequest<CDCategory> = CDCategory.fetchRequest()
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \CDCategory.position, ascending: true)
            ]
            let cdCategories = try managedContext.fetch(fetchRequest)
            return cdCategories.map(Category.init)
        }
        catch {
            throw DaoError.unknown(
                message: "Error in \(type(of: self)).\(#function)",
                underlyingError: error
            )
        }
    }
    
    func remove(byName name: String) throws {
        do {
            
            if let cdCategory = try readCDCategory(byName: name) {
                managedContext.delete(cdCategory)
            }
            else {
                throw DaoError.attemptToDeleteNonExistingEntity(entityId: name, type: Category.self)
            }
        }
        catch {
            throw DaoError.unknown(
                message: "Error in \(type(of: self)).\(#function)",
                underlyingError: error
            )
        }
    }
       

}

private extension CategoryDao {
    
    /// - Returns: `nil` if there is no episode with such id.
    func readCDCategory(byName name: String) throws -> CDCategory? {
        let fetchRequest: NSFetchRequest<CDCategory> = CDCategory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(CDCategory.name), name)
        let cdCategory = try managedContext.fetch(fetchRequest).first
        return cdCategory
    }
}

private extension CDCategory {
    func update(with category: Category) {
        self.name = category.name
    }
}

extension Category {
    convenience init(with cdCategory: CDCategory) {
        self.init(name: cdCategory.name,
                  position: Int(cdCategory.position))
    }
}
