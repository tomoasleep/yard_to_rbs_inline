class YardToRbsInline::YardType::Parser
start expression
rule
  expression : type_list { result = Ast::UnionType.build(val[0]) }

  type_list : type_list SEPARATOR type_single { result = [*val[0], val[2]] }
            | type_single                     { result = [val[0]] }

  type_single : generic_type
              | tuple_type
              | hash_type
              | literal_type     { result = Ast::LiteralType.new(content: val[0]) }
              | DUCK_SYMBOL NAME { result = Ast::DuckType.new(name: val[1]) }
              | NAME             { result = Ast::Type.new(name: val[0]) }

  type_pair : expression ARROW expression { result = [val[0], val[2]] }

  generic_type : type_single GENERIC_START type_list GENERIC_END { result = Ast::GenericType.new(container_type: val[0], types: val[2]) }
               | GENERIC_START type_list GENERIC_END             { result = Ast::GenericType.new(types: val[1]) }

  tuple_type : type_single TUPLE_START type_list TUPLE_END { result = Ast::TupleType.new(container_type: val[0], types: val[2]) }
             | TUPLE_START type_list TUPLE_END             { result = Ast::TupleType.new(types: val[1]) }

  literal_type : SYMBOL | STRING | INTEGER

  hash_type : type_single HASH_START type_pair HASH_END  { result = Ast::HashType.new(container_type: val[0], type_pair: val[2]) }
            | HASH_START type_pair HASH_END             { result = Ast::HashType.new(type_pair: val[1]) }
end

---- header
# Note: Prepend magic comment by script because default comments are prepended to header.

---- inner

#:: (String) -> Ast::node
def parse(string)
  @tokens = Scanner.new(string).to_racc_tokens

  do_parse()
end

#:: () -> untyped
def next_token
  @tokens.shift
end

---- footer

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
