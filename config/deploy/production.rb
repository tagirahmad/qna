# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server "51.250.5.160", user: "tagirahmad", roles: %w{app db web}, primary: true
set :rail_env, :production

# Global options
# --------------
set :ssh_options, {
  keys:          %w(/Users/tagirahmadeev/.ssh/yandex_cloud_qna),
  forward_agent: true,
  auth_methods:  %w(publickey password),
  port:          2222
}
