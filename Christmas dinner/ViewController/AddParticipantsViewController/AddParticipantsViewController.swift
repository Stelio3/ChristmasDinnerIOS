//
//  AddParticipantsViewController.swift
//  Christmas dinner
//
//  Created by PABLO HERNANDEZ JIMENEZ on 9/1/19.
//  Copyright © 2019 PABLO HERNANDEZ JIMENEZ. All rights reserved.
//

import UIKit

protocol AddParticipantsViewControllerDelegate: class {
    func addParticipantsViewController(_ vc: AddParticipantsViewController, didEditParticipants participants: Participants)
    func errorAddParticipantsViewController(_ vc:AddParticipantsViewController)
}

class AddParticipantsViewController: UIViewController {
    
    @IBOutlet weak var viewBack:UIView!
    @IBOutlet weak var name:UITextField!
    internal var repository: LocalParticipantsRepository!
    weak var delegate: AddParticipantsViewControllerDelegate!
    
    convenience init(participants: Participants?) {
        self.init()
        if participants == nil {
            self.repository = LocalParticipantsRepository()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.8) {
            self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.layer.cornerRadius = 8.0
        viewBack.layer.masksToBounds = true
        repository = LocalParticipantsRepository()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed() {
        if (repository.get(name: name.text!) != nil) ||
            (name.text?.elementsEqual(""))! {
            self.delegate?.errorAddParticipantsViewController(self)
        }else{
            let participant = Participants()
            participant.id = UUID().uuidString
            participant.name = name.text!
            participant.paid = false
            participant.creationDate = Date()
            UIView.animate(withDuration: 0.25, animations: {
                self.view.backgroundColor = UIColor.clear
            }) { (bool) in
                if self.repository.create(a: participant){
                    self.delegate?.addParticipantsViewController(self, didEditParticipants: participant)
                }
            }
            }
    }
}
