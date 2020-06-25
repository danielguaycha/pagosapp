import 'package:flutter/material.dart';

class ListsPaymentsPage extends StatefulWidget {
  
  final int clientId;
  ListsPaymentsPage({Key key, @required this.clientId}) : super(key: key);

  @override
  _ListsPaymentsPageState createState() => _ListsPaymentsPageState();
}

class Recaudacion {
  String date;
  double value;
  bool pay;

  Recaudacion(this.date, this.value, this.pay);
}

List<Recaudacion> list = List();
bool multipleSelect = false;
List<int> selectedList = List();
class _ListsPaymentsPageState extends State<ListsPaymentsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list.add(Recaudacion("01-01-2020", 10.0, false));
    list.add(Recaudacion("02-01-2020", 10.0, false));
    list.add(Recaudacion("03-01-2020", 10.0, false));
    list.add(Recaudacion("04-01-2020", 10.0, false));
    list.add(Recaudacion("05-01-2020", 10.0, false));
    list.add(Recaudacion("06-01-2020", 10.0, false));
    list.add(Recaudacion("07-01-2020", 10.0, false));
    list.add(Recaudacion("08-01-2020", 10.0, false));
    list.add(Recaudacion("09-01-2020", 10.0, false));
    list.add(Recaudacion("10-01-2020", 10.0, false));
    list.add(Recaudacion("11-01-2020", 10.0, false));
    list.add(Recaudacion("12-01-2020", 10.0, false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Titulo"),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text("31/05/2020"),
            Text("12/06/2020"),
          ],
        ),
        Divider(),
        Text("12/06/2020"),
        Divider(),
        Expanded(child: Container(child: _grid())),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            RaisedButton(child: Text("No pago"), onPressed: () {}),
            RaisedButton(
                child: Text("Abono ${selectedList.length}"),
                onPressed: () {
                  multipleSelect = false;
                  selectedList.clear();
                  setState(() {});
                }),
          ],
        ),
      ],
    );
  }

  Widget _grid() {
    return GridView.builder(
        itemCount: list.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(0.0),
            margin: EdgeInsets.all(0.0),
            decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(
                    color: list[index].pay ? Colors.green : Colors.black,
                    width: 1.0)),
            child: RaisedButton(
              padding: EdgeInsets.only(top: 10.0),
              color: Colors.white,
              elevation: 0.0,
              onLongPress: () {
                multipleSelect = true;
                setState(() {});
              },
              onPressed: () {
                if (!multipleSelect) {
                  print("Cosquillas");
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("${list[index].date}"),
                          Text("\$ ${list[index].value}"),
                        ],
                      )
                    ],
                  ),
                  Visibility(
                    visible: multipleSelect,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Visibility(
                          // visible: !list[index].pay,
                          child: Checkbox(
                              value: list[index].pay,
                              onChanged: (v) {
                                if(v){
                                selectedList.add(index);
                                }else{
                                  selectedList.remove(index);
                                }
                                list[index].pay = v;
                                

                                print("Value: $v");
                                setState(() {});
                              }),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
