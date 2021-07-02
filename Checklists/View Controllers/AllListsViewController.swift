//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Tolga PIRTURK on 28.03.2021.
//

import UIKit

class AllListsViewController: UITableViewController,
                              ListDetailViewControllerDelegate,
                              UINavigationControllerDelegate {
    
    let cellIdentifier = "ChecklistCell"
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        //print(documentsDirectory())
        print("View did load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        print("View will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if 0..<dataModel.lists.count ~= index {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
        print("View did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("View will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("View did disappear")
    }
        
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    // MARK: - Table view data source
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return dataModel.lists.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: UITableViewCell!
        if let tmp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = tmp
            print("var olan cell kullanıldı \(indexPath)")
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
            print("yeni cell üretildi \(indexPath)")
        }
        
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        } else {
            cell.detailTextLabel!.text = count == 0 ? "All Done" : "\(count) Remaining"
        }
        
        cell.imageView!.image = UIImage(named: checklist.iconName)
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    // MARK: - Table view delegate
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        
        dataModel.indexOfSelectedChecklist = indexPath.row
    }
    
    override func tableView(
        _ tableView: UITableView,
        accessoryButtonTappedForRowWith indexPath: IndexPath
    ) {
        let controller = storyboard!.instantiateViewController(
            withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Navigation Controller Delegates
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    // MARK: - List Detail View Controller Delegates
    func listDetailViewControllerDidCancel(
        _ controller: ListDetailViewController
    ) {
        navigationController?.popViewController(animated: true)
    }
    
    func lisDetailViewController(
        _ controller: ListDetailViewController,
        didFinishAdding checklist: Checklist
    ) {
        //let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        //let indexPath = IndexPath(row: newRowIndex, section: 0)
        //let indexPaths = [indexPath]
        //tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishEditing checklist: Checklist
    ) {
//        if let index = dataModel.lists.firstIndex(of: checklist) {
//            let indexPath = IndexPath(row: index, section: 0)
//            if let cell = tableView.cellForRow(at: indexPath) {
//                cell.textLabel!.text = checklist.name
//            }
//        }
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}
