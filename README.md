# Travel Journal - SwiftUI App

Mobile Application Development II - Assignment #1
Yongjie Xie
Github:https://github.com/Mou2xie/travel_journal_Swift

## Input Validation Logic Implementation

### 1. Form Validation State Management
Using `@State` to manage error states:
```swift
@State private var isTitleError: Bool = false
@State private var isLocationError: Bool = false
@State private var isDateError: Bool = false
```

### 2. Real-time Input Validation
- **Title and Location Validation**: Uses `.onSubmit` modifier to check character length
- **Date Validation**: Uses `.onChange` modifier to real-time check if start date is earlier than end date
- **Notes Character Limit**: Limits maximum 250 characters in `.onChange`

### 3. Save Button Disable Logic
Computed property `saveBtnDisabled` checks all validation conditions:
```swift
private var saveBtnDisabled: Bool {
    if title.isEmpty || title.count < 2 || location.isEmpty
        || location.count < 2 || startDate > endDate || notes.count > 250
    {
        return true
    } else {
        return false
    }
}
```

## Modal Implementation

### Sheet Modal
Uses SwiftUI's `.sheet` modifier to display trip details preview:

```swift
.sheet(isPresented: $isAlerShow) {
    VStack(spacing: 10) {
        Text("Trip Saved")
        // Display all trip information
        HStack {
            Text("Title")
            Spacer()
            Text(title).fontWeight(.semibold)
        }
        // ... other information display
    }
    .padding(40)
    Button("Close") {
        isAlerShow = false
    }
}
```

### Trigger Mechanism
Clicking the "Save" button sets `isAlerShow = true` to trigger modal display.

## Key Features
- Form input and real-time validation
- Automatic trip duration calculation
- Sheet modal preview
- Form reset functionality
