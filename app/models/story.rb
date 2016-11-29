class Story < ApplicationRecord
  acts_as_taggable
  belongs_to :user
  validates :name, :link, presence: true
  has_many :votes do
    def latest
      order('id DESC').limit(3)
    end
  end

  scope :upcoming,  -> { where("votes_count < 5").order("id DESC") }
  scope :popular,   -> { where("votes_count >= 5").order("id DESC") }

  after_create :create_initial_vote

  def to_param
    "#{id}-#{name.gsub(/\W/, '-').downcase}"
  end

  protected
    def create_initial_vote
      votes.create user: user
    end
end
