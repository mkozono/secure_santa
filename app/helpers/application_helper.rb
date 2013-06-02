module ApplicationHelper

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    on_click = "secureSanta.addFields(this, \"#{association}\", \"#{escape_javascript(fields)}\")".html_safe
    link_to_function(name, on_click)
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "secureSanta.removeFields(this)", :tabindex => -1)
  end
  
end
