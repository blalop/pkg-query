
require 'nokogiri'
require 'open-uri'

class Deb
    def initialize(distro, package)
        base_url = 'https://packages.debian.org'
        @url = [base_url, distro, package].join('/')
        @doc = Nokogiri::HTML(open(@url))
        @name = @doc.xpath('/html/body/div[2]/h1').inner_text
        @description = @doc.xpath('//*[@id="pdesc"]').inner_text.strip
        depends = @doc.xpath('/html/body/div[2]/div[6]/ul[1]/li/dl/dt/a').map{|str| str.inner_text.strip}
        depends_desc = @doc.xpath('/html/body/div[2]/div[6]/ul[1]/li/dl/dd').map{|str| str.inner_text.strip}
        @depends = depends.zip(depends_desc).map{|str| str.join(': ')}
        recommends = @doc.xpath('/html/body/div[2]/div[6]/ul[2]/li/dl/dt/a').map{|str| str.inner_text.strip}
        recommends_desc = @doc.xpath('/html/body/div[2]/div[6]/ul[2]/li/dl/dd').map{|str| str.inner_text.strip}
        @recommends = recommends.zip(recommends_desc).map{|str| str.join(': ')}
        suggests = @doc.xpath('/html/body/div[2]/div[6]/ul[3]/li/dl/dt/a').map{|str| str.inner_text.strip}
        suggests_desc = @doc.xpath('/html/body/div[2]/div[6]/ul[3]/li/dl/dd').map{|str| str.inner_text.strip}
        @suggests = suggests.zip(suggests_desc).map{|str| str.join(': ')}
    end
    def to_s
        s = [@url, @name, @description].join
        s += "Depends:\n" + @depends.join("\n")
        s += "Recommends:\n" + @recommends.join("\n")
        s += "Suggests:\n" + @suggests.join("\n")
    end
end

gcc = Deb.new('buster', 'gcc')
puts gcc