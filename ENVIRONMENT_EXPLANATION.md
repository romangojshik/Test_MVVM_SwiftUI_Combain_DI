# @Environment - Получение системных значений

## Что такое @Environment?

`@Environment` - это property wrapper, который позволяет получать **системные значения** из окружения SwiftUI. Это не то же самое, что `@EnvironmentObject`!

### Разница:
- **@EnvironmentObject** - получает **твой кастомный объект** (например, `DependencyContainer`)
- **@Environment** - получает **системные значения** SwiftUI (тема, локаль, размер экрана и т.д.)

---

## Доступные значения через @Environment

### 1. Цветовая схема (тема)

```swift
@Environment(\.colorScheme) var colorScheme

// Использование:
if colorScheme == .dark {
    // темная тема
} else {
    // светлая тема
}
```

**Возможные значения:**
- `.light` - светлая тема
- `.dark` - темная тема

---

### 2. Закрытие экрана (dismiss)

```swift
@Environment(\.dismiss) var dismiss

// Использование:
Button("Закрыть") {
    dismiss()  // закрывает текущий экран (pop в NavigationStack)
}
```

---

### 3. Локаль (язык и регион)

```swift
@Environment(\.locale) var locale

// Использование:
Text("Локаль: \(locale.identifier)")  // "ru_RU", "en_US" и т.д.
```

---

### 4. Размер экрана (Size Classes)

```swift
@Environment(\.horizontalSizeClass) var horizontalSizeClass
@Environment(\.verticalSizeClass) var verticalSizeClass

// Использование:
if horizontalSizeClass == .compact {
    // iPhone в портретной ориентации
} else if horizontalSizeClass == .regular {
    // iPad или iPhone в ландшафте
}
```

**Возможные значения:**
- `.compact` - компактный размер (iPhone в портрете)
- `.regular` - обычный размер (iPad, iPhone в ландшафте)
- `.none` - не определен

---

### 5. Другие полезные значения

```swift
// Время анимации
@Environment(\.animation) var animation

// Режим редактирования
@Environment(\.editMode) var editMode

// Презентационный режим
@Environment(\.presentationMode) var presentationMode  // устаревший, используй dismiss

// Уровень доступности (размер шрифта)
@Environment(\.dynamicTypeSize) var dynamicTypeSize
```

---

## Примеры использования

### Пример 1: Адаптация под тему

```swift
struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Text("Привет")
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .background(colorScheme == .dark ? Color.gray : Color.yellow)
        }
    }
}
```

### Пример 2: Адаптация под размер экрана

```swift
struct ContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if horizontalSizeClass == .compact {
            // Компактный layout для iPhone
            VStack {
                // элементы
            }
        } else {
            // Обычный layout для iPad
            HStack {
                // элементы
            }
        }
    }
}
```

### Пример 3: Закрытие экрана

```swift
struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Детали")
            
            Button("Назад") {
                dismiss()  // закрывает экран
            }
        }
    }
}
```

---

## В DetailView

В твоем `DetailView` теперь используются:

```swift
@Environment(\.colorScheme) var colorScheme
@Environment(\.dismiss) var dismiss
@Environment(\.locale) var locale
@Environment(\.horizontalSizeClass) var horizontalSizeClass
@Environment(\.verticalSizeClass) var verticalSizeClass
```

**Что можно протестировать:**

1. **Цветовая схема:**
   - Переключи тему в симуляторе (Settings → Developer → Dark Appearance)
   - Увидишь изменение в секции "Демонстрация @Environment"

2. **Локаль:**
   - Измени язык устройства
   - Увидишь изменение локали

3. **Размер экрана:**
   - Запусти на iPhone → увидишь "iPhone"
   - Запусти на iPad → увидишь "iPad"
   - Поверни устройство → увидишь изменение вертикального размера

4. **Dismiss:**
   - Нажми кнопку "Закрыть экран" → экран закроется (вернется на предыдущий)

---

## Сравнение с @EnvironmentObject

| @Environment | @EnvironmentObject |
|--------------|-------------------|
| Системные значения SwiftUI | Твои кастомные объекты |
| `\.colorScheme`, `\.dismiss` и т.д. | `DependencyContainer`, `ViewModel` и т.д. |
| Предоставляется SwiftUI | Ты сам передаешь через `.environmentObject()` |
| Нельзя изменить | Можно изменить |

---

## Полный список доступных значений

SwiftUI предоставляет множество значений через `@Environment`:

- `\.colorScheme` - цветовая схема
- `\.dismiss` - закрытие экрана
- `\.locale` - локаль
- `\.horizontalSizeClass` - горизонтальный размер
- `\.verticalSizeClass` - вертикальный размер
- `\.dynamicTypeSize` - размер шрифта (Accessibility)
- `\.editMode` - режим редактирования
- `\.isEnabled` - включен ли View
- `\.layoutDirection` - направление layout (LTR/RTL)
- `\.openURL` - открытие URL
- `\.scenePhase` - фаза приложения (active/background)
- И многие другие...

---

## Ключевые выводы

1. **@Environment** - для системных значений SwiftUI
2. **@EnvironmentObject** - для твоих кастомных объектов
3. Используй `@Environment` когда нужно адаптировать UI под системные настройки
4. Значения автоматически обновляются при изменении системных настроек

