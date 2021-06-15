import 'package:flutter/material.dart';
import 'package:vision_one/bloc/producto_bloc.dart';
import 'package:vision_one/modelo/producto_model.dart';
import 'package:vision_one/modelo/seccion_model.dart';
import 'package:vision_one/provider/producto_provider.dart';

import 'package:vision_one/utils/utils.dart' as utils;

class ProdDetallePage extends StatefulWidget {
  @override
  _ProdDetallePageState createState() => _ProdDetallePageState();
}

class _ProdDetallePageState extends State<ProdDetallePage> {

  final keyformulario = GlobalKey<FormState>();// creamos una variable de tipo FromState que sirve para manejar el estado de un formulario. si se completo o no.

  ProductoProvider productoProvider = new ProductoProvider();// creamos una instancia de la clase ProductoProvider
  ProductoBloc productoBloc = new ProductoBloc();// creamos una instancia de la clase ProductoBloc

  @override
  Widget build(BuildContext context) {//el metodo build es el encargado de dibujar los widgets en la pantalla, por eso debe regresar un widget a fuerza
  //el context contiene la informacion del arbol de widget.

    final List<Object> opcion = ModalRoute.of(context).settings.arguments; // llegamos a esta pantalla mandando una lista con dos objetos y los recibimos de la siguiente manera
    final ProductoModel producto = opcion[0];  // Aqui obtenemos el primer objeto
    final SeccionModel seccion = opcion[1];// Aqui obtenemos el segundo objeto

    final tamano = MediaQuery.of(context).size; // definimos una variable "tamano" que sirve para controlar el espacio que usan los widget en pantalla

    return Scaffold(// scaffold es el lienzo principal donde se dibujan los Widgets
      appBar: AppBar( // es un menu superior que podemos ver en la pantalla. en el se define el titulo y otros botones que nos daran otras funcionalidades
        backgroundColor: Colors.blue, // definimos un color azul de fondo para el appBar
        title: Text('Detalle del producto'),// Especificamos el titulo que tendra esta pantalla
        centerTitle: true,// centramos el titulo
        actions: [// widgets que se agrupan a la esquina superior derecha del appbar.
          IconButton(// Boton en forma de icono
            icon: Icon(Icons.delete_forever),  //Icono que tendra el boton
            color: Colors.white, // Color del icono
            iconSize: 30.0, //tamaño del icono
            onPressed: () => _eliminar(producto, seccion) //metodo que se dispara al presionar el boton
          )
        ],
      ),
      body: SingleChildScrollView(// este Widget (SingleChildScrollView) sirve para hacer scroll infinito mientras la pantalla lo vaya requiriendo.
        child: Center(// definimos el cuerpo de la pantalla. Lo definimos Centrado(Center)
          child: _body(producto, tamano), // metodo que creara el body
        ) 
      ),
    );
            
  } 

  void _eliminar(ProductoModel producto, SeccionModel seccion) { //metodo que eliminara el producto

    final color = TextStyle(color: Colors.white); //creamos una variable llamda color que tendra propiedades de un TextStyle
    SeccionModel seccion = new SeccionModel(); // creamos una nueva instancia de la clase seccionModel

    seccion.id = producto.idseccion; 

    showDialog( // metodo que prepara la pantalla para disparar una alerta
      context: context,//tiene el contexto de lo necesario para disparar dicha alerta
      barrierDismissible: false, // al ser false decimos que la alerta no puede cerrarse si presionamos fuera de ella.
      builder: (context) => _alertas(producto, seccion, color)// el metodo builder contiene en su interior todo lo que se mostrara al presionar el boton. en este caso dispara un metodo
    );

  }

  Widget _alertas(ProductoModel producto, SeccionModel seccion, TextStyle color) { //metodo que disparara las alertas

    if(producto.stockA == 0 && producto.stockB == 0 && producto.stockC == 0) { // condicion: si el producto tiene Stock 0 en todas las sucursales hara lo siguiente

    final color = TextStyle(color: Colors.white);  //creamos una variale color que tendra propiedades de TextStyle.

      return AlertDialog(// regresa una alerta
        title: Text('Esta seguro que desea eliminar el producto?'), // titulo de la alerta
        actions: [// widgets que tendra la alerta
          TextButton(// boton con un texto
            style: TextButton.styleFrom(// estilo para el boton
              backgroundColor: Colors.blueAccent// color de fondo del boton
            ),
            child: Text('No', style: color),// texto que tendra el boton y su respectivo estilo
            onPressed: () => Navigator.of(context).pop() // accion que ejecutara el el boton. en este caso cerrar la alerta y regresar a la pagina. gracias al Navigator.of(context).pop() 
          ),
          Expanded(child: SizedBox(width: 10.0)),// espacio en blanco expandido que usara un espacio de10 pixeles a lo ancho
          TextButton(// boton con un texto
            style: TextButton.styleFrom(// estilo para el boton
              backgroundColor: Colors.red// color de fondo del boton
            ), 
            child: Text('Eliminar', style: color),// texto que tendra el boton y su respectivo estilo
            onPressed: () async {// accion que ejecutara el el boton.
              Navigator.of(context).pop();// cerrara la alerta y volvera a la pantalla
              Navigator.of(context).pop(); // regresara otra pantalla mas atras
              productoProvider.eliminarProducto(producto); // ejecutamos el metodo eliminarProducto
              productoBloc.cargarProducto(seccion.id); // ejecutamos el metodo cargarProducto
              final snack = utils.snackBar('Producto eliminado con exito'); // creamos una variable snack para utilizar un snackbar
              ScaffoldMessenger.of(context).showSnackBar(snack); //dibujamos el snackbar en pantalla
            }, 
          )
        ],
      );
              
    } else { // si el producto tiene stock distinto de 0 en alguna sucursal. hara lo siguiente.
        
      return AlertDialog(// regresa una alerta
        title: Text('No puede eliminar este producto porque aun cuenta con stock disponible en sucursales'), // titulo de la alerta
        actions: [// widgets que tendra la alerta
          TextButton(// boton con un texto
            style: TextButton.styleFrom(// estilo para el boton
              backgroundColor: Colors.blueAccent// color de fondo del boton
            ),
            child: Text('volver', style: color),// texto que tendra el boton y su respectivo estilo
            onPressed: () => Navigator.of(context).pop() // accion que ejecutara el boton. en este caso cerrar la alerta y regresar a la pagina. gracias al Navigator.of(context).pop() 
          ),
        ],
      );
    }
  }

  Widget _body(ProductoModel producto, Size tamano) {// metodo que dibujara el body

    return  Column( // retorno del metodo
      children: [ // lista de widgets(hijos)
        SizedBox(height: tamano.height * 0.03),//espacio imaginario entre un widget y otro, en este caso, espacio de 3% de alto
        Text('${producto.nombre}', style: TextStyle(fontSize: 18.0)),//Texto en pantalla con una fuente de 18 pixeles
        SizedBox(height: tamano.height * 0.03),//espacio imaginario entre un widget y otro, en este caso, espacio de 3% de alto
        img(producto), //metodo que dibujara la imagen del producto
        SizedBox(height: tamano.height * 0.03),//espacio imaginario entre un widget y otro, en este caso, espacio de 3% de alto
        Text('Stock en Sucursales', style: TextStyle(fontSize: 18.0)), // //Texto en pantalla con una fuente de 18 pixeles
        SizedBox(height: tamano.height * 0.03),//espacio imaginario entre un widget y otro, en este caso, espacio de 3% de alto
        _tabla(producto, tamano),///metodo que dibujara una tabla con informacion del producto
        SizedBox(height: tamano.height * 0.05),//espacio imaginario entre un widget y otro, en este caso, espacio de 3% de alto
        _boton(producto), // metodo que dibujara los botones
      ],
    );

  }

  Widget img(ProductoModel producto) { //metodo que dibujara la imagen en pantalla
    
  if(producto.fotoURL == null) { // condicion: si la propiedad FotoURL del producto es nula, hara lo siguiente
    return Container( // regresa un contenedor
      width: 200.0, //tendra un ancho de 200 pixeles
      height: 200.0,//tendra un alto de 200 pixeles
      color: Colors.black26, //definimos el color del contenedor
      child: Center(child: Icon(Icons.image)), //Definimos el hijo del contenedor que sera un icono en el centro de este
    );
  } else { // si la propiedad fotoURl no es nula, hara lo siguiente
    return Container( // regresa un contenedor
      width: 350.0, //tendra un ancho de 350 pixeles
      height: 250.0,//tendra un alto de 250 pixeles
      child: FadeInImage( // Widget que carga una imagen de internet (NetworkImage) y tiene la propiedad para cargar una imagen local (AssetImage) mientras se realiza la carga de internet
        placeholder: AssetImage('imagenes/jar-loading.gif'), //muestra el gif hasta que la imagen de internet esta cargada
        image: NetworkImage(producto.fotoURL), // carga la imagen de internet desde una url
        fit: BoxFit.cover, // propiedad que hace que la imagen ocupe solo el espacio disponible y no se salga de los margenes
      ),
    );
  }  

  }

  Widget _tabla(ProductoModel producto, Size tamano) {// metodo que creara una tabla para ordenar el stock

    final decoracion = InputDecoration( // creamos una variable que tendra una propiedad de bordes un poco mas oscuros
      border: const OutlineInputBorder()
    );

    return Form( //return del metodo. Un formulario
      key: keyformulario, // especificamos la llave que tendra el formulario. esta llave se usa despues para validar el estado del formulario
      child: Table( //Widget que crea una tabla
        children: [ //propiedad del Widget Table
          TableRow( // primera fila de la tabla 
            children: [ //hijos de la primera fila
              _sucursal('2AN1: Arrendadora'), //primer elemento de la fila. un metodo que dibujara un String
              Container( // segundo elemento de la fila
                margin: EdgeInsets.only(right: 12.0, bottom: 10.0), //Margen que se le dara al contenedor a la derecha y arriba
                child: TextFormField( // el hijo del widget Container sera un TextFromField que tiene las propiedades de un input para escribir en el
                  keyboardType: TextInputType.number, //activa el teclado numero en el telefono
                  initialValue: producto.stockA.toString(), //cargas el stock del producto convertido de un entero a un String 
                  decoration: decoracion, //decoracion que se le da al input 
                  validator: (value) {//validacion del input
                    if(value.length <= 0) { //si no se a tipeado nada mandara el siguiente error 
                      return 'Debe especificar la cantidad'; //ERROR: aparecera debajo del input con color rojo
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) => producto.stockA = int.parse(value), //guardamos la cantidad especifica en el producto.StockA
                ),
              ),
            ]
          ),
          TableRow(// segunda fila de la tabla 
            children: [//hijos de la segunda fila
              _sucursal('2AN2: Servicio Liviano'),//primero elemento de la segunda fila. un metodo que dibujara un String
              Container(// segundo elemento de la segunda fila
                margin: EdgeInsets.only(right: 12.0, bottom: 10.0),//Margen que se le dara al contenedor a la derecha y arriba
                child: TextFormField(// el hijo del widget Container sera un TextFromField que tiene las propiedades de un input para escribir en el
                  keyboardType: TextInputType.number,//activa el teclado numero en el telefono
                  initialValue: producto.stockB.toString(),//cargas el stock del producto convertido de un entero a un String 
                  decoration: decoracion, //decoracion que se le da al input 
                  validator: (value) {//validacion del input
                    if(value.length <= 0) { //si no se a tipeado nada mandara el siguiente error 
                      return 'Debe especificar la cantidad';//ERROR: aparecera debajo del input con color rojo
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) => producto.stockB = int.parse(value),//guardamos la cantidad especifica en el producto.StockB
                ),
              ),
            ]
          ),
          TableRow(// tercera fila de la tabla 
            children: [//hijos de la tercera fila
              _sucursal('2AN3 Servicio Pesado'),//primero elemento de la tercera fila. un metodo que dibujara un String
              Container(// segundo elemento de la tercera fila
                margin: EdgeInsets.only(right: 12.0, bottom: 10.0),//Margen que se le dara al contenedor a la derecha y arriba
                child: TextFormField(// el hijo del widget Container sera un TextFromField que tiene las propiedades de un input para escribir en el
                  keyboardType: TextInputType.number,//activa el teclado numero en el telefono
                  initialValue: producto.stockC.toString(),//cargas el stock del producto convertido de un entero a un String 
                  decoration: decoracion,//decoracion que se le da al input
                  validator: (value) {//validacion del input
                    if(value.length <= 0) {//si no se a tipeado nada mandara el siguiente error 
                      return 'Debe especificar la cantidad';//ERROR: aparecera debajo del input con color rojo
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) => producto.stockC = int.parse(value),//guardamos la cantidad especifica en el producto.StockC
                ),
              ),
            ]
          )
        ],
      ),
    );

  }

  Widget _sucursal(String sucursal) { //metodo que dibujara el nombre de la sucursal

    return Container( //retorno del metodo
      decoration: BoxDecoration( // decoracion especial para el contenedor
        borderRadius: BorderRadiusDirectional.circular(20.0)// le damos una curvatura a las puntas
      ),
      margin: EdgeInsets.all(20.0), // margen de 20 pixeles a todos sus lados
      child: Text(sucursal, style: TextStyle(fontSize: 16.0)), // Texto en pantalla
    );

  }

  Widget _boton(ProductoModel producto) { // metodo que dibujara el boton

    return TextButton(// retorno del metodo. un boton con texto en el centro
      style: TextButton.styleFrom( // estilo al boton
        backgroundColor: Colors.blue, // Color del fondo del boton
        padding: EdgeInsets.symmetric(horizontal: 20.0) // Margenes al boton.
      ),
      child: Text('Guardar cambios', style: TextStyle(color: Colors.white)), // texto que tendra el boton
      onPressed: () { // acciones que ejecutara el boton al ser presionado

        if(!keyformulario.currentState.validate()) return; // verifica si el formulario esta validado

        keyformulario.currentState.save();// guarda el formulario en caso que pase todas las validaciones puestas.
        productoProvider.modificarProducto(producto);//ejecutamos el metodo de modifcarProducto

            final snack = utils.snackBar('Producto modificado con exito'); // creamos una variable llamada "snack" que tomara el valor del metodo "snackBar" creado en el archivo utils
            ScaffoldMessenger.of(context).showSnackBar(snack); // desplegamos el snackbar en pantalla
      }, 
    );
  }

}