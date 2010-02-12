require 'pathname'

Puppet::Type.newtype(:boot) do

  ensurable
  
  newparam(:name) do
    isnamevar
  end

  newparam(:configfile) do
    validate do |value|
      unless Pathname.new(value).absolute?
        raise ArgumentError, "configfile must be an absolute path"
      end
    end
  end

  newparam(:kernel) do
    isrequired
    validate do |value|
      unless Pathname.new(value).absolute?
        raise ArgumentError, "kernel must be an absolute path"
      end
    end
  end
  
  newparam(:initrd) do
    validate do |value|
      unless Pathname.new(value).absolute?
        raise ArgumentError, "initrd must be an absolute path"
      end
    end
  end
  
  newparam(:options)

end
