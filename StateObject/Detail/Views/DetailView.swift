//
//  DetailView.swift
//  StateObject
//
//  Created by Roman Gojshik on 2.12.25.
//

import SwiftUI

struct DetailView: View {
    // @StateObject - создаем и владеем ViewModel (создается ОДИН РАЗ)
    @StateObject private var viewModel = DetailViewModel(name: "Иван", email: "ivan@example.com")
    
    // @State - локальное состояние View (не связано с ViewModel)
    @State private var showPassword: Bool = false
    @State private var counter: Int = 0
    
    // @Environment - получение системных значений из окружения SwiftUI
    @Environment(\.colorScheme) var colorScheme          // светлая/темная тема
    @Environment(\.dismiss) var dismiss                  // для закрытия экрана
    @Environment(\.locale) var locale                    // текущая локаль
    @Environment(\.horizontalSizeClass) var horizontalSizeClass  // размер экрана (iPhone/iPad)
    @Environment(\.verticalSizeClass) var verticalSizeClass      // ориентация
    
    var body: some View {
        Form {
            makeDemoBinding()
            makeDemoState()
            makeDemoPublished()
            makeDemoEnviroment()
            
            Section {
                Button {
                    viewModel.save()
                } label: {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                        Text(viewModel.isLoading ? "Сохранение..." : "Сохранить")
                    }
                    .frame(maxWidth: .infinity)
                }
                .disabled(!viewModel.isValid || viewModel.isLoading)
            }
            
            Section {
                if !viewModel.saveMessage.isEmpty {
                    Text(viewModel.saveMessage)
                        .foregroundColor(.green)
                        .font(.caption)
                }
            }
        }
        .navigationTitle("Детали")
        .navigationBarTitleDisplayMode(.inline)
        // Демонстрация: меняем фон в зависимости от темы
        .background(colorScheme == .dark ? Color.black.opacity(0.1) : Color.white)
    }
    
    private func makeDemoBinding() -> some View {
        Section("Профиль пользователя") {
            // @Binding - двусторонняя связь с @Published свойством ViewModel
            TextField("Имя", text: $viewModel.name)
                .textFieldStyle(.roundedBorder)
            
            // Создаем явный Binding
            EmailFieldView(email: $viewModel.email)
            
            // Комбинация @State (showPassword) и @Binding (viewModel.password)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    if showPassword {
                        TextField("Пароль", text: $viewModel.password)
                            .textFieldStyle(.roundedBorder)
                    } else {
                        SecureField("Пароль", text: $viewModel.password)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Button {
                        showPassword.toggle() // меняем @State
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                    }
                }
                
                if !viewModel.passwordErrorMessage.isEmpty {
                    Text(viewModel.passwordErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    private func makeDemoState() -> some View {
        Section("Демонстрация @State") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Локальный счетчик (не в ViewModel): \(counter)")
                
                HStack {
                    Button("-") {
                        counter -= 1 // меняем @State напрямую
                    }
                    .buttonStyle(.bordered)
                    
                    Button("+") {
                        counter += 1 // меняем @State напрямую
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
    
    private func makeDemoPublished() -> some View {
        Section("Демонстрация @Published") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Имя из ViewModel: \(viewModel.name)")
                Text("Email из ViewModel: \(viewModel.email)")
                Text("Пароль валиден: \(viewModel.isPasswordValid ? "✅" : "❌")")
                Text("Валидность формы: \(viewModel.isValid ? "✅ Валидно" : "❌ Невалидно")")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
    }
    
    private func makeDemoEnviroment() -> some View {
        Section("Демонстрация @Environment") {
            VStack(alignment: .leading, spacing: 8) {
                // Цветовая схема
                HStack {
                    Text("Тема:")
                    Spacer()
                    Text(colorScheme == .dark ? "🌙 Темная" : "☀️ Светлая")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
                
                // Локаль
                HStack {
                    Text("Локаль:")
                    Spacer()
                    Text(locale.identifier)
                }
                
                // Размер экрана
                HStack {
                    Text("Горизонтальный размер:")
                    Spacer()
                    Text(horizontalSizeClass == .compact ? "iPhone" : horizontalSizeClass == .regular ? "iPad" : "Неизвестно")
                }
                
                HStack {
                    Text("Вертикальный размер:")
                    Spacer()
                    Text(verticalSizeClass == .compact ? "Landscape" : "Portrait")
                }
                
                // Кнопка для демонстрации dismiss
                Button("Закрыть экран (dismiss)") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
            .font(.caption)
        }
    }
}

struct EmailFieldView: View {
    @Binding var email: String      // ← явный биндинг

    var body: some View {
        TextField("Email", text: $email)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.emailAddress)
    }
}

#Preview {
    NavigationStack {
        DetailView()
    }
}
