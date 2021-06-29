import 'dart:async';

import 'package:flutter/material.dart';

import 'package:vision_one/bloc/seccion_bloc.dart';
import 'package:vision_one/modelo/seccion_model.dart';
import 'package:vision_one/modelo/usuario_model.dart';
import 'package:vision_one/search/search_delegate.dart';

import 'package:vision_one/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  SeccionBloc seccionBloc = new SeccionBloc();// creamos una instancia de la clase SeccionBloc
  SeccionModel seccionModel = new SeccionModel();// creamos una instancia de la clase SeccionBloc
  
  @override
  Widget build(BuildContext context) {//el metodo build es el encargado de dibujar los widgets en la pantalla, por eso debe regresar un widget a fuerza
  //el context contiene la informacion del arbol de widget.

    final tamano = MediaQuery.of(context).size;  // definimos una variable "tamano" que sirve para controlar el espacio que usan los widget en pantalla
    final UsuarioModel usuario = ModalRoute.of(context).settings.arguments;// definimos una variable "usuario" que tomara los datos del usuario logeado cuando navegue de la pantalla de inicio de sesion al home

    seccionBloc.cargarSeccion();//ejecutamos el metodo para cargar las secciones

    return Scaffold(// scaffold es el lienzo principal donde se dibujan los Widgets
      drawer: _menuLateral(context, usuario),
      appBar: AppBar( // es un menu superior que podemos ver en la pantalla. en el se define el titulo y otros botones que nos daran otras funcionalidades
        //leading: utils.boton(usuario.rol, context), // definimos un boton en la esquina superior izquierda del appbar. el boton crea al ejecutar el metodo "boton" del archivo utils
        centerTitle: true,// centramos el titulo
        title: Text('Catalogo de secciones'), // Especificamos el titulo que tendra esta pantalla
        actions: [ // widgets que se agrupan a la esquina superior derecha del appbar.
          IconButton(icon: Icon(Icons.search), onPressed: (){ // Boton en forma de icono
            showSearch(context: context, delegate: DataProd()); // al presionar el boton dispara el metodo "showSearch" y ejeuta la clase "DataProd"
          }),
        ]
      ),
      body: _body(tamano, usuario.rol, usuario), // metodo que continua con la creacion del body
      floatingActionButton: _agregarSecc(usuario.rol) // metodo que crea un boton flotante en la esquina inferior derecha de la pantalla.
    );
  }
  
  Widget _menuLateral(BuildContext context, UsuarioModel usuario) {
    
    final tamano = TextStyle(fontSize: 15.0);

      return Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(
                child: Container(),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('imagenes/salfa.png')
                  )
                )
              ),
              Text('Menu', style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 30.0),
              _adminusuario(usuario, tamano),
              _stockCritico(usuario, tamano),
              ListTile(
                title: Text('Cerrar sesion', style: tamano),
                onTap: () => Navigator.pushReplacementNamed(context, 'iniciarSesion')
              ), 
            ],
          ),
        ),
      );

  }

  Widget _adminusuario(UsuarioModel usuario, TextStyle tamano) {

    if(usuario.rol == "ADMIN") {
      return ListTile(
        title: Text('Administrar usuario', style: tamano),
        onTap: () => Navigator.pushNamed(context, 'lista_users'),
      );
    } else {
      return Container();
    }
  }

  Widget _stockCritico(UsuarioModel usuario, TextStyle tamano) {

    if(usuario.rol == "ADMIN" || usuario.rol == "BODEGUERO") {
      return ListTile(
        title: Text('Stock Critico', style: tamano),
        onTap: () => Navigator.pushNamed(context, 'stock_critico', arguments: usuario),
      );
    } else {
      return Container();
    }

  }

  Widget _agregarSecc(String rol) { // metodo que crea o no el boton dependiendo del rol del usuario que se logeo

    if(rol == 'ADMIN' || rol == 'BODEGUERO') { // si el rol del usuario es "ADMIN" o "BODEGUERO" dispara el return del boton
      return FloatingActionButton( // Widget que crea el boton flotante
        child: Icon(Icons.add), // Icono del boton
        onPressed: () => Navigator.pushNamed(context, 'admin_seccion'), // acciones que hara el boton al ser persionado. nos hara navegar a la pantalla con el string "admin_seccion" (ver archivo main.dart)
      );
    } else {
      return null; // si el usuario no tiene ninguno de esos roles, devuelve nulo. no dibuja nada.
    }

  }

  Widget _body(Size tamano, String rol, UsuarioModel usuario) { // metodo que dibuja el body

    return StreamBuilder( // return del metodo. Un streamBuilder sirve para ir cargando datos a medida que se van añadiendo. el sistema nota los cambios y los carga
      stream: seccionBloc.seccionStream, // aqui se selecciona el "rio" (stream) que hara fluir su informacion por aqui
      builder: (BuildContext context, AsyncSnapshot<List<SeccionModel>> snapshot) { // el builder es el encargado de dibujar lo que deseamos. recibe dos variables, el context y una que por defecto se llama "snapshot" y tendra toda la informacion del stream
        if(snapshot.hasData) {  // "si el snapshot tiene informacion"... hara lo siguiente.

          final seccion = snapshot.data; // guardamos la "Data" (informacion) en la variable seccion

          return RefreshIndicator( // retorno del builder. un RefreshIndicator da la opcion de hacer scroll hacia abajo en la pantalla y refrescarla.
            onRefresh: _refrescar, //metodo que ejecuta el "refresco" de pantalla
            child: ListView.builder( // Widget que se dibujara en la pantalla y que tendra la opcion de ser refrescado
              itemCount: seccion.length, // cuenta la cantidad de secciones cargadas
              itemBuilder: (BuildContext context, int i) // propiedad que debe estar para dibujar los widget que queremos dentro del "ListView.Builder" 
              => _seccion(context ,seccion[i], rol, usuario), // metodo que crea los elementos del ListView.builder
            )
          );
          
        } else {
          return Center(child: Text('No se encontro informacion')); // si snapshot no tiene data envia el el mensaje definido
        } 

      }
    );


  }

  Widget _seccion(BuildContext context, SeccionModel seccion, String rol, UsuarioModel usuario) { // metodo que dibujara los elementos dentro del ListView.builder

    return Card( // retorno del metodo, dibujara una carta
      child: Column( // dentro de la carta, se almaceran los datos como columna
        children: [ // propiedad del widget Column
          ListTile(// primer hijo. otro tipo de lista
            title: Text('${seccion.nombre}'), // el titulo del ListTile sera el nombre de cada seccion
              onTap: () =>Navigator.pushNamed(context, 'productos', arguments: [seccion, rol, usuario]), // al presionar la lista nos mandara a la pantalla con string de nombre "productos" y los argumentos que enviara son la seccion a la cual presionamos mas el rol del usuario.
          ),
        ],
      ),
    );
          
  }

  Future _refrescar() async { // metodo para refrescar la pantalla
  
    Duration carga = new Duration(seconds: 2); // variable llamada "carga" que tendra una propiedad de 2 segundos de demora para cargar
    new Timer(carga, () { // nuevo widget para definir el tiempo de carga.
      build(context); // disparamos el metodo build del archivo actual.
    });
    return Future.delayed(carga); // regresa en un futuro determinado (2 seg) el resultado.
  }
           

}