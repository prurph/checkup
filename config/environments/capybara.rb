Dummy::Application.configure do
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  config.assets.compress = true
  config.assets.compile = false

  config.assets.precompile += %w(email.css)

  config.assets.digest = true
  config.assets.prefix = "/capybara_test_assets"
end
