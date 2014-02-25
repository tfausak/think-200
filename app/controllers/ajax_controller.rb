require 'think200_jobs'
include Think200

class AjaxController < ApplicationController
  before_action :authenticate_user!

  def queue_status
    projects = current_user.projects
    data = {}

    # A list of project id's
    data['project_list'] = projects.map{ |p| p.id }

    # a map of id to true/false if currently working
    data['working'] = {}

    projects.each do |p|
      queued = Resque.enqueued?(ScheduledTest, p.id, p.user_id) ? 'true' : 'false'
      data['working'][p.id] = queued
    end

    render json: data.to_json
  end


end