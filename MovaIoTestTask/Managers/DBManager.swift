//
//  DBManager.swift
//  MovaIoTestTask
//
//  Created by Serhii Rosovskyi on 13.04.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import UIKit
import RealmSwift

class DBManager {
    
    private (set) var database: Realm
    static let shared = DBManager()
    
    init() {
        database = try! Realm()
    }
    
    func addData(object: Object) {
        do {
            try database.write {
                database.add(object)
            }
        } catch {
            print("DBManager add object ERROR!")
        }
    }
    
    func add(img: ImageSearchRealm) {
        self.deleteAll()
        self.addData(object: img)
    }
    
    func delete(img: ImageSearchRealm) {
        let results = database.object(ofType: ImageSearchRealm.self, forPrimaryKey: img.id)
        if let res = results {
            try? database.write ({
                database.delete(res)
            })
        }
    }
    
    func getDataFromDB<T: Object>(with type: T.Type) -> Results<T> {
        let results: Results<T> = database.objects(type.self)
        return results
    }
    
    func deleteDataFromDB<T: Object>(with type: T.Type) {
        let results: Results<T> = database.objects(type.self)
        try? database.write {
            database.delete(results)
        }
    }
    
    func deleteAll() {
        try? database.write {
            database.deleteAll()
        }
    }
}

