class ActionView::Helpers::InstanceTag
  DEFAULT_FIELD_OPTIONS = {}
  DEFAULT_FIELD_OPTIONS["size"] = 30
  
  def to_input_field_tag(field_type, options = {})
    options = options.stringify_keys
    options["size"] = options["maxlength"] || DEFAULT_FIELD_OPTIONS["size"] unless options.key?("size")
    options = DEFAULT_FIELD_OPTIONS.merge(options)
    if field_type == "hidden"
      options.delete("size")
    end
    options["type"]  ||= field_type
    options["value"] = options.fetch("value"){ value_before_type_cast(object) } unless field_type == "file"
    options["value"] &&= ERB::Util.html_escape(options["value"])
    add_default_name_and_id(options)
    tag("input", options)
  end
  
  def value_before_type_cast(object)
    unless object.nil?
      method_before_type_cast = @method_name + "_before_type_cast"

      object.respond_to?(method_before_type_cast) ?
        object.send(method_before_type_cast) :
        value(object)
    end
  end
  
  def add_default_name_and_id_for_value(tag_value, options)
    if tag_value.nil?
      add_default_name_and_id(options)
    else
      specified_id = options["id"]
      add_default_name_and_id(options)

      if specified_id.blank? && options["id"].present?
        options["id"] += "_#{sanitized_value(tag_value)}"
      end
    end
  end

  def add_default_name_and_id(options)
    if options.has_key?("index")
      options["name"] ||= options.fetch("name"){ tag_name_with_index(options["index"], options["multiple"]) }
      options["id"] = options.fetch("id"){ tag_id_with_index(options["index"]) }
      options.delete("index")
    elsif defined?(@auto_index)
      options["name"] ||= options.fetch("name"){ tag_name_with_index(@auto_index, options["multiple"]) }
      options["id"] = options.fetch("id"){ tag_id_with_index(@auto_index) }
    else
      options["name"] ||= options.fetch("name"){ tag_name(options["multiple"]) }
      options["id"] = options.fetch("id"){ tag_id }
    end

    options["id"] = [options.delete('namespace'), options["id"]].compact.join("_").presence
  end
  
  def tag_name(multiple = false)
    "#{@object_name}[#{sanitized_method_name}]#{"[]" if multiple}"
  end
  
  def sanitized_object_name
    @sanitized_object_name ||= @object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
  end

  def sanitized_method_name
    @sanitized_method_name ||= @method_name.sub(/\?$/,"")
  end

  def sanitized_value(value)
    value.to_s.gsub(/\s/, "_").gsub(/[^-\w]/, "").downcase
  end
  
  def tag_id
    "#{sanitized_object_name}_#{sanitized_method_name}"
  end
end