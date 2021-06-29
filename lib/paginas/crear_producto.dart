import 'dart:io';

import 'package:flutter/material.dart';

import 'package:vision_one/bloc/producto_bloc.dart';
import 'package:vision_one/modelo/producto_model.dart';
import 'package:vision_one/provider/producto_provider.dart';

import 'package:vision_one/modelo/seccion_model.dart';

import 'package:image_picker/image_picker.dart';
import 'package:vision_one/utils/utils.dart' as utils;

class CrearProdPage extends StatefulWidget {
  @override
  _CrearProdPageState createState() => _CrearProdPageState();
}

class _CrearProdPageState extends State<CrearProdPage> {

  final keyformulario = GlobalKey<FormState>();// creamos una variable de tipo FromState que sirve para manejar el estado de un formulario. si se completo o no.
  
  ProductoModel productoModel = new ProductoModel(); // creamos una instancia de la clase ProductoModel
  ProductoProvider productoProvider = new ProductoProvider();// creamos una instancia de la clase ProductoProvider
  ProductoBloc productoBloc = new ProductoBloc();// creamos una instancia de la clase ProductoBloc

  bool _guardando = false; // creamos una instancia bool definida como false
  File foto; // definimos una variable File para guardar la fotografia..

  @override
  Widget build(BuildContext context) {//el metodo build es el encargado de dibujar los widgets en la pantalla, por eso debe regresar un widget a fuerza
  //el context contiene la informacion del arbol de widget.


    return Scaffold(// scaffold es el lienzo principal donde se dibujan los Widgets
      appBar: AppBar(// es un menu superior que podemos ver en la pantalla. en el se define el titulo y otros botones que nos daran otras funcionalidades
        centerTitle: true,// centramos el titulo
        title: Text('Añadir producto'),// Especificamos el titulo que tendra esta pantalla
      ),
      body: Center(// definimos el cuerpo de la pantalla. Lo definimos Centrado(Center)
        child: SingleChildScrollView(// este Widget (SingleChildScrollView) sirve para hacer scroll infinito mientras la pantalla lo vaya requiriendo.
          child: Form(// definimos un formulario
            key: keyformulario,// especificamos la llave que tendra el formulario. esta llave se usa despues para validar el estado del formulario
            child: _body(),// especificamos un metodo llamdo "_body" para continuar con el formulario
          ),
        )
      ),
    );
  }

  Widget _body() {

    final tamano = MediaQuery.of(context).size; // creamos una variable que nos ayudara a controlar el espacio que ocupan los widgets

    return Column(// retorno del metodo
      children: [// lista de widgets(hijos)
        SizedBox(height: tamano.height * 0.05),//espacio imaginario entre un widget y otro, en este caso, espacio de 5% de alto
        _subirFoto(tamano),//metodo para subir fotografia
        SizedBox(height: tamano.height * 0.05),//espacio imaginario entre un widget y otro, en este caso, espacio de 5% de alto
        _nombreProd(tamano),//metodo para definir el nombre del producto
        SizedBox(height: tamano.height * 0.05),//espacio imaginario entre un widget y otro, en este caso, espacio de 5% de alto
        _stockA(tamano),//metodo para definir el input del stockA
        SizedBox(height: tamano.height * 0.05),//espacio imaginario entre un widget y otro, en este caso, espacio de 5% de alto
        _stockB(tamano),//metodo para definir el input del stockB
        SizedBox(height: tamano.height * 0.05),//espacio imaginario entre un widget y otro, en este caso, espacio de 5% de alto
        _stockC(tamano),//metodo para definir el input del stockC
        SizedBox(height: tamano.height * 0.05),//espacio imaginario entre un widget y otro, en este caso, espacio de 5% de alto
        _stockCritico(tamano),
        SizedBox(height: tamano.height * 0.05),//espacio imaginario entre un widget y otro, en este caso, espacio de 5% de alto
        _numeroParte(tamano),
        SizedBox(height: tamano.height * 0.05),
        _boton(),//metodo para definir el boton agregar
        SizedBox(height: tamano.height * 0.05),//espacio imaginario entre un widget y otro, en este caso, espacio de 5% de alto
      ]
    );
  }

  Widget _subirFoto(Size tamano) { //metodo que trabajara la subida de la imagen

    if(foto == null) { // si la variable definida al comienzo del archivo es nula realizara lo siguiente
      return GestureDetector( // Widget usado para dar la propiedad a su hijo de un "boton". el hijo detectara cuando se hacet tap en el y podra disparar cualquier instruccion
        child: Container( // hijo que recibira la propiedad de hacer tap
          margin: EdgeInsets.symmetric(horizontal: 30.0), //margen horizontal que se le da al contenedor de 30 pixeles
          child: Image(image: AssetImage('imagenes/no-image.png')), // se carga la imagen guardarda en la carpeta "imagenes" del proyecto
        ),
        onTap: _selccionarFoto, // se dispara el metodo "_seleccionarFoto" cuando presionamos el Container
      );
    } else { // si la foto no es null, quiere decir que ya se ha seleccionado una.
      return GestureDetector(
        child: Image.file( // Wdiget que permite cargar un archivo de imagen
          foto, // Espera recibir un archivo File. cargamos la variable definida al comienzo. esta es la imagen que se muestra.
          height: 300, // le da una altura de 300 pixeles a la imagen.
          fit: BoxFit.cover, // se da la propiedad a la imagen de no sobrepasar de los bordes. que respete el espacio asignado
        ),
        onTap: _selccionarFoto, // se dispara el metodo "_seleccionarFoto" cuando presionamos la imagen
      );
    }
  }

  Widget _nombreProd(Size tamano) { // metodo para crear el nombre del Producto

    final SeccionModel seccion = ModalRoute.of(context).settings.arguments; // cargamos los datos de la seccion cuando navegamos de la pantalla anterior a esta.

    return  Container( // retorno del metodo
      width: tamano.width * 0.7, // espacio maximo que ocupara de ancho el contenedor. 70%  
      child: TextFormField( // // widget para crear el input del rut
        textCapitalization: TextCapitalization.sentences, // define la primera letra como mayuscula
        decoration: InputDecoration( // le damos una decoracion al input
          labelText: 'Nombre del Producto' // texto de ayuda que tendra el input. como un placeholder html
        ),
        validator: (value) { // validacion de los datos ingresados

          if(value.length <= 0) { // cuenta la cantidad de caracteres escritos. si la cantidad es menor o igual a 0 
            return 'Debe especificar el nombre del producto';  // regresa este mensaje bajo el input
          } else {
            return null;
          }

        },
        onSaved: (value) { // guardar el nombre
          productoModel.nombre = value; // el tipeado es guardado con la varaible productoModel.nombre
          productoModel.idseccion = seccion.id; // se añade el id de la seccion al producto.
        }
      ),
    );

  }

  Widget _stockA(Size tamano) { // metodo para definir el input del stockA

    return Container(// retorno del metodo
      width: tamano.width * 0.7, //espacio maximo que ocupara de ancho el contenedor. 70%  
      child: TextFormField(// widget para crear el input del rut
        keyboardType: TextInputType.number, // al presionar el input el se abre el teclado de numeros
        textCapitalization: TextCapitalization.sentences, 
        decoration: InputDecoration( // decoracion del input
          labelText: 'Stock en sucursal Arrendador' // texto de ayuda.
        ),
        validator: (value) { // validacion del completado de campos

          if(value.length <= 0) { // si el campo esta vacio lanza el siguiente error debajo del input
            return 'Debe especificar la cantidad en bodega';
          } else {
            return null;
          }
        },
        onSaved: (value) => productoModel.arrendador = int.parse(value) // Guardamos el contenido en la variable StockA de producto. debemos convertir el string a un int
      ),
    );

  }

  Widget _stockB(Size tamano) {//metodo para definir el input del stockB

    return Container(// retorno del metodo
      width: tamano.width * 0.7,
      child: TextFormField(// widget para crear el input del rut
        keyboardType: TextInputType.number,// al presionar el input el se abre el teclado de numeros
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(// decoracion del input
          labelText: 'Stock en sucursal Servicio liviano' // texto de ayuda.
        ),
        validator: (value) {// validacion del completado de campos
          if(value.length <= 0) {// si el campo esta vacio lanza el siguiente error debajo del input
            return 'Debe especificar la cantidad en bodega';
          } else {
            return null;
          }
        },
        onSaved: (value) => productoModel.servicioliviano = int.parse(value)// Guardamos el contenido en la variable StockA de producto. debemos convertir el string a un int
      ),
    );

  }

