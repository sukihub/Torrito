task :cron => :environment do

    Torrent.rssUpdateTorrents

end