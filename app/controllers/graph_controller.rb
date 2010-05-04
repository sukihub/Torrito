class GraphController < ApplicationController

    require 'RMagick'

    LEFT = 75
    RIGHT = 875
    TOP = 15
    BOTTOM = 265

    def draw

        torrent = Torrent.find(params[:id].to_i)
        details = torrent.details.all

        globalMax = [torrent.details.maximum(:seed), torrent.details.maximum(:leech)].max
        globalMin = [torrent.details.minimum(:seed), torrent.details.minimum(:leech)].min

        #vytvorim prazdny obrazok a sablonu grafu
        o = Magick::Image.new(950, 300) do
            self.format = 'GIF'
            #self.background_color = '#EEEEEE'
        end

        body = Magick::Draw.new

        #body.font_family('Arial')
        body.text_align(Magick::RightAlign)
        body.fill_opacity(1)
        body.stroke_opacity(0)
        body.fill_color('#000000')

        body.text(LEFT-15, TOP, globalMax.to_s)
        body.text(LEFT-15, BOTTOM, globalMin.to_s)

        body.fill_opacity(0)
        body.stroke_width(1)

        body.stroke_color('#AAAAAA')
        body.stroke_linecap('square')

        body.line(LEFT-5,TOP-5, LEFT-5,BOTTOM+5)
        body.line(LEFT-5,BOTTOM+5, RIGHT+5,BOTTOM+5)

        body.line(LEFT-5, TOP, LEFT-10, TOP)
        body.line(LEFT-5, BOTTOM, LEFT-10, BOTTOM)

        #body.stroke_color('#DDDDDD')

        #body.line(LEFT,TOP, LEFT,BOTTOM)
        #body.line(LEFT,BOTTOM, RIGHT,BOTTOM)

        # podla poctu zaznamov zistim, ci robim priemer
        pocetZlucovanych = ( details.size.to_f / 80.0 ).ceil
        pocet = ( details.size.to_f / pocetZlucovanych ).ceil

        seedMax = Array.new(pocet, 0)
        seedMin = Array.new(pocet, 2000000000)

        leechMax = Array.new(pocet, 0)
        leechMin = Array.new(pocet, 2000000000)

        detailID = 0
        pocetID = -1

        details.each do |detail|

            #sme na prvom prvku tohto zlucovania
            pocetID = pocetID+1 if detailID % pocetZlucovanych == 0

            #nastavime max a min ak treba
            seedMax[pocetID] = detail.seed if detail.seed > seedMax[pocetID]
            seedMin[pocetID] = detail.seed if detail.seed < seedMin[pocetID]

            leechMax[pocetID] = detail.leech if detail.leech > leechMax[pocetID]
            leechMin[pocetID] = detail.leech if detail.leech < leechMin[pocetID]

            detailID = detailID+1
        end

        #sirka stlpca
        columnWidth = 900.0 / pocet.to_f

        #"vyska" dat grafu 
        dataHeightC = 250.0 / (globalMax - globalMin).to_f

        #ideme kreslit seedov
        body.stroke_linecap('round')
        body.stroke_linejoin('round')

        line = Array.new(pocet*2)

        body.stroke_color('#00FF00')

        for i in 0 .. pocet-1
            line[i*2] = columnWidth*i + LEFT
            line[i*2 + 1] = 250 - ((seedMax[i] - globalMin ) * dataHeightC) + TOP
        end
        body.polyline(*line)

        for i in 0 .. pocet-1
            line[i*2] = columnWidth*i + LEFT
            line[i*2 + 1] = 250 - ((seedMin[i] - globalMin ) * dataHeightC) + TOP
        end
        body.polyline(*line)

        body.stroke_color('#0000FF')

        for i in 0 .. pocet-1
            line[i*2] = columnWidth*i + LEFT
            line[i*2 + 1] = 250 - ((leechMax[i] - globalMin ) * dataHeightC) + TOP
        end
        body.polyline(*line)

        for i in 0 .. pocet-1
            line[i*2] = columnWidth*i + LEFT
            line[i*2 + 1] = 250 - ((leechMin[i] - globalMin ) * dataHeightC) + TOP
        end
        body.polyline(*line)

        #body.stroke_linecap('round')
        #body.stroke_linejoin('round')

        #pole = [20,40, 40,100, 60,80, 80,120]
        #body.polyline(*pole)

        #body.stroke_color('#0000FF')

        #pole = [120,40, 140,100, 160,80, 180,120]
        #body.polyline(*pole)

        body.draw(o)

        send_data(o.to_blob, :filename => 'graph.gif', :type => 'image/gif', :disposition => 'inline')

    end

end
