# Императивный vs Декларативный подход

## Концепция

### Императивный подход (UIKit)
**"КАК сделать"** - вы описываете шаги для достижения результата
- Создай кнопку
- Установи текст
- Установи цвет
- Добавь на экран
- Настрой constraints
- Добавь обработчик

### Декларативный подход (SwiftUI)
**"ЧТО нужно"** - вы описываете желаемый результат
- Нужна кнопка с текстом "OK" синего цвета

---

## Пример 1: Простая кнопка

### UIKit (императивный)
```swift
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Шаг 1: Создать кнопку
        let button = UIButton(type: .system)
        
        // Шаг 2: Установить текст
        button.setTitle("Нажми меня", for: .normal)
        
        // Шаг 3: Установить цвет
        button.setTitleColor(.blue, for: .normal)
        
        // Шаг 4: Установить размер шрифта
        button.titleLabel?.font = .systemFont(ofSize: 18)
        
        // Шаг 5: Добавить на экран
        view.addSubview(button)
        
        // Шаг 6: Отключить автоматические constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Шаг 7: Настроить constraints (позиция)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Шаг 8: Добавить обработчик
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        print("Кнопка нажата")
    }
}
```

### SwiftUI (декларативный)
```swift
struct ContentView: View {
    var body: some View {
        Button("Нажми меня") {
            print("Кнопка нажата")
        }
        .foregroundColor(.blue)
        .font(.system(size: 18))
        .frame(width: 200, height: 44)
    }
}
```

**Разница:** UIKit - 8 шагов, SwiftUI - описание результата

---

## Пример 2: Список элементов

### UIKit (императивный)
```swift
class ViewController: UIViewController {
    var tableView: UITableView!
    let items = ["Яблоко", "Банан", "Апельсин"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Шаг 1: Создать таблицу
        tableView = UITableView()
        
        // Шаг 2: Настроить делегаты
        tableView.dataSource = self
        tableView.delegate = self
        
        // Шаг 3: Зарегистрировать ячейку
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Шаг 4: Добавить на экран
        view.addSubview(tableView)
        
        // Шаг 5: Настроить constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// Шаг 6: Реализовать протоколы
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Выбрано: \(items[indexPath.row])")
    }
}
```

### SwiftUI (декларативный)
```swift
struct ContentView: View {
    let items = ["Яблоко", "Банан", "Апельсин"]
    
    var body: some View {
        List(items, id: \.self) { item in
            Text(item)
                .onTapGesture {
                    print("Выбрано: \(item)")
                }
        }
    }
}
```

**Разница:** UIKit - 6 шагов + 2 extension, SwiftUI - описание структуры списка

---

## Пример 3: Форма с полями ввода

### UIKit (императивный)
```swift
class FormViewController: UIViewController {
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Создать поле имени
        nameTextField = UITextField()
        nameTextField.placeholder = "Имя"
        nameTextField.borderStyle = .roundedRect
        nameTextField.delegate = self
        view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Создать поле email
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.delegate = self
        view.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Создать кнопку
        submitButton = UIButton(type: .system)
        submitButton.setTitle("Отправить", for: .normal)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Настроить constraints
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            submitButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc func submitTapped() {
        print("Имя: \(nameTextField.text ?? "")")
        print("Email: \(emailTextField.text ?? "")")
    }
}

extension FormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
```

### SwiftUI (декларативный)
```swift
struct FormView: View {
    @State private var name = ""
    @State private var email = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Имя", text: $name)
                .textFieldStyle(.roundedBorder)
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            
            Button("Отправить") {
                print("Имя: \(name)")
                print("Email: \(email)")
            }
            .frame(width: 200)
        }
        .padding()
    }
}
```

**Разница:** UIKit - много шагов настройки, SwiftUI - описание формы

---

## Пример 4: Анимация появления

