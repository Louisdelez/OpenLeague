define(
  [],
  function(){
    var bP2P;
    var currentlySaving = false;
    var saveDialogOpen = false;
    function SettingsController($scope, settingsModal) {

      $scope.saveLogsDisabled = setSaveLogsState();
      $scope.close = settingsModal.deactivate;

      //Translated header and button labels
      $scope.optionsHeader = $scope.tra.flash_options_header;
      $scope.p2pHeader = $scope.tra.flash_options_p2p_header;
      $scope.p2pCheckbox = $scope.tra.flash_options_p2p_checkbox;
      $scope.troubleHeader = $scope.tra.flash_options_troubleshoot_header;
      $scope.repairLabel = $scope.tra.flash_options_button_repair_label;
      $scope.saveLogsLabel = $scope.tra.flash_options_save_logs_label;
      $scope.cefLabel = $scope.tra.button_about_label;
      $scope.optionsWarningHeader = $scope.tra.options_warning_header;
      $scope.optionsWarningText = $scope.tra.options_warning_text;
      $scope.optionsButtonDisabled = $scope.tra.options_buttons_disabled_text;
      $scope.sfxControlHeader = $scope.tra.options_sfx_volume;
      $scope.sfxRangeHeader = ""

      $scope.repair = function() {
        window.riot && riot.client.hostCommand('StartValidate');

        $.event.trigger({
            type: "InitializeRepairEvent",
            message: "true"
        });
      }

      $scope.saveLogs = function() {
        saveDialogOpen = true;
        setSaveLogsState();
        window.riot && riot.client.hostCommand('SaveLogs');
      }

      $scope.displayCopyright = function() {
        window.riot && riot.client.hostCommand("ShowCopyright")
      }

      $scope.sfxChange = function() {
        window.riot && riot.client.hostCommand('SfxVolume', $scope.sfxRange);
        audioDisplay();
        $.event.trigger({
          type: "SFXVolumeEvent",
          message: $scope.sfxRange
        });
      }

      $scope.sfxRelease = function() {
        var audio = document.getElementById("audio-sound-tick");
        if(!$scope.sfxMuted){
          audio.volume = $scope.sfxRange / 100;
          audio.currentTime = 0;
          audio.play();
        }
      }

      $scope.sfxToggleMute = function()
      {
        $scope.sfxMuted = !$scope.sfxMuted;

        window.riot && riot.client.hostCommand('SfxMute', ($scope.sfxMuted == true) ? '1' : '0');
        $.event.trigger({
          type: "SFXMuteEvent",
          message: $scope.sfxMuted
        });
      }

      function audioDisplay() {
        if($scope.sfxRange == 0) {
          $scope.audioValue = 'mute';
        }
        else if($scope.sfxRange <= 33) {
          $scope.audioValue = 'low';
        }
        else if($scope.sfxRange <= 66) {
          $scope.audioValue = 'mid';
        }
        else if($scope.sfxRange <= 100) {
          $scope.audioValue = 'full'
        }
        else {
          $scope.audioValue = 'mid';
        }
      }

      console.log($scope.sfxVolume);
      $scope.sfxRange = $scope.sfxVolume * 100;
      audioDisplay();

      if (bP2P == undefined) {bP2P = $scope.currentP2P }
      $scope.chkP2P = bP2P;

      $scope.p2pChange = function() {
        bP2P = $scope.chkP2P;
        riot.client.hostCommand('SetP2PEnabled', $scope.chkP2P);
      }

      addEventListener('SaveLogs', function (ev) {
          saveDialogOpen = false;
          setSaveLogsState();

          if(ev.detail.savelogs.hasOwnProperty('enabled')) {
              currentlySaving = !ev.detail.savelogs.enabled;
              $scope.saveLogsDisabled = currentlySaving;
          }

          if (ev.detail.savelogs.hasOwnProperty('status')) {
              $scope.saveStatus = ev.detail.savelogs.status;
          }
      });

      function setSaveLogsState() {
          $scope.saveLogsDisabled = (currentlySaving) || (saveDialogOpen);
      }
    }
    return SettingsController;
  }
);