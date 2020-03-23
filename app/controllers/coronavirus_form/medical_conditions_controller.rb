# frozen_string_literal: true

class CoronavirusForm::MedicalConditionsController < ApplicationController
  def show
    session[:medical_conditions] ||= ""
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    session[:medical_conditions] ||= ""
    session[:medical_conditions] = sanitize(params[:medical_conditions]).presence

    invalid_fields = validate_radio_field(
      PAGE,
      radio: session[:medical_conditions],
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render "coronavirus_form/#{PAGE}", status: :unprocessable_entity
    elsif session[:medical_conditions] == I18n.t("coronavirus_form.questions.medical_conditions.options.option_no.label")
      redirect_to controller: "coronavirus_form/not_eligible_medical", action: "show"
    elsif session[:check_answers_seen]
      redirect_to controller: "coronavirus_form/check_answers", action: "show"
    else
      redirect_to controller: "coronavirus_form/#{NEXT_PAGE}", action: "show"
    end
  end

private

  PAGE = "medical_conditions"
  NEXT_PAGE = "know_nhs_number"

  def previous_path
    contact_details_path
  end
end
