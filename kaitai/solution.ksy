meta:
  id: exapunks_solution
  file-extension: exapunks_solution
  endian: le
seq:
  - id: magic
    contents: [0xF0, 0x03, 0x00, 0x00]
  - id: file_id
    type: pstr
    doc: File ID
  - id: name
    type: pstr
    doc: Name
  - id: competition_wins
    type: u4
    doc: competition_wins
  - id: redshift_program_size
    type: u4
    doc: redshift_program_size
  - id: win_stats_count
    type: u4
    doc: win_stats_count
  - id: win_stats
    type: win_value_pair
    repeat: expr
    repeat-expr: win_stats_count
    doc: win_stats
  - id: exa_instances_count
    type: u4
    doc: exa_instances_count
  - id: exa_instances
    type: exa_instance
    repeat: expr
    repeat-expr: exa_instances_count
    doc: exa_instance
types:
  pstr:
    seq:
      - id: length
        type: u4
        doc: length
      - id: string
        type: str
        encoding: ASCII
        size: length
        doc: string
  win_value_pair:
    seq:
      - id: type
        type: u4
        enum: win_value_type
        doc: type
      - id: value
        type: u4
        doc: value
  exa_instance:
    seq:
      - contents: [0xA]
      - id: name
        type: pstr
        doc: name
      - id: code
        type: pstr
        doc: code
      - id: editor_display_status
        type: u1
        enum: editor_display_status
        doc: editor_display_status
      - id: memory_scope
        type: u1
        enum: memory_scope
        doc: memory_scope
      - id: bitmap
        size: 100
        doc: bitmap
enums:
  win_value_type:
    0: cycles
    1: size
    2: activity
  editor_display_status:
    0: unrolled
    1: collapsed
  memory_scope:
    0: global
    1: local