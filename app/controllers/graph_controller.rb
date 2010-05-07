class GraphController < ApplicationController

    require 'RMagick'

    LEFT = 65
    RIGHT = 880
    TOP = 15
    BOTTOM = 265

    def draw

        torrent = Torrent.find(params[:id].to_i)
        details = torrent.details.all

        globalMax = [torrent.details.maximum(:seed), torrent.details.maximum(:leech)].max
        globalMin = [torrent.details.minimum(:seed), torrent.details.minimum(:leech)].min

        #vytvorim prazdny obrazok a sablonu grafu
        o = Magick::Image.new(928, 300) do
            self.format = 'GIF'
            #self.background_color = '#EEEEEE'
        end

        body = Magick::Draw.new

        body.stroke_width(1)
        body.stroke_color('#AAAAAA')
        body.stroke_linecap('square')

        body.line(LEFT-5,TOP-5, LEFT-5,BOTTOM+5)
        body.line(LEFT-5,BOTTOM+5, RIGHT+5,BOTTOM+5)

        #body.line(LEFT-5, TOP, LEFT-10, TOP)
        #body.line(LEFT-5, BOTTOM, LEFT-10, BOTTOM)

        body.stroke_color('#EEEEEE')

        for i in 0 .. 9
            tmp = i*25 + TOP
            body.line(LEFT,tmp, RIGHT,tmp)
        end

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
        columnWidth = 815.0 / (pocet-1).to_f

        #"vyska" dat grafu
        dataHeightC = 250.0 / (globalMax - globalMin)

        #vypisanie textu
        body.font_family('Segoe UI')
        body.pointsize(14)
        body.text_align(Magick::RightAlign)
        body.fill_opacity(1)
        body.stroke_opacity(0)
        body.fill_color('#000000')

        #body.text(LEFT-15, TOP+5, globalMax.to_s)
        #body.text(LEFT-15, BOTTOM+5, globalMin.to_s)

        for i in 0 .. 5
            actual = i*50
            real = (250-actual)/dataHeightC + globalMin

            body.text(LEFT-15, TOP+actual+5, real.round.to_s)
        end

        #label-y datumov po
        dateColumn = (90 / columnWidth).ceil

        body.text_align(Magick::CenterAlign)

        tmp = columnWidth*dateColumn
        dateID = dateColumn
        while tmp < 725
            body.text(LEFT + tmp, BOTTOM + 25, details[pocetZlucovanych*dateID].created_at.strftime('%d.%m.%Y'))
            tmp = tmp + columnWidth*dateColumn
            dateID = dateID + dateColumn
        end

        #ideme kreslit ciary grafu - seedov
        body.stroke_linecap('round')
        body.stroke_linejoin('round')

        line1 = Array.new(pocet*2)
        line2 = Array.new(pocet*2)

        body.stroke_color('#00FF00')
        body.fill_color('#00FF00')
        body.fill_opacity(0.3)
        body.stroke_opacity(1)

        for i in 0 .. pocet-1
            line1[i*2] = columnWidth*i + LEFT
            line1[i*2 + 1] = 250 - ((seedMax[i] - globalMin) * dataHeightC) + TOP
        end

        for i in 0 .. pocet-1
            line2[i*2] = columnWidth*(pocet-1-i) + LEFT
            line2[i*2 + 1] = 250 - ((seedMin[pocet-1-i] - globalMin) * dataHeightC) + TOP
        end

        line1.push(*line2)
        body.polygon(*line1)

        #leechov
        line1 = Array.new(pocet*2)
        line2 = Array.new(pocet*2)

        body.stroke_color('#0000FF')
        body.fill_color('#0000FF')
        body.fill_opacity(0.3)

        for i in 0 .. pocet-1
            line1[i*2] = columnWidth*i + LEFT
            line1[i*2 + 1] = 250 - ((leechMax[i] - globalMin) * dataHeightC) + TOP
        end

        for i in 0 .. pocet-1
            line2[i*2] = columnWidth*(pocet-1-i) + LEFT
            line2[i*2 + 1] = 250 - ((leechMin[pocet-1-i] - globalMin) * dataHeightC) + TOP
        end

        line1.push(*line2)
        body.polygon(*line1)

        body.draw(o)

        send_data(o.to_blob, :filename => "#{params[:id]}.gif", :type => 'image/gif', :disposition => 'inline')

    end

end
