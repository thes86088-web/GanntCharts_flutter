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
        : InputScreen(functionToLoadResultScreen: loadResultScreen));
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
                  funcToReplaceProcessDataInstance: replaceProcessDataInstance,
                )
              : SelectionScreen(
                  selectionScreenData: savedSelectionScreenData,
                  funcToUpdateAlgoString: updateAlgoString,
                  loadNextScreen: loadResultScreen,
                )));
  }

  void replaceProcessDataInstance({
    required int index,
    required int newArrivalTime,
    required int newBurstTime,
  }) {
    setState(() {
      savedDataScreenData.processData[index] = ProcessData(
        processId: index,
        arrivalTime: newArrivalTime,
        burstTime: newBurstTime,
      );
    });
  }

  void updateAlgoString(String chosenAlgo) {
    setState(() {
      savedSelectionScreenData.algoString = chosenAlgo;
    });
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
              DataToNumScreen(
                funcToUpdateProcessCount: funcToUpdateProcessCount,
                funcToLoadNextPage: loadNextScreen,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DataToNumScreen extends StatelessWidget {
  final void Function(int) funcToUpdateProcessCount;
  final void Function() funcToLoadNextPage;

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
          },
        ),
      ],
    );
  }
}

class DataScreen extends StatelessWidget {
  final DataScreenData dataScreenData;
  final void Function() loadNextScreen;
  final void Function({
    required int index,
    required int newArrivalTime,
    required int newBurstTime,
  })
  funcToReplaceProcessDataInstance;

  DataScreen({
    required this.loadNextScreen,
    required this.dataScreenData,
    required this.funcToReplaceProcessDataInstance,
  });

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DataScreen"),
        actions: [
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
            },
          ),
        ],
      ),
      body: DataToDataScreen(
        dataScreenData: dataScreenData,
        funcToReplaceProcessDataInstance: funcToReplaceProcessDataInstance,
      ),
    );
  }
}

class SelectionScreen extends StatelessWidget {
  final SelectionScreenData selectionScreenData;
  final void Function(String) funcToUpdateAlgoString;
  final void Function() loadNextScreen;

  SelectionScreen({
    required this.loadNextScreen,
    required this.selectionScreenData,
    required this.funcToUpdateAlgoString,
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
              SelectionScreenDropDown(
                funcToUpdateAlgoString: funcToUpdateAlgoString,
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
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SelectionScreenDropDown extends StatefulWidget {
  final void Function(String) funcToUpdateAlgoString;

  SelectionScreenDropDown({required this.funcToUpdateAlgoString});

  State<SelectionScreenDropDown> createState() =>
      _SelectionScreenDropDownState();
}

class _SelectionScreenDropDownState extends State<SelectionScreenDropDown> {
  List<String> availableAlgo = [
    "FCFS",
    "SJF",
    "SRTF",
    "LJF",
    "HRRN",
    "RoundRobin( QT = 2 )",
  ];
  String chosenValue = "FCFS";

  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: availableAlgo.first,
      onSelected: (String? value) {
        setState(() {
          chosenValue = value!;
        });
        widget.funcToUpdateAlgoString(value!);
      },
      dropdownMenuEntries: availableAlgo
          .map(
            (String option) =>
                DropdownMenuEntry<String>(value: option, label: option),
          )
          .toList(),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final ResultScreenData resultScreenData;
  final void Function() loadNextScreen;

  ResultScreen({required this.loadNextScreen, required this.resultScreenData});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ResultScreen"),
        actions: [
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
            },
          ),
        ],
      ),
      body: DataToResultScreen(resultScreenData: resultScreenData),
    );
  }

  GenttData firstComeFirstServed(List<ProcessData> receivedGenntData) {
    //find maxAT( no.of rows in matrix )
    //find totalBT ( len of Gennt Chart )
    int maxAT = 0;
    int totalBT = 0;

    List<int> uniqueProcessIds = [];

    for (int i = 0; i < receivedGenntData.length; i++) {
      ProcessData tempData = receivedGenntData[i];
      if (tempData.arrivalTime > maxAT) {
        maxAT = tempData.arrivalTime;
      }
      totalBT = totalBT + tempData.burstTime;
    }

    List<List<ProcessData>> processMatrix = [];

    //arrange each process in a row corresponding to its AT
    for (int j = 0; j < receivedGenntData.length; j++) {
      ProcessData tempData = receivedGenntData[j];

      (processMatrix[tempData.arrivalTime])[tempData.processId] = tempData;
    }

    for (int k = 0; k < maxAT; k++) {
      if (processMatrix[k].isNotEmpty) {
        uniqueProcessIds.add(k);
      }
    }

    List<int> genttList = [];
    //start a loop on aT till maxAT
    //int latestAT = 0;
    for (int aT = 0; aT <= totalBT; aT++) {
      if (processMatrix[aT].isNotEmpty) {
        if (processMatrix[aT].length == 1) {
          ProcessData currProcess = (processMatrix[aT])[0];
          int duration = currProcess.burstTime;

          for (int d = 0; d < duration; d++) {
            genttList.add(currProcess.processId);
          }
        } else {
          int numOfProcessWithSameId = processMatrix[aT].length;
          for (int pIndex = 0; pIndex < numOfProcessWithSameId; pIndex++) {
            ProcessData currProcess = (processMatrix[aT])[pIndex];
            int duration = currProcess.burstTime;

            for (int d = 0; d < duration; d++) {
              genttList.add(currProcess.processId);
            }
          }
        }
      }
    }

    GenttData result = GenttData(
      genttList: genttList,
      uniqueProcessIds: uniqueProcessIds,
    );
    return result;
  }
}

