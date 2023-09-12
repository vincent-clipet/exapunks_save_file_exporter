# This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild

require 'kaitai/struct/struct'

unless Gem::Version.new(Kaitai::Struct::VERSION) >= Gem::Version.new('0.9')
  raise "Incompatible Kaitai Struct Ruby API: 0.9 or later is required, but you have #{Kaitai::Struct::VERSION}"
end

class ExapunksSolution < Kaitai::Struct::Struct

  WIN_VALUE_TYPE = {
    0 => :win_value_type_cycles,
    1 => :win_value_type_size,
    2 => :win_value_type_activity,
  }
  I__WIN_VALUE_TYPE = WIN_VALUE_TYPE.invert

  EDITOR_DISPLAY_STATUS = {
    0 => :editor_display_status_unrolled,
    1 => :editor_display_status_collapsed,
  }
  I__EDITOR_DISPLAY_STATUS = EDITOR_DISPLAY_STATUS.invert

  MEMORY_SCOPE = {
    0 => :memory_scope_global,
    1 => :memory_scope_local,
  }
  I__MEMORY_SCOPE = MEMORY_SCOPE.invert
  def initialize(_io, _parent = nil, _root = self)
    super(_io, _parent, _root)
    _read
  end

  def _read
    @magic = @_io.read_bytes(4)
    raise Kaitai::Struct::ValidationNotEqualError.new([240, 3, 0, 0].pack('C*'), magic, _io, "/seq/0") if not magic == [240, 3, 0, 0].pack('C*')
    @file_id = Pstr.new(@_io, self, @_root)
    @name = Pstr.new(@_io, self, @_root)
    @competition_wins = @_io.read_u4le
    @redshift_program_size = @_io.read_u4le
    @win_stats_count = @_io.read_u4le
    @win_stats = []
    (win_stats_count).times { |i|
      @win_stats << WinValuePair.new(@_io, self, @_root)
    }
    @exa_instances_count = @_io.read_u4le
    @exa_instances = []
    (exa_instances_count).times { |i|
      @exa_instances << ExaInstance.new(@_io, self, @_root)
    }
    self
  end
  class Pstr < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      _read
    end

    def _read
      @length = @_io.read_u4le
      @string = (@_io.read_bytes(length)).force_encoding("ASCII")
      self
    end

    ##
    # length
    attr_reader :length

    ##
    # string
    attr_reader :string
  end
  class WinValuePair < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      _read
    end

    def _read
      @type = Kaitai::Struct::Stream::resolve_enum(ExapunksSolution::WIN_VALUE_TYPE, @_io.read_u4le)
      @value = @_io.read_u4le
      self
    end

    ##
    # type
    attr_reader :type

    ##
    # value
    attr_reader :value
  end
  class ExaInstance < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      _read
    end

    def _read
      @_unnamed0 = @_io.read_bytes(1)
      raise Kaitai::Struct::ValidationNotEqualError.new([10].pack('C*'), _unnamed0, _io, "/types/exa_instance/seq/0") if not _unnamed0 == [10].pack('C*')
      @name = Pstr.new(@_io, self, @_root)
      @code = Pstr.new(@_io, self, @_root)
      @editor_display_status = Kaitai::Struct::Stream::resolve_enum(ExapunksSolution::EDITOR_DISPLAY_STATUS, @_io.read_u1)
      @memory_scope = Kaitai::Struct::Stream::resolve_enum(ExapunksSolution::MEMORY_SCOPE, @_io.read_u1)
      @bitmap = @_io.read_bytes(100)
      self
    end
    attr_reader :_unnamed0

    ##
    # name
    attr_reader :name

    ##
    # code
    attr_reader :code

    ##
    # editor_display_status
    attr_reader :editor_display_status

    ##
    # memory_scope
    attr_reader :memory_scope

    ##
    # bitmap
    attr_reader :bitmap
  end
  attr_reader :magic

  ##
  # File ID
  attr_reader :file_id

  ##
  # Name
  attr_reader :name

  ##
  # competition_wins
  attr_reader :competition_wins

  ##
  # redshift_program_size
  attr_reader :redshift_program_size

  ##
  # win_stats_count
  attr_reader :win_stats_count

  ##
  # win_stats
  attr_reader :win_stats

  ##
  # exa_instances_count
  attr_reader :exa_instances_count

  ##
  # exa_instance
  attr_reader :exa_instances
end
