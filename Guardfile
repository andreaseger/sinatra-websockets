# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :version => 2, :cli => '--color --format d' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

guard 'livereload' do
  watch(%r{templates/.+\.(mustache)})
  watch(%r{lib/helper/.+\.rb})
  watch(%r{service/.+\.rb})
  watch(%r{config/.+\.rb})
  watch(%r{(public/|app/assets).+\.(css|js|html)})
  watch(%r{(assets/.+(\.css)?)\.s[ac]ss}) { |m| m[1] }
  watch(%r{(assets/.+\.js)\.coffee}) { |m| m[1] }
end
