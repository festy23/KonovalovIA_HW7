import SwiftUI
import PhotosUI
import UIKit
import CoreTransferable

@MainActor
class UserProfileM: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var surname: String = ""
    @Published var tel: String = ""
    @Published var tg: String = ""
    @Published var email: String = ""
    @Published var nickname: String = ""
    
    enum ImageState {
        case empty, loading(Progress), success(UIImage), failure(Error)
    }
    
    @Published var imageState: ImageState = .empty
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
    
    enum TransferError: Error {
        case importFailed
    }
    
    struct ProfileImage: Transferable {
        let image: UIImage
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                return ProfileImage(image: uiImage)
            }
        }
    }
    
    func saveAvatar(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(imageData, forKey: "UserAvatar")
        }
    }
    
    func loadAvatar() {
        if let imageData = UserDefaults.standard.data(forKey: "UserAvatar"),
           let uiImage = UIImage(data: imageData) {
            imageState = .success(uiImage)
        } else {
            imageState = .empty
        }
    }
    
    let keyValues = ["FirstName", "LastName", "Surname", "Email", "TG", "Tel", "Nickname"]
    
    func saveInUserDefaults() {
        UserDefaults.standard.set(firstName, forKey: "FirstName")
        UserDefaults.standard.set(lastName, forKey: "LastName")
        UserDefaults.standard.set(surname, forKey: "Surname")
        UserDefaults.standard.set(email, forKey: "Email")
        UserDefaults.standard.set(tg, forKey: "TG")
        UserDefaults.standard.set(tel, forKey: "Tel")
        UserDefaults.standard.set(nickname, forKey: "Nickname")
    }
    
    func setImageStateSuccess(image: UIImage) {
        self.imageState = .success(image)
    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ProfileImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else { return }
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(profileImage.image)
                    self.saveAvatar(image: profileImage.image)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
    
    func logout() {
        KeychainHelper.shared.deleteToken()
        UserDefaults.standard.removeObject(forKey: "UserAvatar")
        for key in keyValues {
            UserDefaults.standard.removeObject(forKey: key)
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("UserLoggedOut"), object: nil)
        }
    }
}
