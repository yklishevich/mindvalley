
import Foundation
import CoreData

/// Class is thread safe and can be used from any thread.
class NewEpisodesDao {
    
    let managedContext: NSManagedObjectContext
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    @discardableResult
    func addOrUpdate(_ episode: Episode) throws -> Episode {
        do {
            if let cdNewEpisode = try readCDNewEpisode(byEpisodeTitle: episode.title,
                                                    channelTitle: episode.lightweightChannel.title) {
                cdNewEpisode.update(with: episode)
                return Episode(with: cdNewEpisode)
            }
            else {
                let cdNewEpisode = CDNewEpisode(context: managedContext)
                cdNewEpisode.update(with: episode)
                return Episode(with: cdNewEpisode)
            }
        }
        catch {
            throw DaoError.unknown(
                message: "Error in \(type(of: self)).\(#function)",
                underlyingError: error
            )
        }
    }
    
    func remove(byEpisodeTitle: String, channelTitle: String) throws {
        do {
            if let cdEpisode = try readCDNewEpisode(byEpisodeTitle: byEpisodeTitle, channelTitle: channelTitle) {
                managedContext.delete(cdEpisode)
            }
            else {
                throw DaoError.attemptToDeleteNonExistingEntity(entityId: byEpisodeTitle, type: Episode.self)
            }
        }
        catch {
            throw DaoError.unknown(
                message: "Error in \(type(of: self)).\(#function)",
                underlyingError: error
            )
        }
    }
    
    func read(byEpisodeTitle title: String, channelTitle: String) throws -> Episode? {
        if let cdNewEpisode = try readCDNewEpisode(byEpisodeTitle: title, channelTitle: channelTitle) {
            return Episode(with: cdNewEpisode)
        }
        else {
            return nil
        }
    }
    
    func readAllNewEpisodes() throws -> [Episode] {
        do {
            let fetchRequest: NSFetchRequest<CDNewEpisode> = CDNewEpisode.fetchRequest()
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \CDNewEpisode.position, ascending: true)
            ]
            let cdEpisodes = try managedContext.fetch(fetchRequest)
            return cdEpisodes.map(Episode.init)
        }
        catch {
            throw DaoError.unknown(
                message: "Error in \(type(of: self)).\(#function)",
                underlyingError: error
            )
        }
    }
    
}

private extension NewEpisodesDao {
    
    /// - Returns: `nil` if there is no episode with such id.
    func readCDNewEpisode(byEpisodeTitle: String, channelTitle: String) throws -> CDNewEpisode? {
        let fetchRequest: NSFetchRequest<CDNewEpisode> = CDNewEpisode.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@ && %K == %@",
                                             #keyPath(CDNewEpisode.title), byEpisodeTitle,
                                             #keyPath(CDNewEpisode.channelTitle), channelTitle)
        let cdEpisode = try managedContext.fetch(fetchRequest).first
        return cdEpisode
    }
    
}

private extension CDNewEpisode {
    
    func update(with episode: Episode) {
        self.title = episode.title
        self.type = episode.type.rawValue
        self.coverAssetUrl = episode.coverAsset.url
        self.position = Int32(episode.position)
        self.channelTitle = episode.lightweightChannel.title
    }
}

extension Episode {
    convenience init(with episode: CDNewEpisode) {
        self.init(title: episode.title,
                  type: EpisodeType(rawValue: episode.type)!,
                  coverAsset: CoverAsset(url: episode.coverAssetUrl),
                  lightweightChannel: LightweightChannel(title: episode.channelTitle))
    }
}


