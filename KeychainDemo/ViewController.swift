import UIKit
import KeychainSwift
import SnapKit
import DeviceKit

class ViewController: UIViewController {
    let setView = SetView()
    
    let top    = UIApplication.shared.windows[0].safeAreaInsets.top
    let bottom = UIApplication.shared.windows[0].safeAreaInsets.bottom
    let screen = UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView.delegate = self
        view.backgroundColor = .white
        navigationItem.title = "Keychain demo"
        setupConstraints()
    }
    
    func setupConstraints() {
        view.addSubview(setView)
        
        setView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(screen / 2)
        }
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

