# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:
* System dependencies: Linux(ubuntu) 

* Database creation: gem "sqlite3", "~> 1.4"
* Ruby version : ruby "3.3.0"
* Rails version: gem "rails", "~> 7.1.3", ">= 7.1.3.3"
* Gems used in this project:
    * gem 'rspec-rails'
    * gem 'factory_bot_rails'
    * gem 'database_cleaner-active_record'
    * gem 'shoulda-matchers' => used for model validation,callbacks, scopes etc.. test case
    * gem 'simplecov', require: false => see the coverage percentage of rspec test case files.
      ![Screenshot from 2024-05-30 11-43-48](https://github.com/bikashdey/lohono_stays/assets/74043649/fbb81fac-95f1-4a5b-9b23-d0000004815c)



* Postman  Api collection: https://api.postman.com/collections/15277899-3a0d9f02-f1e7-4465-9d15-f7ec5975a689?access_key=PMAT-01HZ42T216DSEQPBVQ9BSNSPGJ 
* 1. Index API:- 
      *As per the requirements " API to list villas which denotes average price per night and availability of the villa for
   entered dates. This API should also sort by price and availability depending upon query parameters" 

      * If any day villa is not available between given dates then it will show villa not available for this dates.

      * params will be: * start_date:2021-01-03
                        * end_date:2021-01-05
                        * sort_by:average_price_per_night
                        * order:desc

      * Response :      sorted and orderd DESC
         "villas": [
           {
               "villa": {
                   "id": 45,
                   "name": "Villa #44",
                   "created_at": "2024-05-28T18:23:36.114Z",
                   "updated_at": "2024-05-28T18:23:36.114Z",
                   "total_rate": 73307
               },
               "average_price_per_night": 36653,
               "available": true
           }, 
            {
            "villa": {
                "id": 40,
                "name": "Villa #39",
                "created_at": "2024-05-28T18:23:28.679Z",
                "updated_at": "2024-05-28T18:23:28.679Z",
                "total_rate": 68613
            },
            "average_price_per_night": 34306,
            "available": true
        },]
* 2. total_gst_rate_for_villa API:-  
     * In this Api output will be the A villa's total price can be calculated as the sum of the price of individual nights for which client is
            staying + 18% GST. and availabality also.
      * params will be: * start_date:2021-02-09
                     * end_date:2021-02-13
                     * villa_id:15
      * Response: 
        {
             "available": true,
             "total_rate_with_gst": 217298.18
         }

