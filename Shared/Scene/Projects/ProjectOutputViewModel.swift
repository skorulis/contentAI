//
//  ProjectOutputViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 4/9/21.
//

import Combine
import Foundation
import CreateML
import SQLite

@MainActor
final class ProjectOutputViewModel: ObservableObject {
    
    let project: Project
    let factory: GenericFactory
    let contentAccess: ContentAccess
    
    @Published var operations: [POperator] = []
    @Published var operationNodes: [OperatorNode] = []
    @Published var activeContent: ContentItem?
    @Published var selectedNode: OperatorNode?
    
    private var subscribers: Set<AnyCancellable> = []
    
    @Published var mlJob: MLJob<MLImageClassifier>?
    
    var output: QueryPager?
    
    nonisolated init(project: Project,
         contentAccess: ContentAccess,
         factory: GenericFactory
    ) {
        self.project = project
        self.contentAccess = contentAccess
        self.factory = factory
        Task {
            await initIsolated()
        }
    }
    
    private func initIsolated() async {
        operations = [
            SourceOperator(sources: project.inputs, access: contentAccess),
            FilterOperator(),
            PreloadOperation(factory: factory),
            SortOperator()
            //TrainModelOperator(factory: factory)
            ]
        operationNodes = buildProcesss()
        
        output = QueryPager(access: contentAccess, baseQuery: outputQuery, rowMap: { row in
            return try! ContentAccess.ContentTable.extract(row: row)
        })
        
        output?.objectWillChange
            .sink { [unowned self] _ in
                self.objectWillChange.send()
            }
            .store(in: &subscribers)
        
        var inputQuery = ContentAccess.ContentTable.table
        for o in operations {
            await o.processWaiting(inputQuery: inputQuery)
            inputQuery = o.query(inputQuery: inputQuery)
            self.objectWillChange.send()
        }
        for o in operationNodes {
            await o.updateCount(access: contentAccess)
        }
        self.objectWillChange.send()
    }
    
    func buildProcesss() -> [OperatorNode] {
        var nodes = [OperatorNode]()
        var query: Table = ContentAccess.ContentTable.table
        
        for i in (0..<operations.count) {
            let node = OperatorNode(operation: operations[i], delegate: self, inputQuery: query)
            query = node.outputQuery
            nodes.append(node)
        }
        
        return nodes
    }
    
    var outputQuery: Table {
        var result: Table = ContentAccess.ContentTable.table
        for op in operations {
            result = op.query(inputQuery: result)
        }
        return result
    }
    
    var loaded: [ContentItem] {
        return self.output?.loaded ?? []
    }
    
}

// MARK: - Behaviors

extension ProjectOutputViewModel {
    
    func next() {
        guard let current = activeContent,
              let index = self.loaded.firstIndex(where: {$0.id == current.id} ),
              index < self.loaded.count - 1
        else { return }
        activeContent = self.loaded[index + 1]
        objectWillChange.send()
    }
    
    func train() {
        
        var labeledFiles = [String: [URL]]()
        labeledFiles["upvote"] = []
        labeledFiles["downvote"] = []
        for content in loaded {
            guard let url = PreloadOperation.filename(url: content.url!) else { continue }
            guard content.viewed else { continue }
            if content.labels.contains("upvote") {
                labeledFiles["upvote"]?.append(url)
            } else if content.labels.contains("downvote") {
                labeledFiles["downvote"]?.append(url)
            }
        }
        
        do {
            let data = MLImageClassifier.DataSource.filesByLabel(labeledFiles)
            let job = try MLImageClassifier.train(trainingData: data)
            self.mlJob = job
            job.result
                .sink { result in
                    switch result {
                    case .success(let mlc):
                        print("Training done \(mlc)")
                    case .failure(let error):
                        print("training error \(error)")
                    }

                }
                .store(in: &subscribers)
            Timer.publish(every: 10, on: .main, in: .common).autoconnect()
                .sink { [unowned self] _ in
                    self.objectWillChange.send()
                }
                .store(in: &subscribers)
        } catch {
            print("Training error \(error)")
        }
        
    }
    
    func select(node: OperatorNode) {
        self.selectedNode = node
    }
    
}

// MARK: - Non isolated behaviors

extension ProjectOutputViewModel {
    
    nonisolated func selectAsync(node: OperatorNode) {
        Task { await select(node: node) }
    }
    
    nonisolated func trainAsync() {
        Task { await train() }
    }
    
    nonisolated func nextAsync() {
        Task { await next() }
    }
}



// MARK: - OperatorNodeDelegate

extension ProjectOutputViewModel: OperatorNodeDelegate {
    
    func statusChanged(id: String, status: OperatorNode.Status) async {
        guard let index = self.operationNodes.firstIndex(where: {$0.id == id} ) else { return }
        //self.operationNodes[index].status = status
    }
}

