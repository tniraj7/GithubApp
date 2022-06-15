import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let diffVC = storyBoard.instantiateViewController(identifier: "DiffVC", creator: { coder in
            return DiffVC.init(viewModel: constructViewModel(), coder: coder)
        })
        diffVC.title = "Github Search"
        
        let navigationController = UINavigationController(rootViewController: diffVC)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

}

//MARK: - SEAM

func constructViewModel() -> ViewModel{
    let client = HttpClient(session: .shared)
    let service = GithubService(client: client)
    let repository = GithubDataFacade(service)
    return ViewModel(repository)
}
