class TorrentController < ApplicationController

    layout 'default'

    def index

        @torrent = Torrent.find(params[:id].to_i)
        @last = @torrent.details.last

        @title = "#{@torrent.title} - Torrito"

    end

    def hash

        h = [params[:id]].pack('H*')
        @torrent = Torrent.find_by_tHash(h)
        @last = @torrent.details.last

        @title = "#{@torrent.title} - Torrito"

        render :action => 'index'

    end

end
