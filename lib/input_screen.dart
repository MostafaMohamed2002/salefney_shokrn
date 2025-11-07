import 'package:flutter/material.dart';

import 'prediction_service.dart';
import 'result_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _predictionService = PredictionService();

  bool _isLoading = false;

  // Text field controllers
  final _loanAmountController = TextEditingController();
  final _loanIntRateController = TextEditingController();
  final _personAgeController = TextEditingController();
  final _personEmpLengthController = TextEditingController();
  final _personIncomeController = TextEditingController();

  // Enum values
  String? _ageBand = '26-35';
  String? _band = 'middle';
  String? _binaryFlag = 'Y';
  String? _grade = 'B';
  String? _purpose = 'PERSONAL';
  String? _residence = 'RENT';
  String? _sizeBand = 'medium';

  @override
  void dispose() {
    _loanAmountController.dispose();
    _loanIntRateController.dispose();
    _personAgeController.dispose();
    _personEmpLengthController.dispose();
    _personIncomeController.dispose();
    super.dispose();
  }

  Future<void> _submitPrediction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final data = {
        'loan_amnt': double.parse(_loanAmountController.text),
        'loan_int_rate': double.parse(_loanIntRateController.text),
        'person_age': int.parse(_personAgeController.text),
        'person_emp_length': int.parse(_personEmpLengthController.text),
        'person_income': double.parse(_personIncomeController.text),
        'Age_band': _ageBand,
        'Band': _band,
        'Binary_flag': _binaryFlag,
        'Grade': _grade,
        'Purpose': _purpose,
        'Residence': _residence,
        'Size_band': _sizeBand,
      };

      final result = await _predictionService.predict(data);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              prediction: result['prediction'] ?? 'N/A',
              score: result['score'] ?? 0.0,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Prediction'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Numeric fields
                  TextFormField(
                    controller: _loanAmountController,
                    decoration: const InputDecoration(
                      labelText: 'Loan Amount',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter loan amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _loanIntRateController,
                    decoration: const InputDecoration(
                      labelText: 'Loan Interest Rate',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter interest rate';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _personAgeController,
                    decoration: const InputDecoration(
                      labelText: 'Person Age',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter age';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _personEmpLengthController,
                    decoration: const InputDecoration(
                      labelText: 'Employment Length',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter employment length';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _personIncomeController,
                    decoration: const InputDecoration(
                      labelText: 'Person Income',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter income';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Dropdown fields
                  DropdownButtonFormField<String>(
                    value: _ageBand,
                    decoration: const InputDecoration(
                      labelText: 'Age Band',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: '20-25', child: Text('20-25')),
                      DropdownMenuItem(value: '26-35', child: Text('26-35')),
                      DropdownMenuItem(value: '36-45', child: Text('36-45')),
                      DropdownMenuItem(value: '46-55', child: Text('46-55')),
                      DropdownMenuItem(value: '56-65', child: Text('56-65')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _ageBand = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _band,
                    decoration: const InputDecoration(
                      labelText: 'Band',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'high', child: Text('High')),
                      DropdownMenuItem(
                        value: 'high-middle',
                        child: Text('High-Middle'),
                      ),
                      DropdownMenuItem(value: 'middle', child: Text('Middle')),
                      DropdownMenuItem(
                        value: 'low-middle',
                        child: Text('Low-Middle'),
                      ),
                      DropdownMenuItem(value: 'low', child: Text('Low')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _band = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _binaryFlag,
                    decoration: const InputDecoration(
                      labelText: 'Binary Flag',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Y', child: Text('Yes')),
                      DropdownMenuItem(value: 'N', child: Text('No')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _binaryFlag = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _grade,
                    decoration: const InputDecoration(
                      labelText: 'Grade',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'A', child: Text('A')),
                      DropdownMenuItem(value: 'B', child: Text('B')),
                      DropdownMenuItem(value: 'C', child: Text('C')),
                      DropdownMenuItem(value: 'D', child: Text('D')),
                      DropdownMenuItem(value: 'E', child: Text('E')),
                      DropdownMenuItem(value: 'F', child: Text('F')),
                      DropdownMenuItem(value: 'G', child: Text('G')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _grade = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _purpose,
                    decoration: const InputDecoration(
                      labelText: 'Purpose',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'DEBTCONSOLIDATION',
                        child: Text('Debt Consolidation'),
                      ),
                      DropdownMenuItem(
                        value: 'EDUCATION',
                        child: Text('Education'),
                      ),
                      DropdownMenuItem(
                        value: 'HOMEIMPROVEMENT',
                        child: Text('Home Improvement'),
                      ),
                      DropdownMenuItem(
                        value: 'MEDICAL',
                        child: Text('Medical'),
                      ),
                      DropdownMenuItem(
                        value: 'PERSONAL',
                        child: Text('Personal'),
                      ),
                      DropdownMenuItem(
                        value: 'VENTURE',
                        child: Text('Venture'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _purpose = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _residence,
                    decoration: const InputDecoration(
                      labelText: 'Residence',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'MORTGAGE',
                        child: Text('Mortgage'),
                      ),
                      DropdownMenuItem(value: 'RENT', child: Text('Rent')),
                      DropdownMenuItem(value: 'OWN', child: Text('Own')),
                      DropdownMenuItem(value: 'OTHER', child: Text('Other')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _residence = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _sizeBand,
                    decoration: const InputDecoration(
                      labelText: 'Size Band',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'small', child: Text('Small')),
                      DropdownMenuItem(value: 'medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'large', child: Text('Large')),
                      DropdownMenuItem(
                        value: 'very large',
                        child: Text('Very Large'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _sizeBand = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: _submitPrediction,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Text(
                      'Get Prediction',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
