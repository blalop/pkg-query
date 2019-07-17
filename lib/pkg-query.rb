
require 'nokogiri'
require 'open-uri'
require 'watir' # requires chrome-driver

module PkgQuery
    VERSION = '0.3'

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
        end.empty?
        nil
    end

    def debian(release, package)
        base_url = 'https://packages.debian.org'
        url = [base_url, release, package].join('/')
        doc = Nokogiri::HTML(open(url))
        doc.xpath('/html/body/div[2]/h1').inner_text[/\((.*)\)/, 1]
    end

    def fedora(release, package, timeout=1)
        base_url = 'https://apps.fedoraproject.org/packages'
        url = [base_url, package].join('/')
        browser = Watir::Browser.new :chrome, headless: true
        browser.goto url
        begin
            Watir::Wait.until(timeout: timeout) {browser.execute_script('return jQuery.active') == 0}
        rescue; end
        doc = Nokogiri::HTML(browser.html)
        doc.xpath('/html/body/div/div/div[2]/div/div[2]/div/div[2]/div[1]/div/div[2]/div/div/table/tbody/tr').each do |tbody| 
            return tbody.xpath('td[2]/a[1]').inner_text if tbody.xpath('td[1]/div').inner_text.chop == release
        end
    end

    def ubuntu(release, package)
        base_url = 'https://packages.ubuntu.com'
        url = [base_url, release, package].join('/')
        begin
            doc = Nokogiri::HTML(open(url))
        rescue
            retry
        end
        doc.xpath('/html/body/div[1]/div[3]/h1').inner_text[/\((.*)\)/, 1]
    end
end
