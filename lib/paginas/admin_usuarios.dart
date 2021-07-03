import 'package:flutter/material.dart';

import 'package:vision_one/modelo/usuario_model.dart';
import 'package:vision_one/provider/bodega_provider.dart';
import 'package:vision_one/provider/usuario_provider.dart';

import 'package:vision_one/utils/utils.dart' as utils;

class AdminUsuarioPage extends StatefulWidget {

  @override
  _AdminUsuarioPageState createState() => _AdminUsuarioPageState();
}

class _AdminUsuarioPageState extends State<AdminUsuarioPage> {

  final keyformulario = GlobalKey<FormState>();// creamos una variable de tipo FromState que sirve para manejar el estado de un formulario. si se completo o no.

  UsuarioProvider usuarioProvider = new UsuarioProvider();//creamos una nueva instancia de la clase UsuarioProvider
  BodegaProvider bodegaProvider = new BodegaProvider();

  List<String> roles = ["VENDEDOR", "BODEGUERO", "ADMIN"];//creamos una lista de String con 3 valores.

  @override
  Widget build(BuildContext context) {//el metodo build es el encargado de dibujar los widgets en la pantalla, por eso debe regresar un widget a fuerza
  //el context contiene la informacion del arbol de widget. 

    final UsuarioModel usuario = ModalRoute.of(context).settings.arguments; //creamos una variable de tipo UsuarioModel que obtendra los valores del usuario Logeado cuando cambiamos pagina

    return Scaffold( // scaffold es el lienzo principal donde se dibujan los Widgets
      appBar: AppBar( // es un menu superior que podemos ver en la pantalla. en el se define el titulo y otros botones que nos daran otras funcionalidades
        centerTitle: true,// centramos el titulo
        title: Text('Administrar usuario'), // Especificamos el titulo que tendra esta pantalla
      ),
      body: Center( // definimos el cuerpo de la pantalla. Lo definimos Centrado(Center)
        child: SingleChildScrollView( // este Widget (SingleChildScrollView) sirve para hacer scroll infinito mientras la pantalla lo vaya requiriendo.
          child: Form(// definimos un formulario
            key: keyformulario, // especificamos la llave que tendra el formulario. esta llave se usa despues para validar el estado del formulario
            child: _body(usuario),// especificamos un metodo llamdo "_body" para continuar con el formulario
          ) 
        ),
      ) 
    );
  }

  Widget _body(UsuarioModel usuario) {// Metodo que regresa un widget y recibe la variable de usuario.

    final fuente = TextStyle(fontSize: 18.0); // creamos una variable que toma la propiedad de un texto con tamaño de 18 pixeles.
    final tamano = MediaQuery.of(context).size; // creamos una variable que nos ayudara a controlar el espacio que ocupan los widgets

    return Column( // retorno del metodo
      children: [ // lista de widgets(hijos)
        _rut(tamano, usuario), // metodo que recibe el tamano y usuario.
        SizedBox(height: tamano.height * 0.05), //espacio imaginario entre un widget y otro, en este caso, espacio de 5% de alto
        Text('Rol', style: fuente), //Widget para dibujar un texto en la pantalla. Ademas recibe el estilo definido con anterioridad
        SizedBox(height: tamano.height * 0.03), ////espacio imaginario entre un widget y otro, en este caso, espacio de 3% de alto
        _rol(tamano, usuario), // metodo que recibe el tamano y usuario
        SizedBox(height: tamano.height * 0.04),//espacio imaginario entre un widget y otro, en este caso, espacio de 4% de alto
        Text('Bodega', style: fuente),//Widget para dibujar un texto en la pantalla. Ademas recibe el estilo definido con anterioridad
        Text('*solo si el rol es bodeguero*', style: TextStyle(fontSize: 14.0)),//Widget para dibujar un texto en la pantalla. Ademas recibe el estilo definido con anterioridad
        SizedBox(height: tamano.height * 0.03),
        _bodega(tamano, usuario),//metodo donde se definen la bodega del usuario si fuera hacer necesario
        SizedBox(height: tamano.height * 0.1), // espacio imaginario entre un widget y otro, en este caso, espacio de 1% de alto
        _botones(tamano, usuario),  //metodo donde se definen los botones de la pagina y recibe el tamano y usuario.
      ],
    );

  }
    
