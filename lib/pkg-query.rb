
require 'nokogiri'
require 'open-uri'

module PkgQuery
    VERSION = '0.1'

    def arch(package)
        base_url = 'https://www.archlinux.org/packages'
        repos = ['core', 'community', 'extra']
        archs = ['x86_64', 'any']
        repos.product(archs).each do |repo|
            url = [base_url, repo, package].join('/')
            begin
                doc = Nokogiri::HTML(open(url))
                return doc.xpath('/html/body/div[2]/div[2]/h2').inner_text.split[1]
            rescue OpenURI::HTTPError
                next # pkg is not in this repo, next
            end
        end
    end

    def debian(release, package)
        base_url = 'https://packages.debian.org'
        url = [base_url, release, package].join('/')
        doc = Nokogiri::HTML(open(url))
        doc.xpath('/html/body/div[2]/h1').inner_text[/\((.*)\)/, 1]
    end

    def ubuntu(release, package)
        base_url = 'https://packages.ubuntu.com'
        url = [base_url, release, package].join('/')
        doc = Nokogiri::HTML(open(url))
        doc.xpath('/html/body/div[1]/div[3]/h1').inner_text[/\((.*)\)/, 1]
    end
end
