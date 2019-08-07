# pkg-query

pkg-query is a simple web scraping tool that allows you to compare the version of a package across some Linux distributions.

## Dependencies

[ChromeDriver](https://chromedriver.chromium.org/) is needed in order to query Fedora packages.

Additionally, some Ruby gems are needed in order to run the script:

- nokogiri
- watir

If you're using bundler, just run `bundler install` and it will get the required gems automatically.

## Instalation

```bash
$ gem install pkg-query
```

## Usage

```bash
$ pkg-query package
```

