namespace :torrent do

    task :update => :environment do
        Torrent.rssUpdateTorrents
    end

end

