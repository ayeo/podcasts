import Cocoa

class PodcastsViewController: NSViewController {
    
    @IBOutlet weak var urlField: NSTextField!
    
    private var delegate: AppDelegate
    private var context: NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        delegate = NSApplication.shared.delegate as! AppDelegate
        context = delegate.persistentContainer.viewContext
        super.init(coder: aDecoder)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        urlField.stringValue = "http://www.espn.com/espnradio/podcast/feeds/itunes/podCast?id=2406595"
        
    }
    
    @IBAction func addClicked(_ sender: NSButton) {
        if let url = URL(string: urlField.stringValue) {
            URLSession.shared.dataTask(with: url) {
                (data: Data?, response: URLResponse?, error: Error?) in
                if (data != nil) {
                    let parser = Parser()
                    let info = parser.getMetadata(data: data!)
                    let podcast = Podcast(context: self.context)
                    podcast.title = info.title
                    podcast.image = info.image
                    podcast.url = url.absoluteString                    
                    self.delegate.saveAction(nil)
                }
            }.resume()
        }
    }
}
