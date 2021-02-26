//
//  ViewController.swift
//  Mooncascade-Employee
//
//  Created by Ashutosh Mane on 15.02.2021.
//

import UIKit
import Foundation
import Contacts
import ContactsUI


class EmployeeListViewController: UIViewController {
    @IBOutlet var employeeListTableView:UITableView!
    let refreshControl = UIRefreshControl()
    var contactViewController:CNContactViewController?
    
    //MARK:view Model instance
    var viewModel:EmployeeListViewModel=EmployeeListViewModel()
    var dataSource:ArrangedEmployees=ArrangedEmployees(keys: [], employees: [:])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupEmployeeListTableView()
        self.loadEmployeeListTableView()
        
        
        
    }
    
    private func setupEmployeeListTableView() {
        employeeListTableView.allowsSelection=true
        employeeListTableView.delegate=self
        employeeListTableView.dataSource=self
        employeeListTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(self.refreshEmployeeTableView(_:)), for: .valueChanged)
        
    }
    
    
    //MARK:Setup and loading Table View
    private func loadEmployeeListTableView() {
        viewModel.getemployees { (employeesResult) in
            switch employeesResult{
            
            case .success(let employees):
                self.dataSource=employees
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.employeeListTableView.reloadData()
                    
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.showErrorAlert(from : error)
                }
                
            }
        }
        
    }
    
    
    //MARK:Other UI Element
    
    @objc func refreshEmployeeTableView(_ sender: AnyObject) {
        self.loadEmployeeListTableView()
        self.refreshControl.endRefreshing()
    }
    
    private func getSectionHeaderView(with title:String) -> UIView {
        let label=UILabel()
        label.text=title
        label.font=UIFont(name: "SF PRO", size: CGFloat(24.00))
        return label
    }
    
    private func showErrorAlert(from error: EmployeeAppError){
        let alert = UIAlertController(title: error.rawValue, message: "unable to reload Data", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            self.employeeListTableView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @objc func onContactCardButtonClicked(sender:UIButton){
        let buttonPosition = sender.convert(CGPoint.zero, to: self.employeeListTableView)
        let indexPath = self.employeeListTableView.indexPathForRow(at: buttonPosition)
        if indexPath != nil {
            //MARK:Contacts modal view controller
            self.contactViewController=CNContactViewController(for: (self.dataSource.employees[dataSource.keys[indexPath!.section]]![indexPath!.row].cnContact)!)
            contactViewController!.allowsEditing=true
            contactViewController?.isEditing=false
            contactViewController!.delegate=self
            let navigationController1 = UINavigationController(rootViewController: self.contactViewController!)
            self.present(navigationController1, animated: true)
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let index = employeeListTableView.indexPathForSelectedRow,let EmployeeDetailVC=segue.destination as? EmployeeDetailViewController
        else{
            return
        }
        EmployeeDetailVC.employee=dataSource.employees[dataSource.keys[index.section]]?[index.row]
        
    }
}

//MARK: Table View delegates and datasource
extension EmployeeListViewController:  UITableViewDelegate, UITableViewDataSource{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.keys.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return getSectionHeaderView(with: dataSource.keys[section])
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.employees[dataSource.keys[section]]?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = employeeListTableView.dequeueReusableCell(withIdentifier: "employee_cell", for: indexPath) as! EmployeeTableViewCell
        
        
        cell.lastName.text=self.dataSource.employees[self.dataSource.keys[indexPath.section]]?[indexPath.row].lastName
        cell.firstName.text=self.dataSource.employees[self.dataSource.keys[indexPath.section]]?[indexPath.row].firstName
        cell.contactCard.addTarget(self, action: #selector(self.onContactCardButtonClicked(sender:)), for: .touchUpInside)
        
        if ((self.dataSource.employees[self.dataSource.keys[indexPath.section]]?[indexPath.row].isContactable)!){
            
            cell.contactCard.isEnabled=true
            cell.contactCard.isHidden=false
        }
        else{
            cell.contactCard.isEnabled=false
            cell.contactCard.isHidden=true
        }
        
        return cell
    }
    
   
    
}

extension EmployeeListViewController:CNContactViewControllerDelegate{
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}



//MARK:TABLE VIEW CELL

class EmployeeTableViewCell:UITableViewCell{
    
    @IBOutlet var contactCard: UIButton!
    @IBOutlet var lastName:UILabel!
    @IBOutlet var firstName:UILabel!
    
    
    
}

