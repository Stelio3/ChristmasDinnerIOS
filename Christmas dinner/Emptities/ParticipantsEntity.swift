//
//  ParticipantsEntity.swift
//  Christmas dinner
//
//  Created by PABLO HERNANDEZ JIMENEZ on 9/1/19.
//  Copyright © 2019 PABLO HERNANDEZ JIMENEZ. All rights reserved.
//

import Foundation
import RealmSwift

class ParticipantsEntity: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var paid = false
    @objc dynamic var creationDate = Date()
    
    
    override static func primaryKey() -> String?{
        return "id"
    }
    
    convenience init(participant: Participants) {
        self.init()
        self.id = participant.id
        self.name = participant.name
        self.paid = participant.paid
        self.creationDate = participant.creationDate
    }
    
    func participantModel() -> Participants {
        let model = Participants()
        model.id = id
        model.name = name
        model.paid = paid
        model.creationDate = creationDate
        return model
    }
}
