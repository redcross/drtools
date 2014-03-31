class Role < Struct.new(:component, :name, :title)
  def title
    (super || name.to_s.titleize)
  end

  def label
    component.to_s.titleize + " " + title
  end

  def value
    [component, name].compact.map(&:to_s).join '_'
  end
end