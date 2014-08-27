
class window.WorkAssignmentController
  constructor: () ->
    @resetOrdinals()
    $(document).on 'cocoon:after-insert, cocoon:after-remove, sortupdate', () =>
      @resetOrdinals()
    $('.worksheet-lines').sortable
      axis: 'y'

  resetOrdinals: () ->
    ordinal = 0
    $('.worksheet-lines > tr').each (idx, el) =>
      ordinal += 1
      $(el).find('input[id$=ordinal]').val(ordinal)