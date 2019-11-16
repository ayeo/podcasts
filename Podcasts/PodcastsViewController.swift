import Cocoa

class PodcastsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var urlField: NSTextField!
    @IBOutlet weak var podcastsList: NSTableView!
    private var podcasts: [Podcast] = []
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
        getPodcasts()
    }
    
    func getPodcasts() {
        let fetchy = Podcast.fetchRequest() as NSFetchRequest<Podcast>
        fetchy.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        do {
            self.podcasts = try context.fetch(fetchy)
            DispatchQueue.main.async {
                self.podcastsList.reloadData()
            }
        } catch {}
    }
    
    @IBAction func removeClicked(_ sender: NSButton) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Podcast")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            getPodcasts()
        } catch {}        
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
                    self.getPodcasts()
                }
            }.resume()
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return podcasts.count
    }        
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let id = NSUserInterfaceItemIdentifier("podcastCell")
        let cell = tableView.makeView(withIdentifier: id, owner: self) as? NSTableCellView
        let podcast = podcasts[row]
        cell?.textField?.stringValue = podcast.title!
                
        return cell
    }
}
