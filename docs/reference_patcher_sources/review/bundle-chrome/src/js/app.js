

define(
  function (require) {
    'use strict';

    var progressDirective = require('app/directives/progress'),
        dropdownDirective = require('app/directives/dropdown');

    var app = angular.module('chrome', [
      'ngSanitize',
      'chrome-directives',
      'LocalStorageModule',
      'btford.modal'
    ]);

    app.provider('settings', function(){
      return {
        $get : function(localStorageService) {
          return {
            get : function(attr) {
              localStorageService.get(attr);
            },
            set : function(attr, val) {
              localStorageService.set(attr, val)
            }
          }
        }
      }
    });

    app.controller('ChromeController', require('app/ChromeController'));
    app.controller('SettingsController', require('app/settings/SettingsController'));
    app.factory('settingsModal', require('app/settings/settingsModal'));
    app.controller('RegionalSettingsController', require('app/regionalSettings/RegionalSettingsController'));
    app.factory('regionalSettingsModal', require('app/regionalSettings/regionalSettingsModal'));
    app.controller('DisplayAgreementController', require('app/displayAgreement/DisplayAgreementController'));
    app.factory('displayAgreementModal', require('app/displayAgreement/displayAgreementModal'));
    app.controller('DisplayCopyrightController', require('app/displayCopyright/DisplayCopyrightController'));
    app.factory('displayCopyrightModal', require('app/displayCopyright/displayCopyrightModal'));
    app.controller('ErrorMessageController', require('app/errorMessage/ErrorMessageController'));
    app.factory('errorMessageModal', require('app/errorMessage/errorMessageModal'));
    app.controller('InitialLaunchPopupController', require('app/initialLaunchPopup/InitialLaunchPopupController'));
    app.factory('initialLaunchPopupModal', require('app/initialLaunchPopup/initialLaunchPopupModal'));
    app.controller('PandoRemovalPopupController', require('app/pandoRemovalPopup/PandoRemovalPopupController'));
    app.factory('pandoRemovalPopupModal', require('app/pandoRemovalPopup/pandoRemovalPopupModal'));
    return app;
  }
);
