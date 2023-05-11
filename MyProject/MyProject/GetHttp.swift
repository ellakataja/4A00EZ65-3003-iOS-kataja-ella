//
//  GetHttp.swift
//  MyProject
//
//  Created by Ella Kataja on 11.5.2023.
//

import Foundation
import Alamofire

func getHttpConnection(callback : @escaping (UsersList) -> Void) {
    let url : URL = URL(string : "https://dummyjson.com/users")!
    AF.request(url).response {
        response in print(response)
        let data = response.data
        
        let decoder = JSONDecoder()
        do {
            let usersList : UsersList = try decoder.decode(UsersList.self,
            from: data!)
            print(usersList)
            callback(usersList)
        } catch {
            print("Failed to decode JSON \(error.localizedDescription)")
        }
    }
}
