do ->
  if jQuery and jQuery.fn and jQuery.fn.select2 and jQuery.fn.select2.amd
    $.fn.select2.amd.define('select2/i18n/es', [], ->
      {
        errorLoading: ->
          'La carga falló'
        inputTooLong: (e) ->
          t = e.input.length - (e.maximum)
          n = 'Por favor, elimine ' + t + ' car'
          if t == 1 then (n += 'ácter') else (n += 'acteres')
          n
        inputTooShort: (e) ->
          t = e.minimum - (e.input.length)
          n = 'Por favor, introduzca ' + t + ' car'
          if t == 1 then (n += 'ácter') else (n += 'acteres')
          n
        loadingMore: ->
          'Cargando más resultados…'
        maximumSelected: (e) ->
          t = 'Sólo puede seleccionar ' + e.maximum + ' elemento'
          e.maximum != 1 and (t += 's')
          t
        noResults: ->
          'No se encontraron resultados'
        searching: ->
          'Buscando…'
      }
    )
    $.fn.select2.amd.define('select2/i18n/fr', [], ->
      {
        errorLoading: ->
          'Les résultats ne peuvent pas être chargés.'
        inputTooLong: (e) ->
          t = e.input.length - (e.maximum)
          n = 'Supprimez ' + t + ' caractère'
          t != 1 and (n += 's')
          n
        inputTooShort: (e) ->
          t = e.minimum - (e.input.length)
          n = 'Saisissez ' + t + ' caractère'
          t != 1 and (n += 's')
          n
        loadingMore: ->
          'Chargement de résultats supplémentaires…'
        maximumSelected: (e) ->
          t = 'Vous pouvez seulement sélectionner ' + e.maximum + ' élément'
          e.maximum != 1 and (t += 's')
          t
        noResults: ->
          'Aucun résultat trouvé'
        searching: ->
          'Recherche en cours…'
      }
    )
  $.fn.select2.amd.define('select2/i18n/en', [], ->
    {
      errorLoading: ->
        'The results could not be loaded.'
      inputTooLong: (e) ->
        t = e.input.length - (e.maximum)
        n = 'Please delete ' + t + ' character'
        t != 1 and (n += 's')
        n
      inputTooShort: (e) ->
        t = e.minimum - (e.input.length)
        n = 'Please enter ' + t + ' or more characters'
        n
      loadingMore: ->
        'Loading more results…'
      maximumSelected: (e) ->
        t = 'You can only select ' + e.maximum + ' item'
        e.maximum != 1 and (t += 's')
        t
      noResults: ->
        'No results found'
      searching: ->
        'Searching…'
    }
  )
