class InfoController < ApplicationController
  def welcome
    @pid = Settings.alipay.pid
    @secret = Settings.alipay.secret
  end
end
