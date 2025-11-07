# Loan Prediction App

A simple Flutter application for loan prediction based on user inputs.

## Features

- **Input Screen**: Contains form fields for all required prediction parameters
    - Numeric fields: Loan Amount, Loan Interest Rate, Person Age, Employment Length, Person Income
    - Dropdown menus for categorical fields: Age Band, Band, Binary Flag, Grade, Purpose, Residence,
      Size Band

- **Result Screen**: Displays the prediction result and score

## Setup

### 1. Install Dependencies

Run the following command in your terminal:

```bash
flutter pub get
```

### 2. Configure API Endpoint

Before running the app, you need to configure your API endpoint:

1. Open `lib/prediction_service.dart`
2. Replace `'YOUR_API_BASE_URL'` with your actual API URL

   Example:
   ```dart
   static const String baseUrl = 'http://your-api-domain.com';
   ```

   or for local testing:
   ```dart
   static const String baseUrl = 'http://10.0.2.2:5000';  // For Android emulator
   static const String baseUrl = 'http://localhost:5000';  // For web/desktop
   ```

### 3. Run the App

```bash
flutter run
```

## Usage

1. Fill in all the required fields in the Input Screen
2. Press the "Get Prediction" button
3. View the prediction result and score on the Result Screen
4. Press "Back to Input" to make another prediction

## API Integration

The app sends a POST request to `/predict` endpoint with the following JSON structure:

```json
{
  "loan_amnt": 10000,
  "loan_int_rate": 12,
  "person_age": 30,
  "person_emp_length": 3,
  "person_income": 30000,
  "Age_band": "26-35",
  "Band": "middle",
  "Binary_flag": "Y",
  "Grade": "B",
  "Purpose": "PERSONAL",
  "Residence": "RENT",
  "Size_band": "medium"
}
```

Expected response:

```json
{
  "prediction": "its safe",
  "score": 0.3421
}
```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── input_screen.dart      # Input form screen
├── result_screen.dart     # Result display screen
└── prediction_service.dart # API service
```

## Notes

- Make sure your API server is running before testing the app
- For Android emulator, use `10.0.2.2` instead of `localhost`
- For iOS simulator, you can use `localhost`
- All fields are validated before submission

