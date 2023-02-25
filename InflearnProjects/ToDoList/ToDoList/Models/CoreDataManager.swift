//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by DongKyu Kim on 2023/02/24.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    let modelName: String = "MemoData"
    
    
    // MARK: [Create]
    func saveToDoData(moemoText: String?, colorInt: Int64, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                if let memoData = NSManagedObject(entity: entity, insertInto: context) as? MemoData {
                    
                    // MemoData에 실제 데이터 할당
                    memoData.memoText = moemoText
                    memoData.date = Date()
                    memoData.color = colorInt
                    
                    if context.hasChanges {
                        do {
                            try context.save()
                            completion()
                        } catch {
                            print(error)
                            completion()
                        }
                    }
                }
            }
        }
        completion()
    }
    
    
    // MARK: [Read]
    func getToDoListFromCoreData() -> [MemoData] {
        var toDoList: [MemoData] = []
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            let dateOrder = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [dateOrder]
            
            do {
                if let fetchedToDoList = try context.fetch(request) as? [MemoData] {
                    toDoList = fetchedToDoList
                }
            } catch {
                print("가져오기 실패")
            }
        }
        
        return toDoList
    }
    
    // MARK: [Update]
    func updateToDo(newToDoData: MemoData, completion: @escaping ()  -> Void) {
        guard let date = newToDoData.date else {
            completion()
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
            
            do {
                if let fetchedToDoList = try context.fetch(request) as? [MemoData] {
                    if var _ = fetchedToDoList.first {
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
            } catch {
                print("지우기 실패")
                completion()
            }
        }
    }
    
    // MARK: [Delete]
    func deleteToDo(data: MemoData, completion: @escaping () -> Void) {
        guard let date = data.date else {
            completion()
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            
            request.predicate = NSPredicate(format: "data", date as CVarArg)
            
            do {
                // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기) (fetch메서드)
                if let fetchedToDoList = try context.fetch(request) as? [MemoData] {
                    
                    // 임시저장소에서 (요청서를 통해서) 데이터 삭제하기 (delete메서드)
                    if let targetToDo = fetchedToDoList.first {
                        context.delete(targetToDo)
                        
                        //appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("지우는 것 실패")
                completion()
            }
        }
        
    }
    
}
