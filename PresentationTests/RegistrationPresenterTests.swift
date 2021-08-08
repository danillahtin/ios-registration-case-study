//
//  RegistrationPresenterTests.swift
//  PresentationTests
//
//  Created by Danil Lahtin on 07.08.2021.
//

import XCTest
import Presentation

final class RegistrationPresenterTests: XCTestCase {
    func test_didLoadView_displaysNotLoading() {
        let (sut, services) = makeSut()

        XCTAssertEqual(services.loadingViewModels, [])

        sut.didLoadView()
        XCTAssertEqual(services.loadingViewModels, [.init(isLoading: false)])
    }

    func test_didLoadView_displaysCorrectTitle() {
        let (sut, services) = makeSut()

        XCTAssertEqual(services.titleViewModels, [])

        sut.didLoadView()
        XCTAssertEqual(services.titleViewModels, [.init(title: "Registration")])
    }

    func test_didLoadView_displaysCorrectRegistrationViewModel() {
        let (sut, services) = makeSut()

        XCTAssertEqual(services.registrationViewModels, [])

        sut.didLoadView()
        XCTAssertEqual(services.registrationViewModels, [.init(cancelTitle: "Cancel", nextTitle: "Next", doneTitle: "Done")])
    }

    func test_didStartRegistration_displaysLoading() {
        let (sut, services) = makeSut()

        XCTAssertEqual(services.loadingViewModels, [])

        sut.didStartRegistration()
        XCTAssertEqual(services.loadingViewModels, [.init(isLoading: true)])
    }

    func test_didStartRegistration_displaysNoError() {
        let (sut, services) = makeSut()

        XCTAssertEqual(services.errorViewModels, [])

        sut.didStartRegistration()
        XCTAssertEqual(services.errorViewModels, [.init(message: nil)])
    }

    func test_didFinishRegistration_displaysNotLoading() {
        let (sut, services) = makeSut()

        XCTAssertEqual(services.loadingViewModels, [])

        sut.didFinishRegistration()
        XCTAssertEqual(services.loadingViewModels, [.init(isLoading: false)])
    }

    func test_didFinishRegistrationWithError_displaysNotLoading() {
        let (sut, services) = makeSut()

        XCTAssertEqual(services.loadingViewModels, [])

        sut.didFinishRegistration(with: makeError())
        XCTAssertEqual(services.loadingViewModels, [.init(isLoading: false)])
    }

    func test_didFinishRegistrationWithError_displaysErrorView() {
        let (sut, services) = makeSut()

        XCTAssertEqual(services.errorViewModels, [])

        sut.didFinishRegistration(with: makeError("some error"))
        XCTAssertEqual(services.errorViewModels, [.init(message: "some error")])

        sut.didFinishRegistration(with: makeError("another error"))
        XCTAssertEqual(services.errorViewModels, [
            .init(message: "some error"),
            .init(message: "another error"),
        ])
    }

    func test_givenErrorViewIsDisplayed_whenTimePass_thenErrorViewIsNotDisplayed() {
        let (sut, services) = makeSut()

        sut.didFinishRegistration(with: makeError("some error"))
        XCTAssertEqual(services.errorViewModels, [.init(message: "some error")])

        services.simulateTimePassed(seconds: 4.9)
        XCTAssertEqual(services.errorViewModels, [
            .init(message: "some error"),
        ])

        services.simulateTimePassed(seconds: 0.2)
        XCTAssertEqual(services.errorViewModels, [
            .init(message: "some error"),
            .init(message: nil),
        ])
    }

    func test_givenErrorViewIsDisplayedTwiceWithDelay_whenTimePass_thenErrorViewIsNotDisplayed() {
        let (sut, services) = makeSut()

        sut.didFinishRegistration(with: makeError("some error"))
        services.simulateTimePassed(seconds: 3)
        sut.didFinishRegistration(with: makeError("another error"))
        services.simulateTimePassed(seconds: 4.9)

        XCTAssertEqual(services.errorViewModels, [
            .init(message: "some error"),
            .init(message: "another error"),
        ])

        services.simulateTimePassed(seconds: 0.2)
        XCTAssertEqual(services.errorViewModels, [
            .init(message: "some error"),
            .init(message: "another error"),
            .init(message: nil),
        ])
    }

    func test_givenUsernameIsEmpty_thenDidUpdateUsernamePasswordDisplaysButtonDisabled() {
        let (sut, services) = makeSut()

        XCTAssertEqual(services.buttonViewModels, [])

        sut.didUpdate(username: "", password: "any")
        XCTAssertEqual(services.buttonViewModels, [.init(title: "Register", isEnabled: false)])

        sut.didUpdate(username: nil, password: "any")
        XCTAssertEqual(services.buttonViewModels, [
            .init(title: "Register", isEnabled: false),
            .init(title: "Register", isEnabled: false),
        ])
    }

    func test_givenPasswordIsEmpty_thenDidUpdateUsernamePasswordDisplaysButtonDisabled() {
        let (sut, services) = makeSut()

        XCTAssertEqual(services.buttonViewModels, [])

        sut.didUpdate(username: "any", password: "")
        XCTAssertEqual(services.buttonViewModels, [.init(title: "Register", isEnabled: false)])

        sut.didUpdate(username: "any", password: nil)
        XCTAssertEqual(services.buttonViewModels, [
            .init(title: "Register", isEnabled: false),
            .init(title: "Register", isEnabled: false),
        ])
    }

    func test_givenUsernameAndPasswordAreEmpty_thenDidUpdateUsernamePasswordDisplaysButtonDisabled() {
        let (sut, services) = makeSut()

        XCTAssertEqual(services.buttonViewModels, [])

        sut.didUpdate(username: "", password: "")
        XCTAssertEqual(services.buttonViewModels, [.init(title: "Register", isEnabled: false)])

        sut.didUpdate(username: "", password: nil)
        XCTAssertEqual(services.buttonViewModels, [
            .init(title: "Register", isEnabled: false),
            .init(title: "Register", isEnabled: false),
        ])

        sut.didUpdate(username: nil, password: nil)
        XCTAssertEqual(services.buttonViewModels, [
            .init(title: "Register", isEnabled: false),
            .init(title: "Register", isEnabled: false),
            .init(title: "Register", isEnabled: false),
        ])

        sut.didUpdate(username: nil, password: "")
        XCTAssertEqual(services.buttonViewModels, [
            .init(title: "Register", isEnabled: false),
            .init(title: "Register", isEnabled: false),
            .init(title: "Register", isEnabled: false),
            .init(title: "Register", isEnabled: false),
        ])
    }

    func test_givenUsernameAndPasswordAreNotEmpty_thenDidUpdateUsernamePasswordDisplaysButtonEnabled() {
        let (sut, services) = makeSut()

        XCTAssertEqual(services.buttonViewModels, [])

        sut.didUpdate(username: "some", password: "some")
        XCTAssertEqual(services.buttonViewModels, [.init(title: "Register", isEnabled: true)])

        sut.didUpdate(username: "another", password: "another")
        XCTAssertEqual(services.buttonViewModels, [
            .init(title: "Register", isEnabled: true),
            .init(title: "Register", isEnabled: true),
        ])
    }

    func test_didUpdateUsernamePassword_displaysNoError() {
        let (sut, services) = makeSut()

        XCTAssertEqual(services.errorViewModels, [])

        sut.didUpdate(username: "some", password: "some")
        XCTAssertEqual(services.errorViewModels, [.init(message: nil)])

        sut.didUpdate(username: "another", password: "another")
        XCTAssertEqual(services.errorViewModels, [
            .init(message: nil),
            .init(message: nil),
        ])
    }

    // MARK: - Helpers

    private func makeSut(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: RegistrationViewPresenter, services: Services) {
        let services = Services()
        let sut = RegistrationViewPresenter(
            loadingView: services,
            buttonView: services,
            titleView: services,
            registrationView: services,
            errorView: services,
            scheduler: services
        )

        return (sut, services)
    }
}

private final class Services: LoadingView, ButtonView, TitleView, RegistrationView, ErrorView, DeferredScheduler {
    private(set) var loadingViewModels: [LoadingViewModel] = []
    private(set) var buttonViewModels: [ButtonViewModel] = []
    private(set) var titleViewModels: [TitleViewModel] = []
    private(set) var registrationViewModels: [RegistrationViewModel] = []
    private(set) var errorViewModels: [ErrorViewModel] = []

    func display(viewModel: LoadingViewModel) {
        loadingViewModels.append(viewModel)
    }

    func display(viewModel: ButtonViewModel) {
        buttonViewModels.append(viewModel)
    }

    func display(viewModel: TitleViewModel) {
        titleViewModels.append(viewModel)
    }

    func display(viewModel: RegistrationViewModel) {
        registrationViewModels.append(viewModel)
    }

    func display(viewModel: ErrorViewModel) {
        errorViewModels.append(viewModel)
    }

    private struct Task: Cancellable {
        let onCancel: () -> ()

        func cancel() {
            onCancel()
        }
    }

    private var time: TimeInterval = 0
    private var scheduledWork: [TimeInterval: () -> ()] = [:]

    func schedule(after: TimeInterval, _ work: @escaping () -> ()) -> Cancellable {
        let scheduledTime = after + time
        scheduledWork[scheduledTime] = work

        return Task { [weak self] in
            self?.scheduledWork[scheduledTime] = nil
        }
    }

    func simulateTimePassed(seconds: TimeInterval) {
        time += seconds

        for scheduledTime in scheduledWork.keys where scheduledTime <= time {
            scheduledWork.removeValue(forKey: scheduledTime)?()
        }
    }
}
