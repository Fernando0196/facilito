//
//  UIButtonExtension.swift
//  facilito
//
//  Created by iMac Mario on 4/10/22.
//

import SwiftUI


//**EXTENCIONES PARA ESTILOS**

extension UIButton{
        
    //BORDE DE BOTONES INFERIORES
    func roundButton(){
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
        layer.borderWidth = 2

    }
    
    func roundButtonBack(){
        layer.cornerRadius = bounds.height / 20
        clipsToBounds = true
    }
    
    func addCardShadowToButton(button: UIButton) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowRadius = 6
        button.layer.masksToBounds = false
    }

}
extension UIImageView{
    
    func resized(withSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    //BORDE DE BOTONES INFERIORES
    func roundImagen(){
        layer.borderWidth = 1
        layer.cornerRadius = frame.size.width / 8
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
    }
    
    //GRIFOS -
    //IMAGEN DE FONDO
    func roundImagenFondoGrifo(){
        layer.borderWidth = 1
        layer.cornerRadius = frame.size.width / 40
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
    }
    //IMAGEN DE LOGO
    func roundImagenLogo(){
        //layer.borderWidth = 1
        layer.cornerRadius = frame.size.width / 2
        //layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
    }

}

extension UILabel {
    
    func getSize(constrainedWidth: CGFloat) -> CGSize {
        return systemLayoutSizeFitting(CGSize(width: constrainedWidth, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    //GRIFOS
    func roundLabel(){
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    //TRAMITES
    func roundLabelT(){
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    func applyCustomFormatToHeader(headerText: String, contentText: String) {
        let attributedText = NSMutableAttributedString(string: headerText, attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-SemiBold", size: 13.0) ?? UIFont.systemFont(ofSize: 13.0)])
        
        attributedText.append(NSAttributedString(string: contentText))
        
        self.attributedText = attributedText
    }
}

extension UITextField {
    
     func styleTextField(textField: UITextField){
       
        // corner radius
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 5.0;
       /* // border
        textField.layer.borderWidth = 1.0
        textField.layer.backgroundColor = UIColor.white.cgColor
        // shadow
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 2, height: 2)
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowRadius = 4.0*/
        
    }
    
    func resizeHeightToFit() {
        let fixedWidth = self.frame.size.width
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = self.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.frame = newFrame
    }
}

extension UITextView {
    func adjustHeightToFitContent() {
        self.sizeToFit()
    }
}

extension UIStackView {
    
    //GRIFO -
    //BORDE INFERIOR PARA STACKVIEW
    func showBottomBorder(width: CGFloat) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        bottomBorder.backgroundColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        self.layer.addSublayer(bottomBorder)
    }
    
}


extension UIView {

    func addShadowToTop() {

        let innerShadowLayer = CALayer()
        innerShadowLayer.frame = bounds

        innerShadowLayer.shadowColor = UIColor.black.cgColor
        innerShadowLayer.shadowOffset = CGSize(width: 0, height: -5) // Ajusta la distancia vertical de la sombra hacia arriba
        innerShadowLayer.shadowRadius = 5 // Ajusta el radio de la sombra
        innerShadowLayer.shadowOpacity = 0.7 // Ajusta la opacidad de la sombra
        innerShadowLayer.masksToBounds = false

        // Configura la máscara para la sombra
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: -5, width: bounds.size.width, height: 5))
        innerShadowLayer.shadowPath = shadowPath.cgPath

        // Agrega la capa de sombra a la vista
        layer.addSublayer(innerShadowLayer)
    }
    
    func bordeSuperior(radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath

        layer.mask = maskLayer
    }
    
    func roundView(){
        layer.cornerRadius = 8
        layer.masksToBounds = true  // optional

    }
    
    func dropShadowWithCornerRaduis() {
        layer.cornerRadius = 8
        layer.masksToBounds = true  // optional
        layer.masksToBounds = true
        layer.cornerRadius = 25
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
       
    }
    
    func addShadowOnBottom() {
          self.layer.shadowColor = UIColor.gray.cgColor
          self.layer.shadowOffset = CGSize(width: 0, height: 1) // Ajusta la altura de la sombra según tus preferencias
          self.layer.shadowOpacity = 0.2
          self.layer.shadowRadius = 1
          self.layer.masksToBounds = false // Importante para mostrar la sombra
    }
    
    func addCardShadow() {
        self.layer.shadowColor = UIColor.black.cgColor // Cambiamos el color de la sombra a negro
        self.layer.shadowOffset = CGSize(width: 0, height: 4) // Ajustamos la altura de la sombra
        self.layer.shadowOpacity = 0.4 // Aumentamos la opacidad de la sombra
        self.layer.shadowRadius = 4 // Aumentamos el radio de la sombra
        self.layer.masksToBounds = false
    }
    
    @discardableResult
    public func addBlur(style: UIBlurEffect.Style = .extraLight) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurBackground = UIVisualEffectView(effect: blurEffect)

        addSubview(blurBackground)

        blurBackground.translatesAutoresizingMaskIntoConstraints = false
        blurBackground.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blurBackground.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blurBackground.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        blurBackground.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        return blurBackground
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
        var shadowRadius: CGFloat {
            get {
                return layer.shadowRadius
            }
            set {
                layer.shadowRadius = newValue
            }
        }
        
        @IBInspectable
        var shadowOpacity: Float {
            get {
                return layer.shadowOpacity
            }
            set {
                layer.shadowOpacity = newValue
            }
        }
        
        @IBInspectable
        var shadowOffset: CGSize {
            get {
                return layer.shadowOffset
            }
            set {
                layer.shadowOffset = newValue
            }
        }
        
        @IBInspectable
        var shadowColor: UIColor? {
            get {
                if let color = layer.shadowColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set {
                if let color = newValue {
                    layer.shadowColor = color.cgColor
                } else {
                    layer.shadowColor = nil
                }
            }
        }
    
    //Borde inferior  VIEW 3
    func addBottomBorderItem() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 3)
        bottomLine.backgroundColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1.0).cgColor
        layer.addSublayer(bottomLine)
    }
    //Borde inferior  VIEW 1
    func addBottomBorderItem1() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1.0).cgColor
        layer.addSublayer(bottomLine)
    }
    func addLine(width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1.0)
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)

        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
    }
    
    func addTopBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    
    func preventRepeatedPresses(inNext seconds: Double = 1) {
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            self.isUserInteractionEnabled = true
        }
    }

    
}

