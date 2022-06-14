import UIKit
import KeychainSwift
import SnapKit
import DeviceKit

enum KeychainKeys: String {
    case name = "name"
}

class ViewController: UIViewController {
    var keychain = KeychainSwift()
    let setView = SetView()
    let setButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitle("Записать в keychain", for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(setIntoKeychainButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let screen = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView.delegate = self
        view.backgroundColor = .white
        navigationItem.title = "Keychain demo"
        setupConstraints()
        hideKeyWhenTap()
    }
    
    func setupConstraints() {
        view.addSubview(setView)
        view.addSubview(setButton)
        
        setView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(screen / 2)
        }
        
        setButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(view.keyboardLayoutGuide.snp.top).inset(-16)
        }
    }
    
    @objc func setIntoKeychainButtonTapped() {
        if let name = setView.text.text {
            keychain.set(name, forKey: KeychainKeys.name.rawValue, withAccess: .none)
            print(name)
        }
    }
    
    func hideKeyWhenTap() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dissmisKeyboard))
        tap.cancelsTouchesInView = true
        tap.buttonMaskRequired = .primary
        view.addGestureRecognizer(tap)
    }
    
    @objc func dissmisKeyboard(){
        view.endEditing(true)
    }
    
}

extension ViewController: SetViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func setupPicherView() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: "Галерея", style: .default){ _ in
            self.imagePicker(sourse: .photoLibrary)
        }
        let camera = UIAlertAction(title: "Камера", style: .default){ _ in
            self.imagePicker(sourse: .camera)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(photo)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func imagePicker(sourse: UIImagePickerController.SourceType) {
        //Если есть такой тип источника для пикера
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            //Создаем пикер, разрешаем редактировать, присваиваем источник
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            present(imagePicker, animated: true, completion: nil)
        }
    }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            setView.setupImage(image: (info[.editedImage] as! UIImage))
            dismiss(animated: true, completion: nil)
        }
}

