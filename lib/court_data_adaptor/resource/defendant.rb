# frozen_string_literal: true

module CourtDataAdaptor
  module Resource
    class Defendant < Base
      belongs_to :prosecution_case
      property :prosecution_case_reference, type: :string

      def name
        first_name + ' ' + last_name
      end
    end
  end
end