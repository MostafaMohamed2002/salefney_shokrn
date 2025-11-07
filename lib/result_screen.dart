import 'package:flutter/material.dart';

import 'prediction_service.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final PredictionService _predictionService = PredictionService();
  List<Map<String, dynamic>>? _predictions;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPredictions();
  }

  Future<void> _loadPredictions() async {
    try {
      final predictions = await _predictionService.getPredictionHistory();
      if (mounted) {
        setState(() {
          _predictions = predictions;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  String _formatDate(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Date not available';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction History'),
        actions: [
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_predictions == null || _predictions!.isEmpty) {
      return const Center(child: Text('No predictions yet'));
    }

    return ListView.builder(
      itemCount: _predictions!.length,
      itemBuilder: (context, index) {
        final prediction = _predictions![index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ExpansionTile(
            title: Text(
              'Prediction: ${prediction['prediction']}',
              style: TextStyle(
                color: prediction['prediction'] == 'its safe'
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Score: ${(prediction['score'] * 100).toStringAsFixed(2)}%',
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Loan Amount: \$${prediction['inputs']['loan_amnt']}'),
                    Text(
                      'Interest Rate: ${prediction['inputs']['loan_int_rate']}%',
                    ),
                    Text('Purpose: ${prediction['categorical']['Purpose']}'),
                    Text('Grade: ${prediction['categorical']['Grade']}'),
                    Text(
                      'Residence: ${prediction['categorical']['Residence']}',
                    ),
                    Text('Age Band: ${prediction['categorical']['Age_band']}'),
                    Text(
                      'Size Band: ${prediction['categorical']['Size_band']}',
                    ),
                    Text('Band: ${prediction['categorical']['Band']}'),
                    if (prediction['timestamp'] != null)
                      Text('Date: ${_formatDate(prediction['timestamp'])}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
