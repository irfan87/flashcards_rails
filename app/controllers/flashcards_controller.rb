class FlashcardsController < ApplicationController
  before_action :authenticate_user!, :set_flashcard, only: [:show, :tags, :update, :destroy]

  # GET /flashcards/1/tags
  def tags
    @flashcard.tags
  end

  # GET /flashcards
  def index
    @flashcards = @current_user.flashcards

    render json: @flashcards
  end

  # GET /flashcards/1
  def show
    render json: @flashcard, include: :tags
  end

  # POST /flashcards
  def create
    @flashcard = Flashcard.new(flashcard_params)

    if @flashcard.save
      render json: @flashcard, status: :created, location: @flashcard
    else
      render json: @flashcard.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /flashcards/1
  def update
    if @flashcard.update(flashcard_params)
      render json: @flashcard
    else
      render json: @flashcard.errors, status: :unprocessable_entity
    end
  end

  # DELETE /flashcards/1
  def destroy
    @flashcard.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flashcard
      @flashcard = @current_user.flashcards.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def flashcard_params
      params.require(:flashcard).permit(:user_id, :question, :answer)
    end
end
