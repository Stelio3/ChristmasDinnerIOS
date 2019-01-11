//
//  ParticipantsViewController.swift
//  Christmas dinner
//
//  Created by PABLO HERNANDEZ JIMENEZ on 9/1/19.
//  Copyright © 2019 PABLO HERNANDEZ JIMENEZ. All rights reserved.
//

import UIKit
import RealmSwift

class ParticipantsViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    let realm = try! Realm()
    var participant:Participants?
    internal var participants: [Participants] = []
    internal var repository = LocalParticipantsRepository()
    internal var filteredParticipants: [Participants] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        participants = repository.getAll()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Participantes"
        
        registerCells()
        participants = repository.getAll()
        
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        navigationItem.setRightBarButton(addBarButtonItem, animated: false)
        
        createButtonAdd()
        configSearchBar()
    }
    
    @objc internal func addPressed() {
        let addVC = AddParticipantsViewController()
        addVC.delegate = self
        addVC.modalTransitionStyle = .coverVertical
        addVC.modalPresentationStyle = .overCurrentContext
        present(addVC, animated:false)
    }
    
    internal func createButtonAdd(){
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        navigationItem.rightBarButtonItem = addButtonItem
    }
    
    internal func configSearchBar(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar.backgroundColor = UIColor.white
        navigationItem.searchController = searchController
    }
    //Register the identifier of the cell
    private func registerCells(){
        let identifier = "ParticipantsCell"
        let cellNib = UINib(nibName: identifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: identifier)
    }
    
    //Internal funcions for the searchBar
    internal func searchBarIsEmpty() -> Bool{
        return searchController.searchBar.text?.isEmpty ?? true
    }
    internal func isFiltering() -> Bool{
        return searchController.isActive && !searchBarIsEmpty()
    }
    internal func filterContentForSearchText(searchText: String){
        filteredParticipants = participants.filter({ (nParticipants: Participants ) -> Bool in
            return (nParticipants.name.lowercased().contains(searchText.lowercased()))
        })
        tableView.reloadData()
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
        if isFiltering(){
            return filteredParticipants.count
        }else{
            return participants.count
        }
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
        
        if isFiltering(){
            let participant = filteredParticipants[indexPath.row]
            let updateVC = UpdateViewController(participant: participant)
            updateVC.delegate = self as! UpdateViewControllerDelegate
            updateVC.modalTransitionStyle = .coverVertical
            updateVC.modalPresentationStyle = .overCurrentContext
            searchController.dismiss(animated: true, completion: nil)
            present(updateVC, animated: true, completion: nil)
        }else{
            let participant = participants[indexPath.row]
            let updateVC = UpdateViewController(participant: participant)
            updateVC.delegate = self as! UpdateViewControllerDelegate
            updateVC.modalTransitionStyle = .coverVertical
            updateVC.modalPresentationStyle = .overCurrentContext
            searchController.dismiss(animated: true, completion: nil)
            present(updateVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if isFiltering(){
                let participant = filteredParticipants[indexPath.row]
                if repository.delete(a: participant){
                    participants.remove(at: indexPath.row)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
            }else{
                let participant = participants[indexPath.row]
                if repository.delete(a: participant){
                    participants.remove(at: indexPath.row)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
            }
        }
    }
}
extension ParticipantsViewController: AddParticipantsViewControllerDelegate {
    func errorAddParticipantsViewController(_ vc: AddParticipantsViewController) {
        vc.dismiss(animated: true, completion: nil)
    }
    
    func addParticipantsViewController(_ vc: AddParticipantsViewController, didEditParticipants participants: Participants) {
        vc.dismiss(animated: true, completion: nil)
        if repository.create(a: participants){
            self.participants = repository.getAll()
            tableView.reloadData()
        }
    }
}
extension ParticipantsViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
