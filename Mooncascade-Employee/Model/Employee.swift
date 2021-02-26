//
//  employee.swift
//  Mooncascade-Employee
//
//  Created by Ashutosh Mane on 16.02.2021.
//

import Foundation
import Contacts

// MARK: - EMPLOYEE

struct Employee{
    var firstName, lastName, position: String
    var projects: [String]?
    var email: String
    var phone: String?
    var isContactable:Bool
    var cnContact:CNContact?
    
    
    
}

extension Employee:Equatable,Hashable{
    
    static func == (lhs:Employee,rhs:Employee)-> Bool{
        return (lhs.firstName+lhs.lastName)==(rhs.firstName+rhs.lastName)
    }
    
}

//MARK:EMPLOYEES
struct Employees{
    var employees:[Employee]
    
    
    enum MainResponseKey:String,CodingKey{
        case employees
        
        enum employeeKey:String, CodingKey{
            case firstName="fname"
            case lastName="lname"
            case position
            case contactDetails="contact_details"
            case projects
            case email
            case phone
            
            
            
        }
    }
}
extension Employees:Decodable{
    //MARK: Manual decoder for  JSON Data with Coding Keys
    init(from decoder: Decoder) throws {
        
            let mainResponseContainer = try? decoder.container(keyedBy: MainResponseKey.self)
            var nestedEmployeeContainer = try mainResponseContainer?.nestedUnkeyedContainer(forKey: .employees)
            var tempEmp=Employee(firstName: "", lastName: "", position: "", projects: [""], email: "", phone: nil, isContactable: false)
            self.employees=[]
            
            while !nestedEmployeeContainer!.isAtEnd{
                
                let employeeContainer=try nestedEmployeeContainer?.nestedContainer(keyedBy: MainResponseKey.employeeKey.self)
                tempEmp.firstName = try (employeeContainer?.decode(String.self, forKey: MainResponseKey.employeeKey.firstName))!
                tempEmp.lastName = try (employeeContainer?.decode(String.self, forKey: MainResponseKey.employeeKey.lastName))!
                tempEmp.position = try (employeeContainer?.decode(String.self, forKey: MainResponseKey.employeeKey.position))!
                tempEmp.projects=try employeeContainer?.decodeIfPresent([String].self, forKey: .projects)
                
                let contactDetailsContainer=try employeeContainer?.nestedContainer(keyedBy: MainResponseKey.employeeKey.self, forKey: .contactDetails)
                tempEmp.email=try (contactDetailsContainer?.decode(String.self, forKey:.email ))!
                tempEmp.phone=try contactDetailsContainer?.decodeIfPresent(String.self, forKey: .phone)
                tempEmp.isContactable=false
                tempEmp.cnContact=nil
                self.employees.append(tempEmp)
            }
        
        
    }
    
    
    
    
    
    
    
    
}