### UIKit (императивный)
```swift
class ViewController: UIViewController {
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label = UILabel()
        label.text = "Привет!"
        label.alpha = 0 // Начальное состояние - невидимо
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Анимировать появление
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut) {
            self.label.alpha = 1.0
            self.label.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.label.transform = .identity
            }
        }
    }
}
```

### SwiftUI (декларативный)
```swift
struct ContentView: View {
    @State private var isVisible = false
    
    var body: some View {
        Text("Привет!")
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1.2 : 1.0)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0)) {
                    isVisible = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isVisible = false
                    }
                }
            }
    }
}
```

**Или еще проще:**
```swift
struct ContentView: View {
    var body: some View {
        Text("Привет!")
            .animation(.spring(response: 0.6, dampingFraction: 0.8))
            .scaleEffect(1.2)
    }
}
```

---

## Пример 5: Условное отображение

### UIKit (императивный)
```swift
class ViewController: UIViewController {
    var label: UILabel!
    var isLoading = false {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label = UILabel()
        label.text = "Загрузка..."
        view.addSubview(label)
        // ... constraints
        
        updateUI()
    }
    
    func updateUI() {
        if isLoading {
            label.isHidden = false
            label.text = "Загрузка..."
        } else {
            label.isHidden = true
        }
    }
}
```

### SwiftUI (декларативный)
```swift
struct ContentView: View {
    @State private var isLoading = false
    
    var body: some View {
        if isLoading {
            Text("Загрузка...")
        }
    }
}
```

**Разница:** UIKit - нужно вручную управлять видимостью, SwiftUI - условный рендеринг

---

## Пример 6: Навигация

### UIKit (императивный)
```swift
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.setTitle("Перейти", for: .normal)
        button.addTarget(self, action: #selector(goToNext), for: .touchUpInside)
        view.addSubview(button)
        // ... constraints
    }
    
    @objc func goToNext() {
        let nextVC = NextViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
```

### SwiftUI (декларативный)
```swift
struct ContentView: View {
    var body: some View {
        NavigationStack {
            NavigationLink("Перейти") {
                NextView()
            }
        }
    }
}
```

---

## Пример 7: Сложный layout с несколькими элементами

### UIKit (императивный)
```swift
class ViewController: UIViewController {
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var imageView: UIImageView!
    var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Создать все элементы
        titleLabel = UILabel()
        titleLabel.text = "Заголовок"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleLabel = UILabel()
        subtitleLabel.text = "Подзаголовок"
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textColor = .gray
        view.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        button = UIButton(type: .system)
        button.setTitle("Действие", for: .normal)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Настроить все constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            button.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
```

### SwiftUI (декларативный)
```swift
struct ContentView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Заголовок")
                .font(.bold(.system(size: 24)))
            
            Text("Подзаголовок")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: 100, height: 100)
            
            Button("Действие") {
                // действие
            }
        }
        .padding()
    }
}
```

---

## Ключевые отличия

| Аспект | UIKit (императивный) | SwiftUI (декларативный) |
|--------|---------------------|------------------------|
| **Подход** | "Как сделать" | "Что нужно" |
| **Код** | Много шагов | Описание результата |
| **Обновления** | Вручную обновлять UI | Автоматически |
| **Layout** | Constraints вручную | Автоматический |
| **Состояние** | Управление вручную | Реактивное |
| **Анимации** | Явные вызовы | Декларативные модификаторы |

---

## Аналогия из жизни

### Императивный (UIKit)
> "Иди на кухню, открой холодильник, возьми яйца, закрой холодильник, иди к плите, включи огонь, разбей яйца в сковороду..."

### Декларативный (SwiftUI)
> "Мне нужна яичница"

---

## Вывод

**Императивный подход:**
- Контроль над каждым шагом
- Больше кода
- Больше возможностей для ошибок
- Нужно помнить о всех деталях

**Декларативный подход:**
- Описываете результат
- Меньше кода
- Меньше ошибок
- Фреймворк сам решает детали

SwiftUI делает код более читаемым, поддерживаемым и менее подверженным ошибкам!

