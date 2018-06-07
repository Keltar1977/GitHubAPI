//
//  SearchViewModel.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/5/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import RealmSwift
import RxDataSources
import RxRealm
import ObjectMapper

typealias RxDataSource = RxTableViewSectionedReloadDataSource
typealias DataSourceItem = SectionModel<String, Repository>

class SearchViewModel {
    
    var items: Driver<[DataSourceItem]>
    var dataSource: RxDataSource<DataSourceItem>
    let repoRelay: BehaviorRelay<[Repository]> = BehaviorRelay(value: [])
    let selectedItemRelay: BehaviorRelay<Int?> = BehaviorRelay(value: nil)
    var didSelectRowDriver: Driver<String>!
    let pageListRelay: BehaviorRelay<PageList?> = BehaviorRelay(value: nil)
    var disposeBag = DisposeBag()
    var realm: Realm = {
        let realm: Realm
        do {
            realm = try Realm()
            return realm
        } catch {
            print("realm creation error: \(error)")
            fatalError()
        }
    }()
    
    init(provider: MoyaProvider<GithubAPI>,
         queryObservable: Observable<String>,
         updateObserver: Observable<Void>) {
        items = repoRelay.asDriver().map{ [SectionModel(model: "Repos", items: $0.count > 0 ? $0 : [Repository()])] }
        
        dataSource = RxDataSource<DataSourceItem>(configureCell: { (_, tv, indexPath, item) -> UITableViewCell in
            let cell = tv.dequeueReusableCell(forIndexPath: indexPath) as SearchTableViewCell
            cell.configure(with: item)
            return cell
        })
        
        didSelectRowDriver = selectedItemRelay
            .asDriver()
            .flatMapLatest({ (row) -> Driver<Int> in
                guard let row = row else { return Driver.empty() }
                return Driver.just(row)
            })
            .withLatestFrom(repoRelay.asDriver()) { ($0, $1) }
            .map { value -> String in
                let (row, repos) = value
                return repos[row].svnURL
            }
        
        queryObservable
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest({ [unowned self] (query) -> Observable<[Repository]> in
                guard !query.isEmpty else { return Observable.just([Repository()]) }
                let pageList = PageList()
                self.pageListRelay.accept(pageList)
                return self.performSearch(provider: provider,
                                          query: query,
                                          updateObserver: updateObserver,
                                          pageList: pageList)
            }).observeOn(MainScheduler.instance)
            .flatMapLatest({ (repositories) -> Observable<[Repository]> in
                return Observable.just(repositories)
            })
            .subscribe(realm.rx.add(update: true, onError: nil))
            .disposed(by: disposeBag)
        
        observeReposFromRealm(queryObservable)
    }
    
    private func performSearch(provider: MoyaProvider<GithubAPI>,
                               query: String,
                               updateObserver: Observable<Void>,
                               pageList: PageList) -> Observable<[Repository]>{
        
        let firstRequest = provider.rx.request(GithubAPI.searchRepo(query: query,
                                                                    page: pageList.nextPage,
                                                                    count: pageList.pageSize))
            .mapItems(Repository.self)
            .asObservable()

        let secondRequest = provider.rx.request(GithubAPI.searchRepo(query: query,
                                                                     page: pageList.nextPage,
                                                                     count: pageList.pageSize))
            .mapItems(Repository.self)
            .asObservable()
        
        return Observable
            .combineLatest(firstRequest, secondRequest) { $0 + $1 }
            .flatMapLatest({ [weak self](repositories) -> Observable<[Repository]> in
                guard let sSelf = self else { return Observable.empty() }
                return Observable.concat( Observable.just(repositories),
                                          Observable.never().takeUntil(updateObserver),
                                          sSelf.performSearch(provider: provider,
                                                              query: query,
                                                              updateObserver: updateObserver,
                                                              pageList: pageList) )
            })
            .catchError({ (error) -> Observable<[Repository]> in
                return Observable.just([Repository()])
            })
    }
    
    private func observeReposFromRealm(_ queryObservable: Observable<String>) {
        let repo = realm.objects(Repository.self)
        Observable
            .collection(from: repo)
            .withLatestFrom(queryObservable) { list, query -> [Repository] in
                Array(list).filter { $0.fullName.contains(query.lowercased()) }
            }
            .map { $0.sorted(by: { $0.stars > $1.stars }) }
            .bind(to: repoRelay)
            .disposed(by: disposeBag)
        
    }
}
