import SwiftUI
import PhotosUI
import UIKit
import CoreTransferable

@MainActor
class UserProfileM: ObservableObject {
    
    // MARK: - User Details
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var surname: String = ""
    @Published var tel: String = ""
    @Published var tg: String = ""
    @Published var email: String = ""
    @Published var nickname: String = ""
    
    // MARK: - User Image State
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    // Свойство доступно только для чтения извне
    @Published private(set) var imageState: ImageState = .empty
    
    // Photo picked item
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection = imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    // MARK: - Transferable and Error Types
    enum TransferError: Error {
        case importFailed
    }
    
    struct ProfileImage: Transferable {
        let image: Image
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                
                // Сохраняем данные аватара (например, для восстановления)
                UserDefaults.standard.set(data, forKey: "Avatar")
                
                let image = Image(uiImage: uiImage)
                return ProfileImage(image: image)
            }
        }
    }
    
    // MARK: - Работа с UserDefaults
    let keyValues = ["FirstName", "LastName", "Surname", "Email", "TG", "Tel", "Nickname"]
    
    public func saveInUserDefaults() {
        for key in keyValues {
            switch key {
            case "FirstName":
                UserDefaults.standard.set(firstName, forKey: key)
            case "LastName":
                UserDefaults.standard.set(lastName, forKey: key)
            case "Surname":
                UserDefaults.standard.set(surname, forKey: key)
            case "Email":
                UserDefaults.standard.set(email, forKey: key)
            case "TG":
                UserDefaults.standard.set(tg, forKey: key)
            case "Tel":
                UserDefaults.standard.set(tel, forKey: key)
            case "Nickname":
                UserDefaults.standard.set(nickname, forKey: key)
            default:
                print("Unknown key: \(key)")
            }
        }
    }
    
    /// Устанавливает состояние изображения в success с переданным SwiftUI Image
    public func setImageStateSuccess(image: Image) {
        self.imageState = .success(image)
    }
    
    // MARK: - Private Methods
    
    /// Загружает изображение через механизм Transferable и обновляет состояние
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ProfileImage.self) { result in
            DispatchQueue.main.async {
                // Если выбран другой элемент – игнорируем результат
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(profileImage.image)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
    
    // MARK: - Logout
    /// Метод logout очищает сохранённые данные и сбрасывает свойства модели
    func logout() {
        // Удаляем сохранённый аватар
        UserDefaults.standard.removeObject(forKey: "Avatar")
        // Удаляем сохранённые данные по ключам
        for key in keyValues {
            UserDefaults.standard.removeObject(forKey: key)
        }
        // Сбрасываем свойства модели
        firstName = ""
        lastName = ""
        surname = ""
        tel = ""
        tg = ""
        email = ""
        nickname = ""
        imageState = .empty
        imageSelection = nil
        
        // Можно отправить уведомление о выходе (если используется)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("UserLoggedOut"), object: nil)
        }
    }
    
    func loadAvatar() {
        if let data = UserDefaults.standard.data(forKey: "Avatar"),
           let uiImage = UIImage(data: data) {
            self.imageState = .success(Image(uiImage: uiImage))
        } else {
            self.imageState = .empty
        }
    }

}
