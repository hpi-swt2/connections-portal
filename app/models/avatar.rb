# A model for storing user avatars in the database
class Avatar < ApplicationRecord
  VALID_MIME_TYPES = %w[image/png image/jpg image/jpeg image/gif].freeze
  MAX_FILE_SIZE_MEGABYTES = 5

  validates :filename, :filesize, :file, :mime_type, presence: true
  validates :mime_type, inclusion: VALID_MIME_TYPES
  validates :filesize, numericality: { only_integer: true, less_than_or_equal_to: MAX_FILE_SIZE_MEGABYTES.megabytes }

  belongs_to :user
end
