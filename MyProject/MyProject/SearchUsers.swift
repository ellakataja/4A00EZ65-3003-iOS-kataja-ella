//
//  SearchUsers.swift
//  MyProject
//
//  Created by Ella Kataja on 11.5.2023.
//

import Foundation
import Alamofire

func search(searchText : String, callback: @escaping ([User]?) -> Void) {
    let url : URL = URL(string : "https://dummyjson.com/users/search?q=\(searchText)")!
    // searches for first and lastname and apparently for email and city perhaps??
    AF.request(url).responseDecodable(of: UsersList.self) {
        response in print(response)
        switch response.result {
        case .success(let usersList):
            callback(usersList.users)
        case .failure(let error):
            print("Failed to decode JSON \(error.localizedDescription)")
        }
    }
}
