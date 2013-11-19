module Qwester
  class QuestionnairesController < ApplicationController

    def index
      @questionnaires = current_questionnaires
    end

    def show
      @questionnaire = Qwester::Questionnaire.find(params[:id])
    end

    def update
      @questionnaire = Qwester::Questionnaire.find(params[:id])
      update_qwester_answer_store
      if @questionnaire.errors.empty?
        redirect_to questionnaires_path
      else
        render :show
      end
    end

    def reset
      get_qwester_answer_store
      @qwester_answer_store.reset
      redirect_to questionnaires_path
    end
  end
end
