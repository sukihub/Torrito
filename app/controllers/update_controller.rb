class UpdateController < ApplicationController

    def index
        Torrent.rssUpdateTorrents        
    end

    def details
        torrentID = 5

        seedLast = 1140
        leechLast = 514

        seed = 0
        leech = 0

        for i in 0 .. 40

            seed = seedLast + rand(100) - 50
            leech = leechLast + rand(50) - 20

            Detail.create(:torrent_id => torrentID, :seed => seed, :leech => leech)

            seedLast = seed
            leechLast = leech

        end
    end

end
