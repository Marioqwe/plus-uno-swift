//
//  CoreDataManager.swift
//  PlusUno
//
//  Created by Mario Solano on 3/9/18.
//  Copyright © 2018 Mario Solano. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataManager {
    
    static fileprivate let context = AppDelegate.shared.persistentContainer.viewContext
    
    static func deleteObject(forLevel currentLevel: Int) {
        guard let result = fetchObject(withLevel: currentLevel) else { return }
        context.delete(result)  // we only expect one of these.
        try? context.save()
    }
    
    static func fetchGameState(forLevel currentLevel: Int) -> GameState? {
        guard let result = fetchObject(withLevel: currentLevel),
            let level = result as? CDLevel else { return nil }
        let jsonString = level.jsonString != nil ? level.jsonString! : ""
        let jsonData = jsonString.data(using: .utf8)
        
        guard let rawPayload = try? JSONSerialization.jsonObject(with: jsonData!, options: []),
            let payload = rawPayload as? [String: Any] else { return nil }
        return GameState.build(fromPayload: payload)
    }

    static func save(payload: [String: Any], forLevel level: Int) {
        var levelEntity: NSManagedObject
        if let result = fetchObject(withLevel: level) {
            let level = result as! CDLevel
            levelEntity = level
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "CDLevel", in: context)
            levelEntity = NSManagedObject(entity: entity!, insertInto: context)
        }
        
        guard let jsonString = try? buildJSONString(from: payload) else { return }
        levelEntity.setValue(level, forKey: "value")
        levelEntity.setValue(jsonString, forKey: "jsonString")
        try? context.save()
    }
    
    static fileprivate func fetchObject(withLevel level: Int) -> NSManagedObject? {
        let request = NSFetchRequest<NSManagedObject>(entityName: "CDLevel")
        request.predicate = NSPredicate(format: "value == \(level)")
        guard let results = try? context.fetch(request),
            results.count > 0 else { return nil }
        return results[0]  // we only expect one of these.
    }
    
    static fileprivate func buildJSONString(from payload: [String: Any]) throws -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString
        } catch let error as NSError {
            throw error
        }
    }
    
}
