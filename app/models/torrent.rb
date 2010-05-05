class Torrent < ActiveRecord::Base

    has_many :details

    cattr_reader :per_page
    @@per_page = 50;

    def self.rssUpdateTorrents

        require 'open-uri';

        page = open("http://torrentz.com/verified").read();

        #pocet stran
        pageNumbers = page.scan(/verified\?q=&amp;p=(\d+)/);
        pageNumbers.pop();

        lastPage = pageNumbers.last().to_s().to_i();

        titleRegexp = Regexp.new('<title>(.*)</title>');
        tagRegexp = Regexp.new('<category>(.*)</category>');
        sizeRegexp = Regexp.new('Size: ([0-9]+)');
        seedRegexp = Regexp.new('Seeds: ([0-9]+)');
        peerRegexp = Regexp.new('Peers: ([0-9]+)');
        hashRegexp = Regexp.new('Hash: (.{40})');

        for i in 61 .. lastPage

            puts "processing #{i.to_s}";

            page = open("http://torrentz.com/feed_verified?p=#{i.to_s}").read();
            #vymazem ciarky, ktore by mi neskor pri cislach len zavadzali
            page.delete!(',');

            titles = page.scan(titleRegexp);
            #prve title je napis torrentz
            titles.shift();

            tags = page.scan(tagRegexp);
            sizes = page.scan(sizeRegexp);
            seeds = page.scan(seedRegexp);
            peers = page.scan(peerRegexp);
            hashes = page.scan(hashRegexp);

            #records = [titles.length, tags.length, sizes.length, seeds.length, peers.length, hashes.length].min();

            for j in 0 .. titles.length - 1

                hash = hashes[j].pack('H*');
                result = Torrent.find_by_tHash(hash, :select => :id);
                if result.nil?
                    result = Torrent.create(:tHash => hash, :title => titles[j][0], :tags => tags[j][0], :size => sizes[j][0]);
                end

                Detail.create(:torrent_id => result.id, :seed => seeds[j][0], :leech => peers[j][0]);

            end
        end

    end

end
