import 'dart:async';

import 'package:flutter/material.dart';
//Producto
import 'package:vision_one/bloc/producto_bloc.dart';
import 'package:vision_one/modelo/producto_model.dart';
import 'package:vision_one/provider/producto_provider.dart';
//Seccion
import 'package:vision_one/bloc/seccion_bloc.dart';
import 'package:vision_one/modelo/seccion_model.dart';
import 'package:vision_one/provider/seccion_provider.dart';
//Usuario
import 'package:vision_one/modelo/usuario_model.dart';

import 'package:vision_one/utils/utils.dart' as utils;

class ProductosPage extends StatefulWidget {
  @override
  _ProductosPageState createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {

  ProductoBloc productoBloc = new ProductoBloc();// creamos una instancia de la clase ProductoBloc
  ProductoModel productoModel = new ProductoModel();// creamos una instancia de la clase ProductoModel
  ProductoProvider productoProvider = new ProductoProvider();// creamos una instancia de la clase ProductoProvider

  SeccionBloc seccionBloc = new SeccionBloc();// creamos una instancia de la clase SeccionBloc
  SeccionModel seccionModel = new SeccionModel();// creamos una instancia de la clase SeccionModel
  SeccionProvider seccionProvider = new SeccionProvider();// creamos una instancia de la clase SeccionProvider

  @override
  Widget build(BuildContext context) {//el metodo build es el encargado de dibujar los widgets en la pantalla, por eso debe regresar un widget a fuerza
  //el context contiene la informacion del arbol de widget.

    final tamano = MediaQuery.of(context).size; // definimos una variable "tamano" que sirve para controlar el espacio que usan los widget en pantalla
    final List info = ModalRoute.of(context).settings.arguments;// llegamos a esta pantalla mandando una lista con dos parametros y los recibimos de la siguiente manera
    final SeccionModel seccion = info[0]; // aqui obtenemos el primer paramtro
    final String rol = info[1]; // aqui obtenemos el segundo parametro
    final UsuarioModel usuario = info[2];// aqui obtenemos el tercer parametro
    productoBloc.cargarProducto(seccion.id); // ejecutamos el metodo cargarProducto

    bool condicion; // creamos una variable bool

    if(rol == 'ADMIN' || rol == 'BODEGUERO') { // creamos una condicion para evaluar el rol que se a traido de otra pantalla
      condicion = true; 
    } else {
      condicion = false;
    }

    return Scaffold(// scaffold es el lienzo principal donde se dibujan los Widgets
      appBar: AppBar( // es un menu superior que podemos ver en la pantalla. en el se define el titulo y otros botones que nos daran otras funcionalidades
        centerTitle: true,// centramos el titulo
        title: Text('${seccion.nombre}'),// Especificamos el titulo que tendra esta pantalla
        actions: [botonEliminar(condicion, seccion)]// widgets que se agrupan a la esquina superior derecha del appbar. en este caso dispara un metodo con el widget
      ),
      body: _body(tamano, seccion, condicion, usuario), //metodo que servira para dibujar el body
      floatingActionButton: _agregarProd(condicion, seccion) // metodo que servira para dibujar el boton flotante
    );
  }

  Widget _agregarProd(bool condicion, SeccionModel seccion) { //metodo para crear el boton

    if(condicion == true) { // si la condicion es true hara lo siguiente
      return FloatingActionButton( // dibuja el boton flotante
        onPressed: () => Navigator.pushNamed(context, 'crearProd',  arguments: seccion), // al presionar el boton, navegamos a la pantalla con string asignado llamado "crearProd" y le mandamos como parametro la seccion
        child: Icon(Icons.add), // Icono que tendra el boton
      );
    } else {
      return null;
    }

  }

  Widget _body(Size tamano, SeccionModel seccion, bool condicion, UsuarioModel usuario) { // metodo para crear el body

    return StreamBuilder(// return del metodo. Un streamBuilder sirve para ir cargando datos a medida que se van añadiendo. el sistema nota los cambios y los carga
      stream: productoBloc.productoStream,// aqui se selecciona el "rio" (stream) que hara fluir su informacion por aqui
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {// el builder es el encargado de dibujar lo que deseamos. recibe dos variables, el context y una que por defecto se llama "snapshot" y tendra toda la informacion del stream

        if(snapshot.hasData) {// "si el snapshot tiene informacion"... hara lo siguiente.

          final producto = snapshot.data;// guardamos la "Data" (informacion) en la variable producto

          if(producto.length == 0) { // cuenta la cantidad de productos que hay. si son cero manda el mensaje
            return Center(child: Text('No se encontro informacion'));
          }

          return RefreshIndicator( // retorno del builder. un RefreshIndicator da la opcion de hacer scroll hacia abajo en la pantalla y refrescarla.
            onRefresh: _refrescar,//metodo que ejecuta el "refresco" de pantalla
            child: ListView.builder(// Widget que se dibujara en la pantalla y que tendra la opcion de ser refrescado
              itemCount: producto.length, // cuenta la cantidad de productos cargados
              itemBuilder: (BuildContext context, int i) // propiedad que debe estar para dibujar los widget que queremos dentro del "ListView.Builder" 
              => _producto(context ,producto[i], seccion, condicion, usuario),// metodo que crea los elementos del ListView.builder
            )
          );
          
        }  {
          return Center(child: Text('No se encontro informacion'));// si snapshot no tiene data envia el el mensaje definido
        } 

      }
    );

  }

  Widget _producto(BuildContext context, ProductoModel producto, SeccionModel seccion, bool condicion, UsuarioModel usuario) { //metodo para crear la vista de productos

    final estilo = TextStyle(color: Colors.black, fontSize: 17.0); //creamos una variable que tendra propiedades del TextStyle

    return Card(// retorno del metodo, dibujara una carta
      child: Column(// dentro de la carta, se almaceran los datos como columna
        children: [ // propiedad del widget Column
          ListTile(// primer hijo. otro tipo de lista
            onTap: () { //acciones que se realizaran al presionar un elemento de la lista
            if(condicion == true) { // si la condicion es true
            Navigator.pushNamed(context, 'prodDetalle', arguments: [producto, seccion, usuario]); //podremos navegar a una nueva pantalla "prodDetalle" y enviamos los parametros definidos
            } else {
              return null; // si la condicion es false no hacemos nada al presionar un elemento de la lista
            }
            },
            title: Center(child: Text('${producto.nombre}', style: estilo)),// el titulo del ListTile sera el nombre de cada producto
            subtitle: Column( //subtitulo del ListTile
              children: [
              SizedBox(height: 15.0), //espacio imaginario entre un widget y otro, en este caso, espacio de 15 pixeles de alto
              img(producto),// metodo que dibujara la imagen del producto
              SizedBox(height: 15.0),//espacio imaginario entre un widget y otro, en este caso, espacio de 15 pixeles de alto
              Text('2AN1.Arrendadora: ${producto.arrendador}', style: estilo),//texto en pantalla con su estilo
              SizedBox(height: 5.0),//espacio imaginario entre un widget y otro, en este caso, espacio de 5 pixeles de alto
              Text('2AN2.Servicio Liviano: ${producto.servicioliviano}',style: estilo),//texto en pantalla con su estilo
              SizedBox(height: 5.0),//espacio imaginario entre un widget y otro, en este caso, espacio de 5 pixeles de alto
              Text('2AN3.Servicio Pesado: ${producto.serviciopesado}',style: estilo),//texto en pantalla con su estilo
              SizedBox(height: 10.0),//espacio imaginario entre un widget y otro, en este caso, espacio de 10 pixeles de alto
              Text('N° Parte: ${producto.nParte}',style: TextStyle(color: Colors.red, fontSize: 15.0)),//texto con el numero de parte del producto
              SizedBox(height: 15.0),//espacio imaginario entre un widget y otro, en este caso, espacio de 15 pixeles de alto
              ]
            )
          ),
        ],
      ),
    );

  }

  Widget img(ProductoModel producto) { //metodo que definira la imagen del producto
    
  if(producto.fotoURL == null) { // condicion: si la propiedad FotoURL del producto es nula, hara lo siguiente
    return Container( // regresa un contenedor
      width: 200.0, //tendra un ancho de 200 pixeles
      height: 200.0,//tendra un alto de 200 pixeles
      color: Colors.black26,//definimos el color del contenedor
      child: Center(child: Icon(Icons.image)),//Definimos el hijo del contenedor que sera un icono en el centro de este
    );
  } else {// si la propiedad fotoURl no es nula, hara lo siguiente
    return Container(// regresa un contenedor
      width: 350.0,//tendra un ancho de 350 pixeles
      height: 250.0,//tendra un alto de 250 pixeles
      child: FadeInImage(// Widget que carga una imagen de internet (NetworkImage) y tiene la propiedad para cargar una imagen local (AssetImage) mientras se realiza la carga de internet
        placeholder: AssetImage('imagenes/jar-loading.gif'), //muestra el gif hasta que la imagen de internet esta cargada
        image: NetworkImage(producto.fotoURL),// carga la imagen de internet desde una url
        fit: BoxFit.scaleDown,// propiedad que hace que la imagen ocupe solo el espacio disponible y no se salga de los margenes
      ),
    );
  }  

  }

  Future _refrescar() async {// metodo para refrescar la pantalla
  
    Duration carga = new Duration(seconds: 2);// variable llamada "carga" que tendra una propiedad de 2 segundos de demora para cargar
    new Timer(carga, () {// nuevo widget para definir el tiempo de carga.
      build(context); // disparamos el metodo build del archivo actual.
    });
    return Future.delayed(carga); // regresa en un futuro determinado (2 seg) el resultado.
  }

  Widget botonEliminar(bool condicion, SeccionModel seccion) { //metodo que definira el boton eliminar

    if(condicion == true) { 
      return IconButton(//regresa un boton como icono
        icon: Icon(Icons.delete_forever),//Icono que sera el boton
        color: Colors.white, //Color del icono
        iconSize: 30.0, //tamaño del icono
        onPressed: () => _eliminar(seccion) // se dispara este metodo al presionar el icono
      );
    } else {
      return Container(); // si la condicion es false regresa un contenedor vacio
    }

  }

  void _eliminar(SeccionModel seccion) { // metodo para eliminar la seccion

    final color = TextStyle(color: Colors.white);//creamos una variable de tipo color que tendra propiedades del TextStyle

    showDialog( // metodo que prepara la pantalla para disparar una alerta
      context: context,//tiene el contexto de lo necesario para disparar dicha alerta
      barrierDismissible: false, // al ser false decimos que la alerta no puede cerrarse si presionamos fuera de ella.
      builder: (context) {// el metodo builder contiene en su interior todo lo que se mostrara al presionar el boton. en este caso dispara un metodo

        return StreamBuilder( // return del metodo. Un streamBuilder sirve para ir cargando datos a medida que se van añadiendo. el sistema nota los cambios y los carga
          stream: productoBloc.productoStream,// aqui se selecciona el "rio" (stream) que hara fluir su informacion por aqui
          builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {// el builder es el encargado de dibujar lo que deseamos. recibe dos variables, el context y una que por defecto se llama "snapshot" y tendra toda la informacion del stream

            if (snapshot.hasData) {// "si el snapshot tiene informacion"... hara lo siguiente.
              final producto = snapshot.data; // guardamos la "Data" (informacion) en la variable producto

              if(producto.length == 0) { // si producto no contiene elementos.(osea que la cuenta es 0) dispara el metodo
                return _sielimina(color, seccion);
              } else {
                return _noelimina(color);  //si "producto" tiene 1 elemento o mas dispra este metodo
              }

            } else {
              return Container();
            }

          }
        );

      }
    );    

  }

  Widget _sielimina(TextStyle color, SeccionModel seccion) { //metodo que da la opcion de eliminar

    return AlertDialog(// regresa una alerta
      title: Text('¿Esta seguro que desea eliminar esta seccion?'),// titulo de la alerta
      actions: [// widgets que tendra la alerta
        TextButton(// boton con un texto
          style: TextButton.styleFrom(// estilo para el boton
            backgroundColor: Colors.blueAccent// color de fondo del boton
          ),
          child: Text('No', style: color),// texto que tendra el boton y su respectivo estilo
          onPressed: () => Navigator.of(context).pop()// accion que ejecutara el el boton. en este caso cerrar la alerta y regresar a la pagina. gracias al Navigator.of(context).pop()
        ),
        Expanded(child: SizedBox(width: 10.0)),// espacio en blanco expandido que usara un espacio de 10 pixeles a lo ancho
        TextButton(//boton con un texto.
          style: TextButton.styleFrom(// estilo que se le dara al boton
            backgroundColor: Colors.red// el boton tendra color de fondo rojo
          ), 
          child: Text('Eliminar', style: color),// texto que tendra el boton y estilo definido anteriormente.
          onPressed: () async {// metodo que ejecuta el boton al presionarlo
            Navigator.of(context).pop();// regresa una pantalla
            Navigator.of(context).pop();// regresa una pantalla
                
            seccionProvider.eliminarSeccion(seccion); //ejecutamos el metodo elimianrSeccion
            seccionBloc.cargarSeccion(); //ejeceutamos el metodo cargarSeccion

            final snack = utils.snackBar('Seccion eliminada con exito');// creamos una intancia de un snackbar 
            ScaffoldMessenger.of(context).showSnackBar(snack); //dibujamos el snackbar en pantalla
              
          }, 
        )
      ],
    );
    

  }

  Widget _noelimina(TextStyle color) { //metodo que manda la alerta que no se puede eliminar

    return AlertDialog( // regresa una alerta
      title: Text('No puede eliminar esta seccion porque hay productos asociados a ella'),// titulo de la alerta
      actions: [// widgets que tendra la alerta
        TextButton(// boton con un texto
          style: TextButton.styleFrom(// estilo para el boton
            backgroundColor: Colors.blueAccent// color de fondo del boton
          ),
          child: Text('volver', style: color),// texto que tendra el boton y su respectivo estilo
          onPressed: () => Navigator.of(context).pop() // accion que ejecutara el el boton. en este caso cerrar la alerta y regresar a la pagina. gracias al Navigator.of(context).pop()
        ),
      ],
    );
  }
  
}