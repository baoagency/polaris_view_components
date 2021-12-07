class Polaris::Logo
  attr_reader :src
  attr_reader :url
  attr_reader :alt
  attr_reader :width

  def initialize(src:, url: nil, alt: nil, width: "125px")
    @url = url
    @src = src
    @alt = alt
    @width = width
  end
end
