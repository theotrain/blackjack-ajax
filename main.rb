require 'rubygems'
require 'sinatra'
require 'pry'
require_relative 'helpers'
set :sessions, true
BET_MIN = 15
BET_INCREMENT = 15
START_DOLLARS = 100
BET_MAX_PROPORTION = 1

get '/' do
  erb :name
end

post '/name' do 
  if params[:name].lstrip[0] && params[:action]
    # "name is legit"
    session[:name] = params[:name]
    session[:deck] = nil
    session[:cash] = START_DOLLARS

    #set session vars to button value 
    params[:action][0] = '' #remove dollar sign
    session[:bet] = params[:action].to_i
    session[:settle_ok] = true
    session[:show_deal_top] = false

    redirect "/game"
  else
    @error = "We need a name and a bet amount, sir!"
    erb :name
  end
end

get "/game" do
  if session[:name].nil?
    redirect "/"
  else
    if session[:deck].nil?  || session[:player_hand].nil? || session[:dealer_hand].nil?
      initialize_decks
      clear_hands 
      deal_card(session[:player_hand])
      deal_card(session[:player_hand])
      deal_card(session[:dealer_hand])
    end
    erb :game
  end
end

post '/game/player/hit' do
  deal_card(session[:player_hand])
  session[:show_deal] = true
  session[:dealer_turn] = false
  erb :game, layout: false
end

post '/game/player/stay' do
  session[:dealer_turn] = true
  if hand_value(session[:dealer_hand]) < 17
    deal_card(session[:dealer_hand])
    session[:show_deal_top] = true
    
  else
    session[:show_deal_top] = false
  end
  erb :game, layout: false
end

# post '/game/player_action' do
#   if params[:action] == "Hit"
#     deal_card(session[:player_hand])
#     session[:show_deal] = true
#     session[:dealer_turn] = false
#   else #stay
#     session[:dealer_turn] = true
#     if hand_value(session[:dealer_hand]) < 17
#       deal_card(session[:dealer_hand])
#       session[:show_deal_top] = true
#     else
#       session[:show_deal_top] = false
#     end
#   end
#   redirect "/game"
# end

# post '/game/player_action' do
#   if params[:action] == "Hit"
#     deal_card(session[:player_hand])
#     session[:show_deal] = true
#   else #Stay
#     session[:dealer_turn] = true
#     while hand_value(session[:dealer_hand]) < 17
#      deal_card(session[:dealer_hand])
#     end
#   end
#   redirect "/game"
# end

post '/game/play_again' do
  params[:action][0] = '' #remove dollar sign
  session[:bet] = params[:action].to_i
  session[:settle_ok] = true
  initialize_decks
  clear_hands 
  deal_card(session[:player_hand])
  deal_card(session[:player_hand])
  deal_card(session[:dealer_hand])
  redirect "/game"
end

