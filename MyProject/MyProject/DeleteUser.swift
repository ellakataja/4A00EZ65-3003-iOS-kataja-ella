//
//  DeleteUser.swift
//  MyProject
//
//  Created by Ella Kataja on 11.5.2023.
//

import Foundation
import Alamofire

func delete(id : Int) {
    let url : URL = URL(string : "https://dummyjson.com/users/\(id)")!
    AF.request(url).response {
        response in print(response)
        let data = response.data
        
        let decoder = JSONDecoder()
        do {
            let user : User = try decoder.decode(User.self,
            from: data!)
            print(user)
        } catch {
            print("Failed to decode JSON \(error.localizedDescription)")
        }
    }
}
