AdminUser.create! email: 'admin@example.com', password: 'password', password_confirmation: 'password'

%w(Smartphones Tablets Laptops Headphones).each {|name| Category.create! name: name}
%w(Apricot Gazillion Singsong).each {|name| Brand.create! name: name}

Customer.create! name: 'David', email: 'david@example.com', password: 'password', password_confirmation: 'password', interest: 'smartphones'
Customer.create! name: 'Keith', email: 'keith@example.com', password: 'password', password_confirmation: 'password', interest: 'laptops'

sphone8 = Product.create name:     'sPhone 8',
                         category: Category.find_by_name('Smartphones'),
                         brand:    Brand.find_by_name('Singsong'),
                         image:    File.new(Rails.root.join('public', 'images', 'sPhone8.jpg'), 'r'),
                         price:    799.00
sphone8.features.build description: 'Voice Assistant Boxy'
sphone8.features.build description: 'Fireproof'
sphone8.features.build description: 'S10 Processor'
sphone8.save

aphone8 = Product.create name:     'Pre-Order aPhone 8',
                         category: Category.find_by_name('Smartphones'),
                         brand:    Brand.find_by_name('Apricot'),
                         image:    File.new(Rails.root.join('public', 'images', 'aPhone10-wide.jpg'), 'r'),
                         price:    100.00,
                         preorder: true
aphone8.features.build description: 'Voice Assistant Stoey'
aphone8.features.build description: 'Fireproof'
aphone8.features.build description: 'P10 Processor'
aphone8.color_options = ['White', 'Black', 'GREEN']
aphone8.memory_options = [16, 32, 64]
aphone8.save

aphone7 = Product.create name:     'aPhone 7 GREEN',
                         category: Category.find_by_name('Smartphones'),
                         brand:    Brand.find_by_name('Apricot'),
                         image:    File.new(Rails.root.join('public', 'images', 'aPhone7GREEN.png'), 'r'),
                         price:    699.00
aphone7.features.build description: 'High Quality Camera'
aphone7.features.build description: 'Waterproof'
aphone7.features.build description: 'P9 Processor'
aphone7.save

Product.create name:     'aPad',
               category: Category.find_by_name('Tablets'),
               brand:    Brand.find_by_name('Apricot'),
               image:    File.new(Rails.root.join('public', 'images', 'aPad.png'), 'r'),
               price:    999.00


songbook = Product.create name:     'Song Book',
                          category: Category.find_by_name('Laptops'),
                          brand:    Brand.find_by_name('Singsong'),
                          image:    File.new(Rails.root.join('public', 'images', 'SongBook.jpg'), 'r'),
                          price:    999.00
songbook.features.build description: '8 Core Processor'
songbook.features.build description: 'High Quality and Speakers'
songbook.features.build description: 'Fireproof'
songbook.features.build description: '2 Year Warranty'
songbook.save

apricotbook = Product.create name:     'Apricot Book',
                             category: Category.find_by_name('Laptops'),
                             brand:    Brand.find_by_name('Apricot'),
                             image:    File.new(Rails.root.join('public', 'images', 'apricotbook.jpg'), 'r'),
                             price:    2299.00
apricotbook.features.build description: '16 Core Processor'
apricotbook.features.build description: 'High Quality Video and Speakers'
apricotbook.features.build description: 'Waterproof'
apricotbook.features.build description: '2 Year Warranty'
apricotbook.save

Product.create! name:     'Seal Buds',
                category: Category.find_by_name('Headphones'),
                brand:    Brand.find_by_name('Singsong'),
                image:    File.new(Rails.root.join('public', 'images', 'seal-buds.jpg'), 'r'),
                price:    99.00

aheadphones = Product.create! name:     'Sounds by Sir Simon',
                              category: Category.find_by_name('Headphones'),
                              brand:    Brand.find_by_name('Apricot'),
                              image:    File.new(Rails.root.join('public', 'images', 'aHeadphones.jpg'), 'r'),
                              price:    299.00


Deal.create! product:     aphone8,
             description: 'Lock in your order for just €100'

Deal.create! product:         aheadphones,
             description:     'Get a FREE pair of Sounds by Sir Simon headphones when you purchase Apricot Book',
             trigger_product: apricotbook,
             price:           0.00

Deal.create! product:     sphone8,
             description: "Smithsong's sPhone8 carries Boxy - a travel companion that can translate any foreign text with the aim of a camera",
             image:       File.new(Rails.root.join('public', 'images', 'translate.jpg'), 'r')

Deal.create! product:         aphone8,
             description:     'Good news! Because you are a loyal customer of the Apricot line and are about to purchase the Apricot Book, we offer to waive the regular €100 aPhone 8 Pre-Order deposit. Add it to your cart right now for free!',
             special:         true,
             trigger_product: apricotbook,
             price:           0.00

CSV.foreach('db/seed_data/WEX_output.csv', headers: true) do |row|
  data               = row.to_hash
  data['frequency']  = data['frequency'].to_i
  data['aphone']     = data['aphone'].to_i
  data['sphone']     = data['sphone'].to_i
  data['product_id'] = data['aphone'] > data['sphone'] ? aphone7.id : sphone8.id
  TrendingTopic.create! data
end