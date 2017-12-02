guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

guard :shell do
  watch(/(.*).rb/) {|m| `bundle exec yardoc *.rb` }
  watch(/sequence.plantuml/) {|m| `plantuml sequence.plantuml` }
end