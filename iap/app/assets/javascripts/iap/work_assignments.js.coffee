
class window.WorkAssignmentController
  constructor: (@personDatasource, @drNumber) ->
    @resetOrdinals()
    @updateAutofill()
    $('.worksheet-lines').on 'cocoon:after-insert', () =>
      @resetOrdinals()
      @updateAutofill()
    $('.worksheet-lines').on 'cocoon:after-remove', () =>
      @resetOrdinals()
      @updateAutofill()
    $(document).on 'sortupdate', () =>
      @resetOrdinals()
    $('.worksheet-lines').sortable
      axis: 'y'
      containment: '.worksheet-lines'

  resetOrdinals: () ->
    ordinal = 0
    $('.worksheet-lines > tr').each (idx, el) =>
      ordinal += 1
      $(el).find('input[id$=ordinal]').val(ordinal)

  updateAutofill: () ->
    console.log 'triggered'
    $('.name-autofill').each (idx, el) =>
      if !$(el).data('autofill')
        console.log 'adding autofill to ', el
        $(el).data('autofill', new PersonTypeaheadController(el, @personDatasource))

class window.DriveUploadController
  constructor: (@browserKey, @authToken) ->

  start: () ->
    view = new google.picker.DocsView(google.picker.ViewId.FOLDERS);
    view.setSelectFolderEnabled(true);
    view.setIncludeFolders(true);
    @picker = new google.picker.PickerBuilder().
          addView(view).
          setOAuthToken(@authToken).
          setDeveloperKey(@browserKey).
          setCallback((data) => @pickerCallback(data)).
          build();

          @picker.setVisible(true);

  pickerCallback: (data) ->
    console.log data
    if data[google.picker.Response.ACTION] == google.picker.Action.PICKED
      $('input[name=parent_folder]').val(data[google.picker.Response.DOCUMENTS][0]['id'])
      $('form.folder-form').submit()