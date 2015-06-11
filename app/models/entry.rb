class Entry < ActiveRecord::Base
    belongs_to :account

    validates :title, presence: true, uniqueness: true, length: {maximum: 255}
    validates :contents, presence: true
    validates :account, presence: true
end
