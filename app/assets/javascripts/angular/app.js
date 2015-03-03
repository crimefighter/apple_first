var appleFirstChallengeApp = angular.module('appleFirstChallengeApp', [
  'ngRoute',
  'appleFirstChallengeControllers'
]).config([
  '$routeProvider',
  function($routeProvider) {
    $routeProvider
      .when('/top_pages', {
        templateUrl: '/templates/top_pages.html',
        controller: 'TopPagesCtrl'
      })
      .when('/top_referrers', {
        templateUrl: '/templates/top_referrers.html',
        controller: 'TopReferrersCtrl'
      })
      .otherwise({redirectTo: '/top_pages'})
  }
]);
