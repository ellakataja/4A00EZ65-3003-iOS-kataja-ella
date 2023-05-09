//
//  ContentView.swift
//  MyProject
//
//  Created by Ella Kataja on 9.5.2023.
//

import SwiftUI
import Alamofire

struct UsersList : Decodable {
    let users : [User]
}

struct User : Decodable {
    let firstName : String
    let lastName : String
}

struct ContentView: View {
    @State var users: [User] = []
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    var body: some View {
        NavigationView {
            NavigationStack {
                List {
                    ForEach(users, id: \.firstName) { user in
                        Text("\(user.firstName) \(user.lastName)")
                    }
                }
                NavigationLink(destination: NewUserView()) {
                    Text("Add new user")
                    //addUser(firstName : firstName, lastName : lastName)
                }
                .navigationTitle("All users")
                .padding()
                .onAppear {
                    getHttpConnection { usersList in
                        self.users = usersList.users
                    }
                }
            }
        }
    }
}

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