  Widget _rut(Size tamano, UsuarioModel usuario) {// metodo que define el input para escribir el Rut.

    return Container( // lo que regresa el metodo. un contenedor. parecido a los div html
      width: tamano.width * 0.7, // espacio que usara de la pantalla el contenedor a lo ancho, en este caso un 70%
      child: TextFormField( // widget para crear el input del rut
        enabled: false, // el input no se puede editar
        initialValue: '${usuario.rut}', // el valor que tendra el input sera el rut del usuario
        decoration: InputDecoration( //widget para decorar el input
          labelText: 'Rut', //texto de ayuda
        ),
        onSaved: (value) => usuario.rut = value // se guarda el valor del rut (value )en la propiedad del usuario.rut
      ),
    );

  }

  Widget _rol(Size tamano, UsuarioModel usuario) {// metodo para definir el rol del usuario

    String _rol; // se crea variable de tipo string para usarla mas adelante y guardar el rol

    return  Container( // retorno del metodo
      width: tamano.width * 0.7, // espacio que usara el widget Container a lo ancho. 70%
      child: DropdownButtonFormField( // widget hijo del Container. Parecido a un "Combobox" de html
        value: '${usuario.rol}',// valor inicial del comboBox. toma el rol del usuario
        items: utils.opcionesRol(roles),// Se definen las distintas opciones que tendra el combobox. Estas opciones se traen desde otro archivo. importado al inicio de la pag.
        onChanged: (opt) { // propiedad del DropdownButtonFormField para ir cambiando la opcion que elige el usuario.
          setState(() { // funcion que actualiza de manera automatica la pantalla cuando distingue algun cambio.
            _rol = opt; // la variable string definida antes toma el valor que se selecciona en el DropdownButtonFormField (opt)
          });
        },
        onSaved: (opt) { // guardamos la opcion seleccionada en el usuario.rol
          usuario.rol = opt;
        } 
      ),
    );
  }

  Widget _bodega(Size tamano, UsuarioModel usuario) {//metodo para crear el input de la creacion de bodega

    String _bodega;//creamos una variable string

    return FutureBuilder( //regreso del metodo.
      future: bodegaProvider.cargarBodega(), //cargamos el metodo future donde se obtendra la informacion
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {// opcion builder donde creamos los widget para ser dibujados en pantalla, ademas obtenemos la informacion del stream en la variable "snapshot"
        
        if(snapshot.hasData) {//si el snapshot tiene informacion...

        final bodegas = snapshot.data; // guarda la informacion en una variable llamada "bodegas"

        return Container( //regresamos un contenedor
          width: tamano.width *0.7,//tamano del 70% de la pantalla a lo ancho
            child: DropdownButtonFormField(//definimos el input que contendra la lista de bodegas (ComboBox)
              value: '${bodegas[0]}',//definimos el primer valor que se vera en la lista
              items: utils.opcionesBodega(bodegas),//definimos el resto de la lista del comboBox
              onChanged: (opt) {//propiedad que hara visible los cambios en el input dependiendo de lo que seleccionemos
                setState(() {//metodo que acutaliza la pagina constantemente ante los cambios
                  _bodega = opt; // guardamos la opcion seleccionada
                });
              },
              onSaved: (opt) { //metodo para guardar la opcion seleccionada en el modelo
                usuario.bodega = opt; //le asignamos el valor a la propiedad del modelo
              },
            ),
        );

        } else {// si el snapshot NO tiene informacion
          return Container();// regresa un contenedor
        }
      },
    );

  }

