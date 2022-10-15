//
//  CommentViewController.swift
//  Instagram
//
//  Created by 和泉淳子 on 2022/10/11.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var CommentField: UITextField!
    @IBOutlet weak var HomeBack: UIButton!
    
    var postdata:PostData!
    var commentData:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func TapBack(_ sender: Any) {
        print("DEBUG_PRINT: 戻るボタンがタップされました")
        let HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        self.present(HomeViewController, animated: true, completion: nil)
    }
    
    
    //コメント投稿ボタンを押した時のメソッド
    @IBAction func CommentPostButton(_ sender:Any){
        
         // HUDで投稿処理中の表示を開始
         SVProgressHUD.show()
        
        //コメント投稿データを更新する
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postdata.id)
        let name = Auth.auth().currentUser?.displayName
        var newComment: String
        var updateValue:FieldValue
        newComment = String(name!) + ":" + self.CommentField.text!
        updateValue = FieldValue.arrayUnion([newComment])
        postRef.updateData(["comment": updateValue])
        
             // HUDで投稿完了を表示する
             SVProgressHUD.showSuccess(withStatus: "コメント投稿しました")
             
             // コメント投稿処理が完了したので先頭画面に戻る
             self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
         }
    
    //キャンセルボタンを押した時のメソッド
    @IBAction func CommentCancelButton(_ sender:Any){
        // 加工画面に戻る
        self.dismiss(animated: true, completion: nil)
    }


    }
