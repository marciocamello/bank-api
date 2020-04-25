defmodule BankApi.Seed.Users do
  use Mix.Task

  alias BankApi.Repo
  alias BankApi.Models.Users

  def add_user do

    Faker.start()

    user1 = %{
      email: "hermione@hogwarts.com",
      firstName: "Hermione",
      lastName: "Granger",
      phone: "00 0000 0000",
      password: "123123123"
    }

    {:ok, _user1} =Users.create_user(user1)
    Users.bind_account(_user1)

    user2 = %{
      email: "harrypotter@hogwarts.com",
      firstName: "Harry",
      lastName: "Potter",
      phone: "00 0000 0000",
      password: "123123123"
    }

    {:ok, _user2} =Users.create_user(user2)
    Users.bind_account(_user2)
  end

end
