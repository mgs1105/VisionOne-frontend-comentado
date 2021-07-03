import 'package:flutter/material.dart';
import 'package:vision_one/bloc/usuario_bloc.dart';

import 'package:vision_one/modelo/usuario_model.dart';
import 'package:vision_one/provider/bodega_provider.dart';
import 'package:vision_one/provider/usuario_provider.dart';

import 'package:vision_one/utils/utils.dart' as utils;
import 'package:dart_rut_validator/dart_rut_validator.dart';

class CrearUsuarioPage extends StatefulWidget {
  @override
  _CrearUsuarioPageState createState() => _CrearUsuarioPageState();
}

class _CrearUsuarioPageState extends State<CrearUsuarioPage> {

  TextEditingController _rutController = TextEditingController();
  
  @override
  void initState(){
    _rutController.clear();
    super.initState();
  }

  void onSubmit(){
    RUTValidator.formatFromText(_rutController.text);
}

  final keyformulario = GlobalKey<FormState>();// creamos una variable de tipo FromState que sirve para manejar el estado de un formulario. si se completo o no.

  UsuarioModel usuarioModel = new UsuarioModel();//creamos una nueva instancia de la clase UsuarioModel
  UsuarioProvider usuarioProvider = new UsuarioProvider();//creamos una nueva instancia de la clase UsuarioProvider
  UsuarioBloc usuarioBloc = new UsuarioBloc();//creamos una nueva instancia de la clase UsuarioBloc

  BodegaProvider bodegaProvider = new BodegaProvider();

  List<String> roles = ["VENDEDOR", "BODEGUERO", "ADMIN"]; // creamos una lista String con 3 valores
  //List<String> bodegas = 
  bool _bloquearCombo = true;

  @override 
  Widget build(BuildContext context) {//el metodo build es el encargado de dibujar los widgets en la pantalla, por eso debe regresar un widget a fuerza
  //el context contiene la informacion del arbol de widget.

    return Scaffold(// scaffold es el lienzo principal donde se dibujan los Widgets
      appBar: AppBar(// es un menu superior que podemos ver en la pantalla. en el se define el titulo y otros botones que nos daran otras funcionalidades
        centerTitle: true,// centramos el titulo
        title: Text('Crear nuevo usuario'), // Especificamos el titulo que tendra esta pantalla
      ),
      body: Center( // definimos el cuerpo de la pantalla. Lo definimos Centrado(Center)
        child: SingleChildScrollView(// este Widget (SingleChildScrollView) sirve para hacer scroll infinito mientras la pantalla lo vaya requiriendo.
          child: Form(// definimos un formulario
            key: keyformulario, // especificamos la llave que tendra el formulario. esta llave se usa despues para validar el estado del formulario
            child: _formulario(),// especificamos un metodo llamdo "_formulario" para continuar con el formulario
          ),
        ),
      ),
    );
  }

  Widget _formulario() { // metodo para crear el formulario

    final fuente = TextStyle(fontSize: 18.0);// creamos una instancia de un textStyle.
    final tamano = MediaQuery.of(context).size; //  // definimos una variable "tamano" que sirve para controlar el espacio que usan los widget en pantalla

    return Column(//retornamos un widget llamado Column, que sirve para acomodar a sus hijos uno debajo del otro.
      children: [//propiedad de la columna
        _rut(tamano), // metodo que define la creacion del input del rut
        SizedBox(height: tamano.height * 0.05), //Espacio en blanco entre un widget y otro, en este caso es un espacio vertical al definir la propiedad height. ocupara el 5%
        _password(tamano),// metodo que define la creacion del input del password
        SizedBox(height: tamano.height * 0.05), //Espacio en blanco entre un widget y otro, en este caso es un espacio vertical al definir la propiedad height. ocupara el 5%
        Text('Rol', style: fuente), //Texto desplegado en pantalla
        SizedBox(height: tamano.height * 0.03), //Espacio en blanco entre un widget y otro, en este caso es un espacio vertical al definir la propiedad height. ocupara el 3%
        _rol(tamano),// metodo que define la creacion del input del rol
        SizedBox(height: tamano.height * 0.1), //Espacio en blanco entre un widget y otro, en este caso es un espacio vertical al definir la propiedad height. ocupara el 10%
        Text('Bodega', style: fuente),//Texto desplegado en pantalla
        Text('*solo si el rol es bodeguero*', style: TextStyle(fontSize: 14.0)),//Texto desplegado en pantalla
        SizedBox(height: tamano.height * 0.03),//Espacio en blanco entre un widget y otro, en este caso es un espacio vertical al definir la propiedad height. ocupara el 3%
        _bodega(tamano),//metodo que define el input para las bodegas
        SizedBox(height: tamano.height * 0.1), //Espacio en blanco entre un widget y otro, en este caso es un espacio vertical al definir la propiedad height. ocupara el 10%
        _boton(tamano)
      ],
    );
  }

  Widget _rut(Size tamano) {

    return Container(// lo que regresa el metodo. un contenedor. parecido a los div html
      width: tamano.width * 0.7,// espacio que usara de la pantalla el contenedor a lo ancho, en este caso un 70%
      child: TextFormField( // widget para crear el input del rut
        controller: _rutController,
        validator: RUTValidator().validator, //validacion del rut usando el paquete importado
        decoration: InputDecoration( // decoracion del input
          labelText: 'Rut',//texto de apoyo en el input
        ),
        onSaved: (value) => usuarioModel.rut = value // guardamos el texto tipeado en la variable usuarioModel.rut
      ),
    );    

  }

