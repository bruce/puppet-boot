Puppet::Type.type(:boot).provide(:grubby) do

  commands :grubby => '/sbin/grubby'
  
  def create
    options = ['--add-kernel', @resource.value(:kernel),
               '--title', @resource.value(:name),
               ]
    if @resource.value(:initrd)
      options.push('--initrd', @resource.value(:initrd))
    end
    if @resource.value(:configfile)
      options.push('--config-file', @resource.value(:configfile))
    end
    if @resource.value(:options)
      options.push('--args', @resource.value(:options))
    end
    grubby(*options)
  end
  def exists?
    record
  rescue Puppet::ExecutionFailure
    false
  end

  def destroy
    grubby('--remove-kernel', @resource.value(:kernel))
  end

  private

  def record
    @record ||= records.detect do |record|
      kernel = @resource.value(:kernel).sub(/^\/boot/, '')
      next unless record['kernel'] == kernel
      next unless record['initrd'] == @resource.value(:initrd)
      next unless record['args'] == @resource.value(:options)
      true
    end
  end

  def records
    @records ||= find_records
  end

  def find_records
    current_index = nil
    raw_info.split(/\n/).inject([]) do |sets, line|
      key, value = line.split('=', 2)
      case key
      when 'index'
        if value != current_index
          sets.push({})
          current_index = value
        end
      when 'args'
        value = value[1..-2]
      end
      next sets if sets.empty?
      sets.last[key] = value
      sets
    end
  end

  def raw_info
    options = ['--info', @resource.value(:kernel)]
    if @resource[:configfile]
      options.push('--config-file', @resource.value(:configfile))
    end
    grubby(*options).chomp
  end

end
