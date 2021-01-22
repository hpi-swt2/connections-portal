require 'set'

module UsersHelper
  def search_record(pattern, record, use_wildcard = true)
    patterns = params[:search].split()
    matches = Set[]
    if use_wildcard
      query = 'firstname = ? OR lastname = ? OR username = ? OR email = ?'
      for pattern in patterns do
        matches.merge(record.where(query, "#{pattern}", "#{pattern}", "#{pattern}", "#{pattern}").to_set)
      end
      return matches
    end
    query = 'firstname LIKE ? OR lastname LIKE ? OR username LIKE ? OR email LIKE ?'
    for pattern in patterns do
       matches.merge(record.where(query, "%#{pattern}%", "%#{pattern}%", "%#{pattern}%", "%#{pattern}%").to_set)
    end
    return matches
  end
end
