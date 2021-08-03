class ContactController < ApplicationController
  def new
  end

  def create
    ContactMailer.contact_us(params[:name], params[:email], params[:subject], params[:content]).deliver_now
    flash[:success] = "Your message was sent successfully! We will get back to you shortly!"
    redirect_to contact_path
  end
end
