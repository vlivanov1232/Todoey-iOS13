//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray: [TodoTask] = [
//        TodoTask(todo: "Buy Milk", isDone: false),
//        TodoTask(todo: "Go to gym", isDone: false),
//        TodoTask(todo: "Destroy dragon", isDone: false)
    ]
    
    let datafilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(K.documentForItemsname)

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    
    fileprivate func saveData() {
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            guard let datafilePath = self.datafilePath else { return }
            try data.write(to: datafilePath)
        } catch {
            print(error)
        }
    }
    
    fileprivate func loadData() {
        guard let dataFilePath = datafilePath else { return }
        do{
            let data = try Data(contentsOf: dataFilePath)
            let decoder = PropertyListDecoder()
            itemArray = try decoder.decode([TodoTask].self, from: data)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Add Action Alert
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "ToDo", message: "Add new task", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            switch action.style{
                case .default:
                if let text = alert.textFields![0].text, text != "" {

                    self.itemArray.append(TodoTask(todo: text, isDone: false))
                    
                    self.saveData()
                   
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            default:
                break
            }
        }))
        
        alert.addTextField { (textField: UITextField) in
                textField.placeholder = "What todo?"
                textField.keyboardType = .default
            }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.todoCellName, for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.todo
        cell.accessoryType = item.isDone ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        saveData()
        tableView.reloadData()
    }

}

