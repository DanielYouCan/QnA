require_relative 'jobs_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:digest_user) { create(:user) }
  let!(:author) { create(:user) }
  let!(:questions) { create_list(:question, 3, user: author) }

  it "matches with enqueued job" do
    expect { DailyDigestJob.perform_later }.to have_enqueued_job(DailyDigestJob).on_queue('mailers')
  end

  it 'executes DailyMailer digest action' do
    User.find_each do |user|
      expect(DailyMailer).to receive(:digest).with(user)
    end

    DailyDigestJob.perform_now
  end
end
