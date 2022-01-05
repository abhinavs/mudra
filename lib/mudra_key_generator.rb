require 'digest/sha1'
module Mudra
  module KeyGenerator
    CHARS = ('a'..'z').to_a + ('0'..'9').to_a
    def generate_key
      k = (1..6).map { CHARS[rand(CHARS.size)] }.join
      return Digest::SHA1.hexdigest("#{Time.now.to_i}#{k}")
    end
  end
end
