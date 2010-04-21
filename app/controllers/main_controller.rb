class MainController < ApplicationController

    caches_page :index

    def index
    end

    def search

        @query = params[:q];
        page = params[:p].to_i;

        @results = Torrent.find_by_sql(["SELECT * FROM torrents WHERE MATCH(title, tags) AGAINST(?) LIMIT 50 OFFSET ?", @query, page*50]);
        #@results = Torrent.find_by_sql("SELECT * FROM torrents WHERE MATCH(title, tags) AGAINST('#{query}')");

    end

    def autoComplete

        query = params[:q];
        query.strip!;

        query = "%#{query}%";

        if not query.empty?

            @results = Torrent.find_by_sql(["SELECT title FROM torrents WHERE title LIKE ? ORDER BY id DESC LIMIT 10", query]);

        end

    end

end
