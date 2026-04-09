//
//  ViewController.swift
//  LabExercise9
//
//  Created by Woohyuk Song on 2026-04-08.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var taskTextField: UITextField!
    
    @IBAction func addTaskTapped(_ sender: UIButton) {
        guard let title = taskTextField.text, !title.isEmpty else { return }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let task = Task(context: context)
        task.title = title
        task.createdAt = Date()
        try? context.save()
        
        taskTextField.text = ""
        performSegue(withIdentifier: "showTaskList", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
