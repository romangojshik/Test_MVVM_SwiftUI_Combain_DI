//
//  DetailViewModel.swift
//  StateObject
//
//  Created by Roman Gojshik on 2.12.25.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    // @Published - свойства, которые автоматически обновляют UI при изменении
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var saveMessage: String = ""
    
    init(name: String = "", email: String = "") {
        self.name = name
        self.email = email
    }
    
    func save() {
        isLoading = true
        saveMessage = ""
        
        // Симуляция сохранения
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            self.saveMessage = "Данные сохранены: \(self.name)"
        }
    }
    
    var isValid: Bool {
        !name.isEmpty && !email.isEmpty && email.contains("@") && isPasswordValid
    }
    
    var isPasswordValid: Bool {
        password.count >= 8
    }
    
    var passwordErrorMessage: String {
        if password.isEmpty {
            return ""
        }
        if password.count < 8 {
            return "Пароль должен быть минимум 8 символов"
        }
        return ""
    }
}

