@Optimizely = { fetcher: null }

class Optimizely.Fetcher
  @base_url : 'https://www.optimizelyapis.com/experiment/v1'

  constructor : (options) ->
    throw 'Token option required!' unless options.token

    options.wrapper = 'body' unless $(options.wrapper).length

    @options = options
    fetcher = @

    $(options.wrapper).append('<div id="projects-wrapper"></div>')
    $(options.wrapper).append('<div id="experiments-wrapper"></div>')
    $(options.wrapper).append('<div id="variations-wrapper"></div>')

    $.ajaxSetup
      beforeSend: (xhr) ->
        xhr.setRequestHeader('Token', options.token)

    $("#{options.wrapper} #projects-wrapper").on 'change', 'select', ->
      fetcher.fetchExperiments(@value)

    $("#{options.wrapper} #experiments-wrapper").on 'change', 'select', ->
      fetcher.fetchVariations(@value)

  fetchFromOptimizely : (endpoint, callback) ->
    $.ajax
      url: "#{@constructor.base_url}/#{endpoint}"
      type: 'get'
      datatype: 'json'
      success: (results) -> callback(results)

  fetchProjects : ->
    fetcher = @

    @fetchFromOptimizely 'projects', (results) ->
      choices = results.map (result) -> "<option value=#{result.id}>#{result.project_name}</option>"
      $("#{fetcher.options.wrapper} #projects-wrapper").html("<select><option></option>#{choices}</select>")

  fetchExperiments : (projectId) ->
    fetcher = @

    $(fetcher.options.wrapper).find('#variations-wrapper, #experiments-wrapper').html('')

    return unless projectId

    @fetchFromOptimizely "projects/#{projectId}/experiments", (results) ->
      choices = results.map (result) -> "<option value=#{result.id}>#{result.description}</option>"
      $("#{fetcher.options.wrapper} #experiments-wrapper").html("<select><option></option>#{choices}</select>")

  fetchVariations : (experimentId) ->
    fetcher = @

    $(fetcher.options.wrapper).find('#variations-wrapper').html('')

    return unless experimentId

    $('#variations-wrapper').html('')

    @fetchFromOptimizely "experiments/#{experimentId}/variations", (results) ->
      results.forEach (result) ->
        $("#{fetcher.options.wrapper} #variations-wrapper").append("<pre>#{JSON.stringify(result)}</pre>")
