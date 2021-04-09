//
//  TaskCellView.swift
//  AutoDeskTodo
//
//  Created by Shalom Shwaitzer on 08/04/2021.
//  Copyright © 2021 Shalom Shwaitzer. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

extension Main {
    
    class TaskCell: UITableViewCell {
        
        lazy var container = UIView()
            .backgroundColor(.white)
            
        lazy var lblTitle = "Task title"
            .label
            .numberOfLines(0)
            .font(AppFonts.bold.ofSize(16.0))
            .textColor(ColorPalette.blackish)
            .textAlignment(.left)
        
        lazy var btnStatus = "Complete".button
            .font(AppFonts.writer)
            .border(width: 1, color: ColorPalette.brightBlue)
            .corner(radius: 10)
            
        var viewModel: TaskCellViewModeling!
        
        var disposeBag = DisposeBag()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupViews()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(model: TaskCellViewModeling) {
            self.viewModel = model
            disposeBag = DisposeBag()
            loadContent()
            setupObservables()
        }
        
        private func setupViews() {
            selectionStyle = .none
            self.contentView.backgroundColor = .clear
            self.backgroundColor = .clear
            
            contentView.addSubview(container)
            container.add(subviews: lblTitle, btnStatus)
            
            container.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.top.equalToSuperview().offset(1)
                make.bottom.equalToSuperview().offset(-1)
            }
            
            btnStatus.snp.makeConstraints { make in
                make.width.equalTo(110)
                make.trailing.equalToSuperview().offset(-16)
                make.centerY.equalToSuperview()
            }
            
            lblTitle.snp.makeConstraints({ make in
                make.top.bottom.equalToSuperview().inset(16)
                make.leading.equalToSuperview().offset(16)
                make.trailing.lessThanOrEqualTo(btnStatus.snp.leading).offset(-8)
                
            })
        }
        
        private func loadContent() {
            
            lblTitle.text = viewModel.outputs.title
            
            viewModel.outputs.status
                .map({ $0 ? "Reopen" : "Complete" })
                .drive(btnStatus.rx.title())
                .disposed(by: disposeBag)
            
            viewModel.outputs.status
                .map({ $0 ? ColorPalette.brightBlue : UIColor.clear })
                .drive(btnStatus.rx.backgroundColor)
                .disposed(by: disposeBag)
            
            viewModel.outputs.status
                .map({ $0 ? .clear : ColorPalette.brightBlue })
                .drive(onNext: { [weak self] color in
                    self?.btnStatus.border(width: 1, color: color)
                })
                .disposed(by: disposeBag)
            
            viewModel.outputs.status
                .map({ $0 ? .white : ColorPalette.brightBlue })
                .drive(onNext: { [weak self] color in
                        self?.btnStatus.textColor(color)
                })
                .disposed(by: disposeBag)
            
            
            viewModel.outputs.status
                .map({ [weak self] completed in
                    guard let self = self else { return "".attributedString }
                    if completed {
                       return self.viewModel.outputs.title.withTextColor(.gray).withStrikethroughStyle(.single)
                    }
                    return self.viewModel.outputs.title.attributedString
                })
                .drive(onNext: { [weak self] title in
                    self?.lblTitle.attributedText = title
                })
                .disposed(by: disposeBag)
        }
        
        private func setupObservables() {
            btnStatus.rx.tap
                .bind(to: viewModel.inputs.toggleStatus)
                .disposed(by: disposeBag)
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            lblTitle.attributedText = nil
        }
    }
}
