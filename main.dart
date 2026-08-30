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
  ResultScreenData savedResultScreenData = ResultScreenData.initInstance();

  Widget build(BuildContext context) {
    return (stateString == "result-screen"
        ? ResultScreen(
            resultScreenData: savedResultScreenData,
            loadNextScreen: loadInputScreen,
          )
        : InputScreen(
            functionToLoadResultScreen:
                loadResultScreen /*(){loadResultScreen( receivedGenntData );}*/,
          ));
  }

  void loadInputScreen() {
    setState(() {
      stateString = "input-screen";
    });
  }

  void loadResultScreen(List<ProcessData> newGenntData, String chosenAlgo) {
    setState(() {
      stateString = "result-screen";
      savedResultScreenData.genntData = newGenntData;
      savedResultScreenData.algoString = chosenAlgo;
    });
  }
}

class InputScreen extends StatefulWidget {
  final void Function(List<ProcessData>, String) functionToLoadResultScreen;

  InputScreen({required this.functionToLoadResultScreen});

  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  String stateString = "num-screen";
  final NumScreenData savedNumScreenData = NumScreenData.initInstance();
  final DataScreenData savedDataScreenData = DataScreenData.initInstance();
  final SelectionScreenData savedSelectionScreenData =
      SelectionScreenData.initInstance();

  Widget build(BuildContext context) {
    return (stateString == "num-screen"
        ? NumScreen(
            numScreenData: savedNumScreenData,
            loadNextScreen: loadDataScreen,
            funcToUpdateProcessCount: updateProcessCount,
          )
        : (stateString == "data-screen"
              ? DataScreen(
                  dataScreenData: savedDataScreenData,
                  loadNextScreen: loadSelectionScreen,
                )
              : SelectionScreen(
                  selectionScreenData: savedSelectionScreenData,
                  loadNextScreen: loadResultScreen,
                )));
  }

  void loadNumScreen() {
    setState(() {
      stateString = "num-screen";
    });
  }

  void loadDataScreen() {
    setState(() {
      stateString = "data-screen";
      savedDataScreenData.processData = DataScreenData.listOfInitProcessData(
        savedNumScreenData.chosenCount,
      );
    });
  }

  void loadSelectionScreen() {
    setState(() {
      stateString = "selection-screen";
    });
  }

  void loadResultScreen() {
    (widget.functionToLoadResultScreen)(
      savedDataScreenData.processData,
      savedSelectionScreenData.algoString,
    );
  }

  void updateProcessCount(int newCount) {
    setState(() {
      savedNumScreenData.chosenCount = newCount;
    });
  }
}

class NumScreen extends StatelessWidget {
  final NumScreenData numScreenData;
  final void Function() loadNextScreen;
  final void Function(int) funcToUpdateProcessCount;

  NumScreen({
    required this.loadNextScreen,
    required this.numScreenData,
    required this.funcToUpdateProcessCount,
  });

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NumScreen")),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*Text(numScreenData.defaulTextContent),*/
              DataToNumScreen(
                funcToUpdateProcessCount: funcToUpdateProcessCount,
                funcToLoadNextPage: loadNextScreen,
              ),
              /*
              ElevatedButton(
                child: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Confirm"), Icon(Icons.arrow_forward)],
                  ),
                ),
                onPressed: () {
                  //funcToUpdateProcessCount( tempValue );
                  loadNextScreen();
                  /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => DataScreen()),
                  );
                  */
                },
              ),
              */
            ],
          ),
        ],
      ),
    );
  }
}

/*
class IntWrapper {
  int value = 0;
}
*/

class DataToNumScreen extends StatelessWidget {
  final void Function(int) funcToUpdateProcessCount;
  final void Function() funcToLoadNextPage;
  //final IntWrapper intWrapper = IntWrapper();

  DataToNumScreen({
    required this.funcToUpdateProcessCount,
    required this.funcToLoadNextPage,
  });

  Widget build(BuildContext context) {
    return WidgetToContainSlider(
      funcToUpdateProcessCount: funcToUpdateProcessCount,
      funcToLoadNextPage: funcToLoadNextPage,
    );
  }
}

class WidgetToContainSlider extends StatefulWidget {
  final void Function(int) funcToUpdateProcessCount;
  final void Function() funcToLoadNextPage;

  WidgetToContainSlider({
    required this.funcToUpdateProcessCount,
    required this.funcToLoadNextPage,
  });

  State<WidgetToContainSlider> createState() => _WidgetToContainSliderState();
}

class _WidgetToContainSliderState extends State<WidgetToContainSlider> {
  int tempValue = 0;

  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(tempValue.toString()),
            Slider(
              max: 10,
              divisions: 10,
              value: 1.0 * tempValue,
              onChanged: (sliderValue) {
                //int newValue = sliderValue.ceil();
                //tempValue = newValue;
                setState(() {
                  tempValue = sliderValue.floor();
                });
              },
            ),
          ],
        ),
        ElevatedButton(
          child: Icon(Icons.check),

          onPressed: () {
            (widget.funcToUpdateProcessCount)(tempValue);
            (widget.funcToLoadNextPage)();
            /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => DataScreen()),
                  );
                  */
          },
        ),
      ],
    );
  }
}

class DataScreen extends StatelessWidget {
  final DataScreenData dataScreenData;
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
              //Text( dataScreenData.defaulTextContent ),
              Text( "Current count of processes =  ${ dataScreenData.processData.length }" ),
              //DataToDataScreen( processDataList : dataScreenData.processData ),
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
  final SelectionScreenData selectionScreenData;
  final void Function() loadNextScreen;

