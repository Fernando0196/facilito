//
//  InicioViewController.swift
//  facilito
//
//  Created by iMac Mario on 4/10/22.
//
import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FacebookLogin

class InicioViewController: UIViewController {
    
    @IBOutlet weak var btnIniciarSesion: UIButton!
    @IBOutlet weak var btnIniciarGoogle: UIButton!
    @IBOutlet weak var btnIniciarFacebook: UIButton!

    @IBOutlet weak var vFondo: UIView!
    @IBOutlet weak var lblRegistrarme: UILabel!
    @IBOutlet weak var lblInvitado: UILabel!
    
    @IBOutlet weak var btnInvitado: UIButton!
    @IBOutlet weak var btnRegistrarme: UIButton!
    
    @IBOutlet weak var imgFondo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        btnIniciarSesion.roundButton()
        btnIniciarGoogle.roundButton()
        btnIniciarFacebook.roundButton()

        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: lblRegistrarme.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        let attributeString2: NSMutableAttributedString =  NSMutableAttributedString(string: lblInvitado.text ?? "")
        attributeString2.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, attributeString2.length))
        lblRegistrarme.attributedText = attributeString
        lblInvitado.attributedText = attributeString2
        
        
        
        
    }

    @IBAction func btnMostrarInvitado(_ sender: UIButton) {
        
        sender.preventRepeatedPresses()
        self.performSegue(withIdentifier: "sgLoadInvitado", sender: self)
        
    }
    
    @IBAction func btnRegistrarme(_ sender: UIButton) {
        
        sender.preventRepeatedPresses()
        self.performSegue(withIdentifier: "sgRegistrar1", sender: self)
        
    }
    
    @IBAction func inciarSesionGoogle(_ sender: Any) {
        let signInConfig = GIDConfiguration(clientID: "396165979336-it03dgf5h7l2ic6h3guf2asd0ps8utus.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            if let error = error {
                
                print("Error de inicio de sesión de Google: \(error.localizedDescription)")
            } else if let user = user {
                let userId = user.userID
                let idToken = user.authentication.idToken
                let fullName = user.profile!.name
                let givenName = user.profile?.givenName
                let familyName = user.profile?.familyName
                let email = user.profile?.email

            }
        }
    }
    
    @IBAction func iniciarSesionFacebook(_ sender: Any) {
        
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { (result: LoginResult) in
            switch result {
            case .success(granted: _, declined: _, token: _):
                self.obtenerDatosUsuario()
            case .cancelled:
                print("Inicio de sesión con Facebook cancelado.")
            case .failed(let error):
                // Error al iniciar sesión con Facebook
                print("Error al iniciar sesión con Facebook: \(error.localizedDescription)")
            }
        }
    }
    
    func obtenerDatosUsuario() {
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id,first_name,last_name,email"])
        graphRequest.start { (connection, result, error) in
            if let error = error {
                print("Error al obtener datos del usuario: \(error.localizedDescription)")
            } else if let result = result as? [String: Any] {
                if let firstName = result["first_name"] as? String,
                   let lastName = result["last_name"] as? String,
                   let email = result["email"] as? String,
                   let userID = result["id"] as? String {
                    print("Nombre: \(firstName), Apellido: \(lastName), Email: \(email), ID: \(userID)")
                }
            }
        }
    }
    
    
    
}
