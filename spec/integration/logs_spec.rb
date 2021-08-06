require 'rails_helper'

RSpec.describe "Log", type: :request do
  it 'gets index' do
    get logs_path
    expect(response).to render_template("logs/index")
    expect(response.status).to eq(200)
  end
end
