class Page < ApplicationRecord

  def update_metadata
    update(metadata: Wikipedia::Api.new(name).get_metadata)
  end
end
