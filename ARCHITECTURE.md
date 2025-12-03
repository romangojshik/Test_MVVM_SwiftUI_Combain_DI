# Архитектура проекта StateObject

## Общая схема MVVM архитектуры

```
┌─────────────────────────────────────────────────────────────┐
│                    StateObjectApp                            │
│  (Точка входа в приложение)                                  │
│                                                              │
│  @StateObject private var dependencyContainer                │
│         │                                                     │
│         └─── DependencyContainer (ObservableObject)          │
│                    │                                          │
│                    └─── EntryStore                            │
│                                                              │
│  WindowGroup {                                               │
│      ContentView()                                           │
│          .environmentObject(dependencyContainer) ────────────┐
│  }                                                           │
└──────────────────────────────────────────────────────────────┘
                                                               │
                                                               │
┌──────────────────────────────────────────────────────────────▼─┐
│                    ContentView                                 │
│  (Главный экран)                                               │
│                                                                 │
│  @EnvironmentObject var dependencyContainer ◄──────────────────┘
│         │                                                       │
│         └─── DependencyContainer                                │
│                    │                                            │
│                    └─── entryStore: EntryStore                  │
│                                                                 │
│  @StateObject var viewModel = ContentViewModel()               │
│         │                                                       │
│         └─── ContentViewModel (ObservableObject)               │
│                    │                                            │
│                    ├─── @Published var refreshTimestamp         │
│                    └─── func refresh()                         │
│                                                                 │
│  body: some View {                                             │
│      VStack {                                                  │
│          Text(viewModel.refreshTimestamp)                      │
│          Button("Refresh") { viewModel.refresh() }             │
│          Spacer()                                              │
│          BottomBarView(                                        │
│              viewModel: BottomBarViewModel(                    │
│                  entryStore: dependencyContainer.entryStore    │
│              )                                                 │
│          )                                                     │
│      }                                                         │
│  }                                                             │
└─────────────────────────────────────────────────────────────────┘
                                                               │
                                                               │
┌───────────────────────────────────────────────────────────────▼─┐
│                    BottomBarView                               │
│  (Нижняя панель)                                                │
│                                                                 │
│  @StateObject var viewModel: BottomBarViewModel                 │
│         │                                                       │
│         └─── BottomBarViewModel (ObservableObject)              │
│                    │                                            │
│                    ├─── @Published var text: String             │
│                    ├─── entryStore: EntryStore                  │
│                    └─── Timer (обновляет text каждые 2 сек)     │
│                                                                 │
│  body: some View {                                             │
│      Text(viewModel.text)                                      │
│  }                                                             │
└─────────────────────────────────────────────────────────────────┘
```

## Поток данных и жизненный цикл

### 1. Инициализация приложения
```
StateObjectApp запускается
    ↓
Создается DependencyContainer (@StateObject)
    ↓
DependencyContainer создает EntryStore
    ↓
DependencyContainer передается через .environmentObject()
```

### 2. Создание ContentView
```
ContentView создается
    ↓
@StateObject создает ContentViewModel (ОДИН РАЗ!)
    ↓
@EnvironmentObject получает DependencyContainer
    ↓
body вычисляется
```

### 3. Создание BottomBarView
```
ContentView.body вызывается
    ↓
Создается BottomBarViewModel(entryStore: ...)
    ↓
Передается в BottomBarView
    ↓
@StateObject в BottomBarView сохраняет ViewModel (ОДИН РАЗ!)
    ↓
Timer запускается
```

### 4. При нажатии "Refresh"
```
Button "Refresh" нажата
    ↓
viewModel.refresh() вызывается
    ↓
refreshTimestamp обновляется
    ↓
ContentView перерисовывается
    ↓
НО! BottomBarViewModel НЕ пересоздается (благодаря @StateObject)
    ↓
Timer продолжает работать
```

## Ключевые концепции

### @StateObject
- **Назначение**: Управляет жизненным циклом ObservableObject
- **Поведение**: Создает объект ОДИН РАЗ при первом создании View
- **Использование**: 
  - `ContentView`: `@StateObject var viewModel = ContentViewModel()`
  - `BottomBarView`: `@StateObject var viewModel: BottomBarViewModel`

### @EnvironmentObject
- **Назначение**: Получает объект из окружения (environment)
- **Поведение**: Ищет объект в иерархии View выше
- **Использование**: 
  - `ContentView`: `@EnvironmentObject var dependencyContainer`

### Dependency Injection
```
StateObjectApp
    └─── DependencyContainer (создается один раз)
            └─── EntryStore
                    │
                    └─── Передается в BottomBarViewModel
```

## Сравнение @StateObject vs @ObservableObject

### С @StateObject (текущая реализация)
```
1. ContentView.body вызывается
2. BottomBarViewModel создается (первый раз)
3. ContentView.body вызывается снова
4. BottomBarViewModel НЕ пересоздается ✅
5. Timer продолжает работать ✅
```

### С @ObservableObject (неправильно)
```
1. ContentView.body вызывается
2. BottomBarViewModel создается
3. ContentView.body вызывается снова
4. BottomBarViewModel ПЕРЕСОЗДАЕТСЯ ❌
5. Timer перезапускается ❌
6. Потеря состояния ❌
```

## Файловая структура

```
StateObject/
├── StateObjectApp.swift          # Точка входа, создает DependencyContainer
├── ContentView.swift             # Главный экран с @StateObject и @EnvironmentObject
├── ContentViewModel.swift        # ViewModel для ContentView
├── BottomBarView.swift           # Включает BottomBarView и BottomBarViewModel
├── DependencyContainer.swift     # Контейнер зависимостей (DI)
└── EntryStore.swift              # Хранилище данных
```

## Визуализация обновлений

```
┌─────────────────────────────────────┐
│  ContentView                         │
│  ┌───────────────────────────────┐  │
│  │ Last refresh: 10:30:45        │  │
│  │ [Refresh Button]              │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ BottomBarView                 │  │
│  │ Random number: 42             │  │ ← Обновляется каждые 2 сек
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

## Важные моменты

1. **@StateObject** гарантирует, что ViewModel создается только один раз
2. **@EnvironmentObject** позволяет передавать зависимости через иерархию View
3. **Timer в BottomBarViewModel** демонстрирует, что ViewModel живет и работает
4. **DependencyContainer** обеспечивает централизованное управление зависимостями
5. При перерисовке View ViewModel не пересоздается, сохраняя состояние

