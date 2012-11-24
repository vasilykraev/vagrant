name "addition"
description "Addition soft"
run_list(
  "recipe[postgresql::server]",
  "recipe[php::module_pgsql]",
  "recipe[postgis2]",
  # "recipe[postgresql::postgis]",
  # "recipe[phpmyadmin]",
  "recipe[python]",
  "recipe[zsh]"
)