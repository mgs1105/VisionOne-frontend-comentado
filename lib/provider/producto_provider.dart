import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart'; // importamos el paquete de mime_type en pubspec.yaml
import 'package:http_parser/http_parser.dart';

//Model
import 'package:vision_one/modelo/producto_model.dart';


class ProductoProvider{

  //definimos parte de la url donde se haran las consultas
  final String _dominio = 'http://192.168.1.86:5000';
  //creamos una instancia del modelo del producto
  final producto = new ProductoModel();

  //Creamos un metodo de tipo Future que debe regresar una lista de productos. el metodo se llama "cargarProducto".
  
  //******************************************  EXPLICACION DEL FUTURE   ************************************************* */ 
  //los metodos de tipo Future son de un tipo que entregaran su informacion en un futuro determinado.
  //Se usan mucho en peticiones http donde la consulta no es inmediata, sino que toma unos segundos.
  //Para que el programa no se detenga ni cause algun error esperando la respuesta que queremos. Por eso se usan los Future
  //que deben ir acompañados siempre de un "async". esto define al metodo como "asincrono".
  
  //el metodo a su vez debe recibir el ID de la seccion para poder cargar solo los productos asociados a esa seccion.
  //la variable "idseccion" se usa mas adelante.

  Future<List<ProductoModel>> cargarProducto(int idseccion) async {    
    final url = '$_dominio/producto';  //creamos una variable que tendra todo el url donde hacer la peticion
    //creamos una variable que ESPERARA(await) la respuesta de la peticion. En la funcion get debemos mandar un Uri (Uniform Resource Locator)
    //(Localizador de recursos uniforme). la variable "url" al no ser un Uri debemos "parsearlo" usando el ".parse". 
    // parsear: Proceso de analizar una secuencia de símbolos a fin de determinar su estructura gramatical definida
    final resp = await http.get(Uri.parse(url));
    //creamos una variable que tendra la informacion de la peticion. esta informacion sera en un formato json
    final decodeData = json.decode(resp.body);
    final List<ProductoModel> lista = [];    //una variable de tipo lista de productos.
    if(decodeData == null) return null;  //condicion: si lo recibido del json (decodeData) es nulla, el metodo regresa nulo. si tiene informacion continua con el code
    //recorremos toda la informacion del "decodeData" y cada producto es almacenado en la variable "value".
    decodeData.forEach((value) {
    
      final producto = ProductoModel.fromJson(value);//creamos una variable que tendra toda la informacion de cada producto encontrado.
      if(idseccion == producto.idseccion) //condicion: si el idseccion que se recibio en el metodo es igual al idseccion que tiene el producto
      lista.add(producto);  //si son el mismo id, añade el producto a la lista creada.

    });
    return lista;  //regresa la lista con toda la informacion.
  }

  void crearProducto(ProductoModel producto) async {  //Creamos un metodo void.El metodo recibe un producto para su creacion
    //creamos una variable que tendra todo el url donde hacer la peticion
    final url = '$_dominio/producto';
    //para crear el producto debemos mandar mas contenido en la peticion.
    //en este caso creamos un Map que contiene dos datos utilles para leer la informacion y pasarla a un formato json.
    Map<String, String> header = {"content-type": "application/json"};
    //creamos una variable que esperara la repuesta del POST, en este caso aparte del parsear la url, mandamos el header, y el body. de aqui se obtiene la informacion
    //para crear el producto y guardarlo en la base de datos.
    await http.post(Uri.parse(url), headers: header, body: productoModelToJson(producto));
  }

  void modificarProducto(ProductoModel producto) async {  //creamos un metodo de tipo Future para modificar el producto
    //recibimos el Id del producto para poder espeficiar que producto queremos modificar
    final id = producto.id;
    //creamos una variable que tendra todo el url donde realizar la peticion
    final url ='$_dominio/producto/$id';
    Map<String, String> header = {"content-type": "application/json"};
    //creamos una variable que esperara la repuesta del PUT, en este caso aparte del parsear la url, mandamos el header, y el body. de aqui se obtiene la informacion
    //para modificar el producto y guardarlo en la base de datos.
    await http.put(Uri.parse(url), headers: header, body: productoModelToJson(producto));

  }

