//
//  TodoVC.swift
//  To Do list
//
//  Created by Osama Ramadan on 13/03/2023.
//

import UIKit
import CoreData
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    
        //ffffffff
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class TodosVC: UIViewController {
    
    var todosArray:[Todo] = [
    ]
    @IBOutlet weak var todosTableView: UITableView!
    
    override func viewDidLoad() {
        self.todosArray = getTodo()
        
        super.viewDidLoad()
       
        
        
        // New Todo Notification
        NotificationCenter.default.addObserver(self, selector: #selector(newTodoAdded), name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil)
        
        // Edit Todo Notification
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoEdited), name: NSNotification.Name(rawValue: "CurrentTodoEdited"), object: nil)
        
        // Delete Todo Notification
        NotificationCenter.default.addObserver(self, selector: #selector(todoDeleted), name: NSNotification.Name(rawValue: "TodoDeleted"), object: nil)
        todosTableView.dataSource = self
        todosTableView.delegate = self
    }
    
    @objc func newTodoAdded(notification: Notification){
        
        if let myTodo = notification.userInfo?["addedTodo"] as? Todo {
            todosArray.append(myTodo)
            todosTableView.reloadData()
            storeTodo(todo: myTodo)
        }
    }
    
    @objc func currentTodoEdited(notification: Notification){
        if let todo = notification.userInfo?["editedTodo"] as? Todo {
            if let index = notification.userInfo?["editedTodoIndex"] as? Int {
                todosArray[index] = todo
                
                todosTableView.reloadData()
                updateData(todo: todo, index: index)
            }
        }
    }
    
    @objc func todoDeleted(notification: Notification){
        if let index = notification.userInfo?["deletedTodoIndex"] as? Int {
            
            todosArray.remove(at: index)
            todosTableView.reloadData()
            deleteTodo(index: index)
            
            
        }
    }
    
    func storeTodo(todo : Todo){
        guard let appdelegate = UIApplication.shared.delegate as?AppDelegate else {return}
        let manageContext = appdelegate.persistentContainer.viewContext
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Todo", in: manageContext) else { return  }
        let todoObject = NSManagedObject(entity: todoEntity, insertInto: manageContext)
        todoObject.setValue(todo.title, forKey: "title")
        todoObject.setValue(todo.details, forKey: "detail")
        
        if let image = todo.image{
            let imageData = image.jpegData(compressionQuality: 1)
            todoObject.setValue(imageData, forKey: "image")
        }
        
        do {
            try manageContext.save()
            
            print("======success======")
        }catch{
            print("=======error========")
            
        }
        
        
    }
    func updateData(todo : Todo , index : Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let context = appDelegate.persistentContainer.viewContext
            let  fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
            
            do {
                 let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            
                result [index].setValue(todo.title, forKey: "title")
                result [index].setValue(todo.details, forKey: "detail")
                if let image = todo.image {
                    let imageData = image.jpegData(compressionQuality: 1)
                    result [index].setValue(imageData, forKey: "image")
                }
                
            
                try context.save()
                    
                
            }catch {
                print("=====error========")
            }
            
        }
    func deleteTodo(index : Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let context = appDelegate.persistentContainer.viewContext
            let  fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
            
            do {
                 let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            
               let TodoDelete = result[index]
                context.delete(TodoDelete)
                try context.save()
                    
                
            }catch {
                print("=====error========")
            }
            
        }

    
    func getTodo() -> [Todo] {
        var todos : [Todo] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return[]}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        do {
            let result =  try context.fetch(fetchRequest) as!  [NSManagedObject]
            for manageTodo in result {
                print(manageTodo)
                let title = manageTodo.value(forKey: "title") as? String
                let detials = manageTodo.value(forKey: "detail") as? String
                var todoImage : UIImage? = nil
                if let imageFromContext = manageTodo.value(forKey: "image") as? Data {
                    todoImage = UIImage(data: imageFromContext)
                }
                let todo = Todo(title: title ?? "", image: todoImage ,details: detials ?? "")
                todos.append(todo)
            }
        }
        catch{
            print("========error=======")
        }
        return todos }
        
        
        
        
        
        
    }
    
    extension TodosVC: UITableViewDataSource, UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todosArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as! TodoCell
            
            cell.todoTitleLabel.text = todosArray[indexPath.row].title
            
            if todosArray[indexPath.row].image != nil {
                cell.todoImageView.image = todosArray[indexPath.row].image
            }else {
                cell.todoImageView.image = UIImage(named: "Image-4")
            }
            
            cell.todoImageView.layer.cornerRadius = cell.todoImageView.frame.width / 2
            
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let todo = todosArray[indexPath.row]
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? TodoDetailsVC
            
            if let viewController = vc {
                viewController.todo = todo
                viewController.index = indexPath.row
                
                navigationController?.pushViewController(viewController, animated: true)
            }
            
        }
        

        
        
        
        
        
    }



