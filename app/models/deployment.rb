class Deployment < ActiveRecord::Base
  belongs_to :person

  def gap= gap
    super gap
    (self.group, self.activity, self.position, self.qual) = gap.split '/'
  end
end
