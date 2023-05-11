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
    let id : Int
    let firstName : String
    let lastName : String
}

struct ContentView: View {
    @State var users : [User] = []
    @State private var firstName : String = ""
    @State private var lastName : String = ""
    @State private var searchText = ""
    @State private var isDeleted : Bool = false

    var body: some View {
        NavigationView {
            NavigationStack {
                List {
                    ForEach(users, id: \.firstName) { user in
                        HStack {
                            Text("\(user.firstName) \(user.lastName)")
                            Spacer()
                            Button(action: {
                                delete(id : user.id)
                                isDeleted = true
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                            .foregroundColor(.white)
                            .background(.red)
                            .buttonStyle(.bordered)
                            .cornerRadius(10)
                            .alert(isPresented: $isDeleted) {
                                Alert(title: Text("User deleted"),
                                dismissButton: .default(Text("Okay")))
                            }
                        }
                    }
                }
                .searchable(text: $searchText)
                .onChange(of: searchText) { _ in
                    search(searchText : searchText) { searchedUsers in
                        if let searchedUsers = searchedUsers {
                            self.users = searchedUsers
                        }
                    }
                }
                NavigationLink(destination: NewUserView()) {
                    Text("Add new user")
                }
                .navigationTitle("All users")
                //.padding()
                .onAppear {
                    getHttpConnection { usersList in
                        users = usersList.users
                    }
                }
            }
        }
    }
}
    
