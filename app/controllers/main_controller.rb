class MainController < ApplicationController

    caches_page :index
    layout 'default', :except => :ac

    def index
    end

    def search

        @query = params[:q];

        @results = Torrent.paginate_by_sql(['SELECT * FROM torrents WHERE MATCH(title, tags) AGAINST(?)', @query], :page => params[:p]);
        #@results = Torrent.find_by_sql();
        #@results = Torrent.find_by_sql("SELECT * FROM torrents WHERE MATCH(title, tags) AGAINST('#{query}')");

    end

    def ac

        query = "%#{params[:q]}%"
        limit = params[:limit]

        @results = Torrent.find_by_sql(['SELECT title FROM torrents WHERE title LIKE ? ORDER BY id DESC LIMIT ?', query, limit.to_i])

    end

end
