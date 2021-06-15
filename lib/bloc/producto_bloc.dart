import 'dart:async';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import 'package:vision_one/modelo/producto_model.dart';
import 'package:vision_one/provider/producto_provider.dart';


class ProductoBloc {

  final _productoController = new BehaviorSubject<List<ProductoModel>>(); //creamos una variable de tipo BehaviorSubject
  //BehaviorSubject: es un controlador que permite escuchar varias veces la informacion que se mueve por el stream, y su tipo en este caso es
  //una lista de productos
  final _productoProvider = new ProductoProvider(); //creamos una nueva instancia de la clase productoProvider.

  final _cargandoController = new BehaviorSubject<bool>();//creamos otra variable de tipo BehaviorSubject

  Stream<List<ProductoModel>> get productoStream => _productoController.stream;   // creamos un Stream llamado "productoStream" que sera de tipo Lista de productos.
  Stream<List<ProductoModel>> get cargandoStream  => _productoController.stream;  // creamos un Stream llamado "cargandoStream" que sera de tipo Lista de productos.
  //Stream => un stream es un "flujo" o "rio" de informacion en el cual se puede ir agregando datos y estos se iran reflejando en pantalla.
  //los dos stream creados (productoStream y cargandoStream) escuchan informacion del mismo lugar. _productoController.stream;


  Future cargarProducto(int idseccion) async { //creamos un metodo para cargar productos, debe recibir el id de la seccion para solo cargar productos asociados a esa seccion

    final productos = await _productoProvider.cargarProducto(idseccion); //ejecutamos el metodo cargarProducto en la clase ProductoProvider mandando el idseccion. su repuesta la guardamos en la variable productos
    _productoController.sink.add(productos); // con el ".sink" queremos decir que "añadimos informacion" al "rio" de informacion llamado "_productoConroller".
    // le mandamos como informacion la variable productos , que vendria siendo una lista de productoModel

  }

  Future<String> subirFoto(File foto) async { //creamos un metodo que recibe un File de la fotografia que debemos subir.
    
    _cargandoController.sink.add(true); //definimos un "añadido" valor true
    final fotoURL = await _productoProvider.subirImgen(foto); //ejecutamos el metodo para subir la imagen
    _cargandoController.sink.add(false); //regresamos el "añadido" como valor false

    return fotoURL; // regresamos la variable creada con el valor de al respueta

  }
 
  void dispose(){ // los strem creados deben cerrarse siempre. la fluidez del "rio" debe llegar hasta cierto punto y no dejarlo como "infinito" 
    _productoController?.close();
    _cargandoController?.close();
  }

}