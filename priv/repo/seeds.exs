# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Popo.Repo.insert!(%Popo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Popo.Users.User
alias Popo.Friends.Friend
alias Popo.Repo

# alias Popo.F

# Repo.insert!(%User{email: "aa@aa", name: "aa", password: "123456789012"})
# Repo.insert!(%User{email: "bb@bb", name: "bb", password: "123456789012"})
# Repo.insert!(%User{email: "cc@cc", name: "cc", password: "123456789012"})

# Repo.insert!(%Friend{user_1: 1, user_2: 2})
# Repo.insert!(%Friend{user_1: 2, user_2: 1})

# Repo.insert!(%Friend{user_1: 1, user_2: 3})
# Repo.insert!(%Friend{user_1: 3, user_2: 1})


