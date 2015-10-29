@Optimizely = { fetcher: null }

class Optimizely.Fetcher
  @token : null
  @base_url : 'https://www.optimizelyapis.com/experiment/v1'

  constructor : (token) ->
    fetcher = @

    $.ajaxSetup
      beforeSend: (xhr) ->
        xhr.setRequestHeader('Token', token)

    $('#projects-wrapper').on 'change', 'select', ->
      fetcher.fetchExperiments(@value)

    $('#experiments-wrapper').on 'change', 'select', ->
      fetcher.fetchVariations(@value)

  fetchFromOptimizely : (endpoint, callback) ->
    $.ajax
      url: "#{@constructor.base_url}/#{endpoint}"
      type: 'get'
      datatype: 'json'
      success: (results) -> callback(results)

  fetchProjects : ->
    @fetchFromOptimizely 'projects', (results) ->
      choices = results.map (result) -> "<option value=#{result.id}>#{result.project_name}</option>"
      $('#projects-wrapper').html("<select><option></option>#{choices}</select>")

  fetchExperiments : (projectId) ->
    return unless projectId

    @fetchFromOptimizely "projects/#{projectId}/experiments", (results) ->
      choices = results.map (result) -> "<option value=#{result.id}>#{result.description}</option>"
      $('#experiments-wrapper').html("<select><option></option>#{choices}</select>")

  fetchVariations : (experimentId) ->
    return unless experimentId

    $('#variations-wrapper').html('')

    @fetchFromOptimizely "experiments/#{experimentId}/variations", (results) ->
      results.forEach (result) ->
        $('#variations-wrapper').append("<pre>#{JSON.stringify(result)}</pre>")
