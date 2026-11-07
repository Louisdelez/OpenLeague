

define(function(){
  return angular.module('chrome-directives')
    .controller('DropdownController', function($scope){
      $scope.update = function() {
        console.log(update);
      }
    })
    .directive('dropdown', function () {
      return {
        restrict: 'E',
        templateUrl: 'js/app/directives/dropdown.html',
        transclude: true,
        scope: {
          options : '=',
          ngModel : '=',
          label : '@'
        },
        link: function (scope, elem, attrs) {
          elem.css('display', 'block');

          var value = elem.find('.dropdown-value'),
              options = elem.find('.options'),
              container = elem.find('.dropdown-container');

          if (elem.attr('open') !== undefined){
            options.addClass('open');
            elem.find('.dropdown-container').addClass('active');
          }

          value.on('click', function(){
            //collapse other dropdown on toggle
            if(!$(container).hasClass("active"))
            {
              var actives = $(document).find(".dropdown-container");
              actives.each(function(){$(this).removeClass('active')});
              var opened = $(document).find(".options");
              opened.each(function(){$(this).removeClass('open')});
            }

            toggle();
          });

          elem.on('change', 'dropdown-item', function(evt, el){
            updateValue();
            toggle();
            elem.trigger('change', scope.ngModel );
          });

          var observer = new MutationObserver(function(mutations) {
            var update = false;
            mutations.forEach(function(mutation) {
              if (mutation.type === 'childList') update = true;
            });
            if (update) updateValue();
          });
          var config = { attributes: true, childList: true, characterData: true }
          observer.observe(options[0], config);

          updateValue();

          function updateValue(){
            if (options.find('dropdown-item').length > 5) {
              options.addClass('scrollbar');
            } else {
              options.removeClass('scrollbar');
            }
            var items = elem.find('dropdown-item');
            if (!items.length) return;
            var selected = findSelected(items);
            if (!selected) selected = items[0];
            scope.ngModel = selected.value();
            scope.label = selected.label();
            if (!scope.$root.$$phase) scope.$apply();
          }

          function toggle() {
            elem.find('.dropdown-container').toggleClass('active');
            options.toggleClass('open');
          }
          function findSelected(items) {
            return items.filter(function(i, item){
              return (item.getAttribute('selected') !== null)
            })[0];
          }
        }
      }
    })
    .directive('dropdownItem', function(){
      return {
        restrict: 'E',
        template: '<div ng-transclude></div>',
        transclude: true,
        link: function (scope, elem, attrs) {
          elem[0].value = function() {
            return elem.attr('value');
          };
          elem[0].label = function() {
            return elem.text();
          };
          elem.on('click', function(){
            elem.siblings().removeAttr('selected');
            elem.attr('selected', 'selected');
            elem.trigger('change', elem);
          })
        }
      }
    })
    ;
});