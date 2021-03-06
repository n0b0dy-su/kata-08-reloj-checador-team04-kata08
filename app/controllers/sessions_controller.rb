class SessionsController < ApplicationController

  def create

    if employeer_exist?
      same_day?
    else
      redirect_to sessions_login_path, :alert => "Employeer not found. Make sure your private number is rigth"
    end

  end

  def home
  end 

  def employeer_exist?
    @employeer = Employer.find_by(privatenumber: params[:privatenumber])
    @employeer ? true : false
  end

  def same_day?
    today = Time.new
    query = Check.where("privatenumber = #{@employeer.privatenumber}").last
    if query
      query[:created_at].to_date === today.to_date ? what_move(query[:type_move]) : check_in
    else
      check_in
    end
  end

  def what_move(type_move)
    if type_move == "check_out"
      enough_for_today
    else
      check_out
    end
  end

  def check_in
    @check = Check.create(privatenumber: @employeer.privatenumber, type_move: "check_in")
    redirect_to sessions_login_path, :notice => "Check in successfully, welcome to work"
  end

  def check_out
    @check = Check.create(privatenumber: @employeer.privatenumber, type_move: "check_out")
    redirect_to sessions_login_path, :notice => "Check out successfully, see you later"
  end

  def enough_for_today
    redirect_to sessions_login_path, :alert => "Checks for today completed"
  end
end