  void eliminarProducto(ProductoModel producto) async {//creamos un metodo void. el metodo recibe un producto para la eliminacion
    //recibimos el Id del producto para poder espeficiar que producto queremos eliminar
    final id = producto.id;
    //creamos una variable que tendra todo el url donde realizar la peticion    
    final url = '$_dominio/producto/$id';
    // esperamos a que se ejecute el delete. esta peticion debe recbir un Uri, entonces parseamos el url.
    await http.delete(Uri.parse(url));

  }

  Future<String> subirImgen(File imagen) async { //creamos un metodo encargado de procesar y subir el url donde se guarda la imagen a la base de datos
    // debemos recibir el arcihvo File de la imagen como tal
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dposvsgu8/image/upload?upload_preset=sywzbrqu');//parseamos el string de conexion a un servicios de terceros para guardar todas las imagenes
    final mimeType = mime(imagen.path).split('/'); //debemos conocer el mimType de la imagen, es decir, si es un jpg, png, gif, etc.
    //para eso separamos el string en una lista, asi su primera pocision sea la imagen y la segunda posicion el tipo de imagen (jpg, png, gif),
    // de esta manera es mas facil de procesarlo

    final cargarImagen = http.MultipartRequest( //Creamos el request para poder adjuntar la imagen. 
      'POST', //Mandamos el tipo de peticion
      url //mandamos el url hacia donde hacemos la peticion
    );

    final file = await http.MultipartFile.fromPath( //preparamos el archivo para adjuntarlo al "cargarImagen"
      'file', // es el key que nombramos como variable en donde se guardara la imagen
      imagen.path, //el path de la imagen
      contentType: MediaType(mimeType[0], mimeType[1]) //aqui especficiamos el mimetype y obtenemos el string de la imagen junto al tipo de la imagen
    );

    cargarImagen.files.add(file); //adjuntamos la variable "cargarImagen" con el archivo de la foto(file)

    final streamResponse = await cargarImagen.send(); // se dispara la peticion y obtenemos la respuesta en el "streamResponse"
    final resp = await http.Response.fromStream(streamResponse); // la "resp" ya es la respuesta tradicional como se ha ido trabajando    

    if(resp.statusCode != 200 && resp.statusCode != 201) { // si el statusCode responde distinto a 200 o 201 (que quiere decir que la respuesta es correcta) mandara un mensaje de error
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body); // pasamos a un json toda la respuesta
    print(respData);
    return respData['secure_url']; //obtenemos la variable que tiene todo el string donde se guardo la imagen

  }

  Future<List<ProductoModel>> buscarProducto(String query) async {  //creamos un metodo que recibir un query (texto) para buscar productos

    final url = '$_dominio/producto/$query'; // especificamos la url donde se haran la consultas
    final resp = await http.get(Uri.parse(url)); // realizamos la peticion get y almacenamos la respuesta en la variable "resp"
    final decodeData = json.decode(resp.body); //pasamos a un json toda la respuesta

    final List<ProductoModel> lista = []; // creamos una lista vacia

    if(decodeData == null) return null; //si la el json es nulo, regresa nulo el metodo.

    decodeData.forEach((value) { // recorremos todo el decodeData con el forEach y cada producto sera almacenado en la variable value
      
      final producto = ProductoModel.fromJson(value); //guaradmos un Map del producto en la variable "producto"

      lista.add(producto); // añadimos el producto a la lista vacia creada anteriormente

    });

    return lista; /// regresamos la lista con los productos.

  }

