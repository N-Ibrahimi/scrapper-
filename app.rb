require 'bundler'
Bundler.require

$:.unshift File.expand_path("./../lib/app", __FILE__)
require 'scrapper'

scrap = Scrapper.new
scrap.perform
#scrap.save_as_JSON
#scrap.google_sheet
scrap.save_as_csv 