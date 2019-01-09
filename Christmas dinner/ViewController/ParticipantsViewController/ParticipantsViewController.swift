//
//  ParticipantsViewController.swift
//  Christmas dinner
//
//  Created by PABLO HERNANDEZ JIMENEZ on 9/1/19.
//  Copyright © 2019 PABLO HERNANDEZ JIMENEZ. All rights reserved.
//

import UIKit

class ParticipantsViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    
    internal var participants: [Participants] = []
    internal var repository = LocalParticipantsRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mis tareas"
        registerCells()
        participants = repository.getAll()
        
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        navigationItem.setRightBarButton(addBarButtonItem, animated: false)
        
    }
    
    @objc internal func addPressed() {
        let addVC = addParticipantsViewController(participant: nil)
        addVC.delegate = self
        addVC.modalTransitionStyle = .coverVertical
        addVC.modalPresentationStyle = .overCurrentContext
        present(addVC, animated:false)
    }
    
    //Register the identifier of the cell
    private func registerCells(){
        let identifier = "ParticipantsCell"
        let cellNib = UINib(nibName: identifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: identifier)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension ParticipantsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return participants.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ParticipantsCell = (tableView.dequeueReusableCell(withIdentifier: "ParticipantsCell", for: indexPath) as? ParticipantsCell)!
        let participant = participants[indexPath.row]
        cell.lblcell.text = participant.name
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let participant = participants[indexPath.row]
        if repository.update(a: participant){
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let participant = participants[indexPath.row]
            if repository.delete(a: participants){
                participants.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
}
extension ParticipantsViewController: AddParticipantsViewControllerDelegate {
    func addViewController(_ vc: AddParticipantsViewController, didEditTask participants: Participants) {
        vc.dismiss(animated: true, completion: nil)
        if repository.create(a: participants){
            participants = repository.getAll()
            tableView.reloadData()
        }
    }
}
