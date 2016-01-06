class WebsiteController < ApplicationController
  before_filter  :charity,:amount, :has_token, :set_token, only: :donate
  def index
    @token = nil
  end

  def donate

    if params[:charity] == "random"
      #abort(random.to_s)
      char_id = random
      charity = Charity.find_by(id: char_id)
    else
      charity = Charity.find_by(id: params[:charity])
    end

    if Rails.env.test?
      charge = OpenStruct.new({
                                  amount: params[:amount].to_i * 100,
                                  paid: (params[:amount].to_i != 999),
                              })
    else
      charge = Omise::Charge.create({
                                        amount: params[:amount].to_i * 100,
                                        currency: "THB",
                                        card: params[:omise_token],
                                        description: "Donation to #{charity.name} [#{charity.id}]",
                                    })
    end

      if charge.paid

        charity.credit_amount(charge.amount)
        #flash[:success] = "Success you've donated #{charge.amount/100} bath to #{charity.name} "
        flash.notice = t(".success")
        redirect_to root_path
        #render :index
      else
        fail
      end

  end

  private

  def fail
    flash.now.alert = t(".failure")
    render :index
  end
  def charity
    if params[:charity] == ""
      fail
    end
  end
  def random
    charity_list = Charity.all
    id_arr = []
    i = 0
    charity_list.each do |char|
      id_arr[i] = char.id
      i = i+1
    end
    return id_arr.sample
  end
  def under20
    @token = retrieve_token(params[:omise_token])
    flash.now.alert = t(".under20")
    render :index
  end

  def amount
    if params[:amount].to_i < 20
      under20
    end
  end

  def has_token
    if params[:omise_token].present? == false
      fail
    end
  end

  def set_token
    @token = retrieve_token(params[:omise_token]) if has_token
  end

  def retrieve_token(token)
    if Rails.env.test?
      OpenStruct.new({
                         id: "tokn_X",
                         card: OpenStruct.new({
                                                  name: "J DOE",
                                                  last_digits: "4242",
                                                  expiration_month: 10,
                                                  expiration_year: 2020,
                                                  security_code_check: false,
                                              }),
                     })
    else
      Omise::Token.retrieve(token)
    end
  end

  def update_charge_to_fail(charge_id)
    charge = Omise::Charge.retrieve(charge_id)
    charge.update(paid: false)
  end
end
