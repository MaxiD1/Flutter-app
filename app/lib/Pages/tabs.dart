import 'package:flutter/material.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({super.key});

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      // Cambiar dependiendo de cuantas pestañas
      // queramos
      length: length,
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
