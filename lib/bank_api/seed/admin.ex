defmodule BankApi.Seed.Admin do
  alias BankApi.Models.Users

  def add_admin do

    Faker.start()

    admin = %{
      email: "albusdumbledore@hogwarts.com",
      firstName: "Albus",
      lastName: "Dumbledore",
      phone: "00 0000 0000",
      password: "123123123",
      acl: "admin"
    }

    Users.create_user(admin)
  end
end
