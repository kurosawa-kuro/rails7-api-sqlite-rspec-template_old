# app/models/todo.rb

class Todo < ApplicationRecord
    validates :title, presence: true
  end
  