# == Schema Information
#
# Table name: requirements
#
#  app_id     :integer
#  created_at :datetime
#  id         :integer          not null, primary key
#  name       :string(255)
#  notes      :text
#  updated_at :datetime
#

class Requirement < ActiveRecord::Base
  belongs_to :app
  has_many   :expectations, dependent: :destroy

  default_scope { order(:name) }
  
  def to_s
    name
  end

  def full_name_without_project
    "#{app.name} #{name}"
  end

  def to_rspec
    result = "it '#{name}' do\n"
    expectations.each { |e| result += e.to_rspec.indent(2) }
    result + "end\n"
  end

  def to_plaintext
    result = "Requirement: \"#{name}\":\n"
    expectations.each { |e| result += e.to_plaintext.indent(2) }
    result + "\n"
  end

  def passed?
    ! expectations.map{|e| e.passed?}.include?(false)
  end
end
