//
//  EmployeeListViewModel.swift
//  Mooncascade-Employee
//
//  Created by Ashutosh Mane on 19.02.2021.
//

import Foundation
import Contacts
import ContactsUI

final class EmployeeListViewModel {
    
    //MARK:API'S
    private let tallinAPI:String="https://tallinn-jobapp.aw.ee/employee_list/"
    private let tartuAPI:String="https://tartu-jobapp.aw.ee/employee_list/"
    
    //MARK: Fetch function with Swift <ResultType>
    func getemployees(completion:@escaping (Result<(ArrangedEmployees),EmployeeAppError>)->()){
        let group=DispatchGroup()
        var totalEmployeesArrayBeforeSort:[Employee]=[]
        let DataSourceAPI=["https://tallinn-jobapp.aw.ee/employee_list/",
                           "https://tartu-jobapp.aw.ee/employee_list/"]
        for url in DataSourceAPI{
            group.enter()
            NetworkManager.shared.loadDatafromURL(with: url) { resultResource in
                switch resultResource{
                
                case .success(let employees):
                    totalEmployeesArrayBeforeSort.append(contentsOf: self.fetchEmployeeContact(for: employees))
                    group.leave()
                    
                case .failure(let error):
                    completion(.failure(error))
                    
                }
                
            }
            
        }
        
        group.notify(queue: .global(qos: .userInteractive)) {
            completion(.success(self.sortAndFilterEmployees(from: totalEmployeesArrayBeforeSort)))
            
        }
        
        
        
        
    }
    
    //MARK: To check whether in Contacts(Descriptors can be modified
    private func fetchEmployeeContact(for employees:[Employee])->[Employee]{
        var updatedEmployees=employees
        let store = CNContactStore()
        
        let keysToFetch:[CNKeyDescriptor]=[CNContactViewController.descriptorForRequiredKeys()]
        
        for i in 0..<(employees.count){
            do {
                
                let predicate = CNContact.predicateForContacts(matchingName: employees[i].firstName+" "+employees[i].lastName)
                let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
                if contacts.count != 0 {
                    updatedEmployees[i].isContactable=true
                    updatedEmployees[i].cnContact=contacts[0]
                }
            }
            catch {
                return employees
            }
            
        }
        
        return updatedEmployees
    }
    //MARK:Final Sorting into the Order for TableView with Sections
    private func sortAndFilterEmployees(from empArr:[Employee]) -> ArrangedEmployees {
        let filteredEmpArr=empArr.removingDuplicates()
        var dictionary=Dictionary(grouping: filteredEmpArr) { $0.position}
        for key in dictionary.keys{
            dictionary[key]?.sort(by: { (a, b) -> Bool in
                a.lastName < b.lastName
            })
            
        }
        return ArrangedEmployees(keys: dictionary.keys.sorted(by: {$0<$1}), employees: dictionary)
        
    }
}
