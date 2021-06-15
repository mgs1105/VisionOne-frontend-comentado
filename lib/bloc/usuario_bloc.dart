import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import 'package:vision_one/modelo/usuario_model.dart';
import 'package:vision_one/provider/usuario_provider.dart';

class UsuarioBloc { 

  final _usuarioController = new BehaviorSubject<List<UsuarioModel>>(); //creamos una variable de tipo BehaviorSubject
  //BehaviorSubject: es un controlador que permite escuchar varias veces la informacion que se mueve por el stream, y su tipo en este caso es una lista de Usuarios
  final _usuarioProvider = new UsuarioProvider();///creamos una nueva instancia de la clase UsuarioProvider

  Stream<List<UsuarioModel>> get usuarioStream => _usuarioController.stream;// creamos un Stream llamado "productoStream" que sera de tipo Lista de productos.

  Future cargarUsuario() async {//creamos un metodo que llamara a todas las secciones

    final usuarios = await _usuarioProvider.cargarUsuario();//ejecutamos el metodo cargarUsuario en la clase usuarioProvider. Su repuesta la guardamos en la variable "usuarios"
    _usuarioController.sink.add(usuarios);// con el ".sink" queremos decir que "añadimos informacion" al "rio" de informacion llamado "_usuarioController".
    // le mandamos como informacion la variable usuarios , que vendria siendo una lista de UsuarioModel
  }

  void dispose() {// los strem creados deben cerrarse siempre. la fluidez del "rio" debe llegar hasta cierto punto y no dejarlo como "infinito" 
    _usuarioController?.close();
  }

}