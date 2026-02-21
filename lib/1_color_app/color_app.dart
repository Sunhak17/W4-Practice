import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Home()),
    ),
  );
}

enum CardType { red, blue, yellow, green }

final Map<CardType, Color> colorMap = {
  CardType.red: Colors.red,
  CardType.blue: Colors.blue,
  CardType.yellow: Colors.yellow,
  CardType.green: Colors.green,
};

final colorService = ColorService();

class ColorService extends ChangeNotifier {
  final Map<CardType, int> _tapCounts = {
    for (var type in CardType.values) type: 0,
  };

  int getTapCount(CardType type) => _tapCounts[type] ?? 0;

  void increment(CardType type) {
    _tapCounts[type] = getTapCount(type) + 1;
    notifyListeners();
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? const ColorTapsScreen()
          : const StatisticsScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.tap_and_play),
            label: 'Taps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }
}

class ColorTapsScreen extends StatelessWidget {
  const ColorTapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Color Taps')),
      body: Column(
        children: CardType.values.map((type) => ColorTap(type: type)).toList(),
      ),
    );
  }
}

class ColorTap extends StatelessWidget {
  final CardType type;

  const ColorTap({super.key, required this.type});

  Color get backgroundColor => colorMap[type]!;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: colorService,
      builder: (context, child) {
        final tapCount = colorService.getTapCount(type);

        return GestureDetector(
          onTap: () => colorService.increment(type),
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            height: 100,
            child: Center(
              child: Text(
                'Taps: $tapCount',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistics')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: CardType.values.map((type) {
            return Text(
              'Number of ColorType.${type.name} = ${colorService.getTapCount(type)}',
              style: TextStyle(fontSize: 16),
            );
          }).toList(),
        ),
      ),
    );
  }
}
