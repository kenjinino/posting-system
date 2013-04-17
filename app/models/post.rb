class Post < ActiveRecord::Base
  before_save :set_published_at_post

  belongs_to :user
  attr_accessible :body, :title, :published, :published_at

  scope :published, where(published: true).order("published_at desc")

  private

  def set_published_at_post
    if self.published == true
      self.published_at = Time.now
    end
  end
end
