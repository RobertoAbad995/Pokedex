import UIKit

class PokeDetailViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblAbility: UILabel!
    @IBOutlet weak var lblPokedexId: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    
    var Pokemon: Pokemon!
    var favourite: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Pokemon.forms.count > 0
        {
            imgView.downloaded(from: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/\(Pokemon.id).png")
            lblName?.font = UIFont.boldSystemFont(ofSize: 16.0)
            lblName?.text = Pokemon.forms[0].name.uppercased()
            lblWeight?.text = "\(Pokemon.weight)"
            lblPokedexId?.text = "\(Pokemon.id)"
            getMultipleData()
            btnFav.setImage(UIImage(systemName: (favourite ? "star.fill" : "star")), for: .normal)
//            if favourite {
//                btnFav.setImage(UIImage(systemName: "star.fill"), for: .normal)
//            }
//            else{
//                btnFav.setImage(UIImage(systemName: "star"), for: .normal)
//            }
        }
    }
    
    func getMultipleData(){
        lblType?.text! = ""
        for i in Pokemon.types{
            lblType?.text! += "\(i.type.name) | "
        }
        lblAbility?.text! = ""
        for i in Pokemon.abilities{
            lblAbility?.text! += "\(i.ability.name) | "
        }
    }
    @IBAction func favouriteChange(_ sender: UIButton) {
        
//        let buttonTag = Pokemon.id
        favourite = !favourite
        btnFav.setImage(UIImage(systemName: (favourite ? "star.fill" : "star")), for: .normal)
        if favourite{
            UserDefaults.standard.favorites.remove(at: Pokemon.id)
        }
        else{
            UserDefaults.standard.favorites.append(Pokemon.id)
        }
//        if btnFav.currentImage?.isEqual(UIImage(systemName: "star")) {
//            btnFav.setImage(UIImage(systemName: "star.fill"), for: .normal)
//            UserDefaults.standard.favorites.append(buttonTag)
//        }else{
//            btnFav.setImage(UIImage(systemName: "star"), for: .normal)
//            if let num = UserDefaults.standard.favorites.firstIndex(of: buttonTag){
//                UserDefaults.standard.favorites.remove(at: num)
//            }
//        }
    }
}
