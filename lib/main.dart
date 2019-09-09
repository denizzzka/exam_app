import 'package:exam_app/books_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
  show debugDefaultTargetPlatformOverride;

LibraryCatalog _catalog;

void main()
{
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  _catalog = new LibraryCatalog();
  _catalog.addRecord(Record("Dart for Dummies", "Some Author"));
  _catalog.addRecord(Record("ABC", "Some another authors"));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Library catalog'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _bookNameField = TextEditingController();
  final TextEditingController _authorField = TextEditingController();
  int _currentRecordId = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
        Row(
            children: <Widget>[
              Expanded(child:Column(
                mainAxisAlignment: MainAxisAlignment.start,

                children: <Widget>[
                    TextField(
                      controller: _bookNameField,
                      decoration: InputDecoration(hintText: 'Book name'),
                    ),
                    TextField(
                      controller: _authorField,
                      decoration: InputDecoration(hintText: 'Author(s)'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.add), tooltip: 'Add new book', onPressed: _addNewBookRecord,),
                        IconButton(
                          icon: Icon(Icons.refresh),
                          tooltip: 'Update book info',
                          onPressed: _currentRecordId == -1 ? null : _refreshBookInfo,
                        ),
                      ],
                    )
                ],
              )),


              Expanded(child:
                ListView.builder(
                  itemCount: _catalog.getRecordsNum(),
                  itemBuilder: (buildContext, itemNum)
                  {
                    var r = _catalog.getRecordByNum(itemNum);

                    return ListTile(
                      title: Text(r.bookName.toString()),
                      subtitle: Text(r.authors.toString()),
                      trailing: IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteBookRecord(r.uniqId)),
                      onTap: () => _loadForEdit(r),
                    );
                  },
                ),
              ),
            ]
//          ),
        ),
    );
  }

  void _addNewBookRecord() {
    setState(() {
      _currentRecordId = _catalog.addRecord(Record(_bookNameField.text, _authorField.text));
    });
  }

  void _loadForEdit(Record r)
  {
    setState(() {
      _currentRecordId = r.uniqId;

      _bookNameField.text = r.bookName;
      _authorField.text = r.authors;
    });
  }

  void _deleteBookRecord(int recId)
  {
    setState(() {
      _catalog.tryToDelRecordById(recId);

      if(recId == _currentRecordId)
        _currentRecordId = -1;
    });
  }

  void _refreshBookInfo()
  {
    setState(() {
      _catalog.refreshRecordById(_currentRecordId, Record(_bookNameField.text, _authorField.text));
    });
  }
}
