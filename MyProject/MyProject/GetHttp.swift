//
//  GetHttp.swift
//  MyProject
//
//  Created by Ella Kataja on 11.5.2023.
//

import Foundation
import Alamofire

/// A function that gets http connection to the server
/// and gets all the users from there.
/// - Parameters:
///    - callback: A callback parameter that is used after a succesfull connection.
func getHttpConnection(callback : @escaping (UsersList) -> Void) {
    
    /// The url as a String variable
    let url : String = "https://dummyjson.com/users"
    
    /// Alamofire HTTP Client gets asyncronous request
    /// of the users with the url
    AF.request(url).response {
        /// Response is being printed to indicate succes or failure
        response in print(response)
        /// Data from the connection response is saved inside a variable
        let data = response.data
        
        /// Decoder for parsing the data
        let decoder = JSONDecoder()
        do {
            /// attempting to decode the JSON data
            let usersList : UsersList = try decoder.decode(UsersList.self,
            from: data!)
            print(usersList)
            /// Calling the callback with a list of the received users
            callback(usersList)
        } catch {
            /// In case of a failure it prints an error message
            print("Failed to decode JSON \(error.localizedDescription)")
        }
    }
}
