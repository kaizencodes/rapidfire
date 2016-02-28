module Rapidfire
  module Questions
    class RadioPicture < Select
      has_many :options, as: :attachable
    end
  end
end
