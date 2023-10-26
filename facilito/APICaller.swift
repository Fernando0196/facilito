//
//  APICaller.swift
//  facilito
//
//  Created by iMac Mario on 13/10/22.
//

import Foundation
import Alamofire
import Network
import NetworkExtension
import UIKit

class APICaller {
    
    let serverUrl = "https://wsfacilito.osinergmin.gob.pe/facilito_rest_old/remote" //DEV
    
    let URL_DESARROLLO_MICROSERVICIOS: String
    let URL_PRODUCCION_MICROSERVICIOS: String
    let URL_USADA: String
    
    
    let URL_CONTRATOS: String

    let BASE_URL_MICROSERVICIO_GRIFOS: String
    let BASE_URL_MICROSERVICIO_AUTENTICACION: String
    let BASE_URL_MICROSERVICIO_BALON_GAS: String
    let BASE_URL_MICORSERVICIO_USUARIO: String
    let BASE_URL_MICROSERVICIO_ESTABLECIMIENTOS: String
    let BASE_URL_MICROSERVICIO_BALONCITO: String
    let BASE_URL_MICROSERVICIO_DENUNCIAS: String
    let BASE_URL_MICROSERVICIO_DENUNCIAS_INCORFORMIDAD: String
    let BASE_URL_MICROSERVICIO_GAS_NATURAL: String
    let BASE_URL_MICROSERVICIO_UBIGEO: String

    
    let TERMINAL_CREACION =  "11.160.121.132";
    
