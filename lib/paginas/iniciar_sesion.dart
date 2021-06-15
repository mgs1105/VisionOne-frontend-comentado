import 'package:flutter/material.dart';

import 'package:vision_one/bloc/usuario_bloc.dart';
import 'package:vision_one/modelo/usuario_model.dart';
import 'package:vision_one/provider/usuario_provider.dart';

import 'package:vision_one/utils/utils.dart' as utils;

class IniciarSesion extends StatefulWidget {

  @override
  _IniciarSesionState createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion> {

  final keyformulario = GlobalKey<FormState>();// creamos una variable de tipo FromState que sirve para manejar el estado de un formulario. si se completo o no.

  UsuarioModel usuarioModel = new UsuarioModel(); // creamos una instancia de la clase UsuarioModel
  UsuarioProvider usuarioProvider = new UsuarioProvider(); // creamos una instancia de la clase UsuarioProvider
  UsuarioBloc usuarioBloc = new UsuarioBloc(); // creamos una instancia de la clase UsuarioBloc

  @override
  Widget build(BuildContext context) {//el metodo build es el encargado de dibujar los widgets en la pantalla, por eso debe regresar un widget a fuerza
  //el context contiene la informacion del arbol de widget.

    final tamano = MediaQuery.of(context).size; // definimos una variable "tamano" que sirve para controlar el espacio que usan los widget en pantalla
    usuarioBloc.cargarUsuario();//ejecutamos el metodo para cargar los usuarios

    return Scaffold(// scaffold es el lienzo principal donde se dibujan los Widgets
      appBar: AppBar(// es un menu superior que podemos ver en la pantalla. en el se define el titulo y otros botones que nos daran otras funcionalidades
        centerTitle: true,// centramos el titulo
        title: Text('Bienvenido') // Especificamos el titulo que tendra esta pantalla
      ),
      body: Center(// definimos el cuerpo de la pantalla. Lo definimos Centrado(Center)
        child: SingleChildScrollView(// este Widget (SingleChildScrollView) sirve para hacer scroll infinito mientras la pantalla lo vaya requiriendo.
          child: Form(// definimos un formulario
            key: keyformulario,// especificamos la llave que tendra el formulario. esta llave se usa despues para validar el estado del formulario
            child: _formulario(tamano, context)// especificamos un metodo llamdo "_formulario" para continuar con el formulario
          ),
        ),
      ),
          
    );
      
  }

  Widget _formulario(tamano, context) { // metodo para crear el formulario

    final fuente = TextStyle(fontSize: 18.0);// variable para manejar el tamaño de los widgets

    return Column( // retorno del metodo.
      children: [ // propiedad del Wdiget "Column" para crear a todos sus hijos
        SizedBox(height: tamano.height * 0.03), //espacio imaginario entre un widget y otro, en este caso, espacio de 3% de alto
        Container(child: Image(image: AssetImage('imagenes/salfa.png'))), // Widget donde definimos una imagen guardada en el proyecto
        SizedBox(height: tamano.height * 0.03),//espacio imaginario entre un widget y otro, en este caso, espacio de 3% de alto
        Text('Iniciar sesion', style: fuente), // Texto en pantalla con un estilo
        SizedBox(height: tamano.height * 0.1),//espacio imaginario entre un widget y otro, en este caso, espacio de 1% de alto
        Text('Ingrese sus datos para iniciar sesion', style: fuente),// Texto en pantalla con un estilo
        SizedBox(height: tamano.height * 0.04),//espacio imaginario entre un widget y otro, en este caso, espacio de 4% de alto
        _rut(tamano), // metodo que creara el input del rut
        SizedBox(height: tamano.height * 0.01),//espacio imaginario entre un widget y otro, en este caso, espacio de 1% de alto
        _pass(tamano), // metodo que creara el input del password
        SizedBox(height: tamano.height * 0.1),//espacio imaginario entre un widget y otro, en este caso, espacio de 1% de alto
        _botonIniciar(tamano), // metodo que creara el boton para iniciar sesion
      ],
    );
    
  }

  Widget _rut(Size tamano) { // metodo que creara el input del rut

    return Container( // retorno del metodo
      width: tamano.width * 0.7,// espacio maximo que ocupara de ancho el contenedor. 70% 
      child: TextFormField( // widget para crear el input del rut
        textCapitalization: TextCapitalization.sentences,// define la primera letra como mayuscula
        decoration: InputDecoration(// le damos una decoracion al input
          labelText: 'Rut', // texto de ayuda que tendra el input. como un placeholder html
        ),
        validator: (value) {// validacion de los datos ingresados
          if(value.length < 6) {// cuenta la cantidad de caracteres escritos. si la cantidad es menor a 6 
            return 'Ingrese un rut valido'; // manda el siguiente erro debajo del input
          } else {
            return null;
          }
        },
        onSaved: (value) => usuarioModel.rut = value //al pasar la validacion guardamos el rut ingresado en la variable UsuarioModel.rut
      ),
    );

  }

  Widget _pass(Size tamano) {// metodo que creara el input del password

    return Container( // retorno del metodo
      width: tamano.width * 0.7,// espacio maximo que ocupara de ancho el contenedor. 70% 
      child: TextFormField( // widget para crear el input del rut
        obscureText: true, // enegrese el texto a medida que se va escribiendo
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(// le damos una decoracion al input
          labelText: 'contraseña',// texto de ayuda que tendra el input. como un placeholder html
        ),
        validator: (value) {// validacion de los datos ingresados
          if(value.length <= 4) {// cuenta la cantidad de caracteres escritos. si la cantidad es menor o igual a 4
            return 'El password debe tener minimo 5 caracteres'; // manda el siguiente erro debajo del input
          } else {
            return null;
          }
        },
        onSaved: (value) => usuarioModel.password = value,//al pasar la validacion guardamos el password ingresado en la variable UsuarioModel.password
      ),
    );

  }

  Widget _botonIniciar(Size tamano) {// metodo que creara el boton para iniciar sesion

    return StreamBuilder( // retorno del metodo
      stream: usuarioBloc.usuarioStream, // seleccionamos el flujo de informacion que queremos cargar
      builder: (BuildContext context, AsyncSnapshot<List<UsuarioModel>> snapshot) { // el builder es el encargado de dibujar lo que deseamos. recibe dos variables, el context y una que por defecto se llama "snapshot" y tendra toda la informacion del stream

        final usuarios = snapshot.data;// guardamos la "Data" (informacion) en la variable usuarios

        return TextButton( //retorno del builder. un boton con un texto
          style: TextButton.styleFrom( // estilo para el boton
            padding: EdgeInsets.symmetric(horizontal: 50.0), //le da dimensiones mas grandes o chicas al boton. en este caso 50 pixeles horizontalmente
            backgroundColor: Colors.blue, // color del fondo azul
            primary: Colors.white, // color de las letras blanco
          ),
          child: Text('Ingresar', style: TextStyle(fontSize: 15.0, color: Colors.white)), // texto que tendra el boton con algo de estilo definido
          onPressed: () => _login(usuarios) // metodo que se disparara al presionar el boton
        );

      }
    );

  }

  void _login(List<UsuarioModel> usuarios) async { // metodo que define si las credenciales son valdias o no

    if(!keyformulario.currentState.validate()) return; // verifica si el formulario esta validado
    keyformulario.currentState.save();// guarda el formulario en caso que pase todas las validaciones puestas.

    final resp = await usuarioProvider.validaUsuario(usuarioModel); //ejecutamos el metodo validarUsuario y guardamos su respuesta en la variable "resp"

    if(resp == true) { // si la respuesta obtenida es true
    List<UsuarioModel> login = []; // creamos una lista vacia 

      for (var i = 0; i < usuarios.length; i++) { // recorremos la lista de los usuarios obtenidas
        if(usuarioModel.rut == usuarios[i].rut) { // si en algun momento el rut que ingresamos es igual a un rut de la base de datos
          login.add(usuarios[i]); // guardamos todos los datos de dicho usuario en la lista creada anteriormente.
        }
      }
      Navigator.pushReplacementNamed(context, 'home', arguments: login[0]); // navegamos a la pantalla definda con el string "home" y le mandamos como parametro todo el usuario
    } else { // si la resp = false
      final snack = utils.snackBar('Los datos ingresados no son validos'); // envia un snackbar como aviso
      ScaffoldMessenger.of(context).showSnackBar(snack); // dibujamos el snackbar en pantalla
    }

  }


}
        