module ApplicationHelper


  def method_missing method, *args, &block
    if main_app_url_helper?(method)
      main_app.send(method, *args)
    else
      super
    end
  end

  def respond_to?(method)
    main_app_url_helper?(method) or super
  end

 private

  def main_app_url_helper?(method)
    (method.to_s.end_with?('_path') or method.to_s.end_with?('_url')) and main_app.respond_to?(method)
  end
end