    init() {
        
        URL_DESARROLLO_MICROSERVICIOS = "http://11.160.121.132:30001/"
        URL_PRODUCCION_MICROSERVICIOS = "https://facilitointegrado.osinergmin.gob.pe/"
        
        URL_CONTRATOS = "https://masigas.osinergmin.gob.pe/gnr-api/"
        
        self.URL_USADA = self.URL_DESARROLLO_MICROSERVICIOS
        
        
        BASE_URL_MICROSERVICIO_GRIFOS = URL_DESARROLLO_MICROSERVICIOS + "facilito_grifo/api"
        BASE_URL_MICROSERVICIO_AUTENTICACION = URL_DESARROLLO_MICROSERVICIOS + "facilito_auth/api/autenticacion"
        BASE_URL_MICORSERVICIO_USUARIO = URL_DESARROLLO_MICROSERVICIOS + "facil_usuario/api";
        BASE_URL_MICROSERVICIO_BALON_GAS = URL_DESARROLLO_MICROSERVICIOS + "facilito_balon_gas/api";
        BASE_URL_MICROSERVICIO_ESTABLECIMIENTOS = URL_DESARROLLO_MICROSERVICIOS + "facil_locales/api";
        BASE_URL_MICROSERVICIO_BALONCITO = URL_DESARROLLO_MICROSERVICIOS + "facilito_baloncito/api"
        BASE_URL_MICROSERVICIO_DENUNCIAS = URL_DESARROLLO_MICROSERVICIOS + "facilito_denuncia/api";
        BASE_URL_MICROSERVICIO_DENUNCIAS_INCORFORMIDAD = URL_DESARROLLO_MICROSERVICIOS + "facil_denuncia/api";
        BASE_URL_MICROSERVICIO_GAS_NATURAL = URL_DESARROLLO_MICROSERVICIOS + "facilito_gas_natural/api"
        BASE_URL_MICROSERVICIO_UBIGEO = URL_DESARROLLO_MICROSERVICIOS + "facilito_ubigeo/api"
        
        /*
        BASE_URL_MICROSERVICIO_GRIFOS = URL_USADA + "facil-grifo/api"
        BASE_URL_MICROSERVICIO_AUTENTICACION = URL_USADA + "facilito-auth/api/autenticacion"
        BASE_URL_MICORSERVICIO_USUARIO = URL_USADA + "facil-usuario/api"
        BASE_URL_MICROSERVICIO_BALON_GAS = URL_USADA + "facil-balon-g/api"
        BASE_URL_MICROSERVICIO_ESTABLECIMIENTOS = URL_USADA + "facil-locales/api"
        BASE_URL_MICROSERVICIO_BALONCITO = URL_USADA + "facil-baloncito/api"
        BASE_URL_MICROSERVICIO_DENUNCIAS = URL_USADA + "facil-denuncia/api"
        BASE_URL_MICROSERVICIO_DENUNCIAS_INCORFORMIDAD = URL_USADA + "facil_denuncia/api"
        BASE_URL_MICROSERVICIO_GAS_NATURAL = URL_USADA + "facil-g-natural/api"
        BASE_URL_MICROSERVICIO_UBIGEO = URL_USADA + "facil-ubigeo/api"
        */
        
    }
    
    
    func PostLogin( _ correo: String, _ clave: String, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        let url = "http://11.160.121.132:23018/facilito_rest_old/remote/usuarioFacilito/login"

    
        
        let payload = "{\n" +
            "\"login\": {\n" +
            "\"correo\": \"" + correo + "\",\n" +
            "\"clave\": \"" + clave + "\",\n" +
            "\"favoritosLugares\": [],\n" +
            "\"favoritosGrifos\": []\n" +
            "}\n" +
        "}"
                        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = payload.data(using: String.Encoding.utf8)
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
 
    func PostRegistrarUsuario( _ nombre: String,_ apellidos: String,_ correo: String,_ clave: String, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        let url = "\(serverUrl)/usuarioFacilito/crear"

        let telefono = ""

        let payload =  "{\n" +
        "\"usuario\": " + "{\n" +
        "\"nombre\": \"" + nombre + "\",\n" +
        "\"apellidos\": \"" + apellidos + "\",\n" +
        "\"telefono\": \"" + telefono + "\",\n" +
        "\"correo\": \"" + correo + "\",\n" +
        "\"clave\": \"" + clave + "\"\n" +
        "}\n" +
        "}\n"
        
        debugPrint(payload)
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = payload.data(using: String.Encoding.utf8)
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
    func PostGenerarClave( _ nombre: String,_ apellidos: String,_ correo: String,_ clave: String, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        let url = "\(serverUrl)/usuarioFacilito/generarClave"

        let payload =  "{\n" +
        "\"claveGen\": " + "{\n" +
        "\"correo\": \"" + correo + "\",\n" +
        "}\n" +
        "}\n"
        
        debugPrint(payload)
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = payload.data(using: String.Encoding.utf8)
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
    func PostEditarPerfil(token: String, correo: String, nombre: String, apellidos: String, nroDocumento: String, telefono: String, tipoEdicion: String, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        
        let url = "\(BASE_URL_MICORSERVICIO_USUARIO)/usuario/editar"

        let payload = "{" +
            "\"usuarioEdit\": {" +
            "\"correo\": \"\(correo)\"," +
            "\"token\": \"\(token)\"," +
            "\"nombre\": \"\(nombre)\"," +
            "\"apellidos\": \"\(apellidos)\"," +
            "\"nroDocumento\": \"\(nroDocumento)\"," +
            "\"telefono\": \"\(telefono)\"," +
            "\"tipoEdicion\": \"\(tipoEdicion)\"" +
            "}" +
            "}"
        
        debugPrint(payload)
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = payload.data(using: String.Encoding.utf8)
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }

    func PostActualizarContraseña( _ correo: String,_ token: String,_ clave: String,_ nuevaClave: String,_ repetirClave: String, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        let url = "\(BASE_URL_MICORSERVICIO_USUARIO)/usuario/editarClave"

        let payload = "{\n" +
            "    \"correo\": \"\(correo)\",\n" +
            "    \"token\": \"\(token)\",\n" +
            "    \"clave\": \"\(clave)\",\n" +
            "    \"nuevaClave\": \"\(nuevaClave)\",\n" +
            "    \"repetirClave\": \"\(repetirClave)\"\n" +
            "}"
        
        debugPrint(payload)
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = payload.data(using: String.Encoding.utf8)
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
    func PostListarFavoritos( _ idUsuario: Int, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        let url = "\(BASE_URL_MICROSERVICIO_GRIFOS)/favorito/listFavoritoGrifo"

        let payload = "{\n" +
            "    \"idUsuario\": \(idUsuario)\n" +
            "}"
        
        debugPrint(payload)
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = payload.data(using: String.Encoding.utf8)
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
        
    func GettListarGrifos(_ latitud: String, _ longitud: String, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        
        let categoria = "004"
        let pordefecto = "20C"
        let numero = "-1"
        let calificacion = "5.0"
        let ubigeo = "-"

        
        let url =  "\(BASE_URL_MICROSERVICIO_ESTABLECIMIENTOS)/googleMap/listG/\(categoria)/\(latitud)/\(longitud)/\(pordefecto)/\(numero)/\(latitud)/\(longitud)/\(calificacion)/\(ubigeo)"
                        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }

    func GettDetalleGrifo(_ idUnidadOperativa: Int, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        
        let tipoEstablecimiento = "02"
        
        let url =  "\(BASE_URL_MICROSERVICIO_BALONCITO)/baloncito/localDetalle/\(idUnidadOperativa)/\(tipoEstablecimiento)"
                        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
    func PostConsultarUbigeo( _ latitud: String,_ longitud: String, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        let url = "\(BASE_URL_MICROSERVICIO_DENUNCIAS_INCORFORMIDAD)/concesionaria/consultarCoordenada"

        let payload = "{\n" +
            "    \"empresa\": {\n" +
            "        \"coordenada_x\": \"\(longitud)\",\n" +
            "        \"coordenada_y\": \"\(latitud)\"\n" +
            "    }\n" +
            "}"
        
        debugPrint(payload)
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = payload.data(using: String.Encoding.utf8)
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
     
    func GetListarBalonGas(_ categoria: String,_ latitud: String,_ longitud: String,_ distancia: String,_ idFamiliaGrifo: String,_ ubigeo: String,_ calificacion: Double,_ minPrecio: Double,_ maxPrecio: Double,_ marca: String,_ tipoPago: String,_ variable: String,_ tiempo: String, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        
        //let ubig = "-"
        
        let url = "\(BASE_URL_MICROSERVICIO_ESTABLECIMIENTOS)/googleMap/listLocales/\(categoria)/\(latitud)/\(longitud)/\(distancia)/\(idFamiliaGrifo)/\(ubigeo)/\(calificacion)/\(minPrecio)/\(maxPrecio)/\(marca)/\(tipoPago)/\(variable)/\(tiempo)"

        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
    func GettDetalleBalonGas(_ codigoOsinergmin: String, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        
        let tipoEstablecimiento = "01"
        
        let url =  "\(BASE_URL_MICROSERVICIO_BALONCITO)/baloncito/localDetalle/\(codigoOsinergmin)/\(tipoEstablecimiento)"
                        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
    func PostReportarPrecioBalon(sector: String, motivo: String, asunto: String, dni: String, descripcionInconformidad: String, coordenada_x: String, coordenada_y: String, codigoUnidadOperativa: String, telefono: String, correo: String, nombre: String, apellidoPaterno: String, apellidoMaterno: String, direccion: String, archivo1: String, archivo2: String, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        let url = "\(BASE_URL_MICROSERVICIO_DENUNCIAS)/inconformidad/registrarInconformidad"

        let listaFotos = [archivo1, archivo2]

        let payload = """
        {
            "sector": "\(sector)",
            "motivo": "\(motivo)",
            "asunto": "\(asunto)",
            "dni": "\(dni)",
            "descripcionInconformidad": "\(descripcionInconformidad)",
            "coordenada_x": "\(coordenada_x)",
            "coordenada_y": "\(coordenada_y)",
            "codigoUnidadOperativa": "\(codigoUnidadOperativa)",
            "telefono": "\(telefono)",
            "correo": "\(correo)",
            "nombre": "\(nombre)",
            "apellidoPaterno": "\(apellidoPaterno)",
            "apellidoMaterno": "\(apellidoMaterno)",
            "direccion": "\(direccion)",
            "lista": "\(listaFotos.joined(separator: ", "))"
        }
        """

        debugPrint(payload)
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = payload.data(using: String.Encoding.utf8)
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
    func PostListarTramites(_ email: String,_ codSector: String,_ codCanalRegistro: String, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        
        let url = "\(BASE_URL_MICROSERVICIO_DENUNCIAS_INCORFORMIDAD)/inconformidad/listarInconformidades"

        let payload = "{\n" +
            "    \"ciudadano\": {\n" +
            "       \"email\": \"framos@gmail.com\",\n" +
            "       \"codSector\": \"\(codSector)\",\n" +
            "       \"codCanalRegistro\": \"\(codCanalRegistro)\"\n" +
            "    }\n" +
            "}"
        
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = payload.data(using: String.Encoding.utf8)
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }

    }
    
    
    func PostListarDetalleTramite( _ nroInconformidad: String, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        let url = "\(BASE_URL_MICROSERVICIO_DENUNCIAS)/inconformidad/detalleAcciones"

        let payload = "{\n" +
            "    \"nroInconformidad\": \"\(nroInconformidad)\"\n" +
            "}"
        
        debugPrint(payload)
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = payload.data(using: String.Encoding.utf8)
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
    func PostListarContratos(appInvoker: String, tipoIdentificacionSolicitante: String, numeroIdentificacionSolicitante: String, page: Int, rowsPerPage: Int, idSolicitud: Int?, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        let url = "\(URL_CONTRATOS)/rest/mobile/solicitudInformacionGeneral/listarResumen"


        let payload = "{\n" +
            "    \"appInvoker\": \"\(appInvoker)\",\n" +
            "    \"tipoIdentificacionSolicitante\": \"\(tipoIdentificacionSolicitante)\",\n" +
            "    \"numeroIdentificacionSolicitante\": \"\(numeroIdentificacionSolicitante)\",\n" +
            "    \"page\": \(page),\n" +
            "    \"rowsPerPage\": \(rowsPerPage),\n" +
            "    \"idSolicitud\": \(idSolicitud != nil ? String(idSolicitud!) : "null")\n" +
            "}"
        
        debugPrint(payload)
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = payload.data(using: String.Encoding.utf8)
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
    func PostListarDetalleContratos(appInvoker: String, idSolicitud: Int?, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        let url = "\(URL_CONTRATOS)/rest/mobile/solicitudInformacionGeneral/obtener"

        let payload = "{\n" +
            "    \"appInvoker\": \"\(appInvoker)\",\n" +
            "    \"idSolicitud\": \(idSolicitud != nil ? String(idSolicitud!) : "null")\n" +
            "}"
        
        debugPrint(payload)
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = payload.data(using: String.Encoding.utf8)
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
    func PostCalcularAhorro(appInvoker: String, dias: String, precio: String, arrayArtefactos: [[String: Int]], completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        let url = "\(BASE_URL_MICROSERVICIO_GAS_NATURAL)/gasNatural/calcularAhorro"
       
        let artefactos: [[String: Int]] = arrayArtefactos

        let payload = """
        {
            "appInvoker": "\(appInvoker)",
            "dias": "\(dias)",
            "precio": "\(precio)",
            "artefactos": [\(artefactos.map { "{ \"tipoArtefacto\": \($0["tipoArtefacto"]!)}" }.joined(separator: ","))]
        }
        """
        
        debugPrint(payload)
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = payload.data(using: String.Encoding.utf8)
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
    func PostReportar(sector: String, motivo: String, asunto: String, dni: String, descripcionInconformidad: String, coordenada_x: String, coordenada_y: String, nroSuministro: String, telefono: String, correo: String, nombre: String, apellidoPaterno: String, apellidoMaterno: String, mesesAfectados: String, codigoCanalRegistro: String, listaUAP: String, listaFotos: [String], nombreEmpresa: String, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        
        //let url = "\(BASE_URL_MICROSERVICIO_DENUNCIAS)/inconformidad/registrarInconformidad"
        let url = "http://11.160.121.132:30001/facilito_denuncia/api/inconformidad/registrarInconformidad"
        // Verificar si la lista de fotos está vacía y, en ese caso, asignar una lista vacía en el payload
        let fotosJSON: String
        if listaFotos.isEmpty {
            fotosJSON = "[]"
        } else {
            fotosJSON = "[\(listaFotos.map { "\"\($0)\"" }.joined(separator: ","))]"
        }
        
        let payload = """
        {
            "sector": "\(sector)",
            "motivo": "\(motivo)",
            "asunto": "\(asunto)",
            "dni": "\(dni)",
            "descripcionInconformidad": "\(descripcionInconformidad)",
            "coordenada_x": "\(coordenada_x)",
            "coordenada_y": "\(coordenada_y)",
            "nroSuministro": "\(nroSuministro)",
            "telefono": "\(telefono)",
            "correo": "\(correo)",
            "nombre": "\(nombre)",
            "apellidoPaterno": "\(apellidoPaterno)",
            "apellidoMaterno": "\(apellidoMaterno)",
            "mesesAfectados": "\(mesesAfectados)",
            "codigoCanalRegistro": "\(codigoCanalRegistro)",
            "listaUAP": "\(listaUAP)",
            "listaFotos": \(fotosJSON),
            "nombreEmpresa": "\(nombreEmpresa)"
        }
        """
        
        debugPrint(payload)
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = payload.data(using: String.Encoding.utf8)
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
    func PostConsultarGasNatural(appInvoker: String, token: String, coordenadaX: String, coordenadaY: String, cantidadMetros: Int, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {

        
        let url = "\(BASE_URL_MICROSERVICIO_GAS_NATURAL)/gasNatural/consultarRedGas"

        let payload = """
        {
            "appInvoker": "\(appInvoker)",
            "token": "\(token)",
            "coordenadaX": "\(coordenadaX)",
            "coordenadaY": "\(coordenadaY)",
            "cantidadMetros": \(cantidadMetros)
        }
        """
        
        debugPrint(payload)
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = payload.data(using: String.Encoding.utf8)
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
    func PostListarEmpresasInstaladoras(token: String, appInvoker: String, page: Int, rowsPerPage: Int, asociadoFiseEmpresaInstaladora: String, idCategoriaInstalacion: Int, ubigeoEmpresaInstaladora: String, tipoPersonaEmpresaInstaladora: String, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        
        let url = "\(BASE_URL_MICROSERVICIO_GAS_NATURAL)/gasNatural/listarEmpresaInstaladora"
        
        let payload = """
        {
            "token": "\(token)",
            "appInvoker": "\(appInvoker)",
            "page": \(page),
            "rowsPerPage": 10,
            "asociadoFiseEmpresaInstaladora": "\(asociadoFiseEmpresaInstaladora)",
            "idCategoriaInstalacion": \(idCategoriaInstalacion),
            "ubigeoEmpresaInstaladora": "\(ubigeoEmpresaInstaladora)",
            "tipoPersonaEmpresaInstaladora": "\(tipoPersonaEmpresaInstaladora)"
        }
        """
        
        debugPrint(payload)
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = payload.data(using: String.Encoding.utf8)
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
    func PostListarDetalleEmpresas(token: String, appInvoker: String, idEmpresaInstaladora: Int, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        
        let url = "\(BASE_URL_MICROSERVICIO_GAS_NATURAL)/gasNatural/obtenerEmpresaInstaladora"
        
        let payload = """
        {
            "token": "\(token)",
            "appInvoker": "\(appInvoker)",
            "idEmpresaInstaladora": \(idEmpresaInstaladora)
        }
        """
        
        debugPrint(payload)
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = payload.data(using: String.Encoding.utf8)
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    func PostListarDistritos( _ codDpto: String,_ codProv: String, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        let url = "\(BASE_URL_MICROSERVICIO_UBIGEO)/ubigeo/listarDistrito"

        let payload = "{\n" +
            "    \"codDpto\": \"\(codDpto)\",\n" +
            "    \"codProv\": \"\(codProv)\"\n" +
            "}"
        
        debugPrint(payload)
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = payload.data(using: String.Encoding.utf8)
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
    func PostListarEmpresasElec(completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
                
        let url = "\(BASE_URL_MICROSERVICIO_DENUNCIAS)/concesionaria/listar"
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
    func GetPostes(latitud: String, longitud: String, radio: String, idEmpresa: String, ubigeo: String, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        
        //let ubig = "-"
        
        let url = "\(BASE_URL_MICROSERVICIO_DENUNCIAS_INCORFORMIDAD)/sargop/listarPostes/\(latitud)/\(longitud)/\(radio)/\(idEmpresa)/\(ubigeo)"

        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
    func GetListarGrifosMapa(categoria: String, latitud1: String, longitud1: String, pordefecto: String, numero: String, latitud2: String, longitud2: String, calificacion: Double, ubigeo: String, completion: @escaping (_ success: Bool, _ result: String?, _ errorCode: Int?) -> Void) {
        
        //let ubig = "-"
        
        let url = "\(BASE_URL_MICROSERVICIO_ESTABLECIMIENTOS)/googleMap/list/\(categoria)/\(latitud1)/\(longitud1)/\(pordefecto)/\(numero)/\(latitud2)/\(longitud2)/\(calificacion)/\(ubigeo)"
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        SecurityCertificateManager.sharedInstance.defaultManager.request(urlRequest)
            .responseString { (response) in
                if (response.error == nil) {
                    let stringResponse: String = (String(data: response.data!, encoding: String.Encoding.utf8) as String?)!
                    if (!stringResponse.isEmpty) {
                        completion(true, stringResponse, response.response?.statusCode)
                    } else {
                        completion(false, "", -1)
                    }
                } else {
                    completion(false, "", 0)
                }
        }
    }
    
    /* */
    func concatenate(a: String, b: String, c: String) -> String {
        return a + b + c
    }
    
}

