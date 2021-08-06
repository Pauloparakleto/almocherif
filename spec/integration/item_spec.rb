require 'rails_helper'

RSpec.describe "Item", type: :request do
  before do
    @user = FactoryBot.create(:user)
    sign_in @user
  end
  it 'gets root' do
    get root_path
    expect(response).to render_template("items/index")
    expect(response.status).to eq(200)
  end
  it 'gets index' do
    get items_path
    expect(response).to render_template("items/index")
    expect(response.status).to eq(200)
  end

  it 'gets show' do
    item = FactoryBot.create_list(:item, 5)
    get item_path(item.first.id)
    expect(response).to render_template("items/show")
    expect(response.status).to eq(200)
  end

  it 'get new' do
    get new_item_path
    expect(response).to render_template("items/new")
    expect(response.status).to eq(200)
  end
  it 'post create' do
    post items_path, params: { item: { name: Faker::Commerce.product_name, quantity: Faker::Number.number(digits: 2) } }
    expect(response).to redirect_to item_path(Item.last.id)
    #   expect(response.status).to eq(201) TODO, understand the reason the default status response is 301, moved permanentely
  end
  it 'gets edit' do
    item = FactoryBot.create(:item)
    get edit_item_path(item.id)
    expect(response).to render_template("items/edit")
    expect(response.status).to eq(200)
  end
  it 'puts update' do
    item = FactoryBot.create(:item)
    put item_path(item.id), params: { item: { name: Faker::Commerce.product_name } }
    expect(response).to redirect_to item_path(item.id)
    # TODO, expect(response.status).to eq(200) understand the reason the default status response is 302 (found), moved permanentely expect(response.status).to eq(201)
  end

  it 'should delete' do
    item = FactoryBot.create(:item)
    delete item_path(item.id)
    expect(response).to redirect_to items_path
  end

  it 'entry' do
    item = FactoryBot.create(:item, quantity: 0)
    post entry_items_path, params: { id: item.id, options: 2 }
    expect(response.status).to eq(302)
  end

  it 'exit' do
    item = FactoryBot.create(:item, quantity: 2)
    post exit_items_path, params: { id: item.id, options: 2 }
    expect(response.status).to eq(302)
  end
end
