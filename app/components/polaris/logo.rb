class Polaris::Logo
  attr_reader :url
  attr_reader :src
  attr_reader :inverted_src
  attr_reader :alt
  attr_reader :width

  def initialize(url:, src:, inverted_src: nil, alt: nil, width: "125px")
    @url = url
    @src = src
    @inverted_src = inverted_src
    @alt = alt
    @width = width
  end
end
