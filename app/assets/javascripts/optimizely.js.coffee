@Optimizely = { fetcher: null }

class Optimizely.Fetcher
  @base_url : 'https://www.optimizelyapis.com/experiment/v1'

  constructor : (options) ->
    throw 'Token option required!' unless options.token

    options.wrapper = 'body' unless $(options.wrapper).length

    @options = options
    fetcher = @

    $(options.wrapper)
      .append('<div id="projects-wrapper"></div>')
      .append('<div id="experiments-wrapper"></div>')
      .append('<div id="variations-wrapper"></div>')
      .append('<div id="url-wrapper"></div>')

    $.ajaxSetup
      beforeSend: (xhr) ->
        xhr.setRequestHeader('Token', options.token)

    $("#{options.wrapper} #projects-wrapper").on 'change', 'select', ->
      fetcher.fetchExperiments(@value)

    $("#{options.wrapper} #experiments-wrapper").on 'change', 'select', ->
      fetcher.fetchVariations(@value)

    $("#{options.wrapper} #variations-wrapper").on 'change', 'select', ->
      fetcher.buildVariationURL(@value)

  fetchFromOptimizely : (endpoint, callback) ->
    $.ajax
      url: "#{@constructor.base_url}/#{endpoint}"
      type: 'get'
      datatype: 'json'
      success: (results) -> callback(results)

  fetchProjects : ->
    container = $("#{@options.wrapper} #projects-wrapper").spin('small')

    @fetchFromOptimizely 'projects', (results) ->
      choices = results.map (result) -> "<option value=#{result.id}>#{result.project_name}</option>"
      container.html("<select><option></option>#{choices.join('')}</select>")

  fetchExperiments : (projectId) ->
    container = $("#{@options.wrapper} #experiments-wrapper").html('').spin('small')

    $("#{@options.wrapper} #variations-wrapper").html('')

    return unless projectId

    @fetchFromOptimizely "projects/#{projectId}/experiments", (results) ->
      choices = results.map (result) ->
        "<option value=#{result.id} data-url=#{result.edit_url}>#{result.description}</option>"

      container.html("<select><option></option>#{choices.join('')}</select>")

  fetchVariations : (experimentId) ->
    container = $("#{@options.wrapper} #variations-wrapper").html('').spin('small')

    return unless experimentId

    @fetchFromOptimizely "experiments/#{experimentId}/variations", (results) ->
      choices = results.map (result, index) ->
        "<option value=#{index}>#{result.description}</option>"

      container.html("<select><option></option>#{choices.join('')}</select>")

  buildVariationURL : (index) ->
    experiment = $("#{@options.wrapper} #experiments-wrapper option:selected")
    url = "#{experiment.data('url')}/?optimizely_x#{experiment.val()}=#{index}"

    $("#{@options.wrapper} #url-wrapper").html("<a href='#{url}'>#{url}</a>")
