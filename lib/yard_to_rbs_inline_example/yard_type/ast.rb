# rbs_inline: enabled

module YardToRbsInlineExample
  module YardType
    module Ast
      # @rbs!
      #   type node = Type | LiteralType | DuckType | GenericType | TupleType | HashType | UnionType

      Type = Struct.new(:name, keyword_init: true)
      LiteralType = Struct.new(:content, keyword_init: true)
      DuckType = Struct.new(:name, keyword_init: true)
      GenericType = Struct.new(:container_type, :types, keyword_init: true)
      TupleType = Struct.new(:container_type, :types, keyword_init: true)
      HashType = Struct.new(:container_type, :type_pair, keyword_init: true)
      UnionType = Struct.new(:types, keyword_init: true) do
        #:: (untyped types) -> untyped
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
