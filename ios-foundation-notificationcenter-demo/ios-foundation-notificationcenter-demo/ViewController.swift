//
//  ViewController.swift
//  ios-foundation-notificationcenter-demo
//
//  Created by OkuderaYuki on 2017/02/15.
//  Copyright © 2017年 YukiOkudera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let nc = NotificationCenter.default
    var observers: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNotifications()
    }
    
    // 別の画面へ遷移したら、通知を解除する
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //MARK: selectorを使用して通知を登録している場合
        // 特定の通知のみ解除する
        NotificationCenter.default.removeObserver(self, name: .UIApplicationUserDidTakeScreenshot, object: nil)
        
        // すべての通知を解除する
        NotificationCenter.default.removeObserver(self)
        
        //MARK: closureを使用して通知を登録している場合
        if let observers = observers {
            NotificationCenter.default.removeObserver(observers)
            self.observers = nil
        }
    }
    
    /// 通知を登録する
    private func registerNotifications() {
        
        //MARK: あらかじめ定義されている通知名を使用して通知を登録する
        
        /*
         selector版
         ユーザがスクリーンショットを撮ったことを検知する
         通知された時に呼ばれる処理をSelectorで指定する
         */
        nc.addObserver(self,
                       selector: #selector(type(of: self).detectUserDidTakeScreenshot),
                       name: .UIApplicationUserDidTakeScreenshot,
                       object: nil)

        /*
         closure版
         端末の向きが変わったことを検知する
         通知された時に呼ばれる処理をClosureで直接記述する
         */
        observers = nc.addObserver(forName: .UIDeviceOrientationDidChange,
                                   object: nil,
                                   queue: nil,
                                   using: { (notification) in
                                    
                                    print("\(notification.name.rawValue)が通知されました。")
                                    let currentOrientation = UIDevice.current.orientation
                                    if UIDeviceOrientationIsLandscape(currentOrientation) {
                                        print("横向きになりました。")
                                    } else if UIDeviceOrientationIsPortrait(currentOrientation) {
                                        print("縦向きになりました。")
                                    }
        })
        
        //MARK: 自作の通知名を使用して通知を登録する
        nc.addObserver(self,
                       selector: #selector(type(of: self).detectCustomNotification),
                       name: .customNotification,
                       object: nil)

        // 1回限りの通知（tokenをプロパティで保持する必要なし）
        var token: NSObjectProtocol!
        token = nc.addObserver(forName: .oneTimeOnlyNotification, object: nil, queue: nil) { (notification) in
            // 2回目以降はボタンタップしてもprint出力されない
            print("1回限りの通知: \(notification)")
            self.nc.removeObserver(token)
        }
    }
    
    //MARK:- 通知された時に呼ばれる処理
    @objc private func detectUserDidTakeScreenshot(notification: Notification) {
        print("\(notification.name.rawValue)が通知されました。")
    }
    
    @objc private func detectCustomNotification(notification: Notification) {
        print("\(notification.name.rawValue)が通知されました。")
        
        /*
         通知で文字列を受け取っていたらタイトルに使用する
         受け取っていなければ、タイトルは空文字にする
         */
        let title = notification.object as? String ?? ""
        
        let message = String(format: "%@が通知されました。", notification.name.rawValue)
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        
        // アラートを表示する
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- ボタンタップイベント
    @IBAction func tappedPostButton(_ sender: Any) {
        
        // ボタンタップでcustomNotificationの通知を送る
        nc.post(name: .customNotification, object: nil)
        
        // 通知を送る際にObjectを渡す場合
//        let postObject = "NotificationCenter-demo"
//        nc.post(name: .customNotification, object: postObject)

        // MARK: - oneTimeOnlyNotification
        nc.post(name: .oneTimeOnlyNotification, object: nil)
    }
}

/// あらかじめ定義されている通知名と同じように使用するためにExtensionで自作の通知名を定義する
extension NSNotification.Name {
    static let customNotification = NSNotification.Name("customNotification")

    // Notification.NameでもOK -> typealiasでName = NSNotification.Name と定義されているため
    static let oneTimeOnlyNotification = Notification.Name("oneTimeOnlyNotification")
}
