class TorrentController < ApplicationController

    def index

        @torrent = Torrent.find(params[:id].to_i);       

    end

end
