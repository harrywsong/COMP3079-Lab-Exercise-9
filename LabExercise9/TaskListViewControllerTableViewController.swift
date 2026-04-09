//
//  TaskListViewControllerTableViewController.swift
//  LabExercise9
//
//  Created by Woohyuk Song on 2026-04-08.
//

import UIKit
import CoreData

class TaskListViewControllerTableViewController: UITableViewController {

    var tasks: [Task] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        fetchTasks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTasks()
        tableView.reloadData()
    }

    func fetchTasks() {
        tasks = (try? context.fetch(Task.fetchRequest())) ?? []
    }

    // MARK: - Table view
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].title
        return cell
    }

    // MARK: - Swipe Actions
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, done in
            self.context.delete(self.tasks[indexPath.row])
            try? self.context.save()
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            done(true)
        }

        let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, done in
            let alert = UIAlertController(title: "Edit Task", message: nil, preferredStyle: .alert)
            alert.addTextField { $0.text = self.tasks[indexPath.row].title }
            alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
                self.tasks[indexPath.row].title = alert.textFields?.first?.text
                try? self.context.save()
                tableView.reloadRows(at: [indexPath], with: .automatic)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
            done(true)
        }
        edit.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
}
