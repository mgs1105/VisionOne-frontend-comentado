import 'dart:async';

import 'package:flutter/material.dart';

import 'package:vision_one/bloc/usuario_bloc.dart';
import 'package:vision_one/modelo/usuario_model.dart';

class ListaUserPage extends StatefulWidget {
  @override
  _ListaUserPageState createState() => _ListaUserPageState();
}

class _ListaUserPageState extends State<ListaUserPage> {

  UsuarioBloc usuarioBloc = new UsuarioBloc();// creamos una instancia de la clase UsuarioBloc
  UsuarioModel usuarioModel = new UsuarioModel();// creamos una instancia de la clase UsuarioModel

  @override
  Widget build(BuildContext context) {//el metodo build es el encargado de dibujar los widgets en la pantalla, por eso debe regresar un widget a fuerza
  //el context contiene la informacion del arbol de widget.
    
    setState(() { // carga la pantalla cuando nota algun cambio
    usuarioBloc.cargarUsuario(); // ejecutamos el metodo de cargar usuarios.
    });

    return Scaffold(// scaffold es el lienzo principal donde se dibujan los Widgets
      appBar: AppBar(// es un menu superior que podemos ver en la pantalla. en el se define el titulo y otros botones que nos daran otras funcionalidades
        centerTitle: true,// centramos el titulo
        title: Text('Lista de usuarios'),// Especificamos el titulo que tendra esta pantalla   
      ),
      body: _body(), // metodo que definira la creacion del body
      floatingActionButton: FloatingActionButton( // creacion de un boton flotante en la esquina inferior derecha de la pantalla
        child: Icon(Icons.add), // icono que tendra el boton
        onPressed: () => Navigator.pushNamed(context, 'crear_users'), // navegamos a la pantalla con el string definido "crear_users"
      ),
    );
  }

  Widget _body() { // metodo que dibujara el body de la pantalla
    return StreamBuilder( // return del metodo. Un streamBuilder sirve para ir cargando datos a medida que se van añadiendo. el sistema nota los cambios y los carga
      stream: usuarioBloc.usuarioStream,// aqui se selecciona el "rio" (stream) que hara fluir su informacion por aqui
      builder: (BuildContext context, AsyncSnapshot<List<UsuarioModel>> snapshot) { // el builder es el encargado de dibujar lo que deseamos. recibe dos variables, el context y una que por defecto se llama "snapshot" y tendra toda la informacion del stream

        if(snapshot.hasData) {// "si el snapshot tiene informacion"... hara lo siguiente.
          final usuario = snapshot.data;// guardamos la "Data" (informacion) en la variable usuario

          return RefreshIndicator(// retorno del builder. un RefreshIndicator da la opcion de hacer scroll hacia abajo en la pantalla y refrescarla.
            onRefresh: _refrescar,//metodo que ejecuta el "refresco" de pantalla
            child: ListView.builder( // Widget que se dibujara en la pantalla y que tendra la opcion de ser refrescado
              itemCount: usuario.length, // cuenta la cantidad de usuarios cargados
              itemBuilder: (BuildContext context, int i)// propiedad que debe estar para dibujar los widget que queremos dentro del "ListView.Builder" 
              => _usuarios(context, usuario[i])// metodo que crea los elementos del ListView.builder
            )
          );
        } else {
          return Center(child: Text('No se encontro informacion')); // "si snapshot no tiene data el mensaje definido"
        }

      }
    );

  }

  Widget _usuarios(BuildContext context, UsuarioModel usuario) { // // metodo que dibujara los elementos dentro del ListView.builder

    return Card(// retorno del metodo, dibujara una carta
      elevation: 10.0, // le da un sombreado a la carta
      child: Column( // dentro de la carta, se almaceran los datos como columna
        children: [// propiedad del widget Column
          ListTile(// primer hijo. otro tipo de lista
            title: Text('${usuario.rut}'),// el titulo del ListTile sera el nombre de cada usuario
            subtitle: Text('${usuario.rol}'),//el subtitulo del ListTile sera el rol de cada usuario
            trailing: _boton(usuario)// metodo que creara un boton. este se ubicara en la parte derecha del listTile (trailing)
          )
        ],
      ),
    );

  }

  Widget _boton(UsuarioModel usuario) { // metodo que dibujara el boton

    return Column( //retorno del metodo. se almaceran los datos como columna
      mainAxisSize: MainAxisSize.max, // ocupara el espacio maximo disponible
      children: [
        TextButton( // boton con un texto
          style: TextButton.styleFrom( // estilo al boton
            padding: EdgeInsets.symmetric(horizontal: 13.0), // anchura de 13 pixeles al boton
            backgroundColor: Colors.blue // color de fondo del boton. Azul
          ),
          child: Text('Administrar', style: TextStyle(color: Colors.white)), // texto que tendra el boton
          onPressed: () => Navigator.pushNamed(context, 'admin_users', arguments: usuario)  // navegacion al hacer clic en el boton. nos llevara a una pantalla definda con el string "admin_users"  y mandara como parametro los datos de dicho usuario
        ),
      ],
    );
            
  }

  Future _refrescar() {// metodo para refrescar la pantalla
  
    Duration carga = new Duration(seconds: 2);// variable llamada "carga" que tendra una propiedad de 2 segundos de demora para cargar
    new Timer(carga,() {// nuevo widget para definir el tiempo de carga.
      build(context);// disparamos el metodo build del archivo actual.
    });
    return Future.delayed(carga);// regresa en un futuro determinado (2 seg) el resultado.
  }



}