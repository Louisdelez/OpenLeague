define(
  [],
  function(){

    return function(btfModal){
      return btfModal({
        container: '.modal-container',
        controller: 'SettingsController',
        controllerAs: 'modal',
        templateUrl: 'js/app/settings/modal.html'
      });
    };

  }
);