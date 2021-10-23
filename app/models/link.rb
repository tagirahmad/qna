# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates_format_of :url,
                      with: %r{(http|https)://[a-zA-Z0-9\-\#/_]+\.[a-zA-Z0-9\-.\#/_]+}i,
                      on: :create,
                      message: 'please enter in correct format'

  def gist?
    url.include? 'https://gist.github.com/'
  end

  def gist_id
    URI.parse(url).path.split('/').last
  end
end
