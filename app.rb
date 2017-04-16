#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'localbitcoins'
require 'time'

before do
	@client = LocalBitcoins.new
end

get '/' do
	ticker = @client.online_buy_ads_lookup(countrycode: 'RU', currency: 'RUB', country_name: '', payment_method: 'transfers-with-specific-bank')
	@ticker = ticker.to_hash["data"]["ad_list"]

	erb :index
end
