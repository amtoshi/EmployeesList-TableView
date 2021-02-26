//
//  NetworkHandler.swift
//  Mooncascade-Employee
//
//  Created by Ashutosh Mane on 16.02.2021.
//

import Foundation
//MARK:Singleton Network Handler
final class NetworkManager{
    
    static var shared=NetworkManager()
    
    func loadDatafromURL(with url:String, on completion:@escaping (Result<[Employee],EmployeeAppError>)->()) {
        
        guard let url = URL(string: url) else {
            completion(.failure(.InvalidURL))
            return
        }
        let session=URLSession.shared
        let task=session.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                completion(.failure(.IncompleteRequest))
                
            }
            guard let response=response as? HTTPURLResponse, response.statusCode==200 else{
                completion(.failure(.InvalidResponse))
                return
            }
            
            guard let data=data
            else{
                completion(.failure(.FailedFetch))
                return
            }
            
            do{
                let decoder=JSONDecoder()
                let employeesObj = try decoder.decode(Employees.self, from: data)
                completion(.success(employeesObj.employees))
                
            }
            catch{ 
                completion(.failure(.ParsingError))
                
            }
            
        }
        task.resume()
    }
}
