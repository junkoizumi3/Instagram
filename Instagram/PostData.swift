//
//  PostData.swift
//  Instagram
//
//  Created by 和泉淳子 on 2022/10/06.
//

import Foundation
import Firebase

class PostData:NSObject{
    var id:String
    var name:String?
    var caption:String?
    var date:Date?
    var likes:[String]=[]
    var isLiked:Bool=false
    var comment:[String]=[]
    
    init(document:QueryDocumentSnapshot){
        self.id = document.documentID
        let postDic = document.data()
        self.name=postDic["name"]as?String
        self.caption=postDic["caption"]as?String
        let timestamp=postDic["date"]as?Timestamp
        self.date=timestamp?.dateValue()

        if let likes = postDic["likes"]as?[String]{
            self.likes=likes
        }
        if let myid = Auth.auth().currentUser?.uid{
            //likesの配列の中にmyidがあるのかチェック→いいねを押しているか
            if self.likes.firstIndex(of: myid) != nil{
                self.isLiked=true
            }
        }
        //コメント
        if  let comment = postDic["comment"]as?[String]{
            print(comment)
            self.comment = comment.map { $0 + "\n"}
            
        }
        

    }
}
