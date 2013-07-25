class MainViewController < UITableViewController
  FeedURL = 'http://headlines.yahoo.co.jp/rss/all-c_sci.xml'

  def viewDidLoad
    super
    navigationItem.title = 'rss'

    @ptrview = SSPullToRefreshView.alloc.initWithScrollView(tableView, delegate:self)
    @items ||= []

    fetch_rss(FeedURL) do |items|
      @items = items
      view.reloadData
    end
  end

  def viewDidUnload
    super
    @ptrview = nil
  end

  def fetch_rss(url, &cb)
    items = []
    BW::HTTP.get(url) do |res|
      if res.ok?
        xml = res.body.to_str

        parser = BW::RSSParser.new(xml, true)
        parser.parse do |item|
          items.push(item)
        end
      else
        App.alert(res.error_message)
      end
      cb.call(items)
    end
  end

  def pullToRefreshViewDidStartLoading(ptrview)
    @ptrview.startLoading
    fetch_rss(FeedURL) do |items|
      @items = items
      @ptrview.finishLoading
      view.reloadData
    end
  end

  def tableView(tableView, numberOfRowsInSection:section)
    return @items.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('cell') || UITableViewCell.alloc.initWithStyle(
      UITableViewCellStyleDefault, reuseIdentifier:'cell'
    )
    cell.accessoryType = :disclosure.uitablecellaccessory
    cell.textLabel.font = :bold.uifont(14)
    cell.textLabel.text = @items[indexPath.row].title
    return cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    navigationController << WebViewController.new.tap do |c|
      c.url = @items[indexPath.row].link
    end
  end
end
