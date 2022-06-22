import UIKit

class PokeDetailViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblAbility: UILabel!
    @IBOutlet weak var lblPokedexId: UILabel!
    var Pokemon: Pokemon!
    
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
        }
    }
    
    func getMultipleData(){
        for i in Pokemon.types{
            lblType?.text! += "\(i.type.name) | "
        }
        
        for i in Pokemon.abilities{
            lblAbility?.text! += "\(i.ability.name) | "
        }
    }
}
