namespace :torrent do

    task :update => :environment do
        Torrent.rssUpdateTorrents
        Rake::Task['thinking_sphinx:reindex'].invoke
        #run 'rake thinking_sphinx:reindex RAILS_ENV=production'
        ApplicationController.expire_page :controller => 'main', :action => 'index'
    end

    task :calc => :environment do

        torrents = Torrent.find(:all, :select => 'id')
        torrents.each do |t|

            puts "- #{t.id}"

            details = t.details.all

            sum_s = 0.0
            sum_l = 0.0

            sumsq_l = 0.0
            sumsq_s = 0.0

            count = details.size

            details.each do |d|
                sum_s = sum_s + d.seed
                sum_l = sum_l + d.leech

                sumsq_s = sumsq_s + d.seed*d.seed
                sumsq_l = sumsq_l + d.leech*d.leech
            end

            avg_s = sum_s / count
            avg_l = sum_l / count

            count = 2 if count == 1

            var_s = (sumsq_s - avg_s*sum_s) / (count - 1)
            var_l = (sumsq_l - avg_l*sum_l) / (count - 1)

            t.average_s = avg_s
            t.average_l = avg_l

            t.deviation_s = Math.sqrt(var_s)
            t.deviation_l = Math.sqrt(var_l)

            t.save!

        end

    end

    task :count => :environment do
        Torrent.find(:all).each do |t|
            t.details_count = t.details.all.size
            t.save!
        end
    end

    task :rank_init => :environment do

      Torrent.find(:all).each do |t|
        Torrent.update_rank_leech(t)
        Torrent.update_rank_seed(t)

        t.save!
      end

    end

    task :rank => :environment do

      Torrent.find(:all).each do |t|
        Torrent.update_rank(t)
        
        t.save!
      end

    end

end

