module Enumerable

  def flat_group_by(&block)
    reduce(Hash.new) do |acc, obj|
      key = block.call(obj)
      acc[key] = obj
      acc
    end
  end

end