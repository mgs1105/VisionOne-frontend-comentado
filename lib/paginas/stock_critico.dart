import 'package:flutter/material.dart';
import 'package:vision_one/bloc/producto_bloc.dart';
import 'package:vision_one/modelo/producto_model.dart';
import 'package:vision_one/modelo/usuario_model.dart';
import 'package:vision_one/provider/producto_provider.dart';
import 'package:vision_one/provider/seccion_provider.dart';

class StockCriticoPage extends StatefulWidget {

  @override
  _StockCriticoPageState createState() => _StockCriticoPageState();
}

class _StockCriticoPageState extends State<StockCriticoPage> {

  ProductoModel productoModel = new ProductoModel();//creamos una instancia de la clase ProductoModel
  ProductoBloc productoBloc = new ProductoBloc();// creamos una instancia de la clase ProductoBloc
  ProductoProvider productoProvider = new ProductoProvider();//creamos una instancia de la clase ProductoProvider

  SeccionProvider seccion = new SeccionProvider();//creamos una instancia de la clase SeccionProvider

  @override
  Widget build(BuildContext context) {
    
    final UsuarioModel usuario = ModalRoute.of(context).settings.arguments;// llegamos a esta pantalla mandando un objeto de tipo UsuarioModel, asi lo recibimos
    productoBloc.stockCritico(usuario.bodega);//ejecutamos el metodo "stockCritico" enviando un String

    return Scaffold(// scaffold es el lienzo principal donde se dibujan los Widgets
      appBar: AppBar( //es un menu superior que podemos ver en la pantalla. en el se define el titulo y otros botones que nos daran otras funcionalidades
        centerTitle: true,//centramos el titulo
        title: Text('Stock Critico'),//Especificamos el titulo que tendra esta pantalla
      ),
      body: _listaProductos(usuario.bodega),//metodo que tendra creara el cuerpo de la pagina
    );
  }

  Widget _listaProductos(String usuarioBodega) {//metodo para crear la lista, recibe el un String.

    return StreamBuilder(// return del metodo. Un streamBuilder sirve para ir cargando datos a medida que se van añadiendo. el sistema nota los cambios y los carga
      stream: productoBloc.stockCriticoStream,// aqui se selecciona el "rio" (stream) que hara fluir su informacion por aqui
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {// el builder es el encargado de dibujar lo que deseamos. recibe dos variables, el context y una que por defecto se llama "snapshot" y tendra toda la informacion del stream

        if(snapshot.hasData) {// "si el snapshot tiene informacion"... hara lo siguiente.
          final productos = snapshot.data;// guardamos la "Data" (informacion) en la variable productos

          return ListView.builder(// Widget que dibuja una lista
            itemCount: productos.length,// cuenta la cantidad de productos cargados
            itemBuilder: (BuildContext context, int i)// propiedad que debe estar para dibujar los widget que queremos dentro del "ListView.Builder"
            =>_productos(context, productos[i]) // metodo que crea los elementos del ListView.builder
          );

        } else {
          return Center(child: Text('No se encontro informacion')); // si snapshot no tiene data envia el el mensaje definido
        }        
        }

      
    );

  }

  Widget _productos(BuildContext context, ProductoModel producto) { //metodo que dibuja cada elemento del ListView. recibe el context y la informacion del producto

    final estilo = TextStyle(color: Colors.black, fontSize: 15.0);//creamos una variable que tendra opciones guardados de tipo TextStyle
    int stock; //creamos una variable int llamada "stock"
    String bodega;//creamos una variable String llamada "bodega"

    if(producto.arrendador != null) { //si el atributo "arrendador" de la clase producto es distinto que null (es decir, si tiene informacion)...
      stock = producto.arrendador; //guardamos el valor del atributo "arrendador" en la variable creada llamada "stock"
      bodega = "Arrendador";//le asignamos un valor a la variable creada llamada "bodega"
    }
    if(producto.servicioliviano != null) {//si el atributo "servicioliviano" de la clase producto es distinto que null (es decir, si tiene informacion)...
      stock = producto.servicioliviano;//guardamos el valor del atributo "servicioliviano" en la variable creada llamada "stock"
      bodega = "Servicio Liviano";//le asignamos un valor a la variable creada llamada "bodega"
    } 

    if(producto.serviciopesado != null) {//si el atributo "serviciopesado" de la clase producto es distinto que null (es decir, si tiene informacion)...
      stock = producto.serviciopesado;//guardamos el valor del atributo "serviciopesado" en la variable creada llamada "stock"
      bodega = "Servicio Pesado";//le asignamos un valor a la variable creada llamada "bodega"
    }
    return Card( //el metodo regresa un widget de tipo card
      elevation: 10.0, // le damos un sobreado a la carta por los bordes
      child: ListTile( //Hijo que se creara dentro de la carta
        title: Row( //el titulo sera un widget de tipo fila
          mainAxisAlignment: MainAxisAlignment.spaceAround,//alinea el contenido de la fila con espacios uniforme entre ellos
          children: [ //hijos de la fila
            Text('${producto.nombre}', style: estilo), //Texto con el nombre del producto
          ],
        ),
        subtitle: Column( //subtitulo del widget ListTile, una columna para ordenar los widget verticalmente
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, //espacios entre los widget de una determinada forma
          children: [ //hijos
            SizedBox(height: 10.0),//espacio imaginario entre un widget y otro, en este caso, espacio de 10 pixeles de alto
            Text('N° de parte: ${producto.nParte}', style: TextStyle(color: Colors.red, fontSize: 15.0)),//Texto con el numero de parte del producto
            SizedBox(height: 10.0),//espacio imaginario entre un widget y otro, en este caso, espacio de 10 pixeles de alto
            Text('Bodega: $bodega', style: estilo),//Texto con el nombre de la bodega del producto
            SizedBox(height: 10.0),//espacio imaginario entre un widget y otro, en este caso, espacio de 10 pixeles de alto
            Text('Stock actual: $stock', style: estilo),//Texto con el stock actual del producto en una bodega en especifico
            SizedBox(height: 10.0),//espacio imaginario entre un widget y otro, en este caso, espacio de 10 pixeles de alto
            Text('Stock critico: ${producto.stockCritico}', style: estilo),//Texto con el numero del stock critico del producto
            SizedBox(height: 20.0),//espacio imaginario entre un widget y otro, en este caso, espacio de 20 pixeles de alto
          ],
        ),
      ),
    );


  }


}