
import Foundation
import CoreData

/// Class is thread safe and can be used from any thread.
class EpisodesDao {
    
    let managedContext: NSManagedObjectContext
    lazy var channelsDao = ChannelsDao(managedContext: managedContext)
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    @discardableResult
    func addOrUpdate(_ episode: Episode) throws -> Episode {
        let cdEpisode = try cdAddOrUpdate(episode)
        return Episode(with: cdEpisode)
    }
    
    func read(byTitle title: String, channelTitle: String) throws -> Episode? {
        do {
            if let cdEpisode = try readCDEpisode(byTitle: title, channelTitle: channelTitle) {
                return Episode(with: cdEpisode)
            }
            else {
                return nil
            }
        }
        catch {
            throw DaoError.unknown(
                message: "Error in \(type(of: self)).\(#function)",
                underlyingError: error
            )
        }
    }
    
}

extension EpisodesDao {
    
    @discardableResult
    func cdAddOrUpdate(_ episode: Episode) throws -> CDEpisode {
        do {
            if let cdEpisode = try readCDEpisode(byTitle: episode.title,
                                                 channelTitle: episode.lightweightChannel.title) {
                cdEpisode.update(with: episode)
                return cdEpisode
            }
            else {
                let cdEpisode = CDEpisode(context: managedContext)
                cdEpisode.update(with: episode)
                return cdEpisode
            }
        }
        catch {
            throw DaoError.unknown(
                message: "Error in \(type(of: self)).\(#function)",
                underlyingError: error
            )
        }
    }
    
    /// - Returns: `nil` if there is no episode with such id.
    func readCDEpisode(byTitle title: String, channelTitle: String) throws -> CDEpisode? {
        let fetchRequest: NSFetchRequest<CDEpisode> = CDEpisode.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@",
                                             #keyPath(CDEpisode.title), title,
                                             #keyPath(CDEpisode.channel.title), channelTitle
        )
        let cdEpisode = try managedContext.fetch(fetchRequest).first
        return cdEpisode
    }
    
}

private extension CDEpisode {
    
    func update(with episode: Episode) {
        self.title = episode.title
        self.type = episode.type.rawValue
        self.coverAssetUrl = episode.coverAsset.url
        self.positionInChannel = Int32(episode.position)
    }
}

extension Episode {
    convenience init(with cdEpisode: CDEpisode) {
        let lightweithChannel = LightweightChannel(title: cdEpisode.channel.title)
        
        self.init(title: cdEpisode.title,
                  type: EpisodeType(rawValue: cdEpisode.type)!,
                  coverAsset: CoverAsset(url: cdEpisode.coverAssetUrl),
                  lightweightChannel: lightweithChannel)
    }
}


