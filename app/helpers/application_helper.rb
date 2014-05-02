module ApplicationHelper

  BASE_TITLE = "Secure Santa"

  def full_title(page_title)
    if page_title.blank?
      BASE_TITLE
    else
      "#{BASE_TITLE} | #{page_title}"
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to(name, "javascript:void(0)", { "class" => "add_field", "data-association" => association.to_s, "data-content" => "#{fields}" })
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to("Remove", "javascript:void(0)", { class: "remove_field", tabindex: "-1" })
  end

  def player_role
    Player::ROLE_ANONYMOUS
  end

end