class GenttData {
  List<int> genttList;
  List<int> uniqueProcessIds;

  GenttData({required this.genttList, required this.uniqueProcessIds});
}

class DataToResultScreen extends StatelessWidget {
  final ResultScreenData resultScreenData;
  DataToResultScreen({required this.resultScreenData});

  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: resultScreenData.genntData.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text("P-${resultScreenData.genntData[index].processId}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("AT : ${resultScreenData.genntData[index].arrivalTime}"),
                Text("BT : ${resultScreenData.genntData[index].burstTime}"),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProcessCard extends StatefulWidget {
  final ProcessData processData;
  final int processIndex;
  final void Function({
    required int index,
    required int newArrivalTime,
    required int newBurstTime,
  })
  replaceProcessData;

  ProcessCard({
    required this.processData,
    required this.replaceProcessData,
    required this.processIndex,
  });

  State<ProcessCard> createState() => _ProcessCardState();
}

class _ProcessCardState extends State<ProcessCard> {
  int tempArrivalTime = 0;
  int tempBurstTime = 0;

  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            widget.replaceProcessData(
              index: widget.processIndex,
              newArrivalTime: tempArrivalTime,
              newBurstTime: tempBurstTime,
            );
          },
        ),
        title: Text("P-${widget.processData.processId}"),
        subtitle: Row(
          children: [
            SliderContainer(
              currValue: tempArrivalTime,
              label: "AT",
              funcToUpdateCurrValue: updateArrivalTime,
            ),

            SliderContainer(
              currValue: tempBurstTime,
              label: "BT",
              funcToUpdateCurrValue: updateBurstTime,
            ),
          ],
        ),
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
      tempBurstTime = newBT;
    });
  }
}

class SliderContainer extends StatelessWidget {
  final int currValue;
  final String label;
  final void Function(int) funcToUpdateCurrValue;

  SliderContainer({
    required this.currValue,
    required this.label,
    required this.funcToUpdateCurrValue,
  });

  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text("${label} = ${currValue}"),
          Slider(
            max: 10,
            divisions: 10,
            value: 1.0 * currValue,
            onChanged: (sliderValue) {
              funcToUpdateCurrValue(sliderValue.ceil());
            },
          ),
        ],
      ),
    );
  }
}

