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
    @objc dynamic var name = ""
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    convenience init(participants: Participants) {
        self.init()
        self.name = participants.name
    }
    
    func participantsModel() -> Participants {
        let model = Participants()
        model.name = self.name
        return model
    }
}
