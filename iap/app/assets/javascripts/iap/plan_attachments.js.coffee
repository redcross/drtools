class window.PlanAttachmentsController
  constructor: () ->
    $('document').on 'change', '#plan_attachment_attachment_type', (evt) =>
      @updateName()
    @updateName()

  updateName: () ->
    val = $('#plan_attachment_attachment_type option:selected').data('default-name')
    $('#plan_attachment_title').val(val)