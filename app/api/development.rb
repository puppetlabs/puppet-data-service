# Development aid
if (PDSApp.settings.environment == :development)
  PDSApp.class_eval do
    get("/settings") {
      settings.backend.to_json
    }
  end
end