  Widget _stockC(Size tamano) {//metodo para definir el input del stockC

    return Container( // retorno del metodo
      width: tamano.width * 0.7,
      child: TextFormField(// widget para crear el input del stockC
        keyboardType: TextInputType.number,// al presionar el input el se abre el teclado de numeros
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(// decoracion del input
          labelText: 'Stock en sucursal Servicio pesado' // texto de ayuda.
        ),
        validator: (value) {// validacion del completado de campos
          if(value.length <= 0) {// si el campo esta vacio lanza el siguiente error debajo del input
            return 'Debe especificar la cantidad en bodega';
          } else {
            return null;
          }
        },
        onSaved: (value) => productoModel.serviciopesado = int.parse(value)// Guardamos el contenido en la variable StockC de producto. debemos convertir el string a un int
      ),
    );
    
  }

  Widget _stockCritico(Size tamano) {//metodo para definir el input del stockCritico

    return Container( // retorno del metodo
      width: tamano.width * 0.7,
      child: TextFormField(// widget para crear el input del stockCritico
        keyboardType: TextInputType.number,// al presionar el input el se abre el teclado de numeros
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(// decoracion del input
          labelText: 'Stock Critico del producto' // texto de ayuda.
        ),
        validator: (value) {// validacion del completado de campos
          if(value.length <= 0) {// si el campo esta vacio lanza el siguiente error debajo del input
            return 'Debe especificar el stock critico del producto';
          } else {
            return null;
          }
        },
        onSaved: (value) => productoModel.stockCritico = int.parse(value)// Guardamos el contenido en la variable stockCritico de producto. debemos convertir el string a un int
      ),
    );
    
  }

  Widget _numeroParte(Size tamano) {//metodo para definir el input del stockCritico

    return Container( // retorno del metodo
      width: tamano.width * 0.7,
      child: TextFormField(// widget para crear el input del stockCritico
        keyboardType: TextInputType.number,// al presionar el input el se abre el teclado de numeros
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(// decoracion del input
          labelText: 'Numero de parte' // texto de ayuda.
        ),
        validator: (value) {// validacion del completado de campos
          if(value.length != 10) {// si el campo esta vacio lanza el siguiente error debajo del input
            return 'El numero de parte debe ser de 10 caracteres';
          } else {
            return null;
          }
        },
        onSaved: (value) => productoModel.nParte = value// Guardamos el contenido en la variable stockCritico de producto. debemos convertir el string a un int
      ),
    );
    
  }

  Widget _boton()  { //metodo donde se define el boton

    return TextButton( // boton con un texto
      child: Text('Añadir producto', style: TextStyle(fontSize: 15.0)), // texto del boton y estilo
      style: TextButton.styleFrom( // estilo para el boton
        backgroundColor: Colors.blue,// color de fondo del boton azul
        primary: Colors.white, //color del texto. blanco
        padding: EdgeInsets.symmetric(horizontal: 50.0) // define que tan grande es el boton horizontalmente.
      ),
      onPressed: () async { // metodo que se ejecuta cuando se presiona el boton

        if(!keyformulario.currentState.validate()) return;  // verifica si el formulario esta validado
        keyformulario.currentState.save(); // guarda el formulario en caso que pase todas las validaciones puestas.

        if (foto != null) { // si la variable "foto" NO es nula. hacemos lo siguiente
          productoModel.fotoURL = await productoBloc.subirFoto(foto); // la variable de "fotoURL" del modelo del producto tomara el valor de la respuesta que dara el metodo "subirFoto". donde se le manda la foto como un File.
        }

        productoProvider.crearProducto(productoModel); // ejecutamos el metodo crearProducto para su creacion en la base de datos.
        
        final snack = utils.snackBar('Producto creado con exito'); // creamos una variable llamada "snack" que tomara el valor del metodo "snackBar" creado en el archivo utils
        ScaffoldMessenger.of(context).showSnackBar(snack); // desplegamos el snackbar en pantalla
      }, 
    );

  }

  _selccionarFoto() { // metodo que permite seleccionar fotografias de la galeria
    procesarImagen(ImageSource.gallery); // abrimos la galeria
  }

  void procesarImagen(ImageSource origen) async { // metodo que procesa la imagen para ser subida.

    final _picker = ImagePicker(); // creamos una variable de tipo ImagePicker para poder trabajarla.
    final pickedFile = await _picker.getImage(source: origen); // cargamos la imagen al pickedFile

    setState(() { // actualiza constantemente la pantalla cuando se produce algun cambio
      if(pickedFile != null) { // si la variable donde se cargo la imagen NO  es nula (osea que si tiene informacion)
        productoModel.fotoURL = null; // definimos la variable "fotoURL" del producto como nula
        foto = File(pickedFile.path); // cargamos el File llamado foto con el string de la imagen
      } else {
        print('No ha seleccionado imagen'); // mensaje por consola que no se seleccionado imagen
      }
    });

  }



}