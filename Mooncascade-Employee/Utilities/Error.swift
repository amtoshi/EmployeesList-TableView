//
//  Error.swift
//  Mooncascade-Employee
//
//  Created by Ashutosh Mane on 19.02.2021.
//

import Foundation

public enum EmployeeAppError: String,Error
{
    case InvalidURL="invalid URL in compilation"
    case IncompleteRequest="request interrupted"
    case FailedFetch="failed fetch request error"
    case InvalidResponse="invalid response code"
    case ParsingError="error occured in parsing"
    case fetchingContactError="Contact Manager failed to operate"
}
