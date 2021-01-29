require 'set'

module UsersHelper
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Style/OptionalBooleanParameter

  def search_record(arguments, record, use_wildcard = true)
    patterns = arguments.split
    matches = Set[]
    unless use_wildcard
      query = 'firstname = ? OR lastname = ? OR username = ? OR email = ?'
      patterns.each do |pattern|
        matches.merge(record.where(query, pattern.to_s, pattern.to_s, pattern.to_s, pattern.to_s).to_set)
      end
      return matches
    end
    query = 'firstname LIKE ? OR lastname LIKE ? OR username LIKE ? OR email LIKE ?'
    patterns.each do |pattern|
      matches.merge(record.where(query, "%#{pattern}%", "%#{pattern}%", "%#{pattern}%", "%#{pattern}%").to_set)
    end
    matches
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Style/OptionalBooleanParameter
end
