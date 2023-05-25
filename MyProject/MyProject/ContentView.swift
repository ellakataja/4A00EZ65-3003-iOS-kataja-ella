//
//  ContentView.swift
//  MyProject
//
//  Created by Ella Kataja on 9.5.2023.
//

import SwiftUI
import Alamofire

/// A struct that represents a list of all the users
struct UsersList : Decodable {
    /// A list of users consisting of single users
    let users : [User]
}

/// A struct that represents a single user with id, name and email address
struct User : Decodable {
    /// Unique id number indentifies every user
    let id : Int
    let firstName : String
    let lastName : String
    let email : String
}

/// A struct of the ContentView which is the main page
/// it connects all the functionalities
struct ContentView: View {
    /// A list of the users shown on the page
    @State var users : [User] = []
    /// User input for the search
    @State private var searchText : String = ""
    /// Boolean that controls delete pop-up
    @State private var isDeleted : Bool = false
    
    /// The body of the main View
    var body: some View {
        /// Navigation for moving between ContentView, UpdateUserView
        /// and NewUserView
        NavigationView {
            NavigationStack {
                /// List that displays all the users by default and
                /// searched users while searching
                List {
                    /// Creates an UI for every user by its id
                    ForEach(users, id: \.id) { user in
                        HStack {
                            /// User's data is displayed in one row
                            VStack(alignment: .leading) {
                                Text("\(user.firstName) \(user.lastName)")
                                Text("\(user.email)")
                                    .padding(2)
                            }
                            .padding(2)
                            Spacer()
                            /// NavigationLink that moves to UpdateUserView and
                            /// passes the chosen user with it
                                NavigationLink(destination:
                                UpdateUserView(👤: user)) {
                                    Image(systemName: "square.and.pencil")
                                        .padding(10)
                                }
                                .frame(width: 43, height: 35)
                                .foregroundColor(.white)
                                .background(.yellow)
                                .buttonStyle(.bordered)
                                .cornerRadius(10)
                            /// Button that calls the delete function
                            /// and passes the chosen user's id to it
                            Button(action: {
                                delete(id : user.id)
                                /// Delete pop-up is shown to user
                                isDeleted = true
                            }) {
                                Image(systemName: "trash")
                            }
                            .foregroundColor(.white)
                            .background(.red)
                            .buttonStyle(.bordered)
                            .cornerRadius(10)
                        }
                    }
                }
                /// Search field that uses the input
                .searchable(text: $searchText)
                /// Modifier that is triggered when the search input is
                /// changing.
                .onChange(of: searchText) { _ in
                    search(searchText : searchText) { searchedUsers in
                        /// For every succesfull search the userlist
                        /// is being updated with the results
                        if let searchedUsers = searchedUsers {
                            self.users = searchedUsers
                        }
                    }
                }
                /// NavigationLink that moves to NewUserView
                NavigationLink(destination: NewUserView()) {
                    Image(systemName: "person.badge.plus")
                    Text("Add new user")
                }
                .frame(width: 400, height: 40)
                .foregroundColor(.white)
                .background(.green)
                .navigationTitle("All users")
                /// Before the views appears
                /// getHttpConnection is being called with a trailing
                /// lambda that defines the list of the users to be all users
                .onAppear {
                    getHttpConnection { usersList in
                        users = usersList.users
                    }
                }
            }
        }
        /// Delete pop-up that indicates that the deletion was succesfull
        .alert(isPresented: $isDeleted) {
            Alert(title: Text("User deleted"),
            dismissButton: .default(Text("Okay")))
        }
    }
}
