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
        ? ResultScreen( resultScreenData : ResultScreenData.initInstance(), loadNextScreen: loadInputScreen)
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
        ? NumScreen( numScreenData : NumScreenData.initInstance(),  loadNextScreen: loadDataScreen)
        : (stateString == "data-screen"
              ? DataScreen( dataScreenData :  DataScreenData.initInstance() , loadNextScreen: loadSelectionScreen)
              : SelectionScreen( selectionScreenData :  SelectionScreenData.initInstance(),  loadNextScreen: loadResultScreen)));
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
  final NumScreenData numScreenData ;
  final void Function() loadNextScreen;

  NumScreen({required this.loadNextScreen, required this.numScreenData});

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
                numScreenData.defaulTextContent,
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
  final DataScreenData dataScreenData ;
  final void Function() loadNextScreen;

  DataScreen({required this.loadNextScreen, required this.dataScreenData});

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
               dataScreenData.defaulTextContent,
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
  final SelectionScreenData selectionScreenData ;
  final void Function() loadNextScreen;

  SelectionScreen({required this.loadNextScreen, required this.selectionScreenData});

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
                selectionScreenData.defaulTextContent,
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
  final ResultScreenData resultScreenData ;
  final void Function() loadNextScreen;

  ResultScreen({required this.loadNextScreen, required this.resultScreenData});

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
                resultScreenData.defaulTextContent,
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
  
  static NumScreenData initInstance(  ){
    return NumScreenData( chosenCount : 0 , defaulTextContent : "This Screen contains a slider for choosing the number of processes" ) ;
  }
  
}

class DataScreenData {
  List<ProcessData> processData;
  String defaulTextContent;

  DataScreenData({required this.processData, required this.defaulTextContent});
  
    static DataScreenData initInstance(  ){
    return DataScreenData( processData : [ ]  , defaulTextContent : "This Screen contains sliders for choosing AT and BT of chosen processes" ) ;
  }
  
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
  
  static SelectionScreenData initInstance(  ){
    return SelectionScreenData( algoString : "FCFS"  , defaulTextContent : "This Screen contains dropdowns for selection of scheduling algorithm" ) ;
  }
  
}

class ResultScreenData {
  List<ProcessData> genntData;
  String defaulTextContent;

  ResultScreenData({required this.genntData, required this.defaulTextContent});

    static ResultScreenData initInstance(  ){
    return ResultScreenData( genntData : [ ]  , defaulTextContent :"This Screen contains Gennt chart corresponding to data and algo" ) ;
  }
  
}
