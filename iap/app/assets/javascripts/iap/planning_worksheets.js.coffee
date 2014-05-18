class window.PlanningWorksheetController
  constructor: () ->
    $(document).on 'submit', 'form.iap_planning_worksheet', (evt) ->
      $(evt.target).find("input.resource-header").each (idx, col) ->
        ordinal = $(col).data('ordinal')
        val = $(col).val()

        $(".resource-header-hidden[data-ordinal=#{ordinal}]").val(val)