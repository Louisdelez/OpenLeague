

define(function(){
  return angular.module('chrome-directives', [])
    .directive('progressBar', function () {
      return {
        restrict: 'E',
        template: '<div id="progress-bar" value="" style="color:white"><div id="progress-bar-progress"></div></div>',
        scope: {
          percent : '='
        },
        link: function (scope, elem, attrs) {
          elem.css('display', 'block');
          var bar = elem.find('#progress-bar-progress');

          scope.$watch('percent', function(value) {
            var width = elem.width() * (value / 100);
            bar.width(width + 'px');
          });
        }
      }
    });
});