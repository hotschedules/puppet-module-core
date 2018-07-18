module Puppet::Parser::Functions
 newfunction(:picker, :type => :rvalue, :doc => <<-EOS

Similar to the Puppet stdlib 'pick' function; however supports undef/empty
strings.

This function is similar to a coalesce function in SQL in that it will return
the first value in a list of values
Typically,

  $real_jenkins_version = pick($::jenkins_version, '1.449')

The value of $real_jenkins_version will first look for a top-scope variable
called 'jenkins_version' failing that, will use a default value of 1.449.

EOS
) do |args|
   args = args.compact
   args.delete(:undef)
   args.delete(:undefined)
   args.delete("")
   return args[0]
 end
end
