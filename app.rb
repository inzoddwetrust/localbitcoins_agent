#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'localbitcoins'
require 'time'

def get_offers_buy currency
	@client.online_buy_ads_lookup(currency: currency, countrycode: '', country_name: '', payment_method: '').to_hash["data"]["ad_list"]
end

def get_offers_sell currency
	@client.online_sell_ads_lookup(currency: currency, countrycode: '', country_name: '', payment_method: '').to_hash["data"]["ad_list"]
end

before do
	@client = LocalBitcoins.new
end

get '/' do
	@ticker1 = get_offers_buy ('RUB')
	@ticker2 = get_offers_sell ('CNY')

	erb :index
end
