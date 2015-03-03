angular.module('appleFirstChallengeControllers', [])
  .controller('TopPagesCtrl', function($http, $scope) {
    $scope.loaded = false;
    $http.get('/top_pages.json', {cache: true}).success(function(data) {
      $scope.data = data;
      $scope.loaded = true;
    });
  })
  .controller('TopReferrersCtrl', function($http, $scope) {
    $scope.loaded = false;
    $http.get('/top_referrers.json', {cache: true}).success(function(data) {
      $scope.data = data;
      $scope.loaded = true;
    });
  });
