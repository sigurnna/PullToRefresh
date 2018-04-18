# PullToRefresh
PullToRefresh base on UITableView using Swift.

# How to use?
You can use PullToRefresh both on code and interface builder.

```
IBOutlet weak var tableView: UIPullToRefreshTableView!

tableView.loadingHandler = { [weak self] in
  //
  // some loading logic you must write...
  //
  
  self?.tableView.loadingComplete()
}
```
You must call "loadingComplete", otherwise the refresh animation will not end.

# How to install
writing...
