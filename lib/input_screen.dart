import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'prediction_result_screen.dart';
import 'prediction_service.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final PredictionService _predictionService = PredictionService();
  bool _isLoading = false;

  // Form fields
  String? _ageBand;
  String? _band;
  String? _binaryFlag;
  String? _grade;
  String? _purpose;
  String? _residence;
  String? _sizeBand;
  double? _loanAmount;
  double? _loanInterestRate;
  int? _personAge;
  int? _personEmpLength;
  double? _personIncome;

  final List<String> _ageBands = ['20-25', '26-35', '36-45', '46-55', '56-65'];
  final List<String> _bands = [
    'high',
    'high-middle',
    'middle',
    'low-middle',
    'low',
  ];
  final List<String> _binaryFlags = ['Y', 'N'];
  final List<String> _grades = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
  final List<String> _purposes = [
    'DEBTCONSOLIDATION',
    'EDUCATION',
    'HOMEIMPROVEMENT',
    'MEDICAL',
    'PERSONAL',
    'VENTURE',
  ];
  final List<String> _residences = ['MORTGAGE', 'RENT', 'OWN', 'OTHER'];
  final List<String> _sizeBands = ['small', 'medium', 'large', 'very large'];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      final result = await _predictionService.makePrediction({
        'Age_band': _ageBand,
        'Band': _band,
        'Binary_flag': _binaryFlag,
        'Grade': _grade,
        'Purpose': _purpose,
        'Residence': _residence,
        'Size_band': _sizeBand,
        'loan_amnt': _loanAmount,
        'loan_int_rate': _loanInterestRate,
        'person_age': _personAge,
        'person_emp_length': _personEmpLength,
        'person_income': _personIncome,
      });

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PredictionResultScreen(
              prediction: result['prediction'] as String,
              score: result['score'] as double,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField2<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        isExpanded: true,
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a value';
          }
          return null;
        },
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Prediction Input'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _predictionService.clearToken();
              if (mounted) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/auth', (route) => false);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildDropdown(
                'Age Band',
                _ageBands,
                _ageBand,
                (val) => setState(() => _ageBand = val),
              ),
              _buildDropdown(
                'Band',
                _bands,
                _band,
                (val) => setState(() => _band = val),
              ),
              _buildDropdown(
                'Binary Flag',
                _binaryFlags,
                _binaryFlag,
                (val) => setState(() => _binaryFlag = val),
              ),
              _buildDropdown(
                'Grade',
                _grades,
                _grade,
                (val) => setState(() => _grade = val),
              ),
              _buildDropdown(
                'Purpose',
                _purposes,
                _purpose,
                (val) => setState(() => _purpose = val),
              ),
              _buildDropdown(
                'Residence',
                _residences,
                _residence,
                (val) => setState(() => _residence = val),
              ),
              _buildDropdown(
                'Size Band',
                _sizeBands,
                _sizeBand,
                (val) => setState(() => _sizeBand = val),
              ),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Loan Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null)
                    return 'Enter a valid number';
                  return null;
                },
                onSaved: (value) => _loanAmount = double.parse(value!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Loan Interest Rate',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null)
                    return 'Enter a valid number';
                  return null;
                },
                onSaved: (value) => _loanInterestRate = double.parse(value!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (int.tryParse(value) == null)
                    return 'Enter a valid number';
                  return null;
                },
                onSaved: (value) => _personAge = int.parse(value!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Employment Length (years)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (int.tryParse(value) == null)
                    return 'Enter a valid number';
                  return null;
                },
                onSaved: (value) => _personEmpLength = int.parse(value!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Annual Income',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null)
                    return 'Enter a valid number';
                  return null;
                },
                onSaved: (value) => _personIncome = double.parse(value!),
              ),
              const SizedBox(height: 24),

              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
