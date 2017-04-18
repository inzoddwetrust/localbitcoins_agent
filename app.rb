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

def prepare_list list, condition
	if condition!=""
		temp_list=list.map{|elem| condition.split(/[\s,']/).any?{|word| elem["data"]["bank_name"].upcase.include?(word)} ? elem : elem='NONE'}
		temp_list.delete("NONE")
		return temp_list
	else
		return list
	end
end

before do
	Money::Bank::GoogleCurrency.ttl_in_seconds = 300
	Money.default_bank = Money::Bank::GoogleCurrency.new
	@client = LocalBitcoins.new
end

get '/' do
	erb :index
end

post '/' do
	@currency_1 = params[:currency_1]
	@currency_2 = params[:currency_2]
	@amount = params[:amount]
	@currency_1_bank=params[:currency_1_bank]
	@currency_2_bank=params[:currency_2_bank]

	@google_rate = Money.new(1000000, @currency_2).exchange_to(@currency_1).to_f/10000
	@ticker1 = get_offers_buy (@currency_1)
	@ticker2 = get_offers_sell (@currency_2)

	@currency_1.chop!
	@currency_2.chop!
	@currency_1_bank.upcase! if @currency_1_bank!=nil
	@currency_2_bank.upcase! if @currency_2_bank!=nil

	@ticker1 = prepare_list(@ticker1, @currency_1_bank)
	@ticker2 = prepare_list(@ticker2, @currency_2_bank)

	erb :result
end

# get '/result' do
# 	@ticker1 = get_offers_buy ('RUB')
# 	@ticker2 = get_offers_sell ('CNY')
# 	@google_rate = Money.new(1_00, "CNY").exchange_to(:RUB)
# 	erb :result
# end
