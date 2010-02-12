require 'pathname'

Puppet::Type.newtype(:boot) do

  ensurable
  
  newparam(:name) do
    isnamevar
  end

  newparam(:configfile) do
    munge do |value|
      path = Pathname.new(value)
      unless path.absolute?
        raise ArgumentError, "configfile must be an absolute path"
      end
      path
    end
  end

  newparam(:kernel) do
    isrequired
    munge do |value|
      path = Pathname.new(value)
      unless path.absolute?
        raise ArgumentError, "kernel must be an absolute path"
      end
      path
    end
  end
  
  newparam(:initrd) do
    munge do |value|
      path = Pathname.new(value)
      unless path.absolute?
        raise ArgumentError, "kernel must be an absolute path"
      end
      path
    end
  end
  
  newparam(:options)

end
