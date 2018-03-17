require_relative 'jobs_helper'

RSpec.describe NewAnswerEmailDistributionJob, type: :job do
  let!(:question) { create(:question) }
  let!(:subscribes) { create_list(:subscribe, 3, question: question) }
  let!(:answer) { create(:answer, question: question) }

  it "matches with enqueued job" do
    expect { NewAnswerEmailDistributionJob.perform_later(question, answer) }.to have_enqueued_job(NewAnswerEmailDistributionJob).on_queue('mailers')
  end

  it 'executes DailyMailer digest action' do
    question.subscribers.each do |subscriber|
      expect(AnswerMailer).to receive(:distribution).with(subscriber, answer)
    end

    NewAnswerEmailDistributionJob.perform_now(question, answer)
  end
end