class DataToDataScreen extends StatelessWidget {
  final DataScreenData dataScreenData;
  final void Function({
    required int index,
    required int newArrivalTime,
    required int newBurstTime,
  })
  funcToReplaceProcessDataInstance;
  DataToDataScreen({
    required this.dataScreenData,
    required this.funcToReplaceProcessDataInstance,
  });

  Widget build(BuildContext context) {
    List<ProcessData> processDataList = dataScreenData.processData;

    if (processDataList.isEmpty) {
      return Text("The list of processes is empty ");
    } else {
      return ListView.builder(
        itemCount: processDataList.length,
        itemBuilder: (context, index) {
          return ProcessCard(
            processIndex: index,
            processData: processDataList[index],
            replaceProcessData: funcToReplaceProcessDataInstance,
          );
        },
      );
    }
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
    for (int x = 0; x < chosenCount; x = x + 1) {
      ProcessData tempInstance = ProcessData.initInstance();
      tempInstance.processId = x;
      result.add(tempInstance);
    }

    return result;
  }
}

class ProcessData {
  int processId;
  int arrivalTime;
  int burstTime;

  ProcessData({
    required this.arrivalTime,
    required this.burstTime,
    required this.processId,
  });

  static ProcessData initInstance() {
    return ProcessData(arrivalTime: 0, burstTime: 0, processId: 0);
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

class ProcessLine extends StatelessWidget {
  final List<int> genttList;
  final int scale;

  ProcessLine({required this.genttList, required this.scale});

  Widget build(BuildContext context) {
    List<Container> listOfContainers = [];

    for (int index = 0; index < genttList.length; index++) {
      Container tempContainer = Container(
        //height: 40,
        width: 1.0 * scale,
        color: GenttChart.colorMapForIds[genttList[index]],
      );
      listOfContainers.add(tempContainer);
    }

    return Container(height: 10, child: Row(children: listOfContainers));
  }
}

class TimeLine extends StatelessWidget {
  final int maxBT;
  final int scale;

  TimeLine({required this.maxBT, required this.scale});

  Widget build(BuildContext context) {
    List<Container> listOfContainers = [];

    for (int index = 0; index < maxBT; index++) {
      Container tempContainer = Container(
        //height: 10,
        width: 1.0 * scale,
        color: index % 2 == 0 ? Colors.black : Colors.grey,
      );
      listOfContainers.add(tempContainer);
    }

    return Container(height: 10, child: Row(children: listOfContainers));
  }
}

class GenttChartLegend extends StatelessWidget{
  
 final List<int> uniqueProcessIds ;
  GenttChartLegend( { required this.uniqueProcessIds } );
  
    Widget build(BuildContext context) {
      
    uniqueProcessIds.sort();
    List<Row> listOfRows = [] ;  
    for (int index = 0; index < uniqueProcessIds.length ; index++) {
      Row tempRow = Row( children : [Text("P-${uniqueProcessIds[index]}"), Container( height : 10, width : 20, color : GenttChart.colorMapForIds[ uniqueProcessIds[index] ] ) ] );
      
      listOfRows.add( tempRow );
    }
      
      return Card( child : Column( children : listOfRows ) );
    }
}

class GenttChart extends StatelessWidget {
  final GenttData genttData;

  GenttChart({required this.genttData});

  Widget build(BuildContext context) {
    int scale = 10;
    int maxBT = genttData.genttList.length;

    return Column(
      children: [
        ProcessLine(genttList: genttData.genttList, scale: scale),
        TimeLine(maxBT: maxBT, scale: scale),
      ],
    );
    /*return Text( "this widget displays the GenttChart produced using list of processes and algoString " );*/
  }

  static Map<int, Color> colorMapForIds = {
    0: Colors.blue,
    1: Colors.red,
    2: Colors.green,
    3: Colors.purple,
    4: Colors.brown,
    5: Colors.lime,
    6: Colors.pink,
    7: Colors.cyan,
    8: Colors.orange,
    9: Colors.yellow,
    10: Colors.teal,
  };
}
