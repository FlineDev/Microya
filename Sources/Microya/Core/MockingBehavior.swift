import Foundation
import CombineSchedulers

/// The behavior when mocking is turned on.
public struct MockingBehavior<EndpointType: Endpoint> {
  /// Mocked data should be returned after the given delay.
  public let delay: DispatchQueue.SchedulerTimeType.Stride

  /// Mocked data should be returned on the given dispatch queue.
  public let scheduler: AnySchedulerOf<DispatchQueue>

  /// Defines how the mocked reponse is retrieved from an endpoint. Defaults to just returning the endpoints `mockedResponse`.
  public let mockedResponseProvider: (EndpointType) -> MockedResponse?

  /// Creates a mocking behavior where mocked data should be returned after the given delay and on the given dispatch queue.
  public init(
    delay: DispatchQueue.SchedulerTimeType.Stride,
    scheduler: AnySchedulerOf<DispatchQueue>,
    mockedResponseProvider: @escaping (EndpointType) -> MockedResponse? = { $0.mockedResponse }
  ) {
    self.delay = delay
    self.scheduler = scheduler
    self.mockedResponseProvider = mockedResponseProvider
  }
}
