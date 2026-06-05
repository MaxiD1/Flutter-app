import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  const Tabs({super.key});

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      // Cambiar dependiendo de cuantas pestañas
      // queramos
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          // Cambiar titulo
          title: Text("Test"),
          // Elegir icono
          leading: Icon(Icons.book),
          bottom: TabBar(
            // Poner el texto de
            // las pestañas
            tabs: []
          ),
        ),
        body: TabBarView(
          // Tabs de la app 
          // en la forma tab()
          children: []
        )
      )
    );
  }
}
