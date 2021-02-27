# frozen_string_literal: true

require 'rake/testtask'
require 'rubocop/rake_task'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['*_test.rb']
  t.verbose = true
end

RuboCop::RakeTask.new
