class MainViewController < UIViewController
  def viewDidLoad
    super
    marign = 20
    view.backgroundColor = '#fff'.uicolor
    navigationItem.title = 'sample'

    view << UIButton.rounded_rect.tap do |b|
      b.setTitle('Open Webview', forState:UIControlStateNormal)
      b.frame = [
        [marign, 100],
        [view.frame.size.width - marign * 2, 42],
      ]
      b.on(:touch) do
        navigationController << WebViewController.new.tap do |wv|
          wv.url = 'http://google.com'
        end
      end
    end
  end
end
