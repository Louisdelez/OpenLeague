/**
 * Created by bperry on 6/4/14.
 */
define(
    [],
    function(){

        function ErrorController($scope, errorMessageModal) {
            $scope.title = $scope.error.title;
            $scope.message = $scope.error.message;

            $scope.close = errorMessageModal.deactivate;

            $scope.savelogsClick = function () {
                riot.client.hostCommand('SendLogs');
            }
        }
        return ErrorController;
    }
)