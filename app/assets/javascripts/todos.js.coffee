# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.tower.controller('TodoCtrl', ['$scope', '$http', 'FayeService', ($scope, $http, FayeService) -> 
  $scope.newComment = ''
  $scope.shouldShowCommentForm = false
  $scope.shouldShowConfig = false
  $scope.showCommentForm = () ->
    $scope.shouldShowCommentForm = true

  $scope.addComment = ()->
    $http.post(window.location.pathname+'/comments', {content: $scope.newComment}, {withCredentials: true})
      .success (data, status, headers, config) ->
        $scope.cancelComment()

  $scope.cancelComment = ()->
    $scope.newComment = ''
    $scope.shouldShowCommentForm = false

  $scope.act = (type, params)->
    $http.post(window.location.pathname+'/'+type, params)
      .success (data, status, headers, config) ->
        switch type
          when 'start' then $scope.todo.status = 'ongoing'
          when 'pause' then $scope.todo.status = 'pending'
          when 'finish' then $scope.todo.status = 'finished'
          when 'assign', 'reassign', 'reschedule' then $scope.shouldShowConfig = false
          else return 

  $http.get(window.location.pathname+'.json')
    .success (data, status, headers, config) ->
      $scope.events = data.events
      $scope.todo = data.todo
      $scope.deadline = data.todo.deadline
      $scope.assignee = if data.assignee then data.assignee else { name: '未指派' }
      FayeService.client.subscribe "/todos/#{$scope.todo.id}", (event) ->
        $scope.$apply ->
          $scope.events.push event

      $http.get("/projects/#{$scope.todo.project_id}/members")
        .success (data, status, headers, config) ->
          $scope.members = data

  $scope.options = {
    format: 'yyyy-mm-dd',
    onClose: (e) ->
      $scope.act('reschedule', {new_time: $scope.deadline})
  }

])