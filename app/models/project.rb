require 'think200_jobs'
require 'think200_libs'

# == Schema Information
#
# Table name: projects
#
#  created_at  :datetime
#  id          :integer          not null, primary key
#  in_progress :boolean
#  name        :string(255)
#  notes       :text
#  tested_at   :datetime
#  updated_at  :datetime
#  user_id     :integer
#
class Project < ActiveRecord::Base
  has_many :apps, dependent: :destroy
  belongs_to :user

  # Convenience functions
  has_many :requirements, through: :apps
  has_many :expectations
  has_many :spec_runs

  validates :user, presence: true
  validates_associated :user
  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id }

  def queue_for_testing
    unless incomplete?
      self[:in_progress] = true
      self.save!
      Resque.enqueue(Think200::ScheduledTest, id, user_id)
    end
  end

  # Do I have rspec to offer?
  # Yes, if I have been saved.
  def rspec?
    persisted?
  end

  def to_rspec
    return nil if name.nil?

    result = <<-END.strip_heredoc
    #
    # #{rspec_filename}
    #
    # To run these tests:
    #   1. Install Ruby >= 2.0.0
    #   2. Install RSpec: $ gem install rspec-webservice_matchers
    #   3. Save this code as "#{rspec_filename}"
    #   4. Run RSpec:     $ rspec ./#{rspec_filename}
    #
    # Generated on #{Time.zone.now.to_s(:db)} by think200.com
    #
    require 'rspec/webservice_matchers'

    describe '#{name}' do
      END
      # apps.each { |e| result += e.to_rspec.indent(2) }
      contexts = apps.map { |a| a.to_rspec.indent(2) }
      result + contexts.join("\n") + "end\n"
    end

    def to_plaintext
      result = "Project \"#{name}\":\n"
      apps.each { |e| result += e.to_plaintext.indent(2) }
      result
    end

    def owned_by?(user)
      self.user == user
    end

    def most_recent_test
      @most_recent_test ||= spec_runs.order('created_at DESC').first
    end


    # true  = passed
    # false = failed
    # nil   = untested, at least in part
    def passed?
      return nil if most_recent_test.nil?

      results = most_recent_test.results
      return false if results.values.map{|r| r.success? }.include?(false)

      # If tested expectations are a superset of current ones
      if most_recent_test.expectation_ids.to_set.superset?(expectation_ids)
        # Assert: there are no failed results; we already checked.
        # So therefore, we know that the remaining are successful.
        return true
      else
        # Assert: new, untested expectations have been added
        return nil
      end
    end

    def expectation_ids
      @expectation_ids ||= expectations.pluck(:id).to_set
    end


    # True if not runnable; the user needs to
    # add expectations.
    def incomplete?
      expectation_ids.empty?
    end

    def runnable?
      ! incomplete?
    end

    def tested?
      ! tested_at.nil?
    end

    def failing_requirements
      requirements.select{|r| r.failed?}
    end

    def rspec_filename
      name_slug + '_spec.rb'
    end

    def text_filename
      name_slug + '.txt'
    end

    def to_s
      name
    end


    private
    def name_slug
      name.underscore.gsub(/[\. ]/, '_')
    end

  end
