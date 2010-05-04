class MainController < ApplicationController

    caches_page :index

    def index
    end

    def search

        @query = params[:q];

        @results = Torrent.paginate_by_sql(['SELECT * FROM torrents WHERE MATCH(title, tags) AGAINST(?)', @query], :page => params[:p]);
        #@results = Torrent.find_by_sql();
        #@results = Torrent.find_by_sql("SELECT * FROM torrents WHERE MATCH(title, tags) AGAINST('#{query}')");

    end

end
