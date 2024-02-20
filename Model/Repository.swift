//
//  TodoTableRepository.swift
//  SeSac_TodoList
//
//  Created by youngjoo on 2/16/24.
//

import Foundation
import RealmSwift

final class Repository {
    
    private let realm = try! Realm()
    
    func createItem<T: Object>(item: T) {
        do {
            try realm.write { // 쓰기 트랜잭션을 시작하는 메서드
                realm.add(item)
                print("Realm Create", realm.configuration.fileURL!)
            }
        } catch {
            print("error")
        }
    }
    
    /// List 내부의 todoList 에 todo 레코드 삽입
    func createTodoList(list: ListModel, todo: TodoModel) {
        do {
            try realm.write {
                list.todoList.append(todo)
            }
        } catch {
            print("error", error)
        }
    }
    /// 테이블 가져오기
    func fetchTable<T: Object>() -> Results<T> {
        return realm.objects(T.self)
    }
    
    /// 받아온 데이터를 각 필터링에 맞게 카운트를 올려줌
    func fetchTodoListCount() -> [TodoList: Int] {
        
        let todayCount = fetchFilterToday().count
        
        let expectedCount = fetchFilterExpected().count
        
        let allCount = fetch().count
        
        let completeCount = fetchFilterComplete().count
        
        return [.today: todayCount, .expected: expectedCount, .all: allCount, .complete: completeCount]
    }
    
    /// 원하는 컬럼 기준으로 오름차순 or 내림차순정렬 후 가져오기
    func fetchSortColumn(table: Results<TodoModel>,_ byKeyPath: Todo, ascending: Bool) -> Results<TodoModel> {
        return table.sorted(byKeyPath: byKeyPath.rawValue, ascending: ascending)
    }

    func fetchFilterRowPriority(table: Results<TodoModel>) -> Results<TodoModel> {
        return table.where {
            $0.priority == 1
        }
    }
    
    /// record 삭제, TodoModel 을 갖는 아이템을 매개변수로 사용
    func deleteItem<T: Object>(_ item: T) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
    /// TodoList 열거형의 case.rawValue == text 일 경우 해당하는 함수 실행해서 값 가져옴
    func fetchFilterTodoList(navTitleText text: String) -> Results<TodoModel> {
        switch text {
        case TodoList.today.rawValue:
            return fetchFilterToday()
        case TodoList.expected.rawValue:
            return fetchFilterExpected()
        case TodoList.all.rawValue:
            return fetch()
        case TodoList.complete.rawValue:
            return fetchFilterComplete()
        default:
            return fetch()
        }
    }
    
    func updateItem(_ item: TodoModel, title: String, memo: String, deadLineDate: Date, tag: String?, priority: Int) {
        do {
            try realm.write {
                realm.create(TodoModel.self, value: ["id": item.id, "title": title, "memo": memo, "deadLineDate": deadLineDate, "tag": tag ?? "", "priority": priority], update: .modified)
            }
        } catch {
            print("Failed to update item: \(error)")
        }
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

// MARK: - Private
extension Repository {
    
    /// 전체 테이블 값 가져오기
    private func fetch() -> Results<TodoModel> {
        return realm.objects(TodoModel.self)
    }
    
    /// 오늘 날짜값만 필터링해서 가져옵니다.
    private func fetchFilterToday() -> Results<TodoModel> {
        return fetch().filter(DateManager.shared.query(queryType: .today, date: Date()))
    }
    
    /// 예정된 날짜만 필터링해서 가져옵니다.
    private func fetchFilterExpected() -> Results<TodoModel> {
        return fetch().filter(DateManager.shared.query(queryType: .expected, date: Date()))
    }
    
    private func fetchFilterComplete() -> Results<TodoModel> {
        return fetch().where {
            $0.complete == true
        }
    }
    
}
