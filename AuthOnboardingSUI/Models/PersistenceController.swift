import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Ошибка загрузки хранилища данных: \(error.localizedDescription)")
            }
        }
    }

    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Ошибка сохранения данных: \(error.localizedDescription)")
            }
        }
    }

    func getAllUsers() -> [User] {
        let context = container.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка при получении пользователей: \(error.localizedDescription)")
            return []
        }
    }

    func deleteUserById(id: Int16) {
        let context = container.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            if let user = try context.fetch(request).first {
                context.delete(user)
                save()
            }
        } catch {
            print("Ошибка удаления пользователя: \(error.localizedDescription)")
        }
    }

    func upsertUser(_ user: UserM) {
        let context = container.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", user.id)
        do {
            let results = try context.fetch(request)
            let cdUser: User = results.first ?? User(context: context)
            if results.isEmpty {
                cdUser.id = Int16(user.id)
            }
            cdUser.firstName = user.firstName
            cdUser.lastName = user.lastName
            cdUser.surname = user.surname
            cdUser.tel = user.tel
            cdUser.tg = user.tg
            save()
        } catch {
            print("Ошибка при обновлении пользователя: \(error.localizedDescription)")
        }
    }

    func syncUsers(with serverUsers: [UserM]) {
        let context = container.viewContext
        let localUsers = getAllUsers()
        let serverIds = Set(serverUsers.map { $0.id })
        for localUser in localUsers {
            if !serverIds.contains(Int(localUser.id)) {
                context.delete(localUser)
            }
        }
        serverUsers.forEach { upsertUser($0) }
        save()
    }
}
