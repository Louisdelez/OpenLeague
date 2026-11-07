/**
 * Created by bperry on 4/3/14.
 */
define(
    [],
    function(){

        function DisplayController($scope, displayAgreementModal) {
            $scope.close = displayAgreementModal.deactivate;

            $scope.acceptClick = function(){
                riot.client.hostCommand('SendAgreementResponse', '1');
                //riot.client.forceClientInit();

                $.event.trigger({
                    type: "DisplayAgreementEvent",
                    message: "true"
                });
            }
            $scope.rejectClick = function(){
                riot.client.hostCommand('SendAgreementResponse', '0');

                $.event.trigger({
                    type: "DisplayAgreementEvent",
                    message: "false"
                });
            }
        }
        return DisplayController;
    }
);