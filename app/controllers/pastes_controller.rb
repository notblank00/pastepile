# frozen_string_literal: true

LANGUAGES = JSON.parse(File.read("#{Rails.root}/public/languages.json"))

class PastesController < ApplicationController
  before_action :set_paste, only: %i[show edit update destroy]
  before_action :check_modify_access, only: %i[edit updaate destroy]
  before_action :check_view_access, only: %i[show]
  skip_before_action :authenticate, only: %i[new create show]

  # GET /pastes or /pastes.json
  def index
    @pastes = if @current_user.admin
                Paste.all
              else
                Paste.find_by(users_id: current_user.id)
              end
    @pastes = [@pastes].flatten.compact
  end

  # GET /pastes/1 or /pastes/1.json
  def show; end

  # GET /pastes/new
  def new
    @paste = Paste.new
  end

  # GET /pastes/1/edit
  def edit; end

  # POST /pastes or /pastes.json
  def create
    @paste = Paste.new(paste_params)
    respond_to do |format|
      if @paste.save
        format.html { redirect_to @paste, notice: t('forms.messages.paste_was_successfully_created') }
        format.json { render :show, status: :created, location: @paste }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @paste.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pastes/1 or /pastes/1.json
  def update
    respond_to do |format|
      if @paste.update(paste_params)
        format.html { redirect_to @paste, notice: 'forms.messages.paste_was_successfully_updated' }
        format.json { render :show, status: :ok, location: @paste }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @paste.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pastes/1 or /pastes/1.json
  def destroy
    @paste.destroy
    respond_to do |format|
      format.html { redirect_to pastes_url, notice: 'forms.messages.paste_was_successfully_destroyed ' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_paste
    @paste = Paste.find(params[:id])
  end

  def check_view_access
    refuse_with_method_not_allowed unless !@paste.private || current_user&.admin || @paste.users_id == current_user&.id
  end

  def check_modify_access
    refuse_with_method_not_allowed unless current_user&.admin || @paste.users_id == current_user.id
  end

  # Only allow a list of trusted parameters through.
  def paste_params
    params[:paste][:users_id] = current_user&.id
    params.require(:paste).permit(:name, :content, :language, :private, :users_id)
  end
end
