//
//  UpdateUserView.swift
//  MyProject
//
//  Created by Ella Kataja on 19.5.2023.
//

import Foundation
import SwiftUI
import Alamofire

struct UpdateUserView: View {
    let user: User
    @State var users: [User] = []
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var nameLengthBoolean : Bool = false
    @State private var isEdited : Bool = false
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
                .onAppear {
                    firstName = user.firstName
                }
                TextField(
                    "Last name",
                    text: $lastName
                )
                .padding(3)
                .background(
                    Rectangle()
                    .stroke(Color.gray)
                    .background(.gray.opacity(0.2)))
                .onAppear {
                    lastName = user.lastName
                }
                
                Button("Update user") {
                    if firstName.count > 1 && lastName.count > 1 {
                        let updatedUser = User(
                        id: user.id,
                        firstName: firstName,
                        lastName: lastName
                        )
                        updateUser(user : updatedUser)
                        isEdited = true
                    } else {
                        nameLengthBoolean = true
                    }
                }
                .foregroundColor(.white)
                .background(.green)
                .buttonStyle(.bordered)
                .cornerRadius(10)
                .alert(isPresented: $isEdited) {
                    Alert(title: Text("User updated"),
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
            .navigationTitle("User \(firstName) \(lastName)")
            .padding()
        }
    }
}

private func updateUser(user: User) {
    let id : Int = user.id
    let url : URL = URL(string : "https://dummyjson.com/users/\(id)")!
    let parameters = [
        "firstName": user.firstName,
        "lastName": user.lastName
    ]
    
    AF.request(url, method: .put, parameters: parameters).response {
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
