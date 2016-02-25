module Rapidfire
  module Questions
    class Rating < Rapidfire::Question

      def options
        [1,2,3,4,5]
      end
    end
  end
end
