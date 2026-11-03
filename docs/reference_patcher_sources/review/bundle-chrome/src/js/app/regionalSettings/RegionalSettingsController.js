define(
  [],
  function(){
    function Controller($scope, regionalSettingsModal) {
      $scope.close = regionalSettingsModal.deactivate;
      $scope.save = saveSettings;
      $scope.regions = {};
      $scope.languages = {};
      $scope.regionId = $scope.region.current;
      $scope.languageId = $scope.locale.current;
      setLocales($scope.locale);
      setRegions($scope.region);

      //Translated header and button labels
      $scope.headerLabel = $scope.tra.flash_regional_header;
      $scope.selectLanguageLabel = $scope.tra.flash_region_language_title;
      $scope.selectRegionLabel = $scope.tra.flash_region_region_title;
      $scope.saveLabel = $scope.tra.flash_options_button_save_label;
      $scope.cancelLabel = $scope.tra.flash_options_button_cancel_label;

      $scope.$watch('regionId', function() {
        $scope.regionLanguages = []
        for (var i = 0; i < $scope.regions[$scope.regionId].langs.length; i++)
        {
            var l_id = $scope.regions[$scope.regionId].langs[i]
            var region = $scope.regionId.split('_')[0];
            if(region == "riot" || region == "staging" || region == "pbe")
            {
              $scope.regionLanguages[i] = {id: l_id, name: $scope.languages[l_id] + " - " + $scope.tra[$scope.regionsLabel[l_id]]}
            }
            else
            {
              $scope.regionLanguages[i] = {id: l_id, name: $scope.languages[l_id]}
            }
        }
      });

      function saveSettings() {
        window.riot && riot.client.hostCommand('SetRegionAndLocale', $scope.regionId + ',' + $scope.languageId);
      }

      function setRegions(region) {
          for (var i = 0; i < region.regions.length; i++) {
              var keys = Object.keys(region.regions[i]);
              var key = keys[0];
              $scope.regions[key] = {langs: region.regions[i][key], id: key, name: $scope.tra[key]};
          }
      }

      function setLocales(locale) {
          for (var i = 0; i < locale.locales.length; i++) {
              $scope.languages[locale.locales[i]] = locale.names[i];
          }
      }
    }

    return Controller;
  }
);