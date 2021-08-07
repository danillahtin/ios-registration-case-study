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

    func test_didFinishRegistration_displaysNotLoading() {
        let (sut, services) = makeSut()

        XCTAssertEqual(services.loadingViewModels, [])

        sut.didFinishRegistration()
        XCTAssertEqual(services.loadingViewModels, [.init(isLoading: false)])
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
            registrationView: services
        )

        return (sut, services)
    }
}

private final class Services: LoadingView, ButtonView, TitleView, RegistrationView {
    private(set) var loadingViewModels: [LoadingViewModel] = []
    private(set) var buttonViewModels: [ButtonViewModel] = []
    private(set) var titleViewModels: [TitleViewModel] = []
    private(set) var registrationViewModels: [RegistrationViewModel] = []

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
}
