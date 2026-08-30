import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainScreen());
  }
}

class MainScreen extends StatefulWidget {
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String stateString = "default";

  Widget build(BuildContext context) {
    return (stateString == "result-screen"
        ? ResultScreen(loadNextScreen: loadInputScreen)
        : InputScreen(functionToLoadResultScreen: loadResultScreen));
  }

  void loadInputScreen() {
    setState(() {
      stateString = "input-screen";
    });
  }

  void loadResultScreen() {
    setState(() {
      stateString = "result-screen";
    });
  }
}

class InputScreen extends StatefulWidget {
  final void Function() functionToLoadResultScreen;

  InputScreen({required this.functionToLoadResultScreen});

  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  String stateString = "num-screen";

  Widget build(BuildContext context) {
    return (stateString == "num-screen"
        ? NumScreen(loadNextScreen: loadDataScreen)
        : (stateString == "data-screen"
              ? DataScreen(loadNextScreen: loadSelectionScreen)
              : SelectionScreen(loadNextScreen: loadResultScreen)));
  }

  void loadNumScreen() {
    setState(() {
      stateString = "num-screen";
    });
  }

  void loadDataScreen() {
    setState(() {
      stateString = "data-screen";
    });
  }

  void loadSelectionScreen() {
    setState(() {
      stateString = "selection-screen";
    });
  }

  void loadResultScreen() {
    (widget.functionToLoadResultScreen)();
  }
}

class NumScreen extends StatelessWidget {
  //final NumScreenData numScreenData ;
  final void Function() loadNextScreen;

  NumScreen({required this.loadNextScreen});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NumScreen")),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "This Screen contains a slider for choosing the number of processes",
              ),
              ElevatedButton(
                child: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Confirm"), Icon(Icons.arrow_forward)],
                  ),
                ),
                onPressed: () {
                  loadNextScreen();
                  /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => DataScreen()),
                  );
                  */
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DataScreen extends StatelessWidget {
  final void Function() loadNextScreen;

  DataScreen({required this.loadNextScreen});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DataScreen")),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "This Screen contains sliders for choosing AT and BT of chosen processes",
              ),
              ElevatedButton(
                child: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Confirm"), Icon(Icons.arrow_forward)],
                  ),
                ),
                onPressed: () {
                  loadNextScreen();
                  /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => SelectionScreen()),
                  );
                  */
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SelectionScreen extends StatelessWidget {
  final void Function() loadNextScreen;

  SelectionScreen({required this.loadNextScreen});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SelectionScreen")),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "This Screen contains dropdowns for selection of scheduling algorithm",
              ),
              ElevatedButton(
                child: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Confirm"), Icon(Icons.arrow_forward)],
                  ),
                ),
                onPressed: () {
                  loadNextScreen();
                  /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => ResultScreen()),
                  );
                  */
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final void Function() loadNextScreen;

  ResultScreen({required this.loadNextScreen});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ResultScreen")),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "This Screen contains Gennt chart corresponding to data and algo",
              ),
              ElevatedButton(
                child: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Restart"), Icon(Icons.restart_alt)],
                  ),
                ),
                onPressed: () {
                  loadNextScreen();
                  /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => NumScreen()),
                  );
                  */
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NumScreenData {
  int chosenCount;
  String defaulTextContent;

  NumScreenData({required this.chosenCount, required this.defaulTextContent});
}

class DataScreenData {
  List<ProcessData> processData;
  String defaulTextContent;

  DataScreenData({required this.processData, required this.defaulTextContent});
}

class ProcessData {
  static int processCount = 0;

  final int processId = processCount++;
  int arrivalTime;
  int burstTime;

  ProcessData({required this.arrivalTime, required this.burstTime});
}

class SelectionScreenData {
  String algoString;
  String defaulTextContent;

  SelectionScreenData({
    required this.algoString,
    required this.defaulTextContent,
  });
}

class ResultScreenData {
  List<ProcessData> genntData;
  String defaulTextContent;

  ResultScreenData({required this.genntData, required this.defaulTextContent});
}
