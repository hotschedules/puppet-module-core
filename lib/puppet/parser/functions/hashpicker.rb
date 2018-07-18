# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker smartindent
#
module Puppet::Parser::Functions
 newfunction(:hashpicker, :type => :rvalue, :doc => <<-EOS

Returns the value of the first matching hash key (needle) in an array
of hashes (haystack). The arrays should be passed in priority order.

  $h1 = { foo => 'a' }
  $h2 = { foo => 'b', bar => '1' }

  $x = hashpicker([$h1, $h2], 'foo')

The above example will return 'a'.

EOS
) do |args|

  if (args.size != 2) then
    raise(Puppet::ParseError, "hashpicker(): Wrong number of arguments "+
      "given #{args.size} for 2")
  end

  haystack  = args[0]
  needle    = args[1]

  if (!haystack.is_a?(Array)) then
    raise(Puppet::ParseError, "hashpicker(): first arg is not an array")
  end

  found     = nil

  haystack.each { |hash|
    if hash.key?(needle) then
      found = hash[needle]
      break
    end
  }

  return found

 end
end
