class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.validate.length.max_140}
  validates :image, content_type: {in: Settings.image_format,
                                   message: :image_format},
    size: {less_than: 5.megabytes,
           message: :image_size_limit}

  def recent_posts
     microposts.order(created_at: DESC)
  end
end
