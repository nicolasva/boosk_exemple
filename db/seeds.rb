# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#PACK
  #START
  Plan.create([
               {
                :name => "start",
                :monthly_price => 0,
                :yearly_price => 0,
                :number_admin => 1,
                :number_f_shop => 1,
                :number_m_shop => 1,
                :number_w_shop => 0,
                :number_product => 10,
                :has_google_shopping => false,
                :has_social => true,
                :has_feature_product => true,
                :has_data_import => true,
                :has_deals => true,
                :has_auto_data_import => 0,
                :has_customization => false,
                :has_analytics => false,
                :has_api_access => false
               },
               {
                :name => "premium",
                :monthly_price => 29,
                :yearly_price => 228,
                :number_admin => 3,
                :number_f_shop => 1,
                :number_m_shop => 1,
                :number_w_shop => 0,
                :number_product => 5000,
                :has_google_shopping => false,
                :has_social => true,
                :has_feature_product => true,
                :has_data_import => true,
                :has_deals => true,
                :has_auto_data_import => 24,
                :has_customization => true,
                :has_analytics => true,
                :has_api_access => false
               },
               {
                :name => "agency",
                :monthly_price => 59,
                :yearly_price => 590,
                :number_admin => 10,
                :number_f_shop => 3,
                :number_m_shop => 3,
                :number_w_shop => 0,
                :number_product => 5000,
                :has_google_shopping => false,
                :has_social => true,
                :has_feature_product => true,
                :has_data_import => true,
                :has_deals => true,
                :has_auto_data_import => 24,
                :has_customization => true,
                :has_analytics => true,
                :has_api_access => false
               },
               {
                :name => "gold",
                :monthly_price => 290,
                :yearly_price => 2990,
                :number_admin => 99,
                :number_f_shop => 10,
                :number_m_shop => 10,
                :number_w_shop => 0,
                :number_product => 5000,
                :has_google_shopping => false,
                :has_social => true,
                :has_feature_product => true,
                :has_data_import => true,
                :has_deals => true,
                :has_auto_data_import => 1,
                :has_customization => true,
                :has_analytics => true,
                :has_api_access => true
               },
              ])
