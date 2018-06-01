import 'package:flutter/material.dart';
import 'package:todoapp/model/todo_item.dart';
import 'package:todoapp/util/database_client.dart';
import 'package:todoapp/util/dateformatter.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => new _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController _texteditingcontroller =
      new TextEditingController();
  var db = new DatabaseHelper();
  final List<ToDoItem> _itemlist = <ToDoItem>[];
  @override
  void initState() {
    super.initState();
    _readTodoLists();
  }

  void _handleSubmit(String text) async {
    _texteditingcontroller.clear();
    ToDoItem toDoItem = new ToDoItem(text, dateFormatted());
    int savedItemID = await db.saveItem(toDoItem);
    ToDoItem addedItem = await db.getItem(savedItemID);
    setState(() {
      _itemlist.insert(0, addedItem);
    });
    print("Item saved Id is $savedItemID");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.blue[100],
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _itemlist.length,
              itemBuilder: (_, int index) {
                return new Card(
              
                  color: Colors.blue,
                  child: new ListTile(
                    title: _itemlist[index],
                    onLongPress: () => _updateItem(_itemlist[index], index),
                    trailing: new Listener(
                      key: new Key(_itemlist[index].itemName),
                      child: new Icon(
                        Icons.delete_sweep,
                        color: Colors.white,
                      ),
                      onPointerDown: (pointerEvent) =>
                          _deleteTodo(_itemlist[index].id, index),
                    ),
                  ),
                );
              },
            ),
          ),
          new Container(
            height: 30.0,
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _showFormDialouge,
        tooltip: "Add Item",
        backgroundColor: Colors.blueAccent,
        child: new ListTile(
          title: Icon(Icons.add),
        ),
      ),
    );
  }


  void _showFormDialouge() {
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: _texteditingcontroller,
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: "Enter your todo title",
                  hintText: "eg.Buy stuffs",
                  icon: new Icon(Icons.note_add)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          color: Colors.blue,
          onPressed: () {
            _handleSubmit(_texteditingcontroller.text);
            _texteditingcontroller.clear();
            Navigator.pop(context);
          },
          child: Text("Save",style: new TextStyle(
            color: Colors.white
          ),),
        ),
        new FlatButton(
          highlightColor: Colors.white,
          color: Colors.blueGrey,
          onPressed: () {
            Navigator.pop(context);
            print("Cancled succesfully");
          },
          child: Text("Cancel",style: new TextStyle(
            color: Colors.white
          ),),
        )
      ],
    );
    showDialog(
      
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _readTodoLists() async {
    List items = await db.getItems();
    items.forEach((item) {
      ToDoItem toDoItem = ToDoItem.fromMap(item);
      setState(() {
        _itemlist.add(ToDoItem.map(item));
      });
      print("Db items ${toDoItem.itemName}");
    });
  }

  _deleteTodo(int id, int index) async {
    debugPrint("Deleted items");
    await db.deleteItem(id);
    setState(() {
      _itemlist.removeAt(index);
    });
  }

  _updateItem(ToDoItem item, int index) {
    var alert = new AlertDialog(
      title: Text("Update Item"),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: _texteditingcontroller,
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: "Item",
                  hintText: "e.g update ",
                  icon: new Icon(Icons.update)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () async {
            ToDoItem newItemupdated = ToDoItem.fromMap(
                //
                {
                  "itemName": _texteditingcontroller.text,
                  "dateCreated": dateFormatted(),
                  "id": item.id
                });
            _handleSubmittedUpdated(index, item);
            await db.updateItem(newItemupdated);
            setState(() {
              _readTodoLists();
            });
            Navigator.pop(context);
          },
          child: new Text("Update"),
        ),
        new FlatButton(
          onPressed: () => Navigator.pop(context),
          child: new Text("Cancle"),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmittedUpdated(int index, ToDoItem item) {
    setState(() {
      _itemlist.removeWhere((element) {
        _itemlist[index].itemName == item.itemName;
      });
    });
  }
}
