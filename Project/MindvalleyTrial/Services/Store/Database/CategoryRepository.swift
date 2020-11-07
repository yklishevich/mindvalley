//
//  CategoryRepository.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 28.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

class CategoryRepository {

private let backgroundContext = DaoManager.shared.backgroundContext
private let mainContext = DaoManager.shared.mainContext


// MARK: -

    func readAllCategories() throws -> [Category] {
        var retCategories = [Category]()
        var errorToThrowIfAny: Error? = nil
        let categoryDao = CategoryDao(managedContext: mainContext)
        
        mainContext.performAndWait {
            do {
                retCategories = try categoryDao.readAllCategories()
            }
            catch {
                errorToThrowIfAny = error
            }
        }
        
        if let error = errorToThrowIfAny {
            throw error
        }
        
        return retCategories
    }
    
    // TODO: replace more efficiently
    func replaceAllCategories(with categories: [Category], completion: @escaping (Error?) -> ()) {
        backgroundContext.perform {
            var errorOrNil: Error?
            
            do {
                let categoryDao = CategoryDao(managedContext: self.backgroundContext)
                let oldCategories = try categoryDao.readAllCategories()
                for oldCategory in oldCategories {
                    try categoryDao.remove(byName: oldCategory.name)
                }
                
                try categories.forEach {
                    try categoryDao.addOrUpdate($0)
                }
                
                if self.backgroundContext.hasChanges {
                    try self.backgroundContext.save()
                }
            }
            catch {
                self.backgroundContext.rollback()
                errorOrNil = error
            }
            
            DispatchQueue.main.async {
                completion(errorOrNil)
            }
        }
    }

}
