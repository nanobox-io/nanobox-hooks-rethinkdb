module Hooky
  module Rethinkdb

      CONFIG_DEFAULTS = {
      # global settings
      before_deploy:                 {type: :array, of: :string, default: []},
      after_deploy:                  {type: :array, of: :string, default: []},
      hook_ref:                      {type: :string, default: "stable"},
      # Rethinkdb settings
    }

  end
end
