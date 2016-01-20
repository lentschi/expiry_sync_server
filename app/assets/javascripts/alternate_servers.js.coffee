displayFieldsForLanguage = (lang) ->
  $('form [data-lang][data-lang!="' + lang + '"]').css
    visibility: 'hidden'
    position: 'absolute'
  $('form [data-lang][data-lang="' + lang + '"]').css
    visibility: 'visible'
    position: 'static'

showLanguageSelect = ->
  $div = $('<div class="field"><label for="language">Language</label></div>')
  $select = $('<select id="language"></select>')
  $div.append $select
  $('form [data-lang]').first().before $div

  $('form [data-lang]').each ->
    lang = $(this).attr('data-lang')
    return if $('option[value="' + lang + '"]', $select).length != 0
      
    $select.append '<option value="' + lang + '">' + lang + '</option>'

  displayFieldsForLanguage $select.val()

  $select.change ->
    displayFieldsForLanguage $(this).val()

$(document).ready ->
  if $('form [data-lang]').length > 0
    showLanguageSelect()
