class CupsController < ApplicationController
  def index
    @cups = Cup.all
  end
end
