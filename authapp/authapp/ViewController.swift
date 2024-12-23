import UIKit

struct User {
    var email: String
    var name: String
    var surname: String
    var avatar: String
}

class ViewController: UIViewController {
    
    // UI элементы для авторизации
    let loginTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton(type: .system)
    let errorLabel = UILabel()
    let welcomeImageView = UIImageView()  // Картинка для экрана авторизации
    let titleLabel = UILabel()    // Заголовок "Авторизация"
    
    // UI элементы для профиля
    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let logoutButton = UIButton(type: .system)
    let profileTitleLabel = UILabel() // Заголовок "Профиль"
    
    var currentUser: User?
    
    // Сохранённые пользователи
    let users = [
        ("ruslan@example.com", "Password1", User(email: "ruslan@example.com", name: "Руслан", surname: "Спиридонов", avatar: "avatar1")),
        ("ivan@example.com", "Password2", User(email: "ivan@example.com", name: "Иван", surname: "Иванов", avatar: "avatar2"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        
        if isUserLoggedIn() {
            showProfileView()
        } else {
            setupLoginView()
        }
    }
    
    func setupBackground() {
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: "back")
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    func setupLoginView() {
        
        welcomeImageView.image = UIImage(named: "welcomeimage")
        welcomeImageView.contentMode = .scaleAspectFit
        welcomeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Установка текста "Авторизация"
        titleLabel.text = "Авторизация"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        loginTextField.placeholder = "Email"
        loginTextField.borderStyle = .roundedRect
        loginTextField.autocapitalizationType = .none
        loginTextField.keyboardType = .emailAddress
        
        passwordTextField.placeholder = "Пароль"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        
        loginButton.setTitle("Войти", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        errorLabel.textColor = .red
        errorLabel.isHidden = true
        errorLabel.numberOfLines = 0
        
        let stackView = UIStackView(arrangedSubviews: [welcomeImageView, titleLabel, loginTextField, passwordTextField, loginButton, errorLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            welcomeImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    @objc func loginButtonTapped() {
        let login = loginTextField.text ?? ""
                let password = passwordTextField.text ?? ""
                
                if validateEmail(login) && validatePassword(password) {
                    if let user = users.first(where: { $0.0 == login && $0.1 == password })?.2 {
                        currentUser = user
                        saveLoginState(email: user.email)
                        showProfileView()
                    } else {
                        showError("Неверный логин или пароль")
                    }
                } else {
                    showError("Некорректный формат email или пароля")
                }
            }
            
            func showProfileView() {
                view.subviews.forEach { $0.removeFromSuperview() }
                setupBackground()
                
                guard let user = currentUser else { return }
                
                // Установка текста "Профиль"
                profileTitleLabel.text = "Профиль"
                profileTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
                profileTitleLabel.textAlignment = .center
                profileTitleLabel.textColor = .black
                profileTitleLabel.translatesAutoresizingMaskIntoConstraints = false
                
                avatarImageView.image = UIImage(named: user.avatar)
                avatarImageView.contentMode = .scaleAspectFill
                avatarImageView.layer.cornerRadius = 60
                avatarImageView.clipsToBounds = true
                avatarImageView.translatesAutoresizingMaskIntoConstraints = false
                avatarImageView.layer.borderColor = UIColor.white.cgColor
                avatarImageView.layer.borderWidth = 2
                
                nameLabel.text = "\(user.name) \(user.surname)"
                nameLabel.textAlignment = .center
                nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
                
                emailLabel.text = user.email
                emailLabel.textAlignment = .center
                emailLabel.textColor = .gray
                
                logoutButton.setTitle("Выйти", for: .normal)
                logoutButton.backgroundColor = .systemRed
                logoutButton.setTitleColor(.white, for: .normal)
                logoutButton.layer.cornerRadius = 5
                logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
                logoutButton.translatesAutoresizingMaskIntoConstraints = false
                
                let stackView = UIStackView(arrangedSubviews: [profileTitleLabel, avatarImageView, nameLabel, emailLabel, logoutButton])
                stackView.axis = .vertical
                stackView.spacing = 20
                stackView.translatesAutoresizingMaskIntoConstraints = false
                
                view.addSubview(stackView)
                
                NSLayoutConstraint.activate([
                    stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    avatarImageView.heightAnchor.constraint(equalToConstant: 300),
                    avatarImageView.widthAnchor.constraint(equalToConstant: 80),
                    logoutButton.heightAnchor.constraint(equalToConstant: 44)
                ])
            }
            
            @objc func logoutButtonTapped() {
                UserDefaults.standard.removeObject(forKey: "loggedInUserEmail")
                currentUser = nil
                view.subviews.forEach { $0.removeFromSuperview() }
                setupBackground()
                setupLoginView()
            }
            
            func showError(_ message: String) {
                errorLabel.text = message
                errorLabel.isHidden = false
            }
            
            // MARK: - Валидация
            
            func validateEmail(_ email: String) -> Bool {
                let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
                let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
                return emailPredicate.evaluate(with: email)
            }
            
            func validatePassword(_ password: String) -> Bool {
                let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,}$"
                let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
                return passwordPredicate.evaluate(with: password)
            }
            
            // MARK: - Сохранение состояния
    func saveLoginState(email: String) {
            UserDefaults.standard.set(email, forKey: "loggedInUserEmail")
        }
        
        func isUserLoggedIn() -> Bool {
            if let email = UserDefaults.standard.string(forKey: "loggedInUserEmail"),
               let user = users.first(where: { $0.2.email == email })?.2 {
                currentUser = user
                return true
            }
            return false
        }
    }
