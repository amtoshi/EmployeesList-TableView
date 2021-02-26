//
//  EmployeeDetailViewController.swift
//  Mooncascade-Employee
//
//  Created by Ashutosh Mane on 15.02.2021.
//

import UIKit
import ContactsUI

class EmployeeDetailViewController: UIViewController {
    
    var employee:Employee?
    @IBOutlet var name:UILabel!
    @IBOutlet var position:UILabel!
    @IBOutlet var email:UILabel!
    @IBOutlet var phone:UILabel!
    @IBOutlet var projectsTableView:UITableView!
    @IBOutlet var ContactDetails:UIButton!
    
    var contactViewController:CNContactViewController?
    
    fileprivate func openContactCard() {
        self.contactViewController=CNContactViewController(for: (self.employee?.cnContact)!)
        contactViewController!.allowsEditing=true
        contactViewController?.isEditing=false
        contactViewController!.delegate=self
        let navigationController = UINavigationController(rootViewController: self.contactViewController!)
        self.present(navigationController, animated: true)
        navigationController.delegate=self
    }
    
    @IBAction func contactButtontapped(_ sender: Any) {
        openContactCard()
    }
    
    override func viewDidLoad() {
        
       
        super.viewDidLoad()
        self.updateUI()
        self.projectsTableView.delegate=self
        self.projectsTableView.dataSource=self
    }
    
    private func updateUI() {
        guard let employee = employee else {
           return
        }
        self.name.text=employee.firstName+" "+employee.lastName
        self.position.text=employee.position
        self.email.text=employee.email
        if let phone = employee.phone{
            self.phone.text=phone
        }
        
        else {
            self.phone.text=" Not Available"
            
        }
        
        self.ContactDetails.isHidden = !(employee.isContactable)
        
    }


}

extension EmployeeDetailViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.employee?.projects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = projectsTableView.dequeueReusableCell(withIdentifier: "project_Cell", for: indexPath) as! ProjectCell
        cell.projectName.text=self.employee?.projects?[indexPath.row] ?? "project name"
        return cell
    }
    
    
}

class ProjectCell:UITableViewCell{
    @IBOutlet var projectName:UILabel!
}

extension EmployeeDetailViewController:CNContactViewControllerDelegate,UINavigationControllerDelegate{
 
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

