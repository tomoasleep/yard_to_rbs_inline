# frozen_string_literal: true

# rbs_inline: enabled

module YardToRbsInline
  module YardType
    module Ast
      # @rbs!
      #   type node = Type | LiteralType | DuckType | GenericType | TupleType | HashType | UnionType

      Type = Data.define(:name)
      LiteralType = Data.define(:content)
      DuckType = Data.define(:name)
      GenericType = Data.define(:container_type, :types)
      TupleType = Data.define(:container_type, :types)
      HashType = Data.define(:container_type, :type_pair)

      class UnionType < Data.define(:types)
        # @rbs!
        #   def initialize: (types: Array[node]) -> void
        #   attr_reader types: Array[node]

        #: (untyped types) -> untyped
        def self.build(types)
          if types.length == 1
            types.first
          else
            UnionType.new(types: types)
          end
        end
      end
    end
  end
end
