module Models
  module Taggable
    extend ActiveSupport::Concern
    
    included do
      has_and_belongs_to_many :tags
    
      scope :tagged_with, (lambda do |names|
        joins(:tags).where(:tags => { :name => names }).uniq
      end)
    
      after_save :assign_tags
      after_save :increment_tags_counter_cache
      before_destroy :decrement_tags_counter_cache
    end
    
    def assign_tags
      raw = Replaceable.new(self.body)
      self.tags = raw.tag_names.map do |name|    
        Tag.find_or_create_by_name(name)
      end
    end

    # FIX this to update counter, not increment
    def increment_tags_counter_cache
      update_posts_counts
    end

    def decrement_tags_counter_cache
      update_posts_counts(-1)
    end

    def update_posts_counts(by = 1)
      tags.update_all("posts_count = posts_count + #{by}")
    end
  end
end