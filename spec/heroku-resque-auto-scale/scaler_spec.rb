require 'spec_helper'

# HEROKU_API_KEY=your_api_key HEROKU_APP_NAME=your_app_name bundle exec rake spec
describe HerokuResqueAutoScale::Scaler do

  before { HerokuResqueAutoScale::Scaler.stub authorised?: true }
  
  context 'with stub response' do
    before do
      stub_request(:get, "https://api.heroku.com/apps/your_app_name").
        to_return(:status => 200, :body => JSON.generate({ workers: '42' }), :headers => {})
    end
  
    it { HerokuResqueAutoScale::Scaler.workers.should eql 42 }
  end
  
  context 'with stub response' do
    before do
      stub_request(:post,
                   "https://api.heroku.com/apps/your_app_name/ps/scale?qty=69&type=worker").
      to_return(:status => 200, :body => "", :headers => {})
    end
    
    it { HerokuResqueAutoScale::Scaler.send(:workers=, '69') }
  end
  
  context 'with stub response' do
    before { Resque.stub(info: { pending: '16', working: '61' }) }
    it { HerokuResqueAutoScale::Scaler.job_count.should eql 16 }
    it { HerokuResqueAutoScale::Scaler.working_job_count.should eql 61 }
  end

end
