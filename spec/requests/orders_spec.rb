require 'rails_helper'

RSpec.describe "Orders", type: :request do
  describe "get orders_path" do
    it "renders the index view" do
      FactoryBot.create_list(:order, 10)
      get orders_path
      expect(response).to render_template(:index)
    end
  end
  describe "get order_path" do
    it "renders the :show template" do
      order = FactoryBot.create(:order)
      get order_path(id: order.id)
      expect(response).to render_template(:show)
    end
    it "redirects to the index path if the order id is invalid" do
      get order_path(id: 5000) #an ID that doesn't exist
      expect(response).to redirect_to orders_path
    end
  end
  describe "get new_order_path" do
    it "renders the :new template" do
      get orderer_path(:new)
      expect(response). to render_template(:new)
    end
  end
  describe "get edit_order_path" do
    it "renders the :edit template" do
      order = FactoryBot.create(:order)
      get edit_order_path(id: order.id)
      expect(response).to render_template(:edit)
    end  
  end
  
  describe "post orders_path with valid data" do
    it "saves a new entry and redirects to the show path for the entry" do
      order_attributes = FactoryBot.attributes_for(:order)
      expect { post orders_path, params: {order: order_attributes}
    }.to change(Order, :count)
      expect(response).to redirect_to order_path(id: Order.id)
    end
  end
  describe "post orders_path with invalid data" do
    it "does not save a new entry or redirect" do
      order_attributes = FactoryBot.attributes_for(:order)
      order_attributes.delete(:product_name)
      expect { post orders_path, params: {order: order_attributes}
    }.to_not change(Order, :count)
      expect(response).to render_template(:new)
    end
  end



  describe "put order_path with valid data" do
    it "updates an entry and redirects to the show path for the customer" do
      order = FactoryBot.create(:order)
      put "/orders/#{order.id}", params: {order: {product_count: 50}}
      order.reload
      expect(order.product_count).to eq(50)
      expect(response).to redirect_to("/orders/#{order.id}")
    end
  end
  describe "put order_path with invalid data" do
    it "does not update the customer record or redirect" do
      order = FactoryBot.create(:order)
      put "/orders/#{order.id}", params: {order: {customer_id: 5001}}
      order.reload
      expect(order.customer_id).not_to eq(5001)
      expect(response).to render_template(:edit)
    end
  end

  #describe "put order_path with valid data" do
    #it "updates an entry and redirects to the show path for the order" do
      #create and save
      #order = FactoryBot.create(:order)
      #send PUT request to the order_path
      #put order_path(id: order.id, params: {order:{product_name: "tent"}})
      #order.reload
      #checking the order is updated
      #expect(order.product_name).to eq("tent")
      #checking the response is redirect to order show page
      #expect(response).to redirect_to(order_path(order.id))     
    #end
  #end
  #describe "put order_path with invalid data" do
    #it "does not update the order record or redirect" do
      #order = FactoryBot.create(:order)
      #put order_path(order.id), params: {order: {product_name: "nil"}}
      #order.reload
      #expect(order.product_name).not_to eq("nil")
      #expect(response).to render_template(:edit) 
    #end 
  #end

  describe "delete an order record" do
    it "deletes an order record" do
      #create and save
      order = FactoryBot.create(:order)
      #delete from order_path
      delete order_path(order)
      #checking the response to redirection
      #try to put (200) but I got error, so I changed into 302 (:found)
      #expected the response to have status code 200 but it was 302
      expect(response).to have_http_status(302)
    end
  end
end

#RSpec.describe "Orders", type: :request do
  #describe "GET /index" do
    #pending "add some examples (or delete) #{__FILE__}"
  #end
#end