  SelectionScreen({
    required this.loadNextScreen,
    required this.selectionScreenData,
  });

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SelectionScreen")),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Text(selectionScreenData.defaulTextContent),
              SelectionScreenDropDown(),
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

class SelectionScreenDropDown extends StatefulWidget{
  
  State<SelectionScreenDropDown> createState() => _SelectionScreenDropDownState() ;
}

class _SelectionScreenDropDownState extends State<SelectionScreenDropDown>{
  

  List<String> availableAlgo = [ "FCFS", "SJF", "SRTF", "LJF", "HRRN", "RoundRobin" ] ;
  //String defaultValue = "choose an Algorithm" ;  
  //String chosenValue = "" ;
  //String chosenValue = "choose an Algorithm" ;
  String chosenValue = "FCFS" ;
  
  Widget build( BuildContext context ){
      return DropdownMenu<String>(
      initialSelection: availableAlgo.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          chosenValue = value!;
        });
      },
      dropdownMenuEntries: availableAlgo.map( ( String option ) => DropdownMenuEntry<String>( value : option, label : option )  ).toList( ) ,
    );    
    /*return DropdownButton<String>( 
      value : chosenValue,
      icon: const Icon(Icons.arrow_downward),
      onChanged : ( String? newAlgo ){ setState( (){ chosenValue = newAlgo! /*?? defaultValue*/ ; } ); },
      
      items : availableAlgo.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),  );
  }
  */
    
   
}
}

class ResultScreen extends StatelessWidget {
  final ResultScreenData resultScreenData;
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
              Text(resultScreenData.defaulTextContent),
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

class ProcessCard extends StatefulWidget {
  final ProcessData processData;
  ProcessCard({required this.processData});

  State<ProcessCard> createState() => _ProcessCardState();
}

class _ProcessCardState extends State<ProcessCard> {
  int tempArrivalTime = 0;
  int tempBurstTime = 0;

  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          ListTile(
            title: Text(widget.processData.processId.toString()),
            subtitle: Row(
              children: [
                SliderContainer(
                  currValue: tempArrivalTime,
                  funcToUpdateCurrValue: updateArrivalTime,
                ),
                SliderContainer(
                  currValue: tempBurstTime,
                  funcToUpdateCurrValue: updateBurstTime,
                ),
              ],
            ),
          ),
          IconButton(icon: Icon(Icons.check), onPressed: () {}),
        ],
      ),
    );
  }

  void updateArrivalTime(int newAT) {
    setState(() {
      tempArrivalTime = newAT;
    });
  }

  void updateBurstTime(int newBT) {
    setState(() {
      tempArrivalTime = newBT;
    });
  }
}

class SliderContainer extends StatelessWidget {
  final int currValue;
  final void Function(int) funcToUpdateCurrValue;

  SliderContainer({
    required this.currValue,
    required this.funcToUpdateCurrValue,
  });
  
  Widget build( BuildContext context ){
    return Card( child : Column( children : [ Text( "Value ${ currValue }" ), Slider( max : 10, divisions : 10,  value : 1.0 * currValue, onChanged : ( sliderValue ){ funcToUpdateCurrValue( sliderValue.ceil() ); } ) ] ) );
  }
  
}

class DataToDataScreen extends StatelessWidget {
  final List<ProcessData> processDataList;
  DataToDataScreen({required this.processDataList});

  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ProcessCard(processData: processDataList[index]);
      },
    );
  }
}

class NumScreenData {
  int chosenCount;
  String defaulTextContent;

  NumScreenData({required this.chosenCount, required this.defaulTextContent});

  static NumScreenData initInstance() {
    return NumScreenData(
      chosenCount: 0,
      defaulTextContent:
          "This Screen contains a slider for choosing the number of processes",
    );
  }
}

class DataScreenData {
  List<ProcessData> processData;
  String defaulTextContent;

  DataScreenData({required this.processData, required this.defaulTextContent});

  static DataScreenData initInstance() {
    return DataScreenData(
      processData: [],
      defaulTextContent: "This Screen contains sliders for choosing AT and BT of chosen processes",
    );
  }

  static List<ProcessData> listOfInitProcessData(int chosenCount) {
    List<ProcessData> result = [];
    for (var x = 0; x < chosenCount; x++) {
      ProcessData tempInstance = ProcessData.initInstance() ;
      result.add( tempInstance );
    }

    return result;
  }
}

class ProcessData {
  static int processCount = 0;

  final int processId = processCount++;
  int arrivalTime;
  int burstTime;

  ProcessData({required this.arrivalTime, required this.burstTime});

  static ProcessData initInstance() {
    return ProcessData(arrivalTime: 0, burstTime: 0);
  }
}

class SelectionScreenData {
  String algoString;
  String defaulTextContent;

  SelectionScreenData({
    required this.algoString,
    required this.defaulTextContent,
  });

  static SelectionScreenData initInstance() {
    return SelectionScreenData(
      algoString: "FCFS",
      defaulTextContent: "This Screen contains dropdowns for selection of scheduling algorithm",
    );
  }
}

class ResultScreenData {
  List<ProcessData> genntData;
  String algoString;
  String defaulTextContent;

  ResultScreenData({
    required this.genntData,
    required this.defaulTextContent,
    required this.algoString,
  });

  static ResultScreenData initInstance() {
    return ResultScreenData(
      genntData: [],
      algoString: "FCFS",
      defaulTextContent:
          "This Screen contains Gennt chart corresponding to data and algo",
    );
  }
}
