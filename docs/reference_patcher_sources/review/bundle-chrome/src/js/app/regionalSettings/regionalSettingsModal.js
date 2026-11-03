define(
  [],
  function(){

    return function(btfModal){
      return btfModal({
        container: '.modal-container',
        controller: 'RegionalSettingsController',
        controllerAs: 'modal',
        templateUrl: 'js/app/regionalSettings/modal.html'
      });
    };

  }
);