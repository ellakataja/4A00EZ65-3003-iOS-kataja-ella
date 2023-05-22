//
//  SearchUsers.swift
//  MyProject
//
//  Created by Ella Kataja on 11.5.2023.
//

import Foundation
import Alamofire

/// A function that searches a user by it's name or email from the server
///  - Parameters:
///     - searchText: Input of the search that is used to find
///     mathing names or emails of the users
///     - callback: A callback parameter that is used after a succesfull connection.
func search(searchText : String, callback: @escaping ([User]?) -> Void) {
    /// Variable of the searchText that transforms spaces with &
    let modifiedSearchText = searchText.replacingOccurrences(of: " ", with: "&")
    /// Variable of the url to search from the server
    let url : String = "https://dummyjson.com/users/search?q=\(modifiedSearchText)"
    
    /// Alamofire HTTP Client sends asyncronous request to the server
    AF.request(url).responseDecodable(of: UsersList.self) {
        /// The reponse is being printed to indicate succes or failure
        response in print(response)
        /// Switch case  handles the response
        switch response.result {
        /// In case of succesfull connection list of the users is given to callback
        case .success(let usersList):
            /// Call the callback
            callback(usersList.users)
        /// In case of failure it prints error message
        case .failure(let error):
            print("Failed to search \(error.localizedDescription)")
        }
    }
}
