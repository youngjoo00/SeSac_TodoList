//
//  AppDelegate.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/14/24.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // 현재 사용되는 스키마 버전 입력
        let configuration = Realm.Configuration(schemaVersion: 6) { migration, oldSchemaVersion in
            
            // 0
            
            // 1: TodoModel Table 에 favorite 컬럼 추가
            if oldSchemaVersion < 1 {
                print("Schema Version 0 -> 1")
                print("단순히 컬럼 추가는 뭘 해줄 필요 없음")
            }
            
            // 2: TodoModel Table 에 favorite 컬럼 삭제
            if oldSchemaVersion < 2 {
                print("Schema Version 0 -> 1")
                print("컬럼 삭제도 뭘 해줄 필요 없음")
            }
            
            // 3: TodoModel Table 에 star 컬럼 추가
            if oldSchemaVersion < 3 { }
            
            // 4. TodoModel Table 에 컬럼 이름 변경 from: star -> to: favorite
            if oldSchemaVersion < 4 {
                migration.renameProperty(onType: TodoModel.className(), from: "star", to: "favorite")
            }
            
            // 5. TodoModel Table 에 testDescription 컬럼 추가
            if oldSchemaVersion < 5 {
                migration.enumerateObjects(ofType: TodoModel.className()) { oldObject, newObject in
                    
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    // 오타 내지 맙시다..
                    new["testDescription"] = "이거저거 \(old["title"]!) 랑 \(old["memo"]!) 묶어서 한번에 표시하기에 좋겠네요!"
                }
            }
            
            // 6. TodoModel Table 에 favorite 컬럼 타입 변경 bool -> Int
            // 사용 예시 ex) 0: 아직 별 생각 없어요, 1: 흥미로워요, 2: 좋아요, 3: 많이 좋아요
            if oldSchemaVersion < 6 {
                migration.enumerateObjects(ofType: TodoModel.className()) { oldObject, newObject in
                    
                    guard let new = newObject else { return }
                    new["favorite"] = 0
                }
            }
            
        }
        
        // 이 앱에서 사용할 버전 등록
        Realm.Configuration.defaultConfiguration = configuration
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

