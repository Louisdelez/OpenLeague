define(
  [],
  function(){
    function Controller($scope, initialLaunchPopupModal) {
      $scope.popupHeader = $scope.tra['initial_popup_header'];
      $scope.popupBody1 = $scope.tra['initial_popup_body_1'];
      $scope.popupBody2 = $scope.tra['initial_popup_body_2'];
      $scope.popupCloseLabel = $scope.tra['initial_popup_close'];
      $scope.learnMoreLabel = $scope.tra['initial_popup_learn_more'];
      $scope.regionMap = {
        "en_us":{
          "region":"na",
          "language":"en",
          "http":"http://na.leagueoflegends.com/en/news/game-updates/features/patcher-landing-page-refresh-way"
        },
        "en_gb":{
          "region":"euw",
          "language":"en",
          "http":"http://euw.leagueoflegends.com/en/news/game-updates/features/patcher-landing-page-refresh-way"
        },
        "de_de":{
          "region":"euw",
          "language":"de",
          "http": "http://euw.leagueoflegends.com/de/news/game-updates/features/neuerungen-patcher-und-startseite"
        },
        "es_es":{
          "region":"euw",
          "language":"es",
          "http":"http://euw.leagueoflegends.com/es/news/game-updates/features/renovacion-del-instalador-y-la-pagina-principal"
        },
        "fr_fr":{
          "region":"euw",
          "language":"fr",
          "http":"http://euw.leagueoflegends.com/fr/news/game-updates/features/mise-jour-du-patcher-et-de-la-page-daccueil"
        },
        "it_it":{
          "region":"euw",
          "language":"it",
          "http":"http://euw.leagueoflegends.com/it/news/game-updates/features/aggiornamento-patcher-e-pagina-iniziale"
        },
        "es_mx":{
          "region":"lan",
          "language":"es",
          "http":"http://lan.leagueoflegends.com/es/news/game-updates/features/muy-pronto-instalador-y-pagina-de-inicio-nuevos"
        },
        "es_ar":{
          "region":"las",
          "language":"es",
          "http":"http://las.leagueoflegends.com/es/news/game-updates/features/muy-pronto-instalador-y-pagina-de-inicio-nuevos"
        },
        "en_au":{
          "region":"oce",
          "language":"en",
          "http":"http://oce.leagueoflegends.com/en/news/game-updates/features/patcher-landing-page-refresh-way"
        },
        "pt_br":{
          "region":"br",
          "language":"pt",
          "http":"http://br.leagueoflegends.com/pt/news/game-updates/features/atualizador-e-pagina-de-entrada-mudarao-em-breve"
        },
        "pl_pl":{
          "region":"eune",
          "language":"pl",
          "http":"http://eune.leagueoflegends.com/pl/news/game-updates/features/odnowienie-patchera-i-ekranu-poczatkowego"
        },
        "el_gr":{
          "region":"eune",
          "language":"el",
          "http":"http://eune.leagueoflegends.com/el/news/game-updates/features/prosehos-ananeosi-patcher-kai-arhikis-selidas"
        },
        "ro_ro":{
          "region":"eune",
          "language":"ro",
          "http":"http://eune.leagueoflegends.com/ro/news/game-updates/features/update-patcher-si-pagina-de-intampinare"
        },
        "cs_cz":{
          "region":"eune",
          "language":"cs",
          "http":"http://eune.leagueoflegends.com/cs/news/game-updates/features/blizi-se-uprava-patcheru-uvodni-stranky"
        },
        "hu_hu":{
          "region":"eune",
          "language":"hu",
          "http":"http://eune.leagueoflegends.com/hu/news/game-updates/features/uton-az-uj-frissitoprogram-es-kezdolap"
        },
        "tr_tr":{
          "region":"tr",
          "language":"tr",
          "http":"http://tr.leagueoflegends.com/tr/news/game-updates/features/yama-araci-ve-acilis-sayfasi-yenilemesi-yolda"
        },
        "ru_ru":{
          "region":"ru",
          "language":"ru",
          "http":"http://ru.leagueoflegends.com/ru/news/game-updates/features/uluchshenie-programmy-obnovleniya-igrovogo-klienta"
        },
        "ko_kr":{
          "region":"kr",
          "language":"",
          "http":"http://www.leagueoflegends.co.kr/?m=news&cate=update&mod=view&schwrd=&idx=250445"
        }
      }

      if ($scope.locale != "en_gb"){
        $scope.externalLink = $scope.regionMap[$scope.locale].http;
      }
      else
      {
        if($scope.region.split("_").shift() == "euw")
        {
          $scope.externalLink = "http://euw.leagueoflegends.com/en/news/game-updates/features/patcher-landing-page-refresh-way"
        }
        else
        {
          $scope.externalLink = "http://eune.leagueoflegends.com/en/news/game-updates/features/patcher-landing-page-refresh-way"
        }
      }

      $scope.$watch("$viewContentLoaded", function(){
        setTimeout(function(){
          var ourText = $('#modal-initial-popup .modal-header-text'),
            parent = ourText.parent();
          var fontSize = parseInt(ourText.css("fontSize"), 10);
          var fontNum = Math.max(0.1, Math.min(fontSize * (parent[0].offsetWidth / ourText[0].scrollWidth),fontSize)) - 1;
          ourText.css("font-size", fontNum + "px");
        },250)
      })

      $scope.close = function() {
      	initialLaunchPopupModal.deactivate();
	    $.event.trigger({
	        type: "InitialLaunchEvent",
	        message: "false"
	    });
      }
    }

    return Controller;
  }
);