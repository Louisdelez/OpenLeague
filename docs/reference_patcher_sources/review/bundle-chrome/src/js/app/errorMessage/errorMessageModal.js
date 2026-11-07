/**
 * Created by bperry on 4/3/14.
 */
define(
    [],
    function(){

        return function(btfModal){
            return btfModal({
                container: '.modal-error-container',
                controller: 'ErrorMessageController',
                controllerAs: 'modal',
                templateUrl: 'js/app/errorMessage/modal.html'
            });
        };

    }
);