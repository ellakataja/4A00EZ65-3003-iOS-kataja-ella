//
//  UpdateUserView.swift
//  MyProject
//
//  Created by Ella Kataja on 19.5.2023.
//

import Foundation
import SwiftUI
import Alamofire

/// A struct of the UpdateUserView
struct UpdateUserView: View {
    /// Variable of a single user that is edited
    let user : User
    /// Variable of the user's first name
    @State private var firstName : String = ""
    /// Variable of the user's last name
    @State private var lastName : String = ""
    /// Variable of the user's email
    @State private var email : String = ""
    /// Boolean that controls a warning text's visibility
    @State private var nameLengthBoolean : Bool = false
    /// Boolean that controls a succession pop-up's visibility
    @State private var isEdited : Bool = false
    /// Property that controls whether this view is shown or not
    @Environment(\.presentationMode) var presentationMode
    
    /// View's body that defines the UI
    var body: some View {
        NavigationView {
            NavigationStack {
                /// HStack that hold's information text and
                /// input for the first name
                HStack {
                    Text("First name ⃰")
                    TextField(
                        "Firt name required",
                        text: $firstName
                    )
                    .padding(3)
                    .background(
                        Rectangle()
                            .stroke(Color.gray)
                            .background(.gray.opacity(0.2)))
                    /// Previous first name is inside the input field
                    /// by default
                    .onAppear {
                        firstName = user.firstName
                    }
                }
                .padding(5)
                /// HStack that hold's information text and
                /// input for the last name
                HStack {
                    Text("Last name ⃰")
                    TextField(
                        "Last name required",
                        text: $lastName
                    )
                    .padding(3)
                    .background(
                        Rectangle()
                            .stroke(Color.gray)
                            .background(.gray.opacity(0.2)))
                    /// Previous last name is inside the input field
                    /// by default
                    .onAppear {
                        lastName = user.lastName
                    }
                }
                .padding(5)
                /// HStack that hold's information text and
                /// input for the email
                HStack {
                    Text("Email")
                    TextField(
                        "Email address optional",
                        text: $email
                    )
                    .padding(3)
                    .background(
                        Rectangle()
                            .stroke(Color.gray)
                            .background(.gray.opacity(0.2)))
                    /// Previous email is inside the input field
                    /// by default
                    .onAppear {
                        email = user.email
                    }
                }
                .padding(5)
                /// Button that updates the user's data
                Button("Update user") {
                    /// If both names are two or more characters the user is updated
                    if firstName.count > 1 && lastName.count > 1 {
                        /// Variable of the updated user's new data
                        let updatedUser = User(
                        id: user.id,
                        firstName: firstName,
                        lastName: lastName,
                        email: email
                        )
                        /// Calls the updateUser function and
                        /// passes the updated user to it
                        updateUser(user : updatedUser)
                        /// Succession pop-up is shown
                        isEdited = true
                    } else {
                        /// If the names don't pass the requirements
                        /// warning text is shown
                        nameLengthBoolean = true
                    }
                }
                .foregroundColor(.white)
                .background(.green)
                .buttonStyle(.bordered)
                .cornerRadius(10)
                /// Pop-up for a successfull update
                .alert(isPresented: $isEdited) {
                    Alert(title: Text("User updated"),
                          /// Pop-up button closes the pop-up and
                          /// moves back to the ContentView
                          dismissButton: .default(Text("Okay")) {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                }
                /// If the names don't pass the requirements
                /// warning text is shown
                if(nameLengthBoolean == true) {
                    VStack {
                        Text("Name length minimum 2 characters")
                    }
                }
            }
            .navigationTitle("Edit user")
            .padding()
        }
    }
}

/// Function that updates the user to the server (simulation)
/// - Parameters:
///    - user: User with the updated data from the inputs
private func updateUser(user: User) {
    /// User's id to indentificate the user
    let id : Int = user.id
    /// Url to update a spesific user
    let url : String = "https://dummyjson.com/users/\(id)"
    /// Parameters that are applied to the URL request
    let parameters = [
        "firstName": user.firstName,
        "lastName": user.lastName,
        "email": user.email,
    ]
    
    /// Alamofire HTTP Client sends asyncronous request to the server
    /// It uses put method to update the user with the given parameters
    AF.request(url, method: .put, parameters: parameters).response {
        /// The reponse is being printed to indicate succes or failure
        response in print(response)
        /// Response's data is saved as a variable
        let data = response.data
        
        /// Using JSONdecoder to parse the data
        let decoder = JSONDecoder()
        do {
            /// Attempts to decode the data to an updated user
            let user : User = try decoder.decode(User.self,
            from: data!)
            /// Prints the updated user's information
            print(user)
        } catch {
            /// In case of failure print error message
            print("Failed to decode JSON \(error.localizedDescription)")
        }
    }
}
