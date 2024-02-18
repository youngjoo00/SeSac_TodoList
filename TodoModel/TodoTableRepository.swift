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
            try realm.write { // 쓰기 트랜잭션을 시작하는 메서드
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
    
    /// 원하는 컬럼 기준으로 오름차순 or 내림차순정렬 후 가져오기
    func fetchSortColumn(_ byKeyPath: Todo, ascending: Bool) -> Results<TodoModel> {
        return fetch().sorted(byKeyPath: byKeyPath.rawValue, ascending: ascending)
    }

    func fetchFilterRowPriority() -> Results<TodoModel> {
        return fetch().where {
            $0.priority == 1
        }
    }
    
    /// record 삭제, TodoModel 을 갖는 아이템을 매개변수로 사용
    func deleteItem(_ item: TodoModel) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
}
