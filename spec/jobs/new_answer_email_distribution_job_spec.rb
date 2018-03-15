require_relative 'jobs_helper'

RSpec.describe NewAnswerEmailDistributionJob, type: :job do
  let!(:subscribers) { create_list(:user, 3) }
  let!(:answer) { create(:answer) }

  it "matches with enqueued job" do
    expect { NewAnswerEmailDistributionJob.perform_later(subscribers, answer) }.to have_enqueued_job(NewAnswerEmailDistributionJob).on_queue('mailers')
  end

  it 'executes DailyMailer digest action' do
    subscribers.each do |subscriber|
      expect(AnswerMailer).to receive(:distribution).with(subscriber, answer)
    end

    NewAnswerEmailDistributionJob.perform_now(subscribers, answer)
  end
end
