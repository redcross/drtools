module PdfResponder
  delegate :send_file, to: :controller

  def initialize(controller, resources, options={})
    super
    @filename = options.delete :filename
    @disposition = options.delete(:disposition) || 'inline'
  end

  def to_pdf
    opts = {send_file: {type: :pdf, filename: @filename, disposition: @disposition}}
    body = render_to_string
    render_pdf opts
  end

  def render_to_string *args
    # Need to manually specify html format, as be default it will be looking for pdf.
    opts = args.first.merge(options).merge({formats: [:html], action: default_action})
    controller.render_to_string opts
  end
end
