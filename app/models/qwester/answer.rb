module Qwester
  class Answer < ActiveRecord::Base
    if Qwester.rails_three?
      attr_accessible :value, :question_id, :position, :weighting
    end


    DEFAULT_VALUE = 'Not applicable'
    STANDARD_VALUES = ['Yes', 'No', DEFAULT_VALUE]

    has_and_belongs_to_many(
      :rule_sets,
      :join_table => :qwester_answers_rule_sets
    )
    
    has_and_belongs_to_many(
      :answer_stores,
      :join_table => :qwester_answer_stores_answers
    )

    belongs_to :question

    acts_as_list :scope => :question

    validates :value, :presence => true

    def self.find_first_or_create(attributes)
      where(attributes).first || create(attributes)
    end

    def self.standard_values
      STANDARD_VALUES
    end

    def self.default_value
      DEFAULT_VALUE
    end

    def self.rule_label_prefix
      @rule_label_prefix ||= 'a'
    end
    
    def self.weighting_alias
      @weighting_alias
    end
    
    def self.weighting_alias=(name)
      if name
        @weighting_alias = name
        define_method(name.to_sym) {send(:weighting)}
      else
        remove_weighting_alias
      end
    end
    
    def self.weighting_alias_name
      name = weighting_alias || :weighting
      name.to_s
    end
    
    def self.remove_weighting_alias
      if weighting_alias
        remove_method weighting_alias.to_sym
        @weighting_alias = nil
      end
    end

    def rule_label
      "#{self.class.rule_label_prefix}#{self.id}"
    end
  end
end