class MainViewController < UITableViewController
  FeedURL = 'http://headlines.yahoo.co.jp/rss/all-c_sci.xml'

  YONA_TOP_URL = 'http://yona.dev/feeds.json'

  def viewDidLoad
    super
    navigationItem.title = 'rss'

    p(BW::JSON)
    @ptrview = SSPullToRefreshView.alloc.initWithScrollView(tableView, delegate:self)
    @items ||= []

    fetch_rss do |items|
      @items = items
      view.reloadData
    end
  end

  def viewDidUnload
    super
    @ptrview = nil
  end

  def fetch_rss(&cb)
    items = []
    BW::HTTP.get(YONA_TOP_URL) do |res|
      if res.ok?
        unreads = BW::JSON.parse(res.body.to_str)
        unreads.each do |unread|
          items.push({kind: :tag, data: unread["tag"]})
          unread["user_feeds"].each do |uf|
            items.push({kind: :feed, data: uf})
          end
        end
        parser = BW::JSON.parse(res.body.to_str)
      else
        App.alert(res.error_message)
      end
      cb.call(items)
    end
  end

  def pullToRefreshViewDidStartLoading(ptrview)
    @ptrview.startLoading
    fetch_rss do |items|
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
    if @items[indexPath.row][:kind] == :tag
      cell.accessoryType = UITableViewCellAccessoryNone
      cell.textLabel.font = :bold.uifont(20)
      cell.textLabel.text = @items[indexPath.row][:data]["label"]
    else
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell.textLabel.font = :bold.uifont(14)
      cell.textLabel.text = @items[indexPath.row][:data]["feed"]["title"]
    end
    return cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    navigationController << WebViewController.new.tap do |c|
      if @items[indexPath.row][:kind] == :tag
        return
      end
      c.url = @items[indexPath.row].link
    end
  end
end