  Future<List<ProductoModel>> stockCritico(String bodega) async { // metodo para definir el stock critico de los productos
  //recibe un string "bodega". este String hace referencia a la bodega que el usuario con rol BODEGUERO administra.

    final url = '$_dominio/producto';//creamos una variable que tendra todo el url donde hacer la peticion
    final resp = await http.get(Uri.parse(url));  //creamos una variable que ESPERARA(await) la respuesta de la peticion. En la funcion get debemos mandar un Uri (Uniform Resource Locator)
    //(Localizador de recursos uniforme). la variable "url" al no ser un Uri debemos "parsearlo" usando el ".parse". 
    // parsear: Proceso de analizar una secuencia de símbolos a fin de determinar su estructura gramatical definida
    final data = json.decode(resp.body);//creamos una variable que tendra la informacion de la peticion. esta informacion sera en un formato json

    final List<ProductoModel> lista = [];//una variable de tipo lista de productos.

    if(data == null) return [];//condicion: si lo recibido del json (data) es nulla, el metodo regresa una lista vacia. si tiene informacion continua con el code

    data.forEach((value) {//recorremos toda la informacion del "data" y cada producto es almacenado en la variable "value".
      
      if(bodega == null) { //si no se recibe nada, quiere decir el rol del usuario es "ADMIN", por ende, puede ver todos los productos de todas las bodegas.

      final producto = ProductoModel.jsonBodegaA(value);//creamos una variable que tendra una parte de la informacion encontrada del poducto.
      final productoB = ProductoModel.jsonBodegaB(value);//creamos una variable que tendra una parte de la informacion encontrada del poducto.
      final productoC = ProductoModel.jsonBodegaC(value);//creamos una variable que tendra una parte de la informacion encontrada del poducto.

      producto.diferencia = producto.arrendador - producto.stockCritico; //le damos valor al atributo "diferencia" del objeto credado, llamado "producto"
      productoB.diferencia = productoB.servicioliviano - productoB.stockCritico;//le damos valor al atributo "diferencia" del objeto credado, llamado "productoB"
      productoC.diferencia = productoC.serviciopesado - productoC.stockCritico;//le damos valor al atributo "diferencia" del objeto credado, llamadao "productoC"

      lista.add(producto); // añadimos a la lista el objeto "producto"
      lista.add(productoB);// añadimos a la lista el objeto "productoB"    
      lista.add(productoC);// añadimos a la lista el objeto "productoC"
      } else { // si el String "bodega" es distinto que null, quiere decir que el rol es "BODEGUERO" y que solo necesita la informacion de los productos de su bodega

        if(bodega == "Arrendador") { // si el string recibido es "Arrendador"
          final producto = ProductoModel.jsonBodegaA(value); // creamos una variable llamada "producto" y le guardamos la respuesta del metodo "jsonBodegaA".
          producto.diferencia = producto.arrendador - producto.stockCritico;//le damos valor al atributo "diferencia" del objeto credado, llamado "producto"
          lista.add(producto); //añadimos el objeto producto a la lista
        }

        if(bodega == "ServicioLiviano") {// si el string recibido es "ServicioLiviano"
          final producto = ProductoModel.jsonBodegaB(value); // creamos una variable llamada "producto" y le guardamos la respuesta del metodo "jsonBodegaB".
          producto.diferencia = producto.servicioliviano - producto.stockCritico;//le damos valor al atributo "diferencia" del objeto credado, llamado "producto"
          lista.add(producto);//añadimos el objeto producto a la lista        
        }

        if(bodega == "ServicioPesado") {// si el string recibido es "ServicioPesado"
          final producto = ProductoModel.jsonBodegaC(value); // creamos una variable llamada "producto" y le guardamos la respuesta del metodo "jsonBodegaC".
          producto.diferencia = producto.serviciopesado - producto.stockCritico;//le damos valor al atributo "diferencia" del objeto credado, llamado "producto"
          lista.add(producto);//añadimos el objeto producto a la lista         
        }            
      }

    });

    lista.sort((a,b){ // ejecutamos el metodo "sort" a la lista para ordenarla de una forma especial
      return a.diferencia - b.diferencia; //el metodo sort captura la variable "diferencia" de cada producto de la lista, y ordena los objetos desde el el producto que tenga la "diferencia" menor a la mayor.
    });

    return lista;//regresa la lista ordenada
  }
}

