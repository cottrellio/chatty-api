# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Chatty.Repo.insert!(%Chatty.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Chatty.Accounts.User
alias Chatty.Channels.Channel
alias Chatty.Repo

# Seed some users
admin = Repo.insert!(%User{email: "dave@example.com", first_name: "Dave", last_name: "Cottrell", username: "cottrellio", password: "abcde12345", password_confirmation: "abcde12345"})

user_1 = Repo.insert!(%User{email: "user1@example.com", first_name: "1", last_name: "1", username: "user1", password: "abcde12345", password_confirmation: "abcde12345"})
user_2 = Repo.insert!(%User{email: "user2@example.com", first_name: "2", last_name: "2", username: "user2", password: "abcde12345", password_confirmation: "abcde12345"})
user_3 = Repo.insert!(%User{email: "user3@example.com", first_name: "3", last_name: "3", username: "user3", password: "abcde12345", password_confirmation: "abcde12345"})
user_4 = Repo.insert!(%User{email: "user4@example.com", first_name: "4", last_name: "4", username: "user4", password: "abcde12345", password_confirmation: "abcde12345"})
user_5 = Repo.insert!(%User{email: "user5@example.com", first_name: "5", last_name: "5", username: "user5", password: "abcde12345", password_confirmation: "abcde12345"})


# Setup a few channels for `user_1`
Repo.insert!(%Channel{name: "General", purpose: "General Store of conversation :)", user_id: user_1.id})
