class MainViewController < UIViewController
  def viewDidLoad
    super
    marign = 20
    view.backgroundColor = UIColor.whiteColor
    navigationItem.title = 'sample'

    button = UIButton.buttonWithType(UIButtonTypeRoundedRect).tap do |b|
      b.setTitle('Open Webview', forState:UIControlStateNormal)
      b.frame = [
        [marign, 100],
        [view.frame.size.width - marign * 2, 42],
      ]
      b.addTarget(self, action: 'buttonDidPush', forControlEvents: UIControlEventTouchUpInside)
    end

    view.addSubview(button)
  end

  def buttonDidPush
    web = WebViewController.new.tap do |wv|
      wv.url = 'http://google.com'
    end
    navigationController.pushViewController(web, animated: true)
  end
end
