require 'spec_helper'
require 'rake'

describe 'rake send_karneblocket_reminders' do
  def run_task
    Rake::Task['send_karneblocket_reminders'].invoke
  end

  before do
    load File.expand_path '../../../lib/tasks/scheduler.rake', __FILE__
    Rake::Task.define_task :environment
    $stdout = File.new '/dev/null', 'w'

    ActionMailer::Base.deliveries = []

    @e = FactoryGirl.build :event
    @k = FactoryGirl.build :karnevalist
    @tl = FactoryGirl.create :ticket_listing, :event => @e, :seller => @k
  end

  after do
    $stdout = STDOUT
  end
end
