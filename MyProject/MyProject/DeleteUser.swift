//
//  DeleteUser.swift
//  MyProject
//
//  Created by Ella Kataja on 11.5.2023.
//

import Foundation
import Alamofire

/// A function that deletes a user by it's id from the server (simulation)
/// - Parameters:
///    - id: User's unique id number to indentificate the user
func delete(id : Int) {
    /// Deletion url with a corresponding id
    let url : String = "https://dummyjson.com/users/\(id)"
    
    /// Using Alamofire HTTP request to get connection
    AF.request(url).response {
        /// Prints the response to indicate success or failure
        response in print(response)
        /// Saving the response's data in a variable
        let data = response.data
        
        /// Using JSONdecoder to parse
        let decoder = JSONDecoder()
        do {
            /// Attempts to parse the JSON data as a deleted user
            let user : User = try decoder.decode(User.self,
            from: data!)
            /// Prints the information of the deleted user
            print(user)
        } catch {
            /// In case of failure it prints error message
            print("Failed to decode JSON \(error.localizedDescription)")
        }
    }
}
