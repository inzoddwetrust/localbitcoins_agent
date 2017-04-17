#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'localbitcoins'
require 'time'
require 'money'
require 'money/bank/google_currency'

def get_offers_buy currency
	@client.online_buy_ads_lookup(currency: currency, countrycode: '', country_name: '', payment_method: '').to_hash["data"]["ad_list"]
end

def get_offers_sell currency
	@client.online_sell_ads_lookup(currency: currency, countrycode: '', country_name: '', payment_method: '').to_hash["data"]["ad_list"]
end

before do
	Money::Bank::GoogleCurrency.ttl_in_seconds = 600
	Money.default_bank = Money::Bank::GoogleCurrency.new
	@client = LocalBitcoins.new
end

get '/' do
	erb :index
end

get '/result' do
	@ticker1 = get_offers_buy ('RUB')
	@ticker2 = get_offers_sell ('CNY')
	@google_rate = Money.new(1_00, "CNY").exchange_to(:RUB)
	erb :index
end