  Widget _password(Size tamano) {

    return Container(// lo que regresa el metodo. un contenedor. parecido a los div html
      width: tamano.width * 0.7,// espacio que usara de la pantalla el contenedor a lo ancho, en este caso un 70%
      child: TextFormField(// widget para crear el input del rut
        textCapitalization: TextCapitalization.sentences, //activa la mayuscula para la primera letra
        validator: (value) { // validacion del formulario
          if(value.length <= 4) { // condicion: si el largo del password es igual o inferior a 4 caracteres dispara el error
            return 'La contraseña debe tener minimo 5 digitos';  // error que aperece abajo del input
          } else {
            return null;
          }
        },
        decoration: InputDecoration( // decoracion del input
          labelText: 'Password', // texto de apoyo en el input
        ),
        onSaved: (value) => usuarioModel.password = value // guardamos el texto tipeado en la variable usuarioModel.password
      ),
    );

  }

  Widget _rol(Size tamano) { //metodo para crear el input del rol

    String _rol; // variable creada para manejar el rol

    return  Container(// lo que regresa el metodo. un contenedor. parecido a los div html
      width: tamano.width * 0.7,// espacio que usara de la pantalla el contenedor a lo ancho, en este caso un 70%
      child: DropdownButtonFormField(// widget para crear el combobox 
        value: '${roles[0]}', // el valor inicial que tomara sera el primero de la lista creada
        items: utils.opcionesRol(roles), // creamos los distintos items que tendra el combobox ejecutando el metodo opcionesRol en el archivo utils. debemos enviarle la lista de roles
        onChanged: (opt) { // propiedad que da la opcion de ir cambiando el valor que se selecciona en el combobox
          setState(() {// actualiza la pantalla a medida que se encuentran cambios
            if(opt == "BODEGUERO") {
              _bloquearCombo = false;
            _rol = opt; // iguala el valor elegido a la variable
            } 
          });
        },
        onSaved: (opt) {
          usuarioModel.rol = opt; // guardamos el valor seleccionado en la variable de usuarioModel.rol
        } 
      ),
    );    

  }

  Widget _bodega(Size tamano) {//metodo donde se crea el input de bodegas.

    String _bodega;//creamos una variable String

    return FutureBuilder(//Widget para cargar datos y poder usarlos en la construccion de la vista
      future: bodegaProvider.cargarBodega(),//metodo que se cargara
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {//propiedad que recibe el context para dibujar los widget en pantalla y la propiedad snapshot que tiene la informacion del metodo ejecutado en el Future
        
        if(snapshot.hasData) {//si el snapshot tiene informacion

        final bodegas = snapshot.data;//guarda la informacion en la variable "bodegas"

        return Container( //regresa un contenedor
          width: tamano.width *0.7,//usara el 70% de la pantalla a lo ancho
            child: DropdownButtonFormField(//hijo del contenedor que sera el input tipo ComboBox
              value: '${bodegas[0]}',//valor iniciar del input
              items: utils.opcionesBodega(bodegas),//resto de la lista que tendra el input
              onChanged: (opt) {//propiedad que va cambiando la opcion elegida
                setState(() {//metodo que actualiza la pagina cuando ve un cambio
                  _bodega = opt;//igualamos la opcion elegida.
                });
              },
              onSaved: (opt) {//propiedad para guardar la opcion elegida
                usuarioModel.bodega = opt; //le añadimos el valor elegido a la propiedad del usuarioModel
              },
            ),
        );

        } else {
          return Container();
        }
      },
    );

  }

  Widget _boton(Size tamano) { // metodo para crear al usuario

    final fuente = TextStyle(fontSize: 16.0, color: Colors.white); // instancia creada que contiene propiedades de un TextStyle, como el tamaño y el colors

    return TextButton(//define un boton con un texto.
      style: TextButton.styleFrom(// estilo para el boton
        backgroundColor: Colors.blue // color de fondo del boton azul
      ),
      child: Text('Crear usuario',  style: fuente), // Texto que tendra el boton. Tiene el estilo definido al comienzo del metodo
      onPressed: () async { // acciones que realizara el boton al presionarlo
      
        if(!keyformulario.currentState.validate()) return; // verifica si el formulario esta validado
        keyformulario.currentState.save();// guarda el formulario en caso que pase todas las validaciones puestas.

        final listaUser = await usuarioProvider.cargarUsuario(); //creamos una variable que guardara el listado de todos los usuarios al ejecutar el metodo "cargarUsuario"

        List<String> rutIgual = []; // creamos una lista de String vacia

        for (var i = 0; i < listaUser.length; i++) { // recorremos la lista de usuarios con una variable "i" hasta que la variable "i" sea menor al numero de usuarios
          
          if(usuarioModel.rut == listaUser[i].rut) { // condicion: si el rut que estamos ingresando es igual algun rut en la base de datos
            rutIgual.add(usuarioModel.rut);  // añadimos ese usuario a la listas creada
          } 
        } 

        if(rutIgual.length == 1) { // si la lista contiene un elemento quiere decir que el rut ya existe en la base de datos
          final snack = utils.snackBar('Este usuario ya existe'); // entonces, mandamos un snackbar con el mensaje que el usuario ya existe.
          ScaffoldMessenger.of(context).showSnackBar(snack); // dibujamos el snackbar en la pantalla
        } else {
          setState(() { //actualiza la pagina cuando detecta algun cambio
          usuarioProvider.crearUsuario(usuarioModel); // ejecutamos el metodo crearUsuario para guardarlo en la base de datos
          });
          final snack = utils.snackBar('Usuario creado con exito');  // creamos una variable snack que guardara la informacion obtenida del metodo llamado snackbar
          ScaffoldMessenger.of(context).showSnackBar(snack); // dibujamos el snackbar en pantalla
        }
            
      }
    );

  }

}

    



