import SwiftUI

struct DataV: View {
    @EnvironmentObject var vm: MainVM
    @State private var localUsers: [User] = []

    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                Text(vm.data)
                    .foregroundColor(.green)
                if vm.isLoading {
                    VStack {
                        ProgressView("Loading users...")
                            .padding()
                        Text("Please wait...")
                            .foregroundColor(.gray)
                    }
                } else {
                    List {
                        ForEach(localUsers, id: \.id) { user in
                            userRow(for: user)
                        }
                    }
                    .refreshable {
                        refreshUsers()
                    }
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: AboutS(model: AboutTeamM.mock)) {
                        Text("About")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: UserProfileS()) {
                        Text("Profile")
                    }
                }
            }
            .onAppear {
                refreshUsers()
            }
        }
    }
    
    private func userRow(for user: User) -> some View {
        let model = user.toUserM()
        return NavigationLink(destination: UserS(user: model)) {
            VStack(alignment: .leading) {
                Text(model.username)
                    .font(.headline)
                Text("\(model.firstName) \(model.lastName)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private func loadLocalUsers() {
        localUsers = PersistenceController.shared.getAllUsers()
    }
    
    private func refreshUsers() {
        vm.syncUsers {
            loadLocalUsers()
        }
    }
}
