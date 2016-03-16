GITHUB_CONFIG_FILE = "#{Rails.root.to_s}/config/github.yml"

if File.file?(GITHUB_CONFIG_FILE)
  $GITHUB_CONFIG = YAML.load_file(GITHUB_CONFIG_FILE)
else
  puts "You need to set up #{GITHUB_CONFIG_FILE} before running this application."
  puts "See config/github.example.yml for an example."
  exit
end
