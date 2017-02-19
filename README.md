# NotificationCenter

## 概要
NotificationCenterは、イベントの通知をするためのクラスです。<br>あるイベントが発生した時に別のクラスでそのイベントを検知したい場合に使用します。
## 関連クラス
NSObject
## 主要プロパティ

| プロパティ名 | 説明 | サンプル |
|:-----------:|:------------:|:------------:|
| default | デフォルトの通知センターを取得する | let center = NSNotificationCenter.defaultCenter() |
## 主要メソッド

| メソッド名 | 説明 | サンプル |
|:-----------:|:------------|:------------|
| addObserver(forName:object:queue:using:) | 通知名を設定して通知を登録する<br>通知受信時の処理は、クロージャで記述する | observers = center.addObserver(forName: .UIDeviceOrientationDidChange,<br> object: nil,<br> queue: nil,<br>using: { (notification) in<br>   print("通知されました。\n\(notification)")<br>}) |
| addObserver(_:selector:name:object:) | 通知名を設定して通知を登録する<br>通知受信時の処理は、セレクタで指定する | center.addObserver(self,<br> selector: #selector(type(of: self).detectDidBecomeActive),<br> name: .UIApplicationDidBecomeActive,<br> object: nil) |
| removeObserver(_:) | 指定したオブザーバに登録されている全ての通知を削除する | center.removeObserver(self) |
| removeObserver(_:name:object:)  | 指定したオブザーバに登録されている通知のうち、通知名が一致するものを削除する | center.removeObserver(self, name: .UIApplicationUserDidTakeScreenshot, object: nil) |
| post(name:object:) | 名前を指定して通知を作成し、それを受信者に通知する | center.post(name: .customNotification, object: nil) |
## フレームワーク
Foundation.framework

## 開発環境
| Category | Version |
|:-----------:|:------------:|
| Swift | 3.0.2 |
| Xcode | 8.2.1 |
| iOS | 10.0~ |

## 参考
https://developer.apple.com/reference/foundation/notificationcenter
