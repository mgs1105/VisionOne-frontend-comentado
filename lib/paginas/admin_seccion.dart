import 'package:flutter/material.dart';
import 'package:vision_one/bloc/seccion_bloc.dart';
import 'package:vision_one/modelo/seccion_model.dart';
import 'package:vision_one/provider/seccion_provider.dart';

import 'package:vision_one/utils/utils.dart' as utils;

class AdminSeccionPage extends StatefulWidget { // definimos la clase como un stateFullWidget ya que podriamos necesitar que se vaya actualizando al notar algun cambio
  @override
  _AdminSeccionPageState createState() => _AdminSeccionPageState();
}

class _AdminSeccionPageState extends State<AdminSeccionPage> {

  final keyformulario = GlobalKey<FormState>(); // creamos una variable de tipo FromState que sirve para manejar el estado de un formulario. si se completo o no.
  //final keyScaffold = GlobalKey<ScaffoldState>(); 

  SeccionModel seccionModel = new SeccionModel(); // creamos una instancia de la clase SeccionModel
  SeccionProvider seccionProvider = new SeccionProvider();// creamos una instancia de la clase seccionProvider
  SeccionBloc seccionBloc = new SeccionBloc();// creamos una instancia de la clase SeccionBloc

  @override
  Widget build(BuildContext context) {//el metodo build es el encargado de dibujar los widgets en la pantalla, por eso debe regresar un widget a fuerza
  //el context contiene la informacion del arbol de widget.

    final tamano = MediaQuery.of(context).size; // definimos una variable "tamano" que sirve para controlar el espacio que usan los widget en pantalla

    return Scaffold( // scaffold es el lienzo principal donde se dibujan los Widgets
      appBar: AppBar( // es un menu superior que podemos ver en la pantalla. en el se define el titulo y otros botones que nos daran otras funcionalidades
        centerTitle: true, // centramos el titulo
        title: Text('Gestionar secciones'), // Especificamos el titulo que tendra esta pantalla
      ),
      body: Center( // definimos el cuerpo de la pantalla. Lo definimos Centrado(Center)
        child: SingleChildScrollView( // este Widget (SingleChildScrollView) sirve para hacer scroll infinito mientras la pantalla lo vaya requiriendo.
          child: Form( // definimos un formulario
            key: keyformulario, // especificamos la llave que tendra el formulario. esta llave se usa despues para validar el estado del formulario
            child: _body(tamano) // especificamos un metodo llamdo "_body" para continuar con el formulario
          ),
        ),
      )
    );
  }

  Widget _body(Size tamano) { // Metodo que regresa un widget y recibe la variable "tamano" para controlar los espacios.

    return Column( //retornamos un widget llamado Column, que sirve para acomodar a sus hijos uno debajo del otro.
      children: [ //propiedad de la columna
        Container( //Primer Hijo del Column. es como un div de html, mas facil de trabajar y orientar
          width: tamano.width * 0.7, // definimos su tamaño a lo ancho. en este caso usara el 70% del espacio a los costados.
          child: TextFormField( // el hijo del widget Container sera un TextFromField que tiene las propiedades de un input para escribir en el
            textCapitalization: TextCapitalization.sentences, //activa la mayuscula para la primera letra
            decoration: InputDecoration( //Decoracion del input
              labelText: 'Nombre de la seccion' //es similar al placeholder de html, se ve sombreado el texto que esta escrito aqui. funciona como una ayuda
            ),
            onSaved: (value) => seccionModel.nombre = value, // El texto que escribimos como nuevo nombre de una seccion (value) lo guardamos en la propiedad del seccionModel.nombre
          ),
        ),
        SizedBox(height: tamano.height * 0.09), //Espacio en blanco entre un widget y otro, en este caso es un espacio vertical al definir la propiedad height. ocupara el 9%
        TextButton( //Widget en forma de boton con un texto en el.
          child: Text('Crear', style: TextStyle(fontSize: 15.0),), // el texto del boton sera "Crear" y tendra un tamano de 15 pixeles
          style: TextButton.styleFrom( //añadir estilo al boton
            backgroundColor: Colors.blue, //color de fondo del boton
            primary: Colors.white, // color de las letras
            padding: EdgeInsets.symmetric(horizontal: 50.0) //ancho que se le da al boton. Horizontalmente de 50 pixeles
          ),
          onPressed: () {
            if(!keyformulario.currentState.validate()) return; //validamos el formulario. Si esta completo, continua, si no, no regresa nada (return;)

            keyformulario.currentState.save(); // guarda los datos ingresados en el formulario

            seccionProvider.crearSeccion(seccionModel); //ejecutamos el metodo "crearSeccion" y le mandamos los datos de la seccion

            final snack = utils.snackBar('Seccion creada con exito'); //creamos una variable llamada snack y la igualamos al metodo creado en el carpeta utils, archio utils.dart
            ScaffoldMessenger.of(context).showSnackBar(snack); // Dispara el snackbar en pantalla
            
            seccionBloc.cargarSeccion(); //ejecutamos el metodo y le cargamos la nueva seccion al stream.
          }, 
        ),
      ]
    );
    

  }



}