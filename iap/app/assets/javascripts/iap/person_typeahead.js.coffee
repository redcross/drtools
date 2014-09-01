class window.PersonTypeaheadController
  constructor: (dom, datasourcePath, filter={}, @selected=null) ->
    @taDom = $(dom).find('input.autofill-name-field')[0]
    @phoneDom = $(dom).find('input.autofill-phone-field')[0]

    taOpts = 
      highlight: true
      updater: (item) =>
        @callback(@people[item].id, @people[item])
        @selected = item
        item

    dsOpts =
      name: 'people'
      displayKey: 'full_name'
      templates:
        suggestion: ((ctx) -> ph = ctx['phones'][0] || {}; "<p>#{ctx.full_name}<br />#{ph? && ph['number']}</p>")
      source: (query, process) =>
        if query.length <= 2
          process([])
          return

        query = query.toLowerCase()

        #if @prev_query and query.indexOf(@prev_query) != -1
        #  newData = @prev_data.filter (val) ->
        #    val.full_name.toLowerCase().indexOf(query) != -1
        #  console.log newData
        #  process(newData)
        #  return

        $.ajax
          dataType: 'json'
          data:
            $.extend filter,
              name_contains: query
              include: 'phone'
          url: datasourcePath
          headers:
            Accept: 'application/json'
          success: (data) =>
            @people = {}

            @prev_query = query
            @prev_data = data

            process(data)

    $(@taDom).typeahead taOpts, dsOpts
    $(@taDom).on 'typeahead:selected', (evt, datum) =>
      console.log evt, evt.target, evt.target.value
      $(@phoneDom).val(datum['phones'][0]['number']);
