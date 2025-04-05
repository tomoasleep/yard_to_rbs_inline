#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.7.1
# from Racc grammar file "".
#

require "racc/parser"

# NOTE: Prepend magic comment by script because default comments are prepended to header.

module YardToRbsInline
  module YardType
    class Parser < Racc::Parser
      module_eval(<<~'...END PARSER.Y/MODULE_EVAL...', __FILE__, __LINE__ + 1)

        #: (String) -> Ast::node
        def parse(string)
          @tokens = Scanner.new(string).to_racc_tokens

          do_parse()
        end

        #: () -> untyped
        def next_token
          @tokens.shift
        end

      ...END PARSER.Y/MODULE_EVAL...
      ##### State transition tables begin ###

      racc_action_table = [
        8, 9, 16, 10, 17, 11, 17, 12, 13, 14,
        15, 8, 9, 32, 10, 21, 11, 17, 12, 13,
        14,    15, 8, 9, 36, 10, 26, 11, 33, 12,
        13,    14,    15,     8, 9, 34, 10, 37, 11, nil,
        12,    13,    14, 15, 8, 9, nil, 10, nil, 11,
        nil, 12, 13, 14, 15, 8, 9, nil, 10, nil,
        11, nil, 12, 13, 14, 15, 8, 9, nil, 10,
        nil, 11, nil, 12, 13, 14, 15, 8, 9, nil,
        10, nil, 11, nil, 12, 13, 14, 15, 8, 9,
        nil, 10,    18, 11, 19, 12, 13, 14, 15, 20,
        18, 17, 19, 17, nil, nil, 31, 20, 35
      ]

      racc_action_check = [
        0,     0, 1, 0, 2, 0, 23, 0, 0, 0,
        0, 10, 10, 23, 10, 8, 10, 29, 10, 10,
        10,    10,    11,    11,    29,    11,    16,    11,    24, 11,
        11,    11,    11,    15,    15,    25,    15,    30,    15, nil,
        15,    15,    15,    15,    17,    17, nil, 17, nil, 17,
        nil, 17, 17, 17, 17, 18, 18, nil, 18, nil,
        18, nil, 18, 18, 18, 18, 19, 19, nil, 19,
        nil, 19, nil, 19, 19, 19, 19, 20, 20, nil,
        20, nil, 20, nil, 20, 20, 20, 20, 33, 33,
        nil, 33, 3, 33, 3, 33, 33,    33, 33, 3,
        27, 22, 27, 28, nil, nil, 22, 27, 28
      ]

      racc_action_pointer = [
        -3,     2, 2, 86, nil, nil, nil, nil, 11, nil,
        8,    19, nil, nil, nil, 30, 26, 41, 52, 63,
        74,   nil, 99, 4, 23, 21, nil, 94,   101, 15,
        23,   nil, nil, 85, nil, nil, nil,   nil, nil
      ]

      racc_action_default = [
        -20, -20, -1, -3, -4,    -5, -6, -7, -20, -9,
        -20, -20, -15, -16, -17, -20, -20, -20, -20, -20,
        -20, -8, -20, -20, -20, -20, 39, -2, -20, -20,
        -20, -12, -14, -20, -19, -11, -13, -18, -10
      ]

      racc_goto_table = [
        1, 22,    23, 25, 27, nil, nil, nil, 30, 28,
        29, nil, nil, nil, nil, nil, nil, nil, nil, nil,
        nil,   nil,   nil, nil, nil, nil, nil, nil, nil, nil,
        nil,   nil,   nil, 38
      ]

      racc_goto_check = [
        1,     2, 2, 8, 3, nil, nil, nil, 8, 2,
        2, nil, nil, nil, nil, nil, nil, nil, nil, nil,
        nil,   nil,   nil, nil, nil, nil, nil, nil, nil, nil,
        nil,   nil,   nil, 1
      ]

      racc_goto_pointer = [
        nil, 0, -9, -13, nil, nil, nil, nil, -12
      ]

      racc_goto_default = [
        nil, 24, 2,     3, 4, 5, 6, 7, nil
      ]

      racc_reduce_table = [
        0, 0, :racc_error,
        1, 16, :_reduce_1,
        3, 17, :_reduce_2,
        1, 17, :_reduce_3,
        1, 18, :_reduce_none,
        1, 18, :_reduce_none,
        1, 18, :_reduce_none,
        1, 18, :_reduce_7,
        2, 18, :_reduce_8,
        1, 18, :_reduce_9,
        3, 23, :_reduce_10,
        4, 19, :_reduce_11,
        3, 19, :_reduce_12,
        4, 20, :_reduce_13,
        3, 20, :_reduce_14,
        1, 22, :_reduce_none,
        1, 22, :_reduce_none,
        1, 22, :_reduce_none,
        4, 21, :_reduce_18,
        3, 21, :_reduce_19
      ]

      racc_reduce_n = 20

      racc_shift_n = 39

      racc_token_table = {
        false => 0,
        :error => 1,
        :SEPARATOR => 2,
        :DUCK_SYMBOL => 3,
        :NAME => 4,
        :ARROW => 5,
        :GENERIC_START => 6,
        :GENERIC_END => 7,
        :TUPLE_START => 8,
        :TUPLE_END => 9,
        :SYMBOL => 10,
        :STRING => 11,
        :INTEGER => 12,
        :HASH_START => 13,
        :HASH_END => 14
      }

      racc_nt_base = 15

      racc_use_result_var = true

      Racc_arg = [
        racc_action_table,
        racc_action_check,
        racc_action_default,
        racc_action_pointer,
        racc_goto_table,
        racc_goto_check,
        racc_goto_default,
        racc_goto_pointer,
        racc_nt_base,
        racc_reduce_table,
        racc_token_table,
        racc_shift_n,
        racc_reduce_n,
        racc_use_result_var
      ].freeze
      Ractor.make_shareable(Racc_arg) if defined?(Ractor)

      Racc_token_to_s_table = [
        "$end",
        "error",
        "SEPARATOR",
        "DUCK_SYMBOL",
        "NAME",
        "ARROW",
        "GENERIC_START",
        "GENERIC_END",
        "TUPLE_START",
        "TUPLE_END",
        "SYMBOL",
        "STRING",
        "INTEGER",
        "HASH_START",
        "HASH_END",
        "$start",
        "expression",
        "type_list",
        "type_single",
        "generic_type",
        "tuple_type",
        "hash_type",
        "literal_type",
        "type_pair"
      ].freeze
      Ractor.make_shareable(Racc_token_to_s_table) if defined?(Ractor)

      Racc_debug_parser = false

      ##### State transition tables end #####

      # reduce 0 omitted

      module_eval(<<'.,.,', __FILE__, __LINE__ + 1)
  def _reduce_1(val, _values, result)
     result = Ast::UnionType.build(val[0])
    result
  end
.,.,

      module_eval(<<'.,.,', __FILE__, __LINE__ + 1)
  def _reduce_2(val, _values, result)
     result = [*val[0], val[2]]
    result
  end
.,.,

      module_eval(<<'.,.,', __FILE__, __LINE__ + 1)
  def _reduce_3(val, _values, result)
     result = [val[0]]
    result
  end
.,.,

      # reduce 4 omitted

      # reduce 5 omitted

      # reduce 6 omitted

      module_eval(<<'.,.,', __FILE__, __LINE__ + 1)
  def _reduce_7(val, _values, result)
     result = Ast::LiteralType.new(content: val[0])
    result
  end
.,.,

      module_eval(<<'.,.,', __FILE__, __LINE__ + 1)
  def _reduce_8(val, _values, result)
     result = Ast::DuckType.new(name: val[1])
    result
  end
.,.,

      module_eval(<<'.,.,', __FILE__, __LINE__ + 1)
  def _reduce_9(val, _values, result)
     result = Ast::Type.new(name: val[0])
    result
  end
.,.,

      module_eval(<<'.,.,', __FILE__, __LINE__ + 1)
  def _reduce_10(val, _values, result)
     result = [val[0], val[2]]
    result
  end
.,.,

      module_eval(<<'.,.,', __FILE__, __LINE__ + 1)
  def _reduce_11(val, _values, result)
     result = Ast::GenericType.new(container_type: val[0], types: val[2])
    result
  end
.,.,

      module_eval(<<'.,.,', __FILE__, __LINE__ + 1)
  def _reduce_12(val, _values, result)
     result = Ast::GenericType.new(types: val[1])
    result
  end
.,.,

      module_eval(<<'.,.,', __FILE__, __LINE__ + 1)
  def _reduce_13(val, _values, result)
     result = Ast::TupleType.new(container_type: val[0], types: val[2])
    result
  end
.,.,

      module_eval(<<'.,.,', __FILE__, __LINE__ + 1)
  def _reduce_14(val, _values, result)
     result = Ast::TupleType.new(types: val[1])
    result
  end
.,.,

      # reduce 15 omitted

      # reduce 16 omitted

      # reduce 17 omitted

      module_eval(<<'.,.,', __FILE__, __LINE__ + 1)
  def _reduce_18(val, _values, result)
     result = Ast::HashType.new(container_type: val[0], type_pair: val[2])
    result
  end
.,.,

      module_eval(<<'.,.,', __FILE__, __LINE__ + 1)
  def _reduce_19(val, _values, result)
     result = Ast::HashType.new(type_pair: val[1])
    result
  end
.,.,

      def _reduce_none(val, _values, _result)
        val[0]
      end
    end
  end
end

module Yoda
  module Parsing
    module YardType
      class Parser
        # @rbs!
        #   def parse: (String) -> Ast::node
        #   def next_token: () -> untyped
      end
    end
  end
end
