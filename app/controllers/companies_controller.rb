# frozen_string_literal: true

class CompaniesController < InheritedResources::Base
  private

  def company_params
    params.require(:company).permit(:name, :address)
  end
end
