import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Video tutorial
// https://www.youtube.com/watch?v=reN_okp2Gq4

class LibrosProvider {
  final String API_portada =  'https://covers.openlibrary.org/b/olid';
  final String API_libros = 'https://openlibrary.org/works';
  final String API_buscar = 'https://openlibrary.org/search.json?';

  // Devuelve json del libro usando el OLID del libro
  Future<List<dynamic>> getLibro(String id) async{
    var uri = Uri.parse('$API_libros/$id.json');
    var respuesta = await http.get(uri);
    if(respuesta.statusCode == 200){
      return json.decode(respuesta.body);
    }else{
      return [];
    }
  }
  // Devuelve un jpg de la portada del libro usando el OLID del libro
  Future<Uri> getPortada(String id, String size) async{
    var uri = Uri.parse('$API_portada/$id-$size.jpg');
    return uri;
  }

  Future<List<dynamic>> buscarTitulo(String titulo) async{
    var t = titulo.replaceAll(' ', '+');
    var busqueda = 'q=$t';
    var uri = Uri.parse('$API_buscar$busqueda');
    var respuesta = await http.get(uri);
    if(respuesta.statusCode == 200){
      return json.decode(respuesta.body);
    }else{
      return [];
    }
  }


}
