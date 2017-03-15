class Trainer::LanguagesController < ApplicationController
  before_action :authorize
  before_action :load_language, except: [:index, :new, :create]

  def index
    @languages = Language.all
  end

  def new
    @language = Language.new
  end

  def create
    @language = Language.new language_params
    respond_to do |format|
      if @language.save
        flash.now[:success] = flash_message "created"
        format.html{redirect_to trainer_languages_path}
      else
        flash.now[:failed] = flash_message "not_created"
        format.html{render :new}
      end
      format.js
    end
  end

  def edit
  end

  def update
    if @language.update_attributes language_params
      flash[:success] = flash_message "updated"
    else
      flash[:failed] = flash_message "not_updated"
      render :edit
    end
    redirect_to trainer_languages_path
  end

  def destroy
    if @language.destroy
      flash[:success] = flash_message "deleted"
    else
      flash[:failed] = flash_message "not_deleted"
    end
    redirect_to trainer_languages_path
  end

  private
  def language_params
    params.require(:language).permit Language::ATTRIBUTES_PARAMS
  end

  def load_language
    @language = Language.find_by id: params[:id]
    unless @language
      redirect_to trainer_languages_path
      flash[:alert] = flash_message "not_find"
    end
  end
end
