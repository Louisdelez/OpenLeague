define(
  [
    'lib/chrome'
  ],
  function(chrome){

     function ChromeController($scope, settingsModal, regionalSettingsModal, displayAgreementModal, displayCopyrightModal, errorMessageModal, initialLaunchPopupModal, pandoRemovalPopupModal, $http) {
         $scope.percent = 0;
         $scope.progressCount = 0;
         $scope.saveLogsEnabled = true;
         $scope.bDisabled = true;           // Sets the launch button to be disabled if set to true (ie. after clicking the launch button, prevent it from being clicked again)
         $scope.bServerStatus = false;      // Sets the launch button to be disabled if set to true (ie. when serverStatus is not online)
         $scope.bUrf = true;                // Forces the launch button to be enabled if set to false, regardless of bDisabled or bServerStatus
         $scope.bSettings = true;
         $scope.bRepairAgreement = false;
         $scope.bRepairStarted = false;
         $scope.bRepairing = false;
         $scope.bPatchComplete = true;
         $scope.bPatchDelay = true;
         $scope.patchStatus = "launch";
         $scope.serverKey = 0;
         $scope.delay = false;
         $scope.bypassCode = "";
         $scope.bypassInput = "";
         $scope.tickerMessages = "";
         $scope.bTicker = true;
         $scope.regionsMap = {};
         $scope.popupActive = false;
         $scope.sfxVolume = 0.5;
         $scope.sfxMuted = false;
         $scope.check = true;

         chrome.navigate('landing');
         var repairTime;
         var startupTime;

         $scope.navigate = chrome.navigate.bind(chrome);

         $scope.exit = function() {
             var analyticsData = JSON.stringify({
                 eventType: "click",
                 target: "exit_button",
                 options: { exit: true }
             });

             window.postMessage('TrackEvent:' + analyticsData, location.origin);

             // The analytics wrapper closes the client to make sure the event is tracked first,
             // but in the case that it doesn't work, force close the client after a short timeout
             setTimeout(function() {
                 window.riot && riot.client.exit && riot.client.exit();
             }, 100)
         }

         $scope.minimize = window.riot && riot.client.windowMinimize;

         $scope.goHome = function() {
             document.getElementById('chrome-landing').contentWindow.postMessage('LandingMessage', location.origin);

             var analyticsData = JSON.stringify({
                 eventType: "click",
                 target: "home_button"
             });

             window.postMessage('TrackEvent:' + analyticsData, location.origin);
         };

         $scope.launchClient = function () {
           var audio = document.getElementById("audio-launch");
           audio.volume = $scope.sfxVolume;
           console.log("Audio: ", $scope.bDisabled, $scope.sfxMuted, $scope.bServerStatus);
           if(!$scope.bDisabled && !$scope.sfxMuted && !$scope.bServerStatus) {
             audio.currentTime = 0;
             audio.play();
           }

           window.riot && riot.client.hostCommand('Launch', '2000');

           var analyticsData = JSON.stringify({
            eventType: "click",
            target: "launch_button"
           });

             window.postMessage('TrackEvent:' + analyticsData, location.origin);
         }

         $scope.openSettings = function () {
             $scope.currentModal = settingsModal.activate({currentP2P: $scope.p2p, tra: $scope.tra, sfxVolume: $scope.sfxVolume, sfxMuted:$scope.sfxMuted});

             var analyticsData = JSON.stringify({
                 eventType: "click",
                 target: "settings_button"
             });

             window.postMessage('TrackEvent:' + analyticsData, location.origin);
         };

         $scope.openRegionalSettings = function () {
             regionalSettingsModal.activate({region: $scope.localeAndRegionDetail.region, locale: $scope.localeAndRegionDetail.locale, tra: $scope.tra, regionsLabel:$scope.regionsLabel});

             var analyticsData = JSON.stringify({
                 eventType: "click",
                 target: "regional_settings_button"
             });

             window.postMessage('TrackEvent:' + analyticsData, location.origin);
         };

         addEventListener('DisplayAgreement', function (ev) {
          displayAgreementModal.activate(ev.detail.agreement);
         });

        addEventListener('DisplayCopyright', function(ev) {
          displayCopyrightModal.activate({text: ev.detail.copyright.text, btnLabel: $scope.tra["soft_repair_notification_button_ok"], title: $scope.tra["button_about_label"]});
        })

         addEventListener('ClientInit', function (ev) {
             clientInit(ev);
             if (ev.detail.popup) {
                 $(document).on('InitialLaunchEvent', function() {
                    $scope.popupActive = false;
                    handlePandoRemoval(ev.detail.pando_uninstall);
                 });

                 $scope.popupActive = true;
                 initialLaunchPopupModal.activate({tra: $scope.tra, locale: $scope.localeAndRegionDetail.locale.current, region: $scope.localeAndRegionDetail.region.current});
             }
             else
             {
                 handlePandoRemoval(ev.detail.pando_uninstall);
             }
         });

         addEventListener('UpdateTras', function (ev) {
             setTras(ev.detail.tra);
         });

         addEventListener('UpdateRegionAndLocale', function(ev) {
             $scope.localeAndRegionDetail.region.current = ev.detail.currentRegion;
             $scope.localeAndRegionDetail.locale.current = ev.detail.currentLocale;
             $scope.regionName = $scope.tra[$scope.localeAndRegionDetail.region.current];
             setButtonLaunchText(1000);
             $scope.changeYourRegion = $scope.tra["flash_regional_button_label"];
             $scope.serverLabel = $scope.tra[$scope.serverKey].toLowerCase();

             _analyticsData.region = $scope.localeAndRegionDetail.region.current.split("_")[0].toUpperCase();

             var analyticsData = JSON.stringify({
                 eventType: "client",
                 target: "update_regional_settings",
                 data: {
                     region: $scope.localeAndRegionDetail.region.current.split("_")[0].toUpperCase(),
                     locale: $scope.localeAndRegionDetail.locale.current
                 }
             });

             window.postMessage('TrackEvent:' + analyticsData, location.origin);

             setRegionsMap();
             setLocalStorage($scope.localeAndRegionDetail);
             document.getElementById('chrome-landing').contentWindow.postMessage('ReloadPages', location.origin);

         });

         addEventListener('ServerStatus', function (ev) {
             updateServerStatus(ev.detail.server.status);
         });

         // Korea still sends server status events the old fashioned way, so handle those, too.
         addEventListener('HttpResponse', function (ev) {
             try {
               var locale = "";
               if (localStorage) {
                 locale = localStorage.locale;
               }

               if ((locale == "ko_kr") && (ev.detail.httpResponse.id == 1 || ev.detail.httpResponse.id == 0)) {
                 updateServerStatus(ev.detail.httpResponse.response.serverStatus);
               }
             }
             catch (e) {
               console.log(e.message);
             }
         });

         addEventListener('DisplayError', function (ev) {
             errorMessageModal.activate({error: ev.detail.error, continue:$scope.tra["button_continue"], savelogs:$scope.tra["button_send_logs"]});

             if (!ev.detail.error) {
                ev.detail.error = {};
             }

             var analyticsData = JSON.stringify({
                 eventType: "client",
                 target: "error",
                 data: { title: ev.detail.error.title, message: ev.detail.error.message }
             });

             window.postMessage('TrackEvent:' + analyticsData, location.origin);
         });

         addEventListener('BypassCode', function (ev) {
             $scope.bypassCode = ev.detail.bypass.code.toLowerCase();
         });

         addEventListener('keypress', function(ev) {
             $scope.bypassInput += String.fromCharCode(ev.keyCode).toLowerCase();

             if ($scope.bypassInput.length > $scope.bypassCode.length) {
                $scope.bypassInput = $scope.bypassInput.substring(1, $scope.bypassInput.length+1);
             }

             if ($scope.bypassCode != "" && $scope.bypassInput == $scope.bypassCode) {
                 $scope.bypassInput = "";
                 $scope.bUrf = false;

                 var analyticsData = JSON.stringify({
                     eventType: "client",
                     target: "urf_code"
                 });

                 window.postMessage('TrackEvent:' + analyticsData, location.origin);
             }
         });

         //Force the Client to Initialize once the chrome is loaded
         window.riot && riot.client.forceClientInit();

         // Determine our screen size and location from the available real estate.
         var screenWidth = window.riot && riot.client.windowScreenWidth() || window.innerWidth;
         var screenHeight = window.riot && riot.client.windowScreenHeight() || window.innerHeight;

         // If we're less than or equal to 1280x800 in any dimension, go low res.
         var width = 1280;
         var height = 800;

         if ((screenWidth <= width) || (screenHeight <= height)) {
             width = 992;
             height = 620;
         }

         var x = (screenWidth - width) / 2;
         var y = (screenHeight - height) / 2;

         // Center ourselves on screen.
         window.riot && riot.client.windowMoveTo(x, y);
         window.riot && riot.client.windowResizeTo(width, height);

         // Display the main window.
         window.riot && riot.client.windowShow();

         $(document).on("InitializeRepairEvent", function(ev) {
             $scope.bRepairStarted = true;

             var analyticsData = JSON.stringify({
                 eventType: "client",
                 target: "repair"
             });

             window.postMessage('TrackEvent:' + analyticsData, location.origin);
         });

         $(document).on("SFXVolumeEvent", function(ev) {
           $scope.sfxVolume = parseInt(ev.message)/100;
         });

         $(document).on("SFXMuteEvent", function(ev) {
           $scope.sfxMuted = ev.message;
         });

         $(document).on("DisplayAgreementEvent", function(ev) {
             if ($scope.bRepairStarted) {
                 $scope.bRepairAgreement = (ev.message === "true");
                 $scope.bRepairing = $scope.bRepairAgreement && $scope.bRepairStarted;
             }
         });

         $(document).on('click', '.external-link', function() {
             var analyticsData = JSON.stringify({
                 eventType: "click",
                 target: "external_link",
                 data: { url: $(this).attr('href') }
             });

             parent.window.postMessage('TrackEvent:' + analyticsData, location.origin);
         });

         function clientInit(ev) {
             $scope.localeAndRegionDetail = ev.detail;
             setTras(ev.detail.tra);
             setButtonLaunchText(0);
             $scope.regionName = $scope.tra[ev.detail.region.current];
             $scope.changeYourRegion = $scope.tra["flash_regional_button_label"];
             $scope.p2p = String(ev.detail.p2p);
             $scope.version = ev.detail.version;
             $scope.bSettings = false;
             $scope.sessionId = generateSessionId();
             $scope.sfxVolume = ev.detail.sfx_volume/100;
             (ev.detail.sfx_mute == '1') ? $scope.sfxMuted = true : $scope.sfxMuted = false;

             initializeAnalyticsData();

             // Clear localStorage so we don't miss any bugs from using an old localStorage
             localStorage.language = "";
             localStorage.region = "";
             localStorage.locale = "";

             //This is temporary code so we can test internal news only on riot environments
             localStorage.environment = $scope.localeAndRegionDetail.region.current.split('_')[0];

             setNewsStorage(ev.detail.news);

             setRegionsMap();
             setRegionLabel();
             setLocalStorage($scope.localeAndRegionDetail);

             setInterval(setTickerMessage, 60000);
             setInterval(checkServer, 3000); // Server status is checked only every 15 seconds

             document.getElementById('chrome-landing').contentWindow.postMessage('InitMainHub', location.origin);
         }

         function clientStartUpdate() {
             riot.client.hostCommand('StartUpdate');

             //Adding a delay to UpdateTaskProgress so modes don't flicker on startup
             setTimeout(function() {
               addEventListener('UpdateTaskProgress', patching);
             }, 500)

         }

         function handlePandoRemoval(pando_uninstall)
         {
             if (pando_uninstall == 'no') {
                 $scope.popupActive = false;
                 clientStartUpdate();
             } else {
                 $(document).on('PandoResponseEvent', function() {
                    $scope.popupActive = false;
                    clientStartUpdate();
                 });

                 $scope.popupActive = true;
                 pandoRemovalPopupModal.activate({tra: $scope.tra, locale: $scope.localeAndRegionDetail.locale.current, region: $scope.localeAndRegionDetail.region.current, pando_uninstall: pando_uninstall});
             }
         }

         function setNewsStorage(news)
         {
           if(news.length > 0)
           {
             for (var i=0; i<news.length; i++)
             {
               var item = news[i];

               if(item["news1"] != undefined)
               {
                 localStorage.news1= item["news1"];
               }
               else if(item["news2"] != undefined)
               {
                 localStorage.news2= item["news2"];
               }
               else if(item["news3"] != undefined)
               {
                 localStorage.news3= item["news3"];
               }
               else if(item["champions"] != undefined)
               {
                 var champs = {};
                 champs.champions = [];
                 var keys = item["champions"].split(",");

                 for (var x=0; x<keys.length; x++)
                 {
                   var champ = new Object();
                   champ.id = parseInt(keys[x]);
                   champs.champions.push(champ);
                 }
                 localStorage.champions = JSON.stringify(champs);
               }
             }
             localStorage.patch = true;
           }
         }

         var getTextWidth = function (text, font) {
             var canvas = getTextWidth.canvas || (getTextWidth.canvas = document.createElement("canvas"));
             var context = canvas.getContext("2d");
             context.font = font;
             var metrics = context.measureText(text);
             return metrics.width;
         };

         function setButtonLaunchText(time) {
            //Adding a delay for when regions are changed so can transition

            setTimeout(function(){
              $scope.buttonLaunch = $scope.tra["button_launch_label"];

              $scope.buttonLaunchSize = "";

              if (getTextWidth($scope.buttonLaunch, $('.button-play-text').css('font')) > 100) {
                $scope.buttonLaunchSize = "button-launch-small-text";
              }
            }, time)
         }

         function setLocalStorage(detail) {
             var locale = detail.locale.current;

           switch(locale)
           {
             case "en_gb":
               localStorage.region = detail.region.current.split("_").shift();
               break;
             case "es_mx":
               var region = detail.region.current.split("_").shift();
               if(region == "la2" ){
                 localStorage.region = $scope.regionsMap["es_ar"];
                 locale = "es_ar";
               }
               else {
                 localStorage.region = $scope.regionsMap[locale];
               }
               break;
             default:
               localStorage.region = $scope.regionsMap[locale];
               break;
           }

             var languageCodeArr = locale.split('_');
             languageCodeArr[1] = languageCodeArr[1].toUpperCase();
             localStorage.locale = languageCodeArr.join('_');
             localStorage.language = languageCodeArr[0];

             $scope.locale = localStorage.locale;

             // detail.region.current may cause problems (ie. news-oembed does not recognize "riot" as a region, and it
             // does not make sense to be in NA region with Korean as a language), so find the region from the locale.
             // Here is the mapping that we maintain: https://gh.riotgames.com/web/NodeJS-RiotI18n
             setTickerMessage();
         }

          function setTickerMessage() {
             var status;
             var region = $scope.localeAndRegionDetail.region.current.split('_')[0];

             switch(region) {
               case "riot":
                 status = "http://status.dev.leagueoflegends.com/shards/riot/summary"
                 $scope.tickerLink = 'http://status.dev.leagueoflegends.com/#riot'
                 break;
               case "staging":
                 status = "http://status.dev.leagueoflegends.com/shards/staging/summary"
                 $scope.tickerLink = 'http://status.dev.leagueoflegends.com/#staging'
                 break;
               case "pbe":
                 status = "http://status.pbe.leagueoflegends.com/shards/pbe/summary"
                 $scope.tickerLink = 'http://status.pbe.leagueoflegends.com/#pbe'
                 break;
               default:
                 status = "http://status.leagueoflegends.com/shards/"+ region + "/summary";
                 $scope.tickerLink = 'http://status.leagueoflegends.com/#' + region;
                 break;
             }

             $http.get(status).success(function(data) {
                 var newTickerMessage = [];
                 $scope.maxSeverity = "";
                 $scope.bTicker = (data.messages.length == 0);

                 var count = 0;
                 data.messages.forEach(function(message) {
                    var iSev = 0;
                    var content = message.content;
                    count += 1;
                    message.translations.forEach(function(translation) {
                        if (translation.locale == localStorage.locale) {
                            content = translation.content;
                        }
                    })

                    switch(message.severity) {
                      case "info":
                        if($scope.maxSeverity != "warn" && $scope.maxSeverity != "error"){$scope.maxSeverity = message.severity}
                        iSev = 0;
                        break;
                      case "warn":
                        if($scope.maxSeverity != "error"){$scope.maxSeverity = message.severity}
                        iSev = 1;
                        break;
                      case "error":
                        $scope.maxSeverity = message.severity;
                        iSev = 2;
                        break;
                      default:
                        $scope.maxSeverity = "info"
                        iSev = 0;
                        break;
                    }

                    newTickerMessage.push({title: overflowEllipsis(content, 45), message: content, id:"message_" + count, severity: message.severity, sev_key: iSev});
                 })

                 newTickerMessage.sort(function(a, b) {
                   return b.sev_key- a.sev_key;
                 });

                 if(!angular.equals($scope.tickerMessages, newTickerMessage))
                 {
                   $scope.tickerMessages = newTickerMessage;
                 }
             })
         }


         // Need to use /summary to get only enabled messages (rather than all of them).
         // There is a bug as of Aug 19, 2014 where /summary shows Game and Forums messages
         // and no Store messages; NOC is posting all Store related messages to Game.
         function setTickerMessageAll() {
             var status;
             var region = $scope.localeAndRegionDetail.region.current.split('_')[0];

             switch(region) {
               case "riot":
                 status = "http://status.dev.leagueoflegends.com/shards/riot"
                 break;
               case "staging":
                 status = "http://status.dev.leagueoflegends.com/shards/staging"
                 break;
               case "pbe":
                 status = "http://status.pbe.leagueoflegends.com/shards/pbe"
                 break;
               default:
                 status = "http://status.leagueoflegends.com/shards/"+ region;
                 break;
             }

             $http.get(status).success(function(response) {
                 var incidents = [];
                 var count = 0;
                 var displayedServices = ["Game", "Store"];
                 $scope.tickerMessages = [];
                 $scope.maxSeverity = "";

                 response.services.forEach(function(service) {
                     if (displayedServices.indexOf(service.name) != -1 && service.incidents) {
                         service.incidents.forEach(function(incident) {
                             if (incident.active) {
                                 incidents.push(incident);
                             }
                         })
                     }
                 })

                 incidents.forEach(function(incident) {
                     if (incident.updates) {
                         if ($scope.bTicker) {
                             $scope.bTicker = (incident.updates.length == 0);
                         }

                         incident.updates.forEach(function(message) {
                            var content = message.content;
                            count += 1;
                            message.translations.forEach(function(translation) {
                                if (translation.locale == localStorage.locale) {
                                    content = translation.content;
                                }
                            })

                            switch(message.severity) {
                              case "info":
                                if ($scope.maxSeverity != "warn" && $scope.maxSeverity != "error") {
                                    $scope.maxSeverity = message.severity;
                                }
                                break;
                              case "warn":
                                if ($scope.maxSeverity != "error") {
                                    $scope.maxSeverity = message.severity;
                                }
                                break;
                              case "error":
                                $scope.maxSeverity = message.severity;
                                break;
                              default:
                                $scope.maxSeverity = "info";
                                break;
                            }

                            $scope.tickerMessages.push({
                                title: overflowEllipsis(content, 45),
                                message: content,
                                id: "message_" + count,
                                severity: message.severity
                            })
                         })
                     }
                 })
             })
         }

         function overflowEllipsis(message, length) {
             if (message.length > length) {
                 if (message[length-1] == " ") {
                     return message.substring(0, length-1) + "...";
                 } else {
                     return message.substring(0, length) + "...";
                 }
             } else {
                 return message;
             }
         }

         function checkServer() {
             riot.client.hostCommand('CheckServerStatus');
         }

         function generateSessionId() {
             function s4() {
                 return Math.floor((1 + Math.random()) * 0x10000)
                    .toString(16)
                    .substring(1);
             }

             return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
         }

         function updateServerStatus(status) {
             var prevServerStatus = $scope.serverStatus;
           //We should have a discussion about weather we deliver server status as a number or as text
             server_map = [
              'server_status_error',
              'server_status_online',
              'server_status_unavailable',
              'server_status_busy',
              'server_status_blocked',
              'server_status_limited'
             ];

             server_color_map = [
               'blocked',
               'online',
               'blocked',
               'limited',
               'blocked',
               'limited'
             ];

             $scope.bServerStatus = (server_color_map[status] == 'blocked');
             $scope.serverStatus = server_color_map[status];
             $scope.serverKey = server_map[status];

             if (prevServerStatus != "online" && $scope.serverStatus == "online") {
                 riot.client.hostCommand('StartUpdate');
             }

             if(!$scope.tra){
                 var traWatch = $scope.$watch('tra', function(oldValue, newValue){
                     if ($scope.tra) {
                        $scope.serverLabel = $scope.tra[$scope.serverKey].toLowerCase();
                        $scope.serverLabel = $scope.tra[$scope.serverKey].toLowerCase();
                        traWatch();
                     }
                 })
             }
             else
             {
                 $scope.serverLabel = $scope.tra[$scope.serverKey].toLowerCase();
             }

             _analyticsData.server_status = $scope.serverStatus;
         }

         function initializeAnalyticsData() {
            // Defined in index.html
            _analyticsData = {
                session_id: $scope.sessionId,
                platform: window.navigator.platform,
                region: $scope.localeAndRegionDetail.region.current.split("_")[0].toUpperCase(),
                version: $scope.version,
                server_status: $scope.serverStatus,
                current_page: "main_hub"
            }
         }

         function overallTaskComplete() {
             $scope.ready = true;
             $scope.bDisabled = false;
             $scope.progressCount = 0;
             $scope.patchStatus ="launch";

             //Only play audio if we displayed a patching event
             if(!$scope.bPatchComplete)
             {
               var audio = document.getElementById("audio-patcher-complete");

               audio.volume = $scope.sfxVolume;
               if(!$scope.sfxMuted)
               {
                 audio.currentTime = 0;
                 audio.play();
               }
             }
             $scope.bPatchComplete = true;
             startupTime = null;
             $.event.trigger({
                 type: "PatchComplete",
                 message: "false"
             });

             if (!$scope.$$phase) $scope.$apply();
         }

         function stepTaskComplete() {
             $scope.bRepairStarted = false;
             $scope.bRepairAgreement = false;
             $scope.bRepairing = false;
         }

         function patching(ev){
             if($scope.patchingHeader != ev.detail.progress.overall.header)
             {
                 $scope.patchingHeader = ev.detail.progress.overall.header
                 $scope.progressCount = 0;
             }

            if(ev.detail.progress.overall.percent >= 1)
            {
               $scope.patchingHeader = ev.detail.progress.overall.header;
               /*
               if(!$scope.bPatchComplete)
               {
                 overallTaskComplete();
               }
               */
              overallTaskComplete();

                if(($scope.bRepairStarted && $scope.bRepairAgreement))
                {
                    // Note: Delay is an interm fix - we need to give enough time for bRepairStarted to be set before it is reset by stepTaskComplete
                    if(!repairTime) {
                        repairTime = setTimeout(function() {
                            stepTaskComplete();
                            repairTime = null;
                        }, 1000);
                    }
                }
            }
            else
            {
              if(repairTime) {
                clearTimeout(repairTime);
                repairTime = null;
              }

              if(!startupTime)
              {
                $scope.bPatchComplete = true;
                $scope.bPatchDelay = true;
                $scope.ready = false;

                if (!$scope.$$phase) $scope.$apply();

                startupTime = setTimeout(function() {
                  $scope.bPatchDelay = false;
                }, 1500);
              }

              if(!$scope.bPatchDelay)
              {
                patchingUpdate(ev);
              }
            }
         }

         function patchingUpdate(ev)
         {
           $scope.patchStatus = "patching";
           //$scope.bDisabled = true;
           $scope.ready = false;
           $scope.bPatchComplete = false;

           $.event.trigger({
             type: "PatchComplete",
             message: "true"
           });

           $scope.percent = Math.floor(ev.detail.progress.overall.percent * 100);

           if($scope.percent < 33){ $scope.progressTask = $scope.tra["step_title_updating_interface"]}
           else{ $scope.progressTask = $scope.tra["step_title_updating_game_files"]}
           //$scope.progressHeader = ev.detail.progress.overall.header;

           $scope.progressStepPercent = ev.detail.progress.step.percent;
           $scope.percentBar = ev.detail.progress.overall.percent * 100;

           if($scope.progressStepPercent != 0)
           {
             $scope.scanning = false;
             $scope.progressHeader = extractHeader(ev.detail.progress.step.header, 0) + ":";
           }
           else
           {
             $scope.scanning = true;
             $scope.progressHeader = extractHeader(ev.detail.progress.step.header, 1);
           }

           $scope.progressDetail = extractDetail(ev.detail.progress.overall.detail);

           if($scope.progressDetail.search($scope.tra["step_title_patch_files"]) > -1)
           {
             $scope.progressHeader = $scope.progressHeader.replace($scope.tra["text_calculating"], $scope.tra["text_applying"]);
           }

           if ($scope.progressFile !== ev.detail.progress.step.detail) {
             $scope.progressCount = $scope.progressCount + 1;
             $scope.progressFile = ev.detail.progress.step.detail
           }
           if($scope.patchStatus == 'repair') {
             $scope.patchingHeader = ev.detail.progress.overall.header;
           }
           if (!$scope.$$phase) $scope.$apply();
         }

         /* This function assumes a specific format for the detail, if the format changes this will
            most likely break [Expected: 1856 Kbps (116 MB Left)]  */
         function extractDetail(raw_detail) {
             var to_r = raw_detail.split('(')

             if (to_r.length == 1)
             {
               return $scope.progressCount + " " + to_r[0];
             }

             var kbps = to_r[0];
             var num = to_r[1].match(/\d+\.?\d*/g);
             var text = to_r[1].replace(/\d+\.?\d*/g, '');

             text = text.trim();
             to_r = text.split(" ");

             return num[0] + " " + to_r[0] + " ( " + kbps + ")";
         }

         function extractHeader(data, num) {
             data = data.replace(/\./g, '');
             var split = data.split(':')
             return split[num].trim();
         }

         function setTras(tra) {
             $scope.tra = {}

             for(var i = 0; i < tra.length; ++i) {
                 for (var i = 0; i < tra.length; i++) {
                     var keys = Object.keys(tra[i]);
                     var key = keys[0];
                     $scope.tra[key] = tra[i][key];
                 }
             }
           localStorage.tra = JSON.stringify($scope.tra);
         }

         function setRegionsMap() {
            $scope.regionsMap = {
                "cs_cz": "eune",
                "de_de": "euw",
                "el_gr": "eune",
                "en_au": "oce",
                "en_gb": "euw",
                "en_pl": "eune",
                "en_us": "na",
                "es_ar": "las",
                "es_es": "euw",
                "es_mx": "lan",
                "fr_fr": "euw",
                "hu_hu": "eune",
                "it_it": "euw",
                "ko_kr": "kr",
                "pl_pl": "eune",
                "pt_br": "br",
                "ro_ro": "eune",
                "ru_ru": "ru",
                "tr_tr": "tr"
            }
         }

         function setRegionLabel() {
            $scope.regionsLabel = {
              "cs_cz": "eune_region",
              "de_de": "euw_region",
              "el_gr": "eune_region",
              "en_au": "oc1_region",
              "en_us": "na_region",
              "en_gb": "euw_region",
              "en_pl": "eune_region",
              "es_ar": "la2_region",
              "es_es": "euw_region",
              "es_mx": "la1_region",
              "fr_fr": "euw_region",
              "hu_hu": "eune_region",
              "it_it": "euw_region",
              "ko_kr": "kr_region",
              "pl_pl": "eune_region",
              "pt_br": "br_region",
              "ro_ro": "eune_region",
              "ru_ru": "ru_region",
              "tr_tr": "tr_region"
            }
         }
     }

     return ChromeController;

   }
 );
