class UpdateController < ApplicationController

    def index
        Torrent.rssUpdateTorrents        
    end

end
