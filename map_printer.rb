# frozen_string_literal: true

class MapPrinter
  def self.print(map)
    map.map do |city, directions|
      "#{city} #{directions.to_a.map { |pair| pair.join('=') }.join(' ')}"
    end.join("\n")
  end
end
