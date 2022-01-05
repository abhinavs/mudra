class TransactionsController < ApplicationController
  post '/v1/users/:user_id/credit' do
    authenticate_app!
    manage_resource @user.create_credit_transaction(params)
  end

  post '/v1/users/:user_id/debit' do
    authenticate_app!
    manage_resource @user.create_debit_transaction(params)
  end

  get '/v1/users/:user_id/transactions' do
    authenticate_app!
    manage_resource paginate(@user.all_transactions)
  end

  get '/v1/transactions' do
    authenticate_app!
    manage_resource paginate(@app.all_transactions)
  end
end
