import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';


import 'package:vision_one/modelo/seccion_model.dart';
import 'package:vision_one/provider/seccion_provider.dart';

class SeccionBloc {

  final _seccionController = new BehaviorSubject<List<SeccionModel>>(); //creamos una variable de tipo BehaviorSubject
  //BehaviorSubject: es un controlador que permite escuchar varias veces la informacion que se mueve por el stream, y su tipo en este caso es
  //una lista de secciones
  final _seccionProvider = new SeccionProvider(); //creamos una nueva instancia de la clase seccionProvider.

  Stream<List<SeccionModel>> get seccionStream => _seccionController.stream; // creamos un Stream llamado "productoStream" que sera de tipo Lista de productos.

  Future cargarSeccion() async { //creamos un metodo que llamara a todas las secciones

    final secciones = await _seccionProvider.cargarSeccion(); //ejecutamos el metodo cargarSeccion en la clase SeccionProvider. Su repuesta la guardamos en la variable secciones 
    _seccionController.sink.add(secciones); // con el ".sink" queremos decir que "añadimos informacion" al "rio" de informacion llamado "_seccionController".
    // le mandamos como informacion la variable secciones , que vendria siendo una lista de seccionModel

  }


  void dispose(){// los strem creados deben cerrarse siempre. la fluidez del "rio" debe llegar hasta cierto punto y no dejarlo como "infinito" 
    _seccionController?.close();
  }

}