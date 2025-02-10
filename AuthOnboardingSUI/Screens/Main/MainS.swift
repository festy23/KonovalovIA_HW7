import SwiftUI

struct MainS: View {
    @EnvironmentObject var vm: MainVM
    @State private var users: [UserM] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient
                VStack(spacing: 20) {
                    headerView
                    myProfileButton
                    if users.isEmpty {
                        Text("No users found")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.top, 20)
                    } else {
                        userListView
                    }
                    Spacer()
                    logoutButton
                }
                .padding(.vertical, 30)
            }
            .ignoresSafeArea()
            .navigationBarHidden(true)
            .onAppear { loadUsers() }
        }
    }
    
    // MARK: - Background Gradient
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue, Color.purple]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Заголовок экрана
    private var headerView: some View {
        Text("Registered Users")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.top, 40)
    }
    
    // MARK: - Кнопка "My Profile"
    private var myProfileButton: some View {
        NavigationLink(destination: UserProfileS()) {
            Text("My Profile")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Список пользователей
    private var userListView: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(users) { user in
                    UserMRowView(user: user)
                }
            }
            .padding(.top, 10)
        }
    }
    
    // MARK: - Кнопка Logout
    private var logoutButton: some View {
        Button(action: logout) {
            Text("Logout")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PressableButtonStyle())
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
    
    // MARK: - Действия
    private func loadUsers() {
        vm.getRegisteredUsers { fetchedUsers in
            self.users = fetchedUsers
            print("Loaded \(fetchedUsers.count) users")
        }
    }
    
    private func logout() {
        withAnimation {
            vm.logout()
        }
    }
}

struct UserMRowView: View {
    let user: UserM
    
    var body: some View {
        VStack(spacing: 5) {
            Text(user.username)
                .font(.headline)
                .foregroundColor(.white)
            Text(user.email)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 20)
    }
}

struct MainS_Previews: PreviewProvider {
    static var previews: some View {
        MainS()
            .environmentObject(MainVM())
    }
}
