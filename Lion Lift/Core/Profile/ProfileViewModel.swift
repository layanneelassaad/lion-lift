//
//  ProfileViewModel.swift
//  Lion Lift
//
//  Created by Chase Preston on 11/21/24.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var userName: String = "John Doe"
    @Published var userAge: String = "25"
    @Published var userPhone: String = "123-456-7890"
    @Published var userEmail: String = "john.doe@example.com"
    @Published var profileImage: UIImage? = UIImage(systemName: "person.circle")
    @Published var showImagePicker: Bool = false
}

#Preview {
    ProfileViewModel()
}
