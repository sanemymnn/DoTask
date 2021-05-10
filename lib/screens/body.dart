import 'package:flutter/material.dart';



class Body extends StatelessWidget {

  static const route = "/body";


  @override
  Widget build(BuildContext context) {

        return Scaffold(
          body: Stack (
          children: <Widget> [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
                         
            ),
            
              Container(
                height: double.infinity,
                child: SingleChildScrollView (
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    Container(
                      height: 40.0,
                      margin: const EdgeInsets.only(top: 100) ),

                      Image.asset("assets/dotask_logo.png", height: 100),

                      SizedBox(height: 50.0),
                      Container(
                
                padding: EdgeInsets.symmetric(
                  horizontal: 20
                ),

                child: Text("Hi there! Nice to see you.", 
                textAlign: TextAlign.center,
                
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  
                  ),
                ),
                
              ),
               SizedBox(height:70),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                  RaisedButton(
                  child: Text("SIGN IN"),
                  shape: RoundedRectangleBorder(
                    borderRadius:BorderRadius.circular(15.0),
                    side: BorderSide(color: Colors.blue),
                    
                  ),
                 onPressed:(){
                Navigator.of(context).pushNamed("/signIn");
                },
                  color: Colors.blue,
                  textColor: Colors.black
                  
                ),
                SizedBox(height:30),
                RaisedButton(
                  child: Text("SIGN UP"),
                  padding: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius:BorderRadius.circular(15.0),
                    side: BorderSide(color: Colors.blue),
                    
                  ),
                 onPressed:(){
                Navigator.of(context).pushNamed("/signUp");
                },
                  color: Colors.blue,
                  textColor: Colors.black
                  
                )

              
              
                        ],
                      )

                  ], 
                  ),
                ),
              ),

            ]
          ),
          
     
    );
  }
}