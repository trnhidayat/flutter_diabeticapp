import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';
import 'main_sidebar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/item_card.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatelessWidget {
  final User user;
  const MainPage(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: MainSidebar(user: user),
      ),
      appBar: AppBar(
        title: const Text('Diabetes tracker'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20.0, 275.0, 20.0, 20.0),
              child: Text(
                'Welcome to Diabetic inMe!!!',
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  letterSpacing: 2.0,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              child: const Text('Take picture for your food'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ThirdRoute()),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LogData()),
          );
        },
        child: const Text('+'),
        backgroundColor: Colors.blue[900],
      ),
    );
  }
}

class LogData extends StatelessWidget {

  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController carboController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('Log & View Data'),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ListView(
              children: [
                //// VIEW DATA HERE
                StreamBuilder<QuerySnapshot>(
                    stream: users.snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data.docs
                              .map((e) =>
                              ItemCard(e.data()['glucose'], e.data()['carbo'],
                                onDelete: () {
                                  users.doc(e.id).delete();
                                },
                              ))
                              .toList(),
                        );
                      } else {
                        return const Text('Loading');
                      }
                    }
                ),
                const SizedBox(
                  height: 150,
                )
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(-5, 0),
                        blurRadius: 15,
                        spreadRadius: 3)
                  ]),
                  width: double.infinity,
                  height: 130,
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 160,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              style: GoogleFonts.poppins(),
                              controller: glucoseController,
                              decoration: const InputDecoration(hintText: "Glucose Level"),
                            ),
                            TextField(
                              style: GoogleFonts.poppins(),
                              controller: carboController,
                              decoration: const InputDecoration(hintText: "Carbohydrate Intake"),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 130,
                        width: 130,
                        padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: Colors.blue[900],
                            child: Text(
                              'Add Data',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              //// ADD DATA HERE
                              users.add({
                                'glucose': glucoseController.text,
                                'carbo': int.tryParse(carboController.text) ?? 0
                              });

                              glucoseController.text = '';
                              carboController.text = '';
                            }),
                      )
                    ],
                  ),
                )
            ),
          ],
        ));
  }
}

class ThirdRoute extends StatefulWidget {
  @override
  _ThirdRouteState createState() => _ThirdRouteState();
}

class _ThirdRouteState extends State<ThirdRoute> {
  File imageFile;

  get value => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Camera"),
          backgroundColor: Colors.blue[900],
        ),
        body: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  width: 300,
                  height: 450,
                  color: Colors.grey[200],
                  child: (imageFile != null) ? Image.file(imageFile) : const SizedBox(),
                ),
                ElevatedButton(
                  child: const Text("Take Picture"),
                  onPressed: () {}
                  // async {
                  //   imageFile = await Navigator.push<File>(
                  //       context, MaterialPageRoute(builder: (_) => CameraPage()));
                  //   setState(() {});
                  // },
                )
              ],
            )
        )
    );
  }
}

class FourthRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signal Strength"),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: SignalStrengthIndicator.bars(
          value: 0.6,
          size: 50,
          barCount: 4,
          spacing: 0.2,
        ),
      ),
    );
  }
}

class FiveRouted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeModel>(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (_, model, __) {
          return MaterialApp(
            theme: ThemeData.light(), // Provide light theme.
            darkTheme: ThemeData.dark(), // Provide dark theme.
            themeMode: model.mode, // Decides which theme to show.
            home: Scaffold(
              appBar: AppBar(title: Text('Light/Dark Theme')),
              body: ElevatedButton(
                onPressed: () => model.toggleMode(),
                child: Text('Toggle Theme'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ThemeModel with ChangeNotifier {
  ThemeMode _mode;
  ThemeMode get mode => _mode;
  ThemeModel({ThemeMode mode = ThemeMode.light}) : _mode = mode;

  void toggleMode() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      min: 0,
      max: 500,
      divisions: 500,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }
}


class MyCustomFormState extends State<MyCustomForm> {
  var app;

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  MyCustomFormState ({this.app});
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(const SnackBar(content: Text('Processing Data')));
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}