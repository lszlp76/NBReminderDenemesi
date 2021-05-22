//
//  FeedCell.swift
//  PlantInsta
//
//  Created by ulas özalp on 19.04.2021.
//

import UIKit

//2 tableview ozelliğine protocol ekleniyor. Bu protokolun içine yapılacak method yazılır
// class ın dışına yazman lazım

 protocol TableViewNew {
     func onClickedTrash(index : Int )   // silme tuşu için bir fonksiyon
    func onClickedShare(index : Int)     // paylaşma butonu için bir fonksiyon
    func onClickedDownload ( index : Int) // indirme için buton
}

class FeedCell: UITableViewCell {
    /**
     TablecellView içinde bir tablecell de herhangi bir eleman tıklanma olduğunda
     farklı davranması için bir yöntem var.
     başındaki nolar sırayı gösteriyor.
     
     
     
     */

    
    
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var commentText: UILabel!
    
    // 1 tıklanacak elemanlar action olarak buraya bağlanır
    //androidde ki recycler view adapter mantığına benzer bir mantıkla yapıyor
    
    @IBAction func shareButton(_ sender: Any) {
        //4 aksiyon içinde protokolu çalıştır
        cellDelegate?.onClickedShare(index: index.row)
    }
    @IBAction func downloadButton(_ sender: Any) {
        //4 aksiyon içinde protokolu çalıştır
        cellDelegate?.onClickedDownload(index: index.row)
    }
    @IBAction func trashButtonClicked(_ sender: Any) {
        
    //4 aksiyon içinde protokolu çalıştır
        cellDelegate?.onClickedTrash(index: index.row)
    }
    
   
    //3 cell delegate yaratman lazım.Bunun yarattığın protokola bağlıyorsun
    var cellDelegate: TableViewNew?
    var index: IndexPath = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    
        // 5 tableviewin tanımlandığı controllera git
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
