require 'net/http'

module Wikipedia
  class Api
    def initialize(name)
      @name = name.gsub(' ', '_')
    end

    def get_metadata
      id = get_wikibase_item(name)
      languages = get_languages_for_page(id)
      metadata = languages.reduce({}) do |data, lang|
        data[lang] = { link: language_page_url(lang), word_count: language_page_words_count(lang) } unless lang == 'commons'
        data
      end

      metadata.blank? ? { message: "No matching data found" } : metadata
    end

    def get_wikibase_item(name)
      url = "https://en.wikipedia.org/w/api.php?action=query&prop=pageprops&format=json&origin=*&titles=#{name}"
      uri = URI(url)
      Net::HTTP.get(uri).scan(/(?<="wikibase_item":").+(?=")/).first
    end

    def get_languages_for_page(id)
      url = "https://www.wikidata.org/w/api.php?action=wbgetentities&format=json&origin=*&props=sitelinks&ids=#{id}"
      uri = URI(url)
      result = JSON.parse(Net::HTTP.get(uri))['entities']
      return [] if result.blank?
      result[id]['sitelinks'].keys.map { |a| a.gsub('wiki', '') }
    end

    def language_page_url(lang_code)
      "https://#{lang_code}.wikipedia.org/wiki/#{name}"
    end

    def language_page_words_count(lang_code)
      url = "https://#{lang_code}.wikipedia.org/w/api.php?format=json&origin=*&action=query&list=search&srwhat=nearmatch&srlimit=1&srsearch=#{name}"
      uri = URI(url)
      JSON.parse(Net::HTTP.get(uri))['query']['search'].map { |data| data['wordcount'] }&.first.to_i
    end

    attr_reader :name
  end
end
