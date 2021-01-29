# When establishing a websocket connection, we don't have access to the user session
# but we do have access to the cookies. In order to authenticate the user we need to
# do some devise related stuff first.

Warden::Manager.after_set_user do |user, auth, opts|
  scope = opts[:scope]
  auth.cookies.signed["#{scope}.id"] = user.id
end

Warden::Manager.before_logout do |_user, auth, opts|
  scope = opts[:scope]
  auth.cookies.signed["#{scope}.id"] = nil
end
