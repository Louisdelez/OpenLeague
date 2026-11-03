define(
  [],
  function(){

    return function(btfModal){
      return btfModal({
        container: '.modal-popup-container',
        controller: 'PandoRemovalPopupController',
        controllerAs: 'modal',
        templateUrl: 'js/app/pandoRemovalPopup/modal.html'
      });
    };

  }
);
