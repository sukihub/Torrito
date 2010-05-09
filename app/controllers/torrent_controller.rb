class TorrentController < ApplicationController

    layout 'default'

    def index

        @torrent = Torrent.find(params[:id].to_i);
        @last = @torrent.details.last

        @title = "#{@torrent.title} - Torrito"

    end

end
