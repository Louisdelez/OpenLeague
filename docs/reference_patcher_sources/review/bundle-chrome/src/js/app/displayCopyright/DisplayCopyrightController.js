/**
 * Created by bperry on 4/3/14.
 */
define(
    [],
    function(){

        function DisplayController($scope, displayCopyrightModal) {
            $scope.close = displayCopyrightModal.deactivate;
        }
        return DisplayController;
    }
);