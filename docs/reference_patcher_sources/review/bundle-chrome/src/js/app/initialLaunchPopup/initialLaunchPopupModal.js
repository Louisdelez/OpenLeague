define(
  [],
  function(){

    return function(btfModal){
      return btfModal({
        container: '.modal-popup-container',
        controller: 'InitialLaunchPopupController',
        controllerAs: 'modal',
        templateUrl: 'js/app/initialLaunchPopup/modal.html'
      });
    };

  }
);