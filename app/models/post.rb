class Post < ActiveRecord::Base
  before_save :set_published_at_post

  belongs_to :user
  attr_accessible :body, :title, :published, :published_at

  scope :published, where(published: true).order("published_at desc")

  searchable do
    text :title, stored: true
    text :body, stored: true
    time :published_at
    boolean :published
  end

  private

  def set_published_at_post
    if self.published == true and self.published_at == nil
      self.published_at = Time.now
    end
  end
end
