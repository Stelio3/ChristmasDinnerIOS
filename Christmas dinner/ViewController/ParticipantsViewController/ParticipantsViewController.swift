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
    
    internal var tasks: [Task] = []
    internal var repository = LocalTaskRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mis tareas"
        registerCells()
        tasks = repository.getAll()
        
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        navigationItem.setRightBarButton(addBarButtonItem, animated: false)
        
    }
    
    @objc internal func addPressed() {
        let addVC = AddParticipantsViewController(task: nil)
        addVC.delegate = self
        addVC.modalTransitionStyle = .coverVertical
        addVC.modalPresentationStyle = .overCurrentContext
        present(addVC, animated:false)
    }
    
    //Register the identifier of the cell
    private func registerCells(){
        let identifier = "TaskCell"
        let cellNib = UINib(nibName: identifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: identifier)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TaskCell = (tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell)!
        let task = tasks[indexPath.row]
        cell.lblcell.text = task.name
        cell.imgcell.isHidden = !task.isDone
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        task.isDone = !task.isDone
        if repository.update(a: task){
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let task = tasks[indexPath.row]
            if repository.delete(a: task){
                tasks.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
}
extension MainViewController: AddViewControllerDelegate {
    func addViewController(_ vc: AddViewController, didEditTask task: Task) {
        vc.dismiss(animated: true, completion: nil)
        if repository.create(a: task){
            tasks = repository.getAll()
            tableView.reloadData()
        }
    }
}
