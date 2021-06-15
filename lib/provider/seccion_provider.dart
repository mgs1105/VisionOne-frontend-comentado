import 'dart:convert';
//importamos el paquete http. Este paquete primero debe ser importado en el archivo "pubspec.yaml"
import 'package:http/http.dart' as http;

//Model
import 'package:vision_one/modelo/seccion_model.dart';

class SeccionProvider {
  //definimos parte de la url donde se haran las consultas
  final String _dominio = 'http://192.168.1.86:5000';
  //creamos una instancia del modelo del producto  
  final seccionModel = new SeccionModel();

  //Creamos un metodo de tipo Future que debe regresar una lista de secciones. el metodo se llama "cargarSeccion".
 
  //******************************************  EXPLICACION DEL FUTURE   ************************************************* */
  //los metodos de tipo Future son de un tipo que entregaran su informacion en un futuro determinado.
  //Se usan mucho en peticiones http donde la consulta no es inmediata, sino que toma unos segundos.
  //Para que el programa no se detenga ni cause algun error esperando la respuesta que queremos. Por eso se usan los Future
  //que deben ir acompañados siempre de un "async". esto define al metodo como "asincrono".
  Future<List<SeccionModel>> cargarSeccion() async {    
    //creamos una variable que tendra todo el url donde hacer la peticion    
    final url = '$_dominio/seccion';
    //creamos una variable que ESPERARA(await) la respuesta de la peticion. En la funcion get debemos mandar un Uri (Uniform Resource Locator)
    //(Localizador de recursos uniforme). la variable "url" al no ser un Uri debemos "parsearlo" usando el ".parse". 
    // parsear: Proceso de analizar una secuencia de símbolos a fin de determinar su estructura gramatical definida    
    final resp = await http.get(Uri.parse(url));
    //creamos una variable que tendra la informacion de la peticion. esta informacion sera en un formato json    
    final decodeData = json.decode(resp.body);

    final List<SeccionModel> lista = [];     //una variable de tipo lista de secciones.

    if(decodeData == null) return []; //condicion: si lo recibido del json (decodeData) es nulla, el metodo regresa nulo. si tiene informacion continua con el code

    decodeData.forEach((value) { //recorremos toda la informacion del "decodeData" y cada producto es almacenado en la variable "value".
      
      final seccion = SeccionModel.fromJson(value);//guaradmos un Map de la seccion en la variable "seccion"

      lista.add(seccion); // añadimos la seccion a la lista vacia creada anteriormente

    });

    return lista; // regresamos la lista con las secciones

  }

  void crearSeccion(SeccionModel seccion) async { //el metodo debe recibir un seccion para poder crearla

    final url = '$_dominio/seccion'; // definimos la url donde se haran las peticiones
    Map<String, String> header = {"Content-type": "application/json"}; // definimos un Map con dos propiedades fundamentales para realizar el post
    //convierten la informacion a un json
    await http.post(Uri.parse(url), headers:header,body: seccionModelToJson(seccion)); //esperamos a que se realice la peticion http
  }

  void eliminarSeccion(SeccionModel seccion) async { //el metodo debe recibir la seccion que quiere eliminar

    final id = seccion.id; //capturamos el id de la seccion a eliminar

    final url = '$_dominio/seccion/$id'; // definimos el url donde queremos realizar la peticion
    await http.delete(Uri.parse(url)); // esperamos a que se realice la eliminacion
    
  }

}

