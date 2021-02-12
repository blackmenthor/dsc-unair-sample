import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyNote',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'MyNote'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class NoteItem {
  final String content;
  final int date;

  NoteItem({
    @required this.content,
    @required this.date,
  });
}

class _MyHomePageState extends State<MyHomePage> {
  List<NoteItem> notes = [];
  TextEditingController ctrl = TextEditingController();

  void _deleteNote(BuildContext context, int date) {
    notes.removeWhere((element) => element.date == date);
    setState(() {});
  }

  void _addNote(BuildContext context) {
    final note = ctrl.text;
    if (note == null || note.isEmpty) {
      // Find the Scaffold in the widget tree and use it to show a SnackBar.
      final snackBar = SnackBar(content: Text('Note harus diisi!'));
      Scaffold.of(context).showSnackBar(snackBar);
      return;
    }
    final date = DateTime.now().millisecondsSinceEpoch;
    final item = NoteItem(
      content: note,
      date: date,
    );
    notes.add(item);
    ctrl.text = '';

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: notes.isEmpty
                    ? Container()
                    : ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (ctx, idx) {
                          final note = notes[idx];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Note #${idx + 1}',
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          note.content,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            _deleteNote(context, note.date),
                                        child: Icon(
                                          Icons.delete,
                                          size: 24.0,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              TextField(
                controller: ctrl,
                decoration: InputDecoration(
                  hintText: 'Masukkan note baru',
                  labelText: 'Note Baru',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (ctx) => FloatingActionButton(
          onPressed: () => _addNote(ctx),
          tooltip: 'Add',
          child: Icon(Icons.send),
        ),
      ),
    );
  }
}
