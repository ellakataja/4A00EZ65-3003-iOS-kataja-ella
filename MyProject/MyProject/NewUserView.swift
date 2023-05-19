//
//  NewUserView.swift
//  MyProject
//
//  Created by Ella Kataja on 9.5.2023.
//

import Foundation
import SwiftUI
import Alamofire

struct NewUserView: View {
    @State var users: [User] = []
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var nameLengthBoolean : Bool = false
    @State private var isAdded : Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            NavigationStack {
                TextField(
                    "First name",
                    text: $firstName
                )
                .padding(3)
                .background(
                    Rectangle()
                    .stroke(Color.gray)
                    .background(.gray.opacity(0.2)))
                TextField(
                    "Last name",
                    text: $lastName
                )
                .padding(3)
                .background(
                    Rectangle()
                    .stroke(Color.gray)
                    .background(.gray.opacity(0.2)))
                Button("Add user") {
                    if firstName.count > 1 && lastName.count > 1 {
                        addUser(firstName: firstName, lastName: lastName)
                        isAdded = true
                    } else {
                        nameLengthBoolean = true
                    }
                }
                .foregroundColor(.white)
                .background(.green)
                .buttonStyle(.bordered)
                .cornerRadius(10)
                .alert(isPresented: $isAdded) {
                    Alert(title: Text("User added"),
                          dismissButton: .default(Text("Okay")) {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                }
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

func addUser(firstName : String?, lastName : String?) {
    let params: Parameters = [
            "firstName": firstName!,
            "lastName": lastName!
        ]
        
    AF.request("https://dummyjson.com/users/add", method:
    .post, parameters: params, encoding: JSONEncoding.default)
    .response { response in print(response)
    let data = response.data
        
    let decoder = JSONDecoder()
        do {
            let user : User = try decoder.decode(User.self,
            from: data!)
            print(user)
        } catch {
            print("Failed to decode JSON: \(error.localizedDescription)")
        }
    }
}
