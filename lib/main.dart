import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Call of Nassau Rank',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const RankCalculatorPage(),
    );
  }
}

class RankCalculatorPage extends StatefulWidget {
  const RankCalculatorPage({super.key});

  @override
  State<RankCalculatorPage> createState() => _RankCalculatorPageState();
}

class _RankCalculatorPageState extends State<RankCalculatorPage> {
  final List<String?> _results = List.filled(10, null);

  String _message = '';
  int _totalScore = 0;
  bool _calculated = false;

  void _calculateRank() {
    if (_results.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, selecione o resultado de todas as 10 partidas.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    int score = 0;
    // Lógica para contabilizar a pontuação
    for (String? result in _results) {
      if (result == 'V') {
        score += 10;
      } else if (result == 'E') {
        score += 5;
      } else if (result == 'D') {
        score -= 2;
      }
    }

    String message;
    if (score >= 60) {
      message = 'Subiu de patente! 🚀';
    } else if (score >= 21) {
      message = 'Permaneceu na patente. 🛡️';
    } else {
      message = 'Caiu de patente. ⬇️';
    }

    setState(() {
      _totalScore = score;
      _message = message;
      _calculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Call of Nassau',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Resultados das últimas 10 partidas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'V = Vitória (+10) | E = Empate (+5) | D = Derrota (-2)',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            ...List.generate(10, (index) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Partida ${index + 1}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SegmentedButton<String>(
                        emptySelectionAllowed: true,
                        segments: const [
                          ButtonSegment(value: 'V', label: Text('V')),
                          ButtonSegment(value: 'E', label: Text('E')),
                          ButtonSegment(value: 'D', label: Text('D')),
                        ],
                        selected: _results[index] != null
                            ? {_results[index]!}
                            : <String>{},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            _results[index] = newSelection.isNotEmpty
                                ? newSelection.first
                                : null;
                            _calculated = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateRank,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Calcular Patente'),
            ),
            if (_calculated) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: _totalScore >= 60
                      ? Colors.green.shade100
                      : (_totalScore >= 21
                            ? Colors.orange.shade100
                            : Colors.red.shade100),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _totalScore >= 60
                        ? Colors.green
                        : (_totalScore >= 21 ? Colors.orange : Colors.red),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Pontuação Total: $_totalScore',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _message,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
