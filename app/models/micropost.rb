class Micropost < ApplicationRecord
  belongs_to :user
  scope :newest, ->{order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.content_length}
  validate  :picture_size
  feed = lambda do |id|
    following_ids = "SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id"
    where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end
  scope :feed, feed

  private

  def picture_size
    return unless picture.size > Settings.micropost.maximum_size.megabytes
    errors.add(:picture, t("microposts.micropost.size_error"))
  end
end