  Widget _botones(Size tamano, UsuarioModel usuario) { // metodo que crea los botones

    final fuente = TextStyle(fontSize: 16.0, color: Colors.white); // creamos la variable fuente con propiedades del TextStyle.

    return Row(// retorno del metodo.
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // alinea todo el contenido de la Fila con espacios iguales entre los widget
      children: [ // hijos de la fila.
        TextButton( //Primer hijo (widget). boton con un texto.
          style: TextButton.styleFrom( // estilo para el boton
            backgroundColor: Colors.blue, // color de fondo del boton azul
            padding: EdgeInsets.symmetric(horizontal: 20.0) // define que tan grande es el boton horizontalmente.
          ),
          child: Text('Eliminar',  style: fuente),// Texto que tendra el boton. Tiene el estilo definido al comienzo del metodo
          onPressed: () => _eliminarUsuario(usuario) // metodo que se ejcutara al precionar el boton.
        ),
        TextButton( // boton con un texto
          style: TextButton.styleFrom(// estilo para el boton
            backgroundColor: Colors.blue,// color de fondo del boton azul
            padding: EdgeInsets.symmetric(horizontal: 20.0)// define que tan grande es el boton horizontalmente.
          ),
          child: Text('Actualizar',  style: fuente),// Texto que tendra el boton. Tiene el estilo definido al comienzo del metodo
          onPressed: () => _actualizarUsuario(usuario) // metodo que se ejcutara al precionar el boton.
        ),
      ]
    );

  }

  void _eliminarUsuario(UsuarioModel usuario) { //metodo que dispara una alerta al presionar el boton con el texto eliminar
    
    final color = TextStyle(color: Colors.white); //creamos una variable color con propiedades del TextStyle.
    
    showDialog( // metodo que prepara la pantalla para disparar una alerta
      context: context,  //tiene el contexto de lo necesario para disparar dicha alerta
      builder: (context) { // el metodo builder contiene en su interior todo lo que se mostrara al presionar el boton
        return AlertDialog( // regresa una alerta
          title: Text('¿Esta seguro que desea eliminar este usuario?'), // titulo de la alerta
          actions: [ // widgets que tendra la alerta
            TextButton(// boton con un texto
              style: TextButton.styleFrom(// estilo para el boton
              backgroundColor: Colors.blueAccent// color de fondo del boton
              ),
              child: Text('No', style: color), // texto que tendra el boton y su respectivo estilo
              onPressed: () => Navigator.of(context).pop() // accion que ejecutara el el boton. en este caso cerrar la alerta y regresar a la pagina. gracias al Navigator.of(context).pop()
            ),
            Expanded(child: SizedBox(width: 10.0)),// espacio en blanco expandido que usara un espacio de10 pixeles a lo ancho
            TextButton( //boton con un texto.
            style: TextButton.styleFrom( // estilo que se le dara al boton
              backgroundColor: Colors.red // el boton tendra color de fondo rojo
            ), 
            child: Text('Eliminar', style: color), // texto que tendra el boton y estilo definido anteriormente.
            onPressed: () async { // metodo que ejecuta el boton al presionarlo
              Navigator.of(context).pop(); // regresa una pantalla
              Navigator.of(context).pop(); // regresa una pantalla

              usuarioProvider.eliminarUsuario(usuario); // ejecutamos el metodo eliminarUsuario de la la clase UsuarioProvider 
              final snack = SnackBar( // creamos una intancia de un snackbar 
              content: Text('Usuario eliminado con exito'), // definimos el texto que tendra el snackbar
              duration: Duration(seconds: 2), // tiempo que permanecera activo el snackbbar
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);// dibuja del snackbar en pantalla
            }, 
            )
          ],
        );
      }
    );    
  }

  void _actualizarUsuario(UsuarioModel usuario) { //metodo para actualizar al usuario

    keyformulario.currentState.save(); // guarda el formulario 
    usuarioProvider.modificarUsuario(usuario); // ejecutamos el metodo modificarUsuario de la clase UsuarioProvider.

    final snack = SnackBar( // // creamos una intancia de un snackbar
      content: Text('Usuario modificado con exito'),// definimos el texto que tendra el snackbar
      duration: Duration(seconds: 2),// tiempo que permanecera activo el snackbbar
    );
    ScaffoldMessenger.of(context).showSnackBar(snack); // dibuja del snackbar en pantalla

  }

}
