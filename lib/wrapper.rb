module Wrapper
  def pack(msg)
    if JSON
      msg.to_json
    elsif MessagePack
      msg.to_msgpack
    else
      msg
    end
  end

  def unpack(msg)
    if JSON
      JSON.parse(msg)
    elsif MessagePack
      MessagePack.unpack(msg)
    else
      msg
    end
  end

  alias :p :pack
  alias :u :unpack
end