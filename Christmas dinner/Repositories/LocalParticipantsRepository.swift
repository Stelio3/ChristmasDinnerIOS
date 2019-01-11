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
        var participants: [Participants] = []
        do {
            let entities = try Realm().objects(ParticipantsEntity.self).sorted(byKeyPath: "creationDate", ascending: false)
            for entity in entities {
                let model = entity.participantModel()
                participants.append(model)
            }
        }
        catch let error as NSError {
            print("ERROR getAll Participants: ", error.description)
        }
        return participants
    }
    
    func get(identifier: String) -> Participants? {
        do{
            let realm = try Realm()
            if let entity = realm.objects(ParticipantsEntity.self).filter("id == %@", identifier).first{
                let model = entity.participantModel()
                return model
            }
        }
        catch {
            return nil
        }
        return nil
    }
    
    func get(name: String) -> Participants? {
        do{
            let realm = try Realm()
            if let entity = realm.objects(ParticipantsEntity.self).filter("name == %@", name).first{
                let model = entity.participantModel()
                return model
            }
        }
        catch {
            return nil
        }
        return nil
    }
    
    func create(a: Participants) -> Bool {
        do{
            let realm = try Realm()
            let entity = ParticipantsEntity(participant: a)
            try realm.write{
                realm.add(entity,update: true)
            }
        }
        catch{
            return false
        }
        return true
    }
    
    func delete(a: Participants) -> Bool {
        do{
            let realm = try Realm()
            try realm.write {
                let entityToDelete = realm.objects(ParticipantsEntity.self).filter("id == %@", a.id)
                realm.delete(entityToDelete)
            }
        }
        catch{
            return false
        }
        return true
    }
    
    func update(a: Participants) -> Bool {
        return create(a:a)
    }
}
