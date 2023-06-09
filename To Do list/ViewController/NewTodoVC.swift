//
//  NewTodoVC.swift
//  To Do list
//
//  Created by Osama Ramadan on 13/03/2023.
//

import UIKit

class NewTodoVC: UIViewController {

    var isCreation = true
    var editedTodo: Todo?
    var editedTodoIndex: Int?
    
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var todoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if !isCreation{
            mainButton.setTitle("Edit", for: .normal)
            navigationItem.title = "Edit Mission"
            
            if let todo = editedTodo {
                titleTextField.text = todo.title
                detailsTextView.text = todo.details
                todoImageView.image = todo.image
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeButtonClicked(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func addButtonClicked(_ sender: Any) {
        if isCreation {
            let todo = Todo(title: titleTextField.text!, image: todoImageView.image, details: detailsTextView.text)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil, userInfo: ["addedTodo": todo])
            
            
            let alert = UIAlertController(title: "Added", message: "the mission has been added successfully", preferredStyle: UIAlertController.Style.alert)
            let closeAction = UIAlertAction(title: "Done", style: UIAlertAction.Style.cancel) { _ in
                self.tabBarController?.selectedIndex = 0
                self.titleTextField.text = ""
                self.detailsTextView.text = ""
            }
            
            alert.addAction(closeAction)
            present(alert, animated: true, completion: {
                
            })
            
            
            
        }else { // else, if the the view controller is opened for edit (not for create)
            let todo = Todo(title: titleTextField.text!, image: todoImageView.image, details: detailsTextView.text)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentTodoEdited"), object: nil, userInfo: ["editedTodo": todo, "editedTodoIndex": editedTodoIndex])
            
            let alert = UIAlertController(title: "Modified", message: "The Task Has Been Modified successfully", preferredStyle: UIAlertController.Style.alert)
            let closeAction = UIAlertAction(title:"Done", style: UIAlertAction.Style.cancel) { _ in
                self.navigationController?.popViewController(animated: true)
                self.titleTextField.text = ""
                self.detailsTextView.text = ""
            }
            
            alert.addAction(closeAction)
            present(alert, animated: true, completion: {
                
            })
            
            
        }
        
        
        
    }
    

}


extension NewTodoVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        dismiss(animated: true, completion: nil)
        todoImageView.image = image
    }
    
}

