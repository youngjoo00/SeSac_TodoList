//
//  TodoTableRepository.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/16/24.
//

import Foundation
import RealmSwift

final class TodoTableRepository {
    
    private let realm = try! Realm()
    
    func createItem(item: TodoModel) {
        do {
            try realm.write {
                realm.add(item)
                print("Realm Create", realm.configuration.fileURL!)
            }
        } catch {
            print("error")
        }
    }
    
    func fetch() -> Results<TodoModel> {
        return realm.objects(TodoModel.self)
    }
    
    /// 받아온 데이터를 각 필터링에 맞게 카운트를 올려줌
    func fetchTodoListCount() -> [TodoList: Int] {
        let data = fetch()

        let todayDate = CustomDateFormatter.todayDate()
        
        let todayCount = data.where {
            $0.deadLineDate == todayDate && $0.complete == false
        }.count
        
        let expectedCount = data.where {
            $0.deadLineDate != todayDate && $0.complete == false
        }.count
        
        let allCount = data.count
        
        let completeCount = data.where {
            $0.complete
        }.count
        
        return [.today: todayCount, .expected: expectedCount, .all: allCount, .complete: completeCount]
    }
    
    /// TodoModel 타입의 item 을 매개변수로 넣으면 complete 변환
    func updateComplete(_ item: TodoModel) {
        do {
            try realm.write {
                item.complete.toggle()
            }
        } catch {
            print(error)
        }
    }
}
