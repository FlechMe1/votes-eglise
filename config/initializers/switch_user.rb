SwitchUser.setup do |config|
  # provider may be :devise, :authlogic, :clearance, :restful_authentication, :sorcery, or {name: :devise, store_sign_in: true}
  config.provider = :devise

  # available_users is a hash,
  # key is the model name of user (:user, :admin, or any name you use),
  # value is a block that return the users that can be switched.
  config.available_users = { user: -> { User.all } } # use User.scoped instead for rails 3.2

  # available_users_identifiers is a hash,
  # keys in this hash should match a key in the available_users hash
  # value is the name of the identifying column to find by,
  # defaults to id
  # this hash is to allow you to specify a different column to
  # expose for instance a username on a User model instead of id
  config.available_users_identifiers = { user: :id }

  # available_users_names is a hash,
  # keys in this hash should match a key in the available_users hash
  # value is the column name which will be displayed in select box
  config.available_users_names = { user: :email }

  # controller_guard is a block,
  # if it returns true, the request will continue,
  # else the request will be refused and returns "Permission Denied"
  # if you switch from "admin" to user, the current_user param is "admin"
  config.controller_guard = true

  # view_guard is a block,
  # if it returns true, the switch user select box will be shown,
  # else the select box will not be shown
  # if you switch from admin to "user", the current_user param is "user"
  config.view_guard = true

  # redirect_path is a block, it returns which page will be redirected
  # after switching a user.
  config.redirect_path = lambda { |request, params| params[:path].presence || request.referrer || '/' }

  config.switch_back = true
  config.controller_guard = ->(current_user, request, original_user) { current_user && current_user.is_admin? || original_user && original_user.is_admin? }
end