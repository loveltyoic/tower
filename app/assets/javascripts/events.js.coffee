window.tower = angular.module('tower', ['angular-datepicker'])

window.tower.service('FayeService', ()->
  client = new Faye.Client('http://localhost:8080/push')
  
  client.addExtension({
    outgoing: (message, callback)->
      return callback(message) if (message.channel isnt '/meta/subscribe')
      message.ext ?= {}
      message.ext.token = window.subscribeToken
      callback(message)
  })

  { client: client }
)

window.tower.controller('EventCtrl', ['$scope', '$http', '$location', 'FayeService', 'filterFilter', ($scope, $http, $location, FayeService, filterFilter) -> 
  subscribeProject = (pId) -> 
    FayeService.client.subscribe("/projects/#{pId}", (event) ->
      $scope.$apply -> 
        $scope.events.unshift(event)
    )

  subscribeProject pId for pId in window.projectIds

  $scope.selectedMember = {name: ''}

  $http.get(window.location.pathname+'.json').success (data, status, headers, config) ->
    $scope.events = data

  $scope.shouldShowFilter = false

  $scope.showFilter = ->
    $scope.shouldShowFilter = true

  $http.get(window.location.pathname.replace('events', 'members') + '.json')
    .success (data, status, headers, config)->
      $scope.members = data

  $scope.selectMember = (member)->
    $scope.selectedMember = member 
    $scope.shouldShowFilter = false     

  $scope.eventFilter = (actual, expect) ->
    return actual.initiator.name == expect

])
