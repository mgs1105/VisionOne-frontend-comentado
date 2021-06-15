import 'dart:convert';
import 'package:http/http.dart' as http;

//Model
import 'package:vision_one/modelo/usuario_model.dart';

class UsuarioProvider{

  final String _dominio = 'http://192.168.1.86:5000';//definimos parte de la url donde se haran las consultas
  final usuario = new UsuarioModel();//creamos una instancia del modelo del usuario

  Future<List<UsuarioModel>> cargarUsuario() async {

    final url = '$_dominio/usuario'; //creamos una variable que tendra todo el url donde hacer la peticion
    final resp = await http.get(Uri.parse(url)); // esperamos a que se realice la peticion y guardamos la respuesta en la variable creada
    final decodeData = json.decode(resp.body);  //creamos una variable que tendra la informacion de la peticion. esta informacion sera en un formato json
 
    final List<UsuarioModel> lista = []; //creamos una variable de tipo lista de usuarios.

    if(decodeData == null) return []; //condicion: si lo recibido del json (decodeData) es nulla, el metodo regresa una lista vacia. si tiene informacion continua con el code

    //recorremos toda la informacion del "decodeData" y cada usuario es almacenado en la variable "value".
    decodeData.forEach((value) {
     
      final usuario = UsuarioModel.fromJson(value);  //creamos una variable que tendra toda la informacion de cada usuario encontrado.

      lista.add(usuario);//añadimos el usuario a la lista creada.

    });

    return lista; // regresamos la lista de los usuarios
  }

  void crearUsuario(UsuarioModel usuario) async {  //Creamos un metodo void.El metodo recibe un usuario para su creacion.

    final url = '$_dominio/usuario'; // definimos la url donde se haran las peticiones
    Map<String, String> header = {"content-type": "application/json"};  // definimos un Map con dos propiedades fundamentales para realizar el post
    //convierten la informacion a un json
    await http.post(Uri.parse(url), headers: header, body: usuarioModelToJson(usuario)); //esperamos a que se realice la peticion http 
  }

  void modificarUsuario(UsuarioModel usuario) async { //creamos un metodo que recibir toda la informacion del usuario que se desea modificar

    final rut = usuario.rut; // capturamos el Rut del usuario

    final url = '$_dominio/usuario/$rut'; // creamos la url a la cual se haran las peticiones
    Map<String, String> header = {"content-type": "application/json"}; // Definimos este Map para pasar la informacion a un json
    await http.put(Uri.parse(url),headers: header, body: usuarioModelToJson(usuario)); // esperamos a que la peticon PUT se realice
  }

  void eliminarUsuario(UsuarioModel usuario) async { // creamos un metodo que recibe toda la informacion del usuario que se desea eliminar

    final rut = usuario.rut; // capturamos el rut del usuario a eliminar
 
    final url = '$_dominio/usuario/$rut'; // creamos la url a la cual se haran las peticiones
    await http.delete(Uri.parse(url)); // esperamos a que la peticon DELETE se realice


  }

  Future<bool> validaUsuario(UsuarioModel usuario) async { // creamos un metodo para validar el  login del usuario, para eso recibimos al usuario que desea logearse

    final url = '$_dominio/login'; // creamos la url donde se hara la peticion
    Map<String, String> header = {"content-type": "application/json"}; // transforma la informacion a un json
    final resp = await http.post(Uri.parse(url), headers: header, body: usuarioModelToJson(usuario)); // esperamos a que la peticion POST se realice
    final decodeData = json.decode(resp.body); // guardamos la informacion en formato json en la variable creada

    
    return decodeData; // regresamos la informacion
  }
}

