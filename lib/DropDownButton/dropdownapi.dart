import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'gropdownmodel.dart';

class DropDownApi extends StatefulWidget {
  const DropDownApi({super.key});

  @override
  State<DropDownApi> createState() => _DropDownApiState();
}

class _DropDownApiState extends State<DropDownApi> {
  var selectedvalue;
Future<List<DropDownModel>> getApi()async{
  try{
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
   final body= jsonDecode(response.body) as List;
   if(response.statusCode==200){
     return body.map((e) {
       final map =e as Map<String,dynamic>;
       return DropDownModel(
        userId: map['userId'],
         id: map['id'],
         title: map['title'],
         body: map[' body'],
       );
     }).toList();
   }
  }on SocketException{
    throw Exception('No InterNet');
  }
  throw Exception('Error Messege');
}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('DropDown Button'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<List<DropDownModel>>(
                future: getApi(),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                 return DropdownButton(
                   hint: Text('Select Item'),
                     isExpanded: true,
                     value: selectedvalue,
                     icon: Icon(Icons.add),
                     items: snapshot.data!.map((e){
                       return DropdownMenuItem(
                         value: e.title.toString(),
                           child: Text(e.title.toString()));
                     }).toList(),
                     onChanged: (value){
                     selectedvalue=value;
                     setState(() {

                     });
                     });
                  }else{
                   return CircularProgressIndicator();
                  }
                })
          ],
        ),
      ),
    );
  }
}
