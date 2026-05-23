import 'dart:collection';
import 'dart:convert';


import 'package:http/http.dart' as http;

class LibrosProvider {
  final String API_covers =  'https://covers.openlibrary.org/b';
  final String API_libros = 'https://openlibrary.org/works';

  Future<List<dynamic>> getLibro(String id) async{
    var uri = Uri.parse('$API_libros/marcas');
    var respuesta = await http.get(uri);

    if(respuesta.statusCode == 200){
      return json.decode(respuesta.body);
    }else{
      return [];
    }
  }

  Future<LinkedHashMap<String, dynamic>> MarcasAgregar(String nombreMarca)async{
    var uri = Uri.parse('$API_URL/marcas');
    var respuesta = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept':'application/json',
      },
      body: jsonEncode(
        <String, String>{'nombre': nombreMarca},
      ),
      );
      return json.decode(respuesta.body);
  }

  Future<bool> marcasBorrar(int id)async{
    var uri = Uri.parse('$API_URL/marcas/$id');
    var respuesta = await http.delete(uri);
    return respuesta.statusCode == 200;
  }

  Future<LinkedHashMap<String, dynamic>> marcasEditar(int id, String nombreMarca)async{
    
    var uri = Uri.parse('$API_URL/marcas/$id');
    var respuesta = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept':'application/json',
      },
      body: jsonEncode(
        <String, String>{'nombre': nombreMarca},
      ),
      );
      return json.decode(respuesta.body);
  }




}
