define(
  [],
  function(){
    function Controller($scope, pandoRemovalPopupModal) {
      if ($scope.pando_uninstall == 'yes') {
        $scope.popupHeader = $scope.tra['pando_removal_popup_header'];
        $scope.popupBody1 = $scope.tra['pando_removal_popup_body_1'];
        $scope.popupBody2 = $scope.tra['pando_removal_popup_body_2'];
      } else if ($scope.pando_uninstall == 'uninstallFailed') {
        $scope.popupHeader = $scope.tra['pando_removal_failed_popup_header'];
        $scope.popupBody1 = $scope.tra['pando_removal_failed_popup_body_1'];
        $scope.popupBody2 = $scope.tra['pando_removal_failed_popup_body_2'];
      }
      $scope.popupYesLabel = $scope.tra['pando_removal_popup_yes'];
      $scope.popupNoLabel = $scope.tra['pando_removal_popup_no'];
      $scope.popupNeverLabel = $scope.tra['pando_removal_popup_never'];
      $scope.learnMoreLabel = $scope.tra['initial_popup_learn_more'];

      $scope.regionMap = {
        "en_us":{
          "region":"na",
          "language":"en",
          "http":"http://na.leagueoflegends.com/en/news/game-updates/features/upcoming-pando-media-booster-removal"
        },
        "de_de":{
          "region":"euw",
          "language":"de",
          "http": "http://euw.leagueoflegends.com/de/news/game-updates/features/ankundigung-pando-media-booster-wird-entfernt"
        },
        "es_es":{
          "region":"euw",
          "language":"es",
          "http":"http://euw.leagueoflegends.com/es/news/game-updates/features/proxima-desaparicion-de-pando-media-booster"
        },
        "fr_fr":{
          "region":"euw",
          "language":"fr",
          "http":"http://euw.leagueoflegends.com/fr/news/game-updates/features/suppression-de-pando-media-booster"
        },
        "it_it":{
          "region":"euw",
          "language":"it",
          "http":"http://euw.leagueoflegends.com/it/news/game-updates/features/futura-rimozione-di-pando-media-booster"
        },
        "es_mx":{
          "region":"lan",
          "language":"es",
          "http":"http://lan.leagueoflegends.com/es/news/game-updates/features/proxima-eliminacion-de-pando-media-booster"
        },
        "es_ar":{
          "region":"las",
          "language":"es",
          "http":"http://las.leagueoflegends.com/es/news/game-updates/features/proxima-eliminacion-de-pando-media-booster"
        },
        "en_au":{
          "region":"oce",
          "language":"en",
          "http":"http://oce.leagueoflegends.com/en/news/game-updates/features/upcoming-pando-media-booster-removal"
        },
        "pt_br":{
          "region":"br",
          "language":"pt",
          "http":"http://br.leagueoflegends.com/pt/news/game-updates/features/pando-media-booster-sera-desabilitado-em-breve"
        },
        "pl_pl":{
          "region":"eune",
          "language":"pl",
          "http":"http://eune.leagueoflegends.com/pl/news/game-updates/features/wkrotce-usuniemy-pando-media-booster"
        },
        "el_gr":{
          "region":"eune",
          "language":"el",
          "http":"http://eune.leagueoflegends.com/el/news/game-updates/features/eperhomeni-katargisi-toy-pando-media-booster"
        },
        "ro_ro":{
          "region":"eune",
          "language":"ro",
          "http":"http://eune.leagueoflegends.com/ro/news/game-updates/features/vom-elimina-pando-media-booster"
        },
        "cs_cz":{
          "region":"eune",
          "language":"cs",
          "http":"http://eune.leagueoflegends.com/cs/news/game-updates/features/chystane-odebrani-programu-pando-media-booster"
        },
        "hu_hu":{
          "region":"eune",
          "language":"hu",
          "http":"http://eune.leagueoflegends.com/hu/news/game-updates/features/beszuntetjuk-pando-media-booster-hasznalatat"
        },
        "tr_tr":{
          "region":"tr",
          "language":"tr",
          "http":"http://tr.leagueoflegends.com/tr/news/game-updates/features/pando-media-booster-yakinda-kaldiriliyor"
        },
        "ru_ru":{
          "region":"ru",
          "language":"ru",
          "http":"http://ru.leagueoflegends.com/ru/news/game-updates/features/otkaz-ot-pando-media-booster"
        },
        // still waiting for korean link ... 
        "ko_kr":{
          "region":"kr",
          "language":"",
          "http":"http://www.leagueoflegends.co.kr/"
        }
      }

      if ($scope.locale != "en_gb"){
        $scope.externalLink = $scope.regionMap[$scope.locale].http;
      }
      else
      {
        if($scope.region.split("_").shift() == "euw")
        {
          $scope.externalLink = "http://euw.leagueoflegends.com/en/news/game-updates/features/upcoming-pando-media-booster-removal"
        }
        else
        {
          $scope.externalLink = "http://eune.leagueoflegends.com/en/news/game-updates/features/upcoming-pando-media-booster-removal"
        }
      }

      $scope.close = function() {
        pandoRemovalPopupModal.deactivate();
      }

      $scope.yesClick = function(){
        riot.client.hostCommand('PandoRemove', 'yes');
        $.event.trigger({
          type: "PandoResponseEvent",
          message: "true"
        });
      }

      $scope.noClick = function(){
        riot.client.hostCommand('PandoRemove', 'no');
        $.event.trigger({
          type: "PandoResponseEvent",
          message: "true"
        });
      }

      $scope.neverClick = function(){
        riot.client.hostCommand('PandoRemove', 'never');
        $.event.trigger({
          type: "PandoResponseEvent",
          message: "true"
        });
      }

      $scope.$watch("$viewContentLoaded", function(){
        setTimeout(function(){
          var ourText = $('#modal-pando-media-booster .modal-header-text'),
            parent = ourText.parent();
          var fontSize = parseInt(ourText.css("fontSize"), 10);
          var fontNum = Math.max(10, Math.min(fontSize * (parent[0].offsetWidth / ourText[0].scrollWidth),fontSize)) - 1;
          ourText.css("font-size", fontNum + "px");
        }, 250)
      });
    }
    return Controller;
  }
);
