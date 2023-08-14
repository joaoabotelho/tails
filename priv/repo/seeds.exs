alias Tails.Addresses.Addresses
alias Tails.Jobs.Jobs
alias Tails.Pets.Pets
alias Tails.Sitters.Sitters
alias Tails.Users.Users
alias Timex

now = DateTime.utc_now()

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

{:ok, cartman_sitter} =
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

{:ok, kenny_address} =
  Addresses.create_address(%{
    address: "Str 2",
    city: "South Park",
    postal_code: "3000-035",
    state: "Colorado"
  })

{:ok, _} =
  Users.create_personal_details(%{
    user_id: kenny_mccormick.id,
    address_id: kenny_address.id,
    name: "Kenny McCormick",
    age: 10,
    mobile_number: "916915372",
    emergency_contact: "912589971",
    title: :mr
  })

{:ok, _} =
  Pets.create_pet(%{
    user_id: kenny_mccormick.id,
    name: "Paco",
    breed: "Stray",
    age: 3,
    castrated: true,
    trained: false,
    vaccination: true,
    sex: :male,
    relationship_with_animals: "very good",
    vet_contact: "919919919",
    vet_name: "Maria",
    microship_id: "ABCDEFG12345",
    type: :xl_dog
  })

{:ok, _} =
  Pets.create_pet(%{
    user_id: kenny_mccormick.id,
    name: "Chico",
    breed: "Stray",
    age: 1,
    castrated: false,
    trained: false,
    vaccination: true,
    sex: :male,
    relationship_with_animals: "not good",
    vet_contact: "919919919",
    vet_name: "Maria",
    microship_id: "ABCDEFG12345",
    type: :s_dog
  })

{:ok, _} =
  Pets.create_pet(%{
    user_id: kenny_mccormick.id,
    name: "Melly",
    breed: "Stray",
    age: 1,
    castrated: true,
    trained: false,
    vaccination: true,
    sex: :female,
    vet_contact: "919919919",
    vet_name: "Maria",
    microship_id: "ABCDEFG12345",
    type: :cat
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

{:ok, _} =
  Jobs.create_job(%{
    client_id: kenny_mccormick.id,
    sitter_id: cartman_sitter.id,
    total_price: 10.2,
    type: :dog_walking,
    init_at: now |> Timex.shift(days: 4)
  })

{:ok, _} =
  Jobs.create_job(%{
    client_id: kenny_mccormick.id,
    sitter_id: cartman_sitter.id,
    total_price: 10.2,
    type: :dog_walking,
    init_at: now |> Timex.shift(days: 4)
  })
