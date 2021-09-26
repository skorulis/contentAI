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
    let contentAccess: ContentAccess
    
    @Published var operations: [POperator] = []
    @Published var operationNodes: [OperatorNode.NodeStatus] = []
    @Published var activeContent: ContentItem?
    @Published var selectedNode: OperatorNode?
    
    @Published var output: StorageOperator = .init()
    
    private var subscribers: Set<AnyCancellable> = []
    
    @Published var mlJob: MLJob<MLImageClassifier>?
    
    @Published var output2: QueryPager?
    
    nonisolated init(project: Project,
         contentAccess: ContentAccess,
         factory: GenericFactory
    ) {
        self.project = project
        self.contentAccess = contentAccess
        Task {
            await initIsolated()
        }
    }
    
    private func initIsolated() async {
        operations = [
            SourceOperator(sources: project.inputs, access: contentAccess),
            FilterOperator(),
            //PreloadOperation(factory: factory),
            //TrainModelOperator(factory: factory)
            ]
        operationNodes = buildProcesss()
        
        output2 = QueryPager(access: contentAccess, baseQuery: outputQuery, rowMap: { row in
            return try! ContentAccess.ContentTable.extract(row: row)
        })
        
        for o in operations {
            await o.processWaiting()
        }
        for o in operationNodes {
            await o.node.updateCount(access: contentAccess)
        }
        self.objectWillChange.send()
    }
    
    func buildProcesss() -> [OperatorNode.NodeStatus] {
        var nodes = [OperatorNode]()
        var query: Table = ContentAccess.ContentTable.table
        
        for i in (0..<operations.count).reversed() {
            let node = OperatorNode(operation: operations[i], delegate: self, inputQuery: query)
            query = node.outputQuery
            nodes.append(node)
        }
        return nodes.reversed().map { node in
            return OperatorNode.NodeStatus(node: node, status: .init(count: 0))
        }
    }
    
    var outputQuery: Table {
        var result: Table = ContentAccess.ContentTable.table
        for op in operations {
            result = op.query(inputQuery: result)
        }
        return result
    }
    
}

// MARK: - Behaviors

extension ProjectOutputViewModel {
    
    func next() {
        guard let current = activeContent,
              let index = self.output.storage.firstIndex(where: {$0.id == current.id} ),
              index < self.output.storage.count - 1
        else { return }
        activeContent = self.output.storage[index + 1]
        objectWillChange.send()
    }
    
    func train() {
        
        var labeledFiles = [String: [URL]]()
        labeledFiles["upvote"] = []
        labeledFiles["downvote"] = []
        for content in self.output.storage {
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
        guard let index = self.operationNodes.firstIndex(where: {$0.node.id == id} ) else { return }
        self.operationNodes[index].status = status
    }
}

