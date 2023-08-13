# Users

alias Tails.Users.Users

{:ok, eric_cartman} =
  Users.create_user(%{
    email: "cartman_bra@gmail.com",
    name: "Eric Cartman",
    password: Application.get_env(:tails, :seed_password),
    confirm_password: Application.get_env(:tails, :seed_password),
    password_changed_at: DateTime.truncate(DateTime.utc_now(), :second),
    status: :active
  })

{:ok, kenny_mccormick} =
  Users.create_user(%{
    email: "kenny@gmail.com",
    name: "Kenny McCormick",
    password: Application.get_env(:tails, :seed_password),
    confirm_password: Application.get_env(:tails, :seed_password),
    password_changed_at: DateTime.truncate(DateTime.utc_now(), :second),
    status: :active
  })

{:ok, stan_marsh} =
  Users.create_user(%{
    email: "stan_marsh@gmail.com",
    name: "Stan Marsh",
    password: Application.get_env(:tails, :seed_password),
    confirm_password: Application.get_env(:tails, :seed_password),
    password_changed_at: DateTime.truncate(DateTime.utc_now(), :second),
    status: :active
  })

{:ok, kyle_broflovski} =
  Users.create_user(%{
    email: "kyle@gmail.com",
    name: "Kyle Broflovski",
    password: Application.get_env(:tails, :seed_password),
    confirm_password: Application.get_env(:tails, :seed_password),
    password_changed_at: DateTime.truncate(DateTime.utc_now(), :second),
    status: :active
  })

{:ok, _towelie} =
  Users.create_user(%{
    email: "towelie@gmail.com",
    name: "Towlie",
    password: Application.get_env(:tails, :seed_password),
    confirm_password: Application.get_env(:tails, :seed_password),
    password_changed_at: DateTime.truncate(DateTime.utc_now(), :second),
    status: :initiated
  })
