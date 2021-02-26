//
//  ArrangedEmployee.swift
//  Mooncascade-Employee
//
//  Created by Ashutosh Mane on 21.02.2021.
//

import Foundation
//MARK:Model Employee Dict with Key as Positions (created for Easier Fetching in SearchViewController)
public struct ArrangedEmployees {
    var keys:[String]
    var employees:[String:[Employee]]
}
