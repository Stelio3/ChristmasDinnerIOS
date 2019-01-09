//
//  LocalParticipantsRepository.swift
//  Christmas dinner
//
//  Created by PABLO HERNANDEZ JIMENEZ on 9/1/19.
//  Copyright © 2019 PABLO HERNANDEZ JIMENEZ. All rights reserved.
//

import UIKit
import RealmSwift

class LocalParticipantsRepository: Repository {
    
    func getAll() -> [Participants] {
        var tasks: [Participants] = []
        do {
            let entities = try Realm().objects(ParticipantsEntity.self).sorted(byKeyPath: "name", ascending: true)
            for entity in entities {
                let model = entity.participantsModel()
                tasks.append(model)
            }
        }catch let error as NSError {
            print("Error getAll Participants: ", error.description)
        }
        return tasks
    }
    func get(identifier: String) -> Participants? {
        do{
            let realm = try Realm()
            if let entity = realm.objects(ParticipantsEntity.self).filter("name == %@", identifier).first {
                let model = entity.participantsModel()
                return model
            }
        }catch {
            return nil
        }
        return nil
    }
    func create(a: Participants) -> Bool {
        do{
            let realm = try Realm()
            let entity = ParticipantsEntity(participants: a)
            try realm.write {
                realm.add(entity, update: true)
            }
        }catch {
            return false
        }
        return true
    }
    func update(a: Participants) -> Bool {
        return true
    }
    func delete(a: Participants) -> Bool {
        do{
            let realm = try Realm()
            try realm.write {
                let entityToDelete = realm.objects(ParticipantsEntity.self).filter("name == %@", a.name)
                realm.delete(entityToDelete)
            }
        }catch {
            return false
        }
        return true
    }
}
