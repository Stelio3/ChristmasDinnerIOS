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
}

class AddParticipantsViewController: UIViewController {
    
    @IBOutlet weak var viewBack:UIView!
    @IBOutlet weak var textField:UITextField!
    @IBOutlet weak var saveButton:UIButton!
    internal var participants: Participants!
    weak var delegate: AddParticipantsViewControllerDelegate!
    
    convenience init(participants: Participants?) {
        self.init()
        if participants == nil {
            self.participants = Participants()
            self.participants.name = ""
        }
        else {
            self.participants = participants
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
        
        saveButton.layer.cornerRadius = 8.0
        saveButton.layer.masksToBounds = true
        
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
        self.participants.name = textField.text
        delegate.addParticipantsViewController(self, didEditParticipants: participants)
    }
}
