//
//  SearchViewController.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/5/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var viewModel: SearchViewModel!
    private var isOnline = true
    private var provider = APIProvider.provider()
    private var disposeBag = DisposeBag()
    private var updateObserver: Observable<Void>!
    
    var searchQueryObservable: Observable<String> {
        return searchBar
            .rx
            .text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupRx()
    }
    
    private func setupRx() {
        viewModel = SearchViewModel(provider: provider,
                                    queryObservable: searchQueryObservable,
                                    updateObserver: updateObserver)
        viewModel
            .items
            .drive(tableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .asObservable()
            .map {$0.row}
            .bind(to: viewModel.selectedItemRelay)
            .disposed(by: disposeBag)
        
        viewModel
            .didSelectRowDriver
            .drive(onNext: { [unowned self] (repoURL) in
                NavigationRouter.showDetails(from: self, with: repoURL)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.register(SearchTableViewCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        updateObserver = tableView
            .rx
            .willDisplayCell
            .asObservable()
            .flatMapLatest { (cell, indexPath) -> Observable<Void> in
                guard let pageList = self.viewModel.pageListRelay.value, pageList.currentPage > 0 else {
                    return Observable.empty()
                }
                return indexPath.row >= pageList.currentPage * pageList.pageSize ? Observable.just(()) : Observable.empty()
        }
    }
}

extension SearchViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
