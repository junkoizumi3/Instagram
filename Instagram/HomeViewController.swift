//
//  HomeViewController.swift
//  Instagram
//
//  Created by 和泉淳子 on 2022/09/26.
//

import UIKit
import Firebase

 class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    //投稿データを格納する配列
    var postArray:[PostData]=[]
    
    //Firestoreのリスナー
    var listener: ListenerRegistration?
     
     
      private var myInputAccessoryView: InputAccessoryView = {
          let view = InputAccessoryView()
          view.frame = .init(x:0,y:0,width:view.frame.width,height:100)
          return view
      }()

     
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        
        //カスタムセルを登録する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        //self.textView.becomeFirstResponder()

    }
    
     
     override var inputAccessoryView:UIView?{
         get{
             return myInputAccessoryView
         }
     }
     
     /*override var canBecomeFirstResponder:Bool{
         return true
     }*/
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        //ログイン済みか確認
        if Auth.auth().currentUser != nil{
            //listnerを登録して投稿データの更新を監視する
            let postRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
            listener = postRef.addSnapshotListener(){(querySnapshot,error) in
                if let error = error{
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。\(error)")
                    return
                }
                
                //取得したdocumentを元にPostDataを作成し、postArrayの配列にする
                self.postArray = querySnapshot!.documents.map{document in print("DEBUG_PRINT:document取得\(document.documentID)")
                    let postData = PostData(document: document)
                    return postData
                }
                //TableViewの表示を更新する
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: ViewWillDisappear")
        //listenerを削除　監視を停止
        listener?.remove()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        //セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action: #selector(tapLike(_:forEvent:)), for: .touchUpInside)
        
        //コメントボタンを押した時の処理
        cell.commentButton.addTarget(self, action: #selector(tapComment(_:forEvent:)), for: .touchUpInside)
        

        return cell
    }
    
    //セル内の❤️ボタンがタップされた時に呼ばれるメソッド
    @objc func tapLike(_ sender:UIButton,forEvent event: UIEvent){
        print("DEBUG_PRINT: Likeボタンがタップされました")
        
        //タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        //配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        //likesを更新する
        if let myid = Auth.auth().currentUser?.uid{
            //更新データを作成する
            var updateValue:FieldValue
            if postData.isLiked{
                //すでにいいねをしてたら解除、myidを取り除く更新データ作成
                updateValue = FieldValue.arrayRemove([myid])
            }else{
                //今回あらたないいねならmyidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            //likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
    }
    
    //セル内のコメントボタンがタップされた時に呼ばれるメソッド
    @objc func tapComment(_ sender:UIButton,forEvent event: UIEvent){

        
        //タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        //配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
 
        
        //commentViewControllerに遷移
        let commentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Comment") as! CommentViewController
        commentViewController.postdata=postData
        self.present(commentViewController, animated: true, completion: nil)
        
       

         }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


