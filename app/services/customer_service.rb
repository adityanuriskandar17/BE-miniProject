class CustomerService
  def initialize(user)
    @user = user
    @redis = Redis.new(host: 'localhost', port: 6380)
  end

  def all_customers
    Customer.where(user_id: @user.id).to_a
  end

  def find_customer(id)
    cache_key = "customer:#{id}"
    cached_customer = @redis.get(cache_key)

    if cached_customer
      Rails.logger.info "Customer #{id} found in Redis cache"
      Customer.new(JSON.parse(cached_customer))
    else
      customer = Customer.find_by(id: id, user_id: @user.id)
      if customer
        @redis.set(cache_key, customer.to_json)
        Rails.logger.info "Customer #{id} not found in Redis cache. Queried from DB and cached."
      end
      customer
    end
  rescue Mongoid::Errors::DocumentNotFound
    nil
  end

  def create_customer(customer_params)
    customer = Customer.new(customer_params.merge(user_id: @user.id))
    if customer.save
      @redis.set("customer:#{customer.id}", customer.to_json)
      { success: true, customer: customer }
    else
      { success: false, errors: customer.errors }
    end
  end

  def update_customer(id, customer_params)
    customer = Customer.find(id)
    if customer.update(customer_params.except(:_id))
      @redis.set("customer:#{customer.id}", customer.to_json)
      { success: true, customer: customer }
    else
      { success: false, errors: customer.errors }
    end
  rescue Mongoid::Errors::DocumentNotFound
    { success: false, errors: { base: ["Customer not found"] } }
  end
  
  

  def destroy_customer(customer)
    if customer.destroy
      @redis.del("customer:#{customer.id}")
      { success: true }
    else
      { success: false, errors: customer.errors }
    end
  end

  def authorize_customer!(customer)
    customer.user_id == @user.id
  end
end
