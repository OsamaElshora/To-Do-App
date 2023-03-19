//
//  TodoStorage.swift
//  To Do list
//
//  Created by Osama Ramadan on 19/03/2023.
//

import UIKit
import CoreData

class TodoStorage {
    
    static func storeTodo(todo : Todo){
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
    
   static func updateData(todo : Todo , index : Int) {
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
   static func deleteTodo(index : Int) {
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
    
    static func getTodo() -> [Todo] {
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
        
    
