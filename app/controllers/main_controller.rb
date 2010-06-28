class MainController < ApplicationController

    caches_page :index
    layout 'default', :except => :ac

    def index

      @focus = true

      time = 1.week.ago.to_formatted_s(:db)
      details_count = 7;

      @results = Torrent.find(:all, :conditions => ['created_at < ? AND details_count >= ?', time, details_count], :order => 'rank_agg DESC', :limit => 20)

    end

    def search

        @focus = true

        @query = params[:q];
        @title = "#{@query} - Torrito search"

        #@results = Torrent.paginate(:page => params[:p], :conditions => ['title LIKE ?', "%#{@query}%"], :order => 'id DESC')
        #@results = Torrent.paginate_by_sql(['SELECT * FROM torrents WHERE MATCH(title, tags) AGAINST(?)', @query], :page => params[:p]);
        #@results = Torrent.find_by_sql();
        #@results = Torrent.find_by_sql("SELECT * FROM torrents WHERE MATCH(title, tags) AGAINST('#{query}')");

        @results = Torrent.search @query, :page => params[:p], :per_page => 50, :sort_mode => :extended, :order => '@relevance DESC, rank_agg DESC'

    end

    def ac

        @query = "%#{params[:q]}%"
        limit = params[:limit]

        @results = Torrent.find_by_sql(['SELECT title FROM torrents WHERE title LIKE ? ORDER BY id DESC LIMIT ?', @query, limit.to_i])

    end

    def about
    end

end
