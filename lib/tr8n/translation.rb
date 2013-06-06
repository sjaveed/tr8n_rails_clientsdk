#--
# Copyright (c) 2010-2013 Michael Berkovich, tr8nhub.com
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++


class Tr8n::Translation < Tr8n::Base
  attributes :locale, :label, :context

  def initialize(attrs = {})
    super
    if attrs['context']
      ctx = {}
      attrs['context'].each do |token, rule_def|
        ctx[token.to_sym] = Tr8n::Rules::Base.rule_class(rule_def['type']).new(rule_def)
      end
      self.context = ctx
    end
  end

  # checks if the translation is valid for the given tokens
  def matches_rules?(token_values)
    return true if context.nil? or context.empty?   # doesn't have any rules
    
    context.each do |token, rule|
      # TODO: we need to support multiple versions of the token value: array, hash, etc...
      # it should be possible to have multiple rules per token - !

      token_value = token_values[token]
      token_value = token_value.first if token_value.is_a?(Array)
      return false unless rule.evaluate(token_value)
    end
    
    true
  end
  
  # used by the permutation generator
  def matches_rule_definitions?(new_rules_hash)
    rules_hash == new_rules_hash
  end

  def blank?
    self.label.blank?    
  end

end