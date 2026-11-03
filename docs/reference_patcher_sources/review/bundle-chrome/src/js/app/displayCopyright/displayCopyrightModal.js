/**
 * Created by bperry on 4/3/14.
 */
define(
    [],
    function(){

        return function(btfModal){
            return btfModal({
                container: '.modal-container',
                controller: 'DisplayCopyrightController',
                controllerAs: 'modal',
                templateUrl: 'js/app/displayCopyright/modal.html'
            });
        };

    }
);