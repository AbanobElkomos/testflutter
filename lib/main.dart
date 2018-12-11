import 'package:flutter/material.dart';
import 'myvar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


void main() { runApp(new MaterialApp(
   debugShowCheckedModeBanner: false,
 
     title: 'Flutter Demo',
      theme: ThemeData(
         
          primarySwatch: Colors.blue,
        ),
         home: FirstPage(),
           
           ));
           
}
  class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     var _categorynameController = new TextEditingController();
          return Scaffold(
           
           body: Material(
             color: Colors.white,
             child: Center(
               child: ListView(
                 children: <Widget>[
                   Padding(padding: EdgeInsets.all(30.0),),
                   new Image.asset('images/dent.jpg',
                   width: 200.0,
                   height: 200.0,),
                   new ListTile(
                     title: new TextFormField(
                       controller: _categorynameController,
                       decoration: new InputDecoration(
                         labelText: "Enter Category name",
                         hintText: "eg: happy.",
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius. circular(25.5 ),
                           
                         ),
                         contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0)
                         
                       ),
                ),
                 ),

               new ListTile(
                  title: new  Material(
                  color: Colors.lightBlue,
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(25.0),
                  child: new MaterialButton(
                    onPressed: (){
                      Navigator.of(context).push(new MaterialPageRoute(builder: (context){
                       return new secondPage( searchable:  _categorynameController.text,);
                      },
                      )
                      );
                    },
                    child: new Text("Find"+_categorynameController.text.toString(),style:TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                ),
               )
             
            ],
          ),
        ),
      )
    );
  }
}
  
 class secondPage extends StatefulWidget{
   String searchable ;
   secondPage({Key key,this.searchable}): super(key: key);
  @override
  _secondpageState createState() => _secondpageState();
   
   
  }
  class _secondpageState extends State<secondPage>{
        
 
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: new AppBar(
         title: Text(widget.searchable),
         centerTitle: true,
         

       ),
       body:  new FutureBuilder(
         future: getimages(widget.searchable),
         builder: (context,snapShot){
           Map data = snapShot.data ; 
 
           if (snapShot.hasError){
             print(snapShot.error);
             return Text("error in getting data");


           }
           else if(snapShot.hasData){
             return new Center(
               child: new ListView.builder(
                 itemCount: data.length,
               itemBuilder: (context,index){
return new Column(
  children: <Widget>[
    new Padding(padding: EdgeInsets.all(20.0),),
    new Container(
      child:     new Image.network('${data['hits'][index]['largeImageURL']}'),

    ),
  ],
);
               }),
             );
           } else  if(!snapShot.hasData){
             return new Center(child: CircularProgressIndicator(),);
           }
         },
       ),
     );
  }

  }

 
   
Future <Map> getimages(String titlet) async{
  String url ="https://pixabay.com/api/?key=$apikey&q=$titlet&image_type=photo&pretty=true" ;
http.Response response =await http.get(url);
return json.decode(response.body);

}