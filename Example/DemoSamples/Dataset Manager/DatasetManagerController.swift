//
//  DemosViewController.swift
//  Demos
//
//  Created by Daniel Nielsen on 07/03/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit
import MapsIndoors

class DatasetManagerController : UITableViewController {
    
    let demoAPIKeys:[String] = [ "ccc6787e288c4e379b42e4d8"
                               , "57e4e4992e74800ef8b69718"
                               , "607bc06a456c4cc494de4231"
                               , "5667325fc1843a06bca1dd2b"
                               ]

    let cm = MapsIndoors.dataSetCacheManager;
    
    var syncSizesButton :UIBarButtonItem?
    var syncButton      :UIBarButtonItem?
    var cancelButton    :UIBarButtonItem?
    var spinnerStyle    :UIActivityIndicatorView.Style = .gray
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 12.0, *) {
            self.spinnerStyle = self.traitCollection.userInterfaceStyle == .dark ? UIActivityIndicatorView.Style.white : UIActivityIndicatorView.Style.gray
        }

        syncSizesButton = UIBarButtonItem.init(title: "Update sizes", style: .plain, target: self, action: #selector(fetchSyncSizes))
        syncButton = UIBarButtonItem.init(title: "Synchronise", style: .plain, target: self, action: #selector(syncroniseContent))
        cancelButton = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(cancelSync))
        
        self.navigationItem.rightBarButtonItems = [syncButton!, syncSizesButton!]
        setupRightBarButtons(cancel: false)

        cm.delegate = self
        for apiKey in demoAPIKeys {
            cm.addDataSet(apiKey)
        }

        cm.fetchSyncSizes(for: cm.managedDataSets, delegate: self as MPDataSetCacheManagerSizeDelegate )
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        if #available(iOS 12.0, *) {
            self.spinnerStyle = newCollection.userInterfaceStyle == .dark ? UIActivityIndicatorView.Style.white : UIActivityIndicatorView.Style.gray
            for cell in self.tableView.visibleCells {
                if let aiv = cell.accessoryView as? UIActivityIndicatorView {
                    aiv.activityIndicatorViewStyle = self.spinnerStyle;
                }
            }
            if let aiv = self.tableView.tableFooterView as? UIActivityIndicatorView {
                aiv.activityIndicatorViewStyle = self.spinnerStyle;
            }
        }
    }

    func setupRightBarButtons( cancel : Bool ) {

        if ( (syncSizesButton != nil) && (syncButton != nil) && (cancelButton != nil) ) {

            if ( cancel ) {
                self.navigationItem.rightBarButtonItems = [cancelButton!    ]
            } else {
                self.navigationItem.rightBarButtonItems = [syncButton!, syncSizesButton!]
            }
        }
    }

    @objc func fetchSyncSizes() {
        cm.fetchSyncSizes(for: cm.managedDataSets, delegate: self as MPDataSetCacheManagerSizeDelegate )
    }

    @objc func syncroniseContent() {
        cm.synchronizeContent()
    }
    
    @objc func cancelSync() {
        cm.cancelSynchronization()
    }
    
    //This cleanup is only needed in this demo
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParentViewController {
            MapsIndoors.provideAPIKey(AppDelegate.mApiKey, googleAPIKey: AppDelegate.gApiKey)
        }
    }

    class func formattedByteCount( _ byteCount : Int64) -> String {
        return ByteCountFormatter.string(fromByteCount: byteCount, countStyle: .file)
    }

    class func formattedDate( _ dt : Date? ) -> String {
        if let dt = dt {
            let df = DateFormatter()
            df.timeStyle = .medium
            df.dateStyle = .medium
            df.doesRelativeDateFormatting = true
            return df.string(from: dt)
        }
        return "Never"
    }

    
    // MARK: Tableview delegate and datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cm.managedDataSets.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: nil)
        let dataSetCache = cm.managedDataSets[indexPath.row]
        cell.textLabel?.text = dataSetCache.name

        var detail :String
        if dataSetCache.cacheItem.isCached {
            detail = "\(DatasetManagerController.formattedByteCount(Int64(dataSetCache.cacheItem.cachedSize))) (Downloaded \(DatasetManagerController.formattedDate(dataSetCache.cacheItem.cachedTimestamp))"
            if let syncResult = dataSetCache.cacheItem.syncResult {
                detail += ", " + syncResult.localizedDescription
            }
            detail += ")"
        } else {
            detail = "~\(DatasetManagerController.formattedByteCount(Int64(dataSetCache.cacheItem.syncSize)))"
            if let syncResult = dataSetCache.cacheItem.syncResult {
                detail += " (\(syncResult.localizedDescription))"
            }
        }
        cell.detailTextLabel?.text = detail
        if cell.accessoryView == nil {
            cell.accessoryView = UIActivityIndicatorView.init(activityIndicatorStyle: self.spinnerStyle)
        }
        if let aiv = cell.accessoryView as? UIActivityIndicatorView {
            if dataSetCache.isSyncing && !aiv.isAnimating {
                aiv.startAnimating()
            } else if !dataSetCache.isSyncing && aiv.isAnimating {
                aiv.stopAnimating()
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let datasets = MapsIndoors.dataSetCacheManager.managedDataSets
        let dataset = datasets[indexPath.row]
        let apiKey = dataset.dataSetId
        let vc = DatasetMapController.init(apiKey)
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension DatasetManagerController : MPDataSetCacheManagerSizeDelegate {

    func dataSetManagerWillStartFetchingSyncSizes(_ dsm: MPDataSetCacheManager) {
        self.tableView.reloadData()
        setupRightBarButtons(cancel: true)
    }

    func dataSetManagerDidFinishFetchingSyncSizes(_ dsm: MPDataSetCacheManager) {
        self.tableView.reloadData()
        setupRightBarButtons(cancel: false)
    }

    func dataSetManager(_ dsm: MPDataSetCacheManager, didFetchSyncSizesForDataSet dataSet: MPDataSetCache) {
        self.tableView.reloadData()
    }

    func dataSetManager(_ dsm: MPDataSetCacheManager, willStartFetchingSyncSizesForDataSet dataSet: MPDataSetCache) {
        self.tableView.reloadData()
    }
}


extension DatasetManagerController : MPDataSetCacheManagerDelegate {

    func dataSetManager(_ dscm: MPDataSetCacheManager, didAddDataSet dataset: MPDataSetCache) {
        NSLog( "[DSM.delegate] didAddDataSet: " + dataset.name )
    }

    func dataSetManager(_ dscm: MPDataSetCacheManager, didRemoveDataSet dataset: MPDataSetCache) {
        NSLog( "[DSM.delegate] didRemoveDataSet: " + dataset.name )
    }

    func dataSetManagerWillStartSynchronizing(_ dataSetManager: MPDataSetCacheManager) {
        let syncSpinner = UIActivityIndicatorView.init(activityIndicatorStyle: self.spinnerStyle)
        syncSpinner.startAnimating()
        self.tableView.tableFooterView = syncSpinner
    }

    func dataSetManagerDidFinishSynchronizing(_ dataSetManager: MPDataSetCacheManager) {
        self.tableView.tableFooterView = nil
    }

    func dataSetManager(_ dscm: MPDataSetCacheManager, willStartSynchronizingDataSet dataset: MPDataSetCache) {
        self.tableView.reloadData()
        setupRightBarButtons(cancel: dscm.isSyncing )
        NSLog( "[DSM.delegate] willStartSynchronizingDataSet [" + dataset.name + "]" )
    }

    func dataSetManager(_ dscm: MPDataSetCacheManager, didFinishSynchronizingDataSet dataset: MPDataSetCache) {
        self.tableView.reloadData()
        setupRightBarButtons(cancel: dscm.isSyncing )
        NSLog( "[DSM.delegate] didFinishSynchronizingDataSet [" + dataset.name + "]" )
    }

    func dataSetManager(_ dscm: MPDataSetCacheManager, willStartSynchronizingItem item: MPDataSetCacheItem) {
        self.tableView.reloadData()
        NSLog( "[DSM.delegate] willStartSynchronizingItem [" + item.name! + "]" )
    }

    func dataSetManager(_ dscm: MPDataSetCacheManager, didFinishSynchronizingItem item: MPDataSetCacheItem) {
        self.tableView.reloadData()
        NSLog( "[DSM.delegate] didFinishSynchronizingItem [" + item.name! + "]" )
    }
}
