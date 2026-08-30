import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: NumScreen());
  }
}

/*
class NavigationButton extends StatelessWidget{

  Widget nextScreen;
  ScreenData data;
  
  NavigationButton( {required this.nextScreen, required this.data } );

  Widget build( BuildContext context ){
    return ElevatedButton(
          child: Row(children: [Text("Confirm"), Icon(Icons.arrow_forward)]),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => DataScreen()),
            );
          },
        );
  }

}
*/

class NumScreen extends StatelessWidget {
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => DataScreen()),
                  );
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => SelectionScreen()),
                  );
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => ResultScreen()),
                  );
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => NumScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
