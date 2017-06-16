# noinspection ALL
class Product < ActiveRecord::Base
  belongs_to :category
  belongs_to :brand
  has_many :features
  has_one :deal
  has_many :trigger_deals, :class_name => 'Deal', :foreign_key => 'trigger_product_id'
  
  serialize :color_options, Array
  serialize :storage_options, Array
  
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  
  attr_accessor :discount_price
  
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  def check_special_offer(customer)
    
    potential_deal = trigger_deals.where(special: true)
    
    if potential_deal
      
      ml_service = MachineLearningService.find_by_name 'Customer Interest'
      deployment = ml_service.deployments.find_by_name 'aPhone Model'
      
      score = ml_service.get_score deployment.guid, customer.attributes
      
      return potential_deal if score > 0.8
      
    end
  end
end
