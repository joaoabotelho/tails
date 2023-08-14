# Users

alias Tails.Users.Users
alias Tails.Addresses.Addresses
alias Tails.Sitters.Sitters

{:ok, eric_cartman} =
  Users.create_user(%{
    email: "cartman_bra@gmail.com",
    password: Application.get_env(:tails, :seed_password),
    confirm_password: Application.get_env(:tails, :seed_password),
    password_changed_at: DateTime.truncate(DateTime.utc_now(), :second),
    status: :active,
    role: :sitter
  })

{:ok, eric_address} =
  Addresses.create_address(%{
    address: "Str 1",
    city: "South Park",
    postal_code: "3000-035",
    state: "Colorado"
  })

{:ok, _} =
  Users.create_personal_details(%{
    user_id: eric_cartman.id,
    address_id: eric_address.id,
    name: "Eric Cartman",
    age: 10,
    mobile_number: "916915372",
    emergency_contact: "912589971",
    title: :mr
  })

{:ok, _} =
  Sitters.create_sitter(%{
    user_id: eric_cartman.id,
    time_exp: 10,
    exp_description: "thats a bad mr kitty",
    job_types: [:drop_in, :dog_walking],
    pref_animals: [:xs_dog, :s_dog, :cat]
  })

{:ok, kenny_mccormick} =
  Users.create_user(%{
    email: "kenny@gmail.com",
    password: Application.get_env(:tails, :seed_password),
    confirm_password: Application.get_env(:tails, :seed_password),
    password_changed_at: DateTime.truncate(DateTime.utc_now(), :second),
    status: :active
  })

{:ok, _} =
  Users.create_personal_details(%{
    user_id: kenny_mccormick.id,
    name: "Kenny McCormick",
    age: 10,
    mobile_number: "916915372",
    emergency_contact: "912589971",
    title: :mr
  })

{:ok, stan_marsh} =
  Users.create_user(%{
    email: "stan_marsh@gmail.com",
    password: Application.get_env(:tails, :seed_password),
    confirm_password: Application.get_env(:tails, :seed_password),
    password_changed_at: DateTime.truncate(DateTime.utc_now(), :second),
    status: :active
  })

{:ok, _} =
  Users.create_personal_details(%{
    user_id: stan_marsh.id,
    name: "Stan Marsh",
    age: 10,
    mobile_number: "916915372",
    emergency_contact: "912589971",
    title: :mr
  })

{:ok, kyle_broflovski} =
  Users.create_user(%{
    email: "kyle@gmail.com",
    password: Application.get_env(:tails, :seed_password),
    confirm_password: Application.get_env(:tails, :seed_password),
    password_changed_at: DateTime.truncate(DateTime.utc_now(), :second),
    status: :active
  })

{:ok, _} =
  Users.create_personal_details(%{
    user_id: kyle_broflovski.id,
    name: "Kyle Broflovski",
    age: 10,
    mobile_number: "916915372",
    emergency_contact: "912589971",
    title: :mr
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
