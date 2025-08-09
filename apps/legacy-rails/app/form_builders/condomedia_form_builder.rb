class CondomediaFormBuilder < ActionView::Helpers::FormBuilder
  delegate :content_tag, :tag, to: :@template

  %w[text_field text_area password_field email_field number_field select].each do |method_name|
    define_method(method_name) do |name, *args|
      extracted_options = args.extract_options!

      if method_name == 'select' && !args[1][:skip_prompt]
        args[1][:prompt] = object.class.human_attribute_name(name) + ':'
      end

      if options[:auto_placeholder] == true
        unless method_name == 'select'
          extracted_options[:placeholder] ||= object.class.human_attribute_name(name)
        end
        super(name, *(args << extracted_options))
      elsif extracted_options[:skip_autolabel]
        super(name, *(args << extracted_options))
      else
        label(name) + super(name, *(args << extracted_options))
      end

    end
  end

end