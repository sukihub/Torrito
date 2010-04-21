class MainController < ApplicationController

    caches_page :index

    def index
    end

    def search

        query = params[:q];
        page = params[:p].to_i;

        @results = Torrent.find_by_sql(["SELECT * FROM torrents WHERE MATCH(title, tags) AGAINST(?) LIMIT 50 OFFSET ?", query, page*50]);
        #@results = Torrent.find_by_sql("SELECT * FROM torrents WHERE MATCH(title, tags) AGAINST('#{query}')");

    end

end