var backgroundView: UIView?
var containerView: UIView?

extension UIViewController {
    func realizarLlamada(telefono: String) {
        if let url = URL(string: "tel://\(telefono)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Mostrar un mensaje de error o manejar la situación en caso de que no se pueda realizar la llamada.
        }
    }
    
    private struct AssociatedKeys {
        static var backgroundView: UIView?
        static var containerView: UIView?
    }

    var backgroundView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.backgroundView) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.backgroundView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var containerView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.containerView) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.containerView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height)  // / 2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }
    
    
    func showActivityIndicatorWithText(msg:String, _ indicator:Bool, _ wd:Int) {
        
        var strLabel = UILabel()
        var messageFrame = UIView()
        var activityIndicator = UIActivityIndicatorView()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.black //UIColor(red: 5/255.0, green: 50/255.0, blue: 32/255.0, alpha: 1.0)//UIColor.white
        //messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 250, height: 50))
        messageFrame = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 50))
        var newFrame = messageFrame.frame
        newFrame.size.width = CGFloat(wd)
        
        messageFrame.frame = newFrame
        
        messageFrame.center = self.view.center
        
        messageFrame.layer.cornerRadius = 15
        //messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        messageFrame.backgroundColor = UIColor.white //UIColor(red: 255/255.0, green: 41/255.0, blue: 28/255.0, alpha: 1.0)
        if indicator {
            //activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
            activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.color = UIColor.blue
            messageFrame.tag = 50
            activityIndicator.tag = 51
            
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
        //UIApplication.shared.beginIgnoringInteractionEvents()
        self.view.isUserInteractionEnabled = false
    }
    
    func hideActivityIndicatorWithText() {
        if let messageFrame = self.view.viewWithTag(50) {
            //let activityIndicator = messageFrame.viewWithTag(51) as! UIActivityIndicatorView
            //activityIndicator.stopAnimating()
            messageFrame.removeFromSuperview()
        }
        //UIApplication.shared.endIgnoringInteractionEvents()
        self.view.isUserInteractionEnabled = true
    }
    
    func displayMessage(Header: String, Message: String) {
        let alertController = UIAlertController(title: Header, message: Message , preferredStyle:UIAlertController.Style.alert)
    
        let subview = (alertController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        //subview.layer.cornerRadius = 1
        subview.backgroundColor = UIColor.white //UIColor(red: 255/255.0, green: 41/255.0, blue:28/255.0, alpha: 1.0)
        alertController.view.tintColor = UIColor.black //UIColor.white
        
        alertController.setValue(NSAttributedString(string: Header, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17),NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedTitle")
        
        alertController.setValue(NSAttributedString(string: Message, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
        
        alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default)
        { action -> Void in
            //NOOP
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
}

//Agregar color de fondo de un label
extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue:  CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
