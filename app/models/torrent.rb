class Torrent < ActiveRecord::Base

    has_many :details

    #will_paginate
    cattr_reader :per_page
    @@per_page = 50;

    def self.rssUpdateTorrents

        require 'open-uri';

        begin
            timeout(5) do
                @page = open("http://torrentz.com/verified").read()
            end
            #puts '  - page numbers loaded'
        rescue Timeout::Error
            puts '  - sleeping 120, retry'
            sleep(120)
            retry
        end

        #pocet stran
        pageNumbers = @page.scan(/verified\?q=&amp;p=(\d+)/);
        pageNumbers.pop();

        lastPage = pageNumbers.last().to_s().to_i();

        titleRegexp = Regexp.new('<title>(.*)</title>');
        tagRegexp = Regexp.new('<category>(.*)</category>');
        sizeRegexp = Regexp.new('Size: ([0-9]+)');
        seedRegexp = Regexp.new('Seeds: ([0-9]+)');
        peerRegexp = Regexp.new('Peers: ([0-9]+)');
        hashRegexp = Regexp.new('Hash: (.{40})');

        for i in 0 .. lastPage

            puts "processing #{i.to_s}";

            begin
                timeout(5) do
                    @page = open("http://torrentz.com/feed_verified?p=#{i.to_s}").read();
                end
                #puts "  - ok"
            rescue Timeout::Error
                puts "  - failed, sleeping 120 seconds, then retry"
                sleep(120)
                #time = time*2

                #if time < 2000
                    retry
                #else
                    #puts " - sleeping time greater then 2000s, moving to next page"
                    #next
                #end
            end

            #vymazem ciarky, ktore by mi neskor pri cislach len zavadzali
            @page.delete!(',');
            titles = @page.scan(titleRegexp);
            #prve title je napis torrentz
            titles.shift();

            tags = @page.scan(tagRegexp);
            sizes = @page.scan(sizeRegexp);
            seeds = @page.scan(seedRegexp);
            peers = @page.scan(peerRegexp);
            hashes = @page.scan(hashRegexp);

            #records = [titles.length, tags.length, sizes.length, seeds.length, peers.length, hashes.length].min();

            for j in 0 .. titles.length - 1

                hash = hashes[j].pack('H*');
                t = Torrent.find_by_tHash(hash);
                if t.nil?
                    t = Torrent.create(:tHash => hash, :title => titles[j][0], :tags => tags[j][0], :size => sizes[j][0], :average_l => peers[j][0], :average_s => seeds[j][0], :deviation_s => 0.0, :deviation_l => 0.0);
                else
                    t.details_count = t.details_count + 1

                    leech = peers[j][0].to_i
                    seed = seeds[j][0].to_i

                    #nova odchylka leechov
                    delta_l = leech - t.average_l
                    t.average_l = t.average_l + delta_l/t.details_count

                    new_l = (t.details_count - 2)*(t.deviation_l**2) + delta_l*(leech - t.average_l)
                    t.deviation_l = Math.sqrt(new_l / (t.details_count - 1) )

                    #nova odchylka seedov
                    delta_s = seed - t.average_s
                    t.average_s = t.average_s + delta_s/t.details_count

                    new_s = (t.details_count - 2)*(t.deviation_s**2) + delta_s*(seed - t.average_s)
                    t.deviation_s = Math.sqrt(new_s / (t.details_count - 1) )

                    t.save!
                end

                Detail.create(:torrent_id => t.id, :seed => seeds[j][0], :leech => peers[j][0]);

            end
        end

    end

end
