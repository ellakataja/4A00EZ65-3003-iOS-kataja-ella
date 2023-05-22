//
//  NewUserView.swift
//  MyProject
//
//  Created by Ella Kataja on 9.5.2023.
//

import Foundation
import SwiftUI
import Alamofire

/// A struct of the NewUserView
struct NewUserView: View {
    /// Variable of the user's first name
    @State private var firstName: String = ""
    /// Variable of the user's last name
    @State private var lastName: String = ""
    /// Variable of the user's email address
    @State private var email: String = ""
    /// Boolean that controls a warning text's visibility
    @State private var nameLengthBoolean : Bool = false
    /// Boolean that controls user added pop-up's visibility
    @State private var isAdded : Bool = false
    /// Property that controls whether this view is shown or not
    @Environment(\.presentationMode) var presentationMode
    
    /// View's body that defines the UI
    var body: some View {
        NavigationView {
            NavigationStack {
                /// HStack that holds information text and
                /// input for the first name
                HStack {
                    Text("First name ⃰")
                    TextField(
                        "First name required",
                        text: $firstName
                    )
                    .padding(3)
                    .background(
                        Rectangle()
                        .stroke(Color.gray)
                        .background(.gray.opacity(0.2)))
                }
                .padding(5)
                /// HStack that holds information text and
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
                }
                .padding(5)
                /// HStack that holds information text and
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
                }
                .padding(5)
                /// A button that adds the new user
                Button("Add user") {
                    /// Checks if the names are correct length
                    if firstName.count > 1 && lastName.count > 1 {
                        /// If both names are two or more character long
                        /// button calls addUser function and passes
                        /// the input values to it
                        addUser(firstName: firstName, lastName: lastName, email: email)
                        /// Pop-up of succession is shown to user
                        isAdded = true
                    } else {
                        /// If names don't pass the requirements
                        /// warning text is shown
                        nameLengthBoolean = true
                    }
                }
                .foregroundColor(.white)
                .background(.green)
                .buttonStyle(.bordered)
                .cornerRadius(10)
                /// Pop-up of succesfull adding
                .alert(isPresented: $isAdded) {
                    Alert(title: Text("User added"),
                          dismissButton: .default(Text("Okay")) {
                        /// Button closes the pop-up and the view returns
                        /// to the ContentView
                        self.presentationMode.wrappedValue.dismiss()
                    })
                }
                /// If the names don't pass the requirements
                /// warning text is being shown to the user
                if(nameLengthBoolean == true) {
                    VStack {
                        Text("Name length minimum 2 characters")
                    }
                }
            }
            .navigationTitle("Create new user")
            .padding()
        }
    }
}

/// A function that adds the new user to the server (simulation)
/// - Parameters:
///    - firstName: user's input for the first name
///    - lastName: user's input for the last name
///    - email: user's input for the email
func addUser(firstName : String?, lastName : String?, email : String?) {
    /// The parameters that are applied to the URL request
    let params: Parameters = [
            "firstName": firstName!,
            "lastName": lastName!,
            "email": email!,
        ]
        
    /// The url for adding to the server
    let url : String = "https://dummyjson.com/users/add"
    
    /// Alamofire HTTP Client is sending asyncronous request to the server
    /// It uses post method to add the parameter of the new user
    AF.request(url, method:
    .post, parameters: params, encoding: JSONEncoding.default)
    /// The reponse is being printed to indicate succes or failure
    .response { response in print(response)
    /// response's data is saved as a variable
    let data = response.data
        
    /// Using JSONdecoder to parse the data
    let decoder = JSONDecoder()
        do {
            /// Attempts to decode the data to a new user
            let user : User = try decoder.decode(User.self,
            from: data!)
            /// Prints the new user's information
            print(user)
        } catch {
            /// In case of failure it prints an error message
            print("Failed to decode JSON: \(error.localizedDescription)")
        }
    }
}
