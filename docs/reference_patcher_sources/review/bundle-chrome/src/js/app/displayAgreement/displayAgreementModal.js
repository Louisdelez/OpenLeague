/**
 * Created by bperry on 4/3/14.
 */
define(
    [],
    function(){

        return function(btfModal){
            return btfModal({
                container: '.modal-container',
                controller: 'DisplayAgreementController',
                controllerAs: 'modal',
                templateUrl: 'js/app/displayAgreement/modal.html'
            });
        };

    }
);