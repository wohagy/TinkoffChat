//
//  GCDSaver.swift
//  iOS Chat
//
//  Created by Macbook on 22.03.2022.
//

import UIKit

protocol IInformationStorageManager: AnyObject {
    func save(model: ProfileInformation, completion: @escaping (Result<ProfileInformation, Error>) -> Void )
    func read(completion: @escaping (ProfileInformation?) -> Void)
}

final class InformationStorageManager: IInformationStorageManager {
    
    private let serialQueue = DispatchQueue(label: "ru.wohagy.gcd")
    
    private let localStorage: ILocalStorage
    
    private lazy var informationFileURL = localStorage.getWritingURL(forFile: "informationFile.json")
    private lazy var photoFileURL = localStorage.getWritingURL(forFile: "photoFile.jpg")
    
    init(localStorage: ILocalStorage) {
        self.localStorage = localStorage
    }
    
    func save(model: ProfileInformation, completion: @escaping (Result<ProfileInformation, Error>) -> Void) {
        
        guard let informationURL = self.informationFileURL,
              let photoURL = self.photoFileURL else { return }
        
        serialQueue.async {
            
            let jsonObject: [String: Any] = [
                "name": model.name as Any,
                "bio": model.bio as Any,
                "location": model.location  as Any
            ]
            
            do {
                let infoFata = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
                try infoFata.write(to: informationURL, options: [.atomicWrite])
                
                if let imageData = model.image?.jpegData(compressionQuality: 0.8) {
                    try? imageData.write(to: photoURL)
                }
                
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            } catch {
                Logger.shared.message(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
    }
    
    func read(completion: @escaping (ProfileInformation?) -> Void) {
        
        guard let informationURL = self.informationFileURL,
              let photoURL = self.photoFileURL else { return }
        
        serialQueue.async {
            
            do {
                let data = try Data(contentsOf: informationURL)
                let image = UIImage(contentsOfFile: photoURL.path)
                let result = try JSONDecoder().decode(ProfileInformationCodable.self, from: data)
                let resultInfo = ProfileInformation(name: result.name,
                                                    bio: result.bio,
                                                    location: result.location,
                                                    image: image)
                DispatchQueue.main.async {
                    completion(resultInfo)
                }
            } catch {
                Logger.shared.message(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        
    }
    
}
