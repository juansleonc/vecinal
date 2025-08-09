module NilModels

  module NilBooleans
    def present?; false end
    def blank?; true end
  end

  class NilAccountable
    include NilBooleans

    def method_missing(method_name)
      method_name == :company ? NilCompany.new : ''
    end
  end

  class NilCompany
    include NilBooleans

    def method_missing(method_name, *args, &block)
      ''
    end

    def administrators_and_residents
      User.where(id: nil)
    end

  end

  # class NilContactDetails
  #   include NilBooleans

  #   def method_missing(method_name)
  #     method_name.to_s.end_with?('?') ? false : ''
  #   end
  # end

  class NilPaymentFee
    include NilBooleans

    def method_missing(method_name)
      %i[bank_discount_percent platform_fee cm_fee].include?(method_name) ? 0 : nil
    end
  end

end