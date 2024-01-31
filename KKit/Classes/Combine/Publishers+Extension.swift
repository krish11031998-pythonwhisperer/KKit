//
//  Publishers+Extension.swift
//  KKit
//
//  Created by Krishna Venkatramani on 31/01/2024.
//

import Combine

public typealias StandardError = Error & LocalizedError

public typealias SharePublisher<T,E: Error> = Publishers.MakeConnectable<Publishers.Share<AnyPublisher<T,E>>>
public typealias ConnectablePublisher<T,E: Error> = Publishers.MakeConnectable<AnyPublisher<T, E>>
public typealias StringPublisher<E: Error> = AnyPublisher<String, E>
public typealias BoolPublisher<E: Error> = AnyPublisher<Bool, E>
public typealias IntPublisher<E: Error> = AnyPublisher<Int, E>
public typealias VoidPublisher = AnyPublisher<Void, Never>


//MARK: - Publisher

public extension Publisher {
    
    func withUnretained<T: AnyObject>(_ obj: T) -> AnyPublisher<(T, Self.Output), Self.Failure> {
        self.tryMap { [weak obj] in
            guard let validObj = obj else { throw ObjectError.objectOutOfMemory }
            return (validObj, $0)
        }
        .catch {
            Swift.print("(DEBUG) err : ", $0.localizedDescription)
            return Empty(outputType: (T, Self.Output).self, failureType: Self.Failure.self)
        }
        .eraseToAnyPublisher()
    }
    
    func sinkReceive(_ receiveCompletion: @escaping (Self.Output) -> Void) -> AnyCancellable {
        self
            .receive(on: DispatchQueue.main)
            .sink {
                switch $0 {
                case .failure(let err):
                    Swift.print("(ERROR) err: ", err)
                case .finished:
                    Swift.print("(FINISHED) finished")
                }
            } receiveValue: { receiveCompletion($0) }

    }
    
    func justSink() -> AnyCancellable {
        self.sink { completion in
            switch completion {
            case .finished:
                Swift.print("(JUST SINK) Finished!")
            case .failure(let err):
                Swift.print("(JUST SINK) Error: ", err.localizedDescription)
            }
        } receiveValue: { Swift.print("(JUST SINK) Received Val: ", $0) }
    }
    
    func mapToVoid() -> AnyPublisher<Void, Self.Failure> {
        self.map { _ in () }.eraseToAnyPublisher()
    }
}


//MARK: - Convenience

public extension Publisher {
    
    static func just(_ val: Self.Output) -> AnyPublisher<Self.Output, Self.Failure> {
        return Just(val).setFailureType(to: Self.Failure.self).eraseToAnyPublisher()
    }
    
    static func empty(completeImmediately: Bool) ->  AnyPublisher<Self.Output, Self.Failure> {
        return Empty(completeImmediately: completeImmediately, outputType: Self.Output.self, failureType: Self.Failure.self).eraseToAnyPublisher()
    }
}


//MARK: - CatchError

public extension Publisher {
    func catchWithError(errHandle: PassthroughSubject<String?, Error>,
                        withErr customErr: StandardError) -> AnyPublisher<Self.Output, Self.Failure>
    {
        self.catch { [weak errHandle] err -> AnyPublisher<Self.Output, Self.Failure> in
            Swift.print("(ERROR ‼️) err: ", err.localizedDescription)
            errHandle?.send(customErr.localizedDescription)
            return .empty(completeImmediately: true)
        }.eraseToAnyPublisher()
    }
}
