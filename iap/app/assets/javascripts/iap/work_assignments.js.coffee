
class window.WorkAssignmentController
  constructor: (@personDatasource, @drNumber) ->
    @resetOrdinals()
    @updateAutofill()
    $(document).on 'cocoon:after-insert, cocoon:after-remove, sortupdate', () =>
      @resetOrdinals()
      @updateAutofill()
    $('.worksheet-lines').sortable
      axis: 'y'
      containment: '.worksheet-lines'

  resetOrdinals: () ->
    ordinal = 0
    $('.worksheet-lines > tr').each (idx, el) =>
      ordinal += 1
      $(el).find('input[id$=ordinal]').val(ordinal)

  updateAutofill: () ->
    $('.name-autofill').each (idx, el) =>
      if !$(el).data('autofill')
        $(el).data('autofill', new PersonTypeaheadController(el, @personDatasource, {deployed_to: @drNumber}))

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