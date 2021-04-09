//
//  MainViewController.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import SwiftyAttributes

extension Main {
    
    class ViewController: UIViewController {
        
        fileprivate lazy var emptyStateView: UIView = {
            let view = UIView()
            
            let image = "empty_state_wasteland"
                .image!
                .view
                .add(to: view)
            
            let lblText = "Text"
                .label
                .font(AppFonts.regular.ofSize(16))
                .numberOfLines(0)
                .textAlignment(.center)
                .add(to: view)
            
            let text = "It's dry out here\n".withFont(AppFonts.regular.ofSize(24)) + "Maybe create anew task?!".withFont(AppFonts.regular.ofSize(16))
            
            lblText.attributedText = text
            
            let btn = "Create new task".button
                .font(AppFonts.regular.ofSize(15))
                .backgroundColor(ColorPalette.paleGreyTwo)
                .corner(radius: 20)
                .textColor(.white)
                .add(to: view)
                
            image.snp.makeConstraints({ make in
                make.height.equalTo(168)
                make.width.equalTo(168)
                make.bottom.equalTo(view.snp.centerY).offset(-30)
                make.centerX.equalToSuperview()
            })
            
            lblText.snp.makeConstraints({ make in
                make.top.equalTo(image.snp.bottom).offset(16)
                make.leading.equalToSuperview().offset(25)
                make.trailing.equalToSuperview().offset(-25)
                make.centerX.equalToSuperview()
            })
            
            btn.snp.makeConstraints { make in
                make.leading.equalTo(image).offset(8)
                make.trailing.equalTo(image).offset(-8)
                make.height.equalTo(40)
                make.top.equalTo(lblText.snp.bottom).offset(16)
            }
            
            btn.rx.tap
                .bind(to: viewModel.inputs.tapNewTaskBtn)
                .disposed(by: disposeBag)
            
            return view
        }()
        
        let loadingView: UIActivityIndicatorView = {
            let av = UIActivityIndicatorView(style: .gray)
            av.hidesWhenStopped = true
            
            return av
        }()
        
        lazy var tableView: UITableView = {
            return UITableView()
                .register(cell: TaskCell.self)
                .backgroundColor(.clear)
                .rowHeight(estimated: 80, automatic: true)
                .separator(style: .none)
                .contentInset(.init(top: 20, left: 0, bottom: 10, right: 0))
                .hideFooterView()
        }()
        
        lazy var btnBack = "Back".barButton
        
        lazy var btnNewTask = "navbar_create_new_icon".image!.barButton
            
        var viewModel: MainViewModeling!
        
        var disposeBag = DisposeBag()

        init(viewModel: MainViewModeling = ViewModel()) {
            super.init(nibName: nil, bundle: nil)
            self.viewModel = viewModel
        }
        
        override func loadView() {
            super.loadView()
            setupObservables()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            setupNavigation()
            setupSearch()
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupViews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// MARK: - Setup Views

extension Main.ViewController {
    
    func setupViews() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNavigation() {
        
        var attrs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: ColorPalette.blackish
        ]
        
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        attrs[NSAttributedString.Key.font] = AppFonts.bold.ofSize(32)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.largeTitleTextAttributes = attrs
        self.navigationController?.navigationBar.backgroundColor = .white
        self.view.backgroundColor = UIColor.white
        title = "Tasks"
        
        navigationItem.setLeftBarButton(btnBack, animated: true)
        navigationItem.setRightBarButton(btnNewTask, animated: true)
    }
}

// MARK: - Setup Search

extension Main.ViewController {
    func setupSearch() {
        let search = UISearchController(searchResultsController: nil)
        
        self.navigationItem.searchController = search
        
        search.searchBar.rx.text.orEmpty
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .takeUntil(rx.deallocated)
            .observeOn(MainScheduler.instance)
            .bind(to: viewModel.inputs.query)
            .disposed(by: disposeBag)
        
        search.rx.didDismiss
            .takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.inputs.triggerLoadTasks()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup Observabels

extension Main.ViewController {
    func setupObservables() {
        
        // MARK: TableView Bindings
        
        viewModel.outputs.tasks
            .drive(tableView.rx.items(cellIdentifier: Main.TaskCell.identifierName,
                                      cellType: Main.TaskCell.self)) { index, viewModel, cell in
                cell.configure(model: viewModel)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelDeleted(TaskCellViewModeling.self)
            .takeUntil(rx.deallocated)
            .bind(to: viewModel.inputs.deleteTask)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(TaskCellViewModeling.self)
            .takeUntil(rx.deallocated)
            .subscribe(onNext: { model in
                //print("\(model.outputs.title) tapped")
            })
            .disposed(by: disposeBag)
        
        // MARK: Navigation Bindings
        
        btnNewTask.rx.tap
            .bind(to: viewModel.inputs.tapNewTaskBtn)
            .disposed(by: disposeBag)
        
        btnBack.rx.tap
            .bind(to: viewModel.inputs.tapBackBtn)
            .disposed(by: disposeBag)
        
        // MARK: Empty State & Loader
        
        let emptyStateObs = viewModel.outputs.tasks.asObservable()
            .takeUntil(rx.deallocated)
            .map ({ $0.isEmpty })
            .distinctUntilChanged()
        
        viewModel.outputs.isLoading
            .bind(to: loadingView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(emptyStateObs, viewModel.outputs.isLoading)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEmpty, isLoading in
                if isLoading {
                    self?.tableView.backgroundView = self?.loadingView
                    self?.tableView.separatorStyle = .none
                } else if isEmpty {
                    self?.tableView.backgroundView = self?.emptyStateView
                    self?.tableView.separatorStyle = .none
                } else {
                    self?.tableView.backgroundView = nil
                    self?.tableView.separatorStyle = .singleLine
                }
                
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        // MARK: Load Tasks.
        viewModel.inputs.triggerLoadTasks()
    }
}
