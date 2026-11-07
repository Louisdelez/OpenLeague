# SYS-18.1-02 — provenance des médias du patcher

2026-11-01T16:30:24.438210+00:00

Lot de provenance disponible terminé sous réserve de relecture ; audit du parent toujours ouvert pour la population des cinq conteneurs nommés. Aucune extraction complète ou fonctionnalité/rendu accepté.

Extraire les images du patcher depuis les fichiers fournis
Le résultat « Extraire les images du patcher depuis les fichiers fournis » est intégré au consommateur réel et vérifié sur la référence 4.20 ; succès, refus et limites applicables sont documentés.

## Précision du reçu hérité
118médias identifiés par octets ;108PNG,3GIF,4JPEG=115images matricielles et3ressources de police (SVGfont/TTF/WOFF). Le lecteur LOAD fournit les payloads en mémoire ; les seules dimensions relevées sont des headers PNG. Aucun décodage complet PNG/GIF/JPEG de pixels ou frames n’est établi par ce producteur.
Le reçu et son ancienne association restent conservés à leurs chemins/empreintes. Le mot décodé ne doit pas être utilisé comme preuve de pixels intégralement décodés ni de fichiers installés.

## Vérifications et résultats

### IDENTITY-VS-DECODE
Attendu : Distinguer identité de membre, headers, pixels et fichiers extraits.
Observé : 118médias identifiés par octets ;108PNG,3GIF,4JPEG=115images matricielles et3ressources de police (SVGfont/TTF/WOFF). Le lecteur LOAD fournit les payloads en mémoire ; les seules dimensions relevées sont des headers PNG. Aucun décodage complet PNG/GIF/JPEG de pixels ou frames n’est établi par ce producteur.
Limite : Aucun nouveau décodage de pixels ou frame, aucun export.

### BOUNDED-PHYSICAL-SEARCH
Attendu : Ne pas déduire de manque global depuis des noms de fichiers.
Observé : Recherche d’égalité d’octets après filtrage de taille dans trois racines explicites :0copies trouvées ;14candidats de taille dans la racine de recherche E examinés.
Limite : Autres racines et versions réencodées non qualifiées.

### CURRENT-ASSET-OWNER
Attendu : Nommer les vrais fichiers consommateurs.
Observé : HTML/CSS utilisent9cibles AIR420 (7images/2polices), toutes identifiées ;0égalité d’octets avec les médias patcher.
Limite : Lecture source/identités, pas succès de chargement ou rendu.

### COMPLETE-CONTAINER-BOUNDARY
Attendu : Conserver l’inconnu des conteneurs du manifeste non récupérés.
Observé : 12LOAD déclarés,7conservés,5non retrouvés aux chemins nommés ; index local exact disponible, contenu des5non examiné.
Limite : Parent d’audit laissé ouvert ; aucune exclusion de source par nom ni pourcentage.

## Images identifiées, non matérialisées dans les racines contrôlées
Chaque ligne possède dans la preuve un pointeur aux octets/métadonnées natifs et une note proposée dans SYS-18.1-02 existante. Une note ne coche aucune tâche et n’applique aucun critère.
- bundle-chrome/src/images/artBarDisclaimerIcon.png — 4104octets ; SHA256 a499bb2e8f72beb3b6c3839d414800e1c0ec41339c14b6976db92b39217fd0da ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artBarIcon.png — 3030octets ; SHA256 33ff93b2fee2e5e7ffc2b6287ca0c464ed07e33818203e18d32ae8303b39c154 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artButtonBusyStatus.png — 3789octets ; SHA256 ce081c71d8d9de391d466fc677e1f0a8bfe837ef920fb8cfe5867b48b9bdb52e ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artButtonCloseUp.png — 1243octets ; SHA256 0f0a7537536398078fd48cc19d1ff71c6799bed1fbf66329e18f9943e4d131c6 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artButtonLaunchDisabled.png — 5084octets ; SHA256 a84dedcc412406cb3b3fc4b4036ffd40f5393d94ff3a789dce7681fc78836f8f ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artButtonLaunchUp.png — 10585octets ; SHA256 084b3035330f7be798ae40c4d28982f54a13748de36e23f0525ab4c90d17bc5e ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artButtonMinUp.png — 956octets ; SHA256 ffd00e6ef016bc5ae83a7bcee984f9b2cf9e10defb6f165bb2157055208d396d ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artButtonOfflineStatus.png — 3793octets ; SHA256 7912cefab03049d5be76a8bc00d553fe857331d54014fc42337d6823690c2d02 ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artButtonOnlineStatus.png — 3769octets ; SHA256 1955c346bc5a204d8fd71f3a8144f1d12f824eae73bed0fdec223639fa9ea36f ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artButtonSettingsUp.png — 1332octets ; SHA256 c9626513fc1b9bbdbe130b8084f3a2e9e2427e47f7061913e76f30c660a8da13 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artButtonSocialAddFriendUp.png — 3910octets ; SHA256 99bd7a93cacf97a403c5da10cb3eb07b6a63ec775d5ea9fd703e325a09471a4c ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artButtonSocialChatOver.png — 3749octets ; SHA256 52cf49ea950e5f2dbe5d8312715436a1570b18013ba90fef9d83292c843e8161 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artButtonSocialNotificationUp.png — 3893octets ; SHA256 a38f625c96ce972a7852db1de1042a8040ad00df8db550ae3738e8cf59954ff1 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artLaunchFrame.png — 8116octets ; SHA256 1747ebb025a95f4bdcf6ea5c8d37acb10f7715dfddd7517e3e62b301d86938fc ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artLaunchFrameSmall.png — 6476octets ; SHA256 dfb02b53f51ab3dce68efb4e797b39346f21d9ddc03e92df17e2f7cbf6d6ce35 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artLineSeparator.png — 1107octets ; SHA256 24cd49df159fc71c12f4d9d9642abb938b74e6aa64d6a14aacbea6474477f149 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artMainNavFrame.png — 86853octets ; SHA256 d2352f9795a1745d6d2650bb1924e383b5e9bd0a076d35ad27e6547dad08ac79 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artMainNavFrameSmall.png — 57757octets ; SHA256 6eb715d01868dfe54901246894217202ab245b9a6367ae1332ffa227e8daa2be ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artPatchBarBusy.png — 7576octets ; SHA256 b856bf568597660759fdf09446461900062e260b17d87a16be2c196b70976536 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artPatchBarLine.png — 416octets ; SHA256 0914a981323fdf1e7947d773371af834882de018652b6b731cf5108448e65064 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artPatchBarLineSmall.png — 3061octets ; SHA256 15de106c20c61315e869b0b1b70fc9101f28f0a1d21748856f56ad26f96eaef4 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artRegionalArrow.png — 608octets ; SHA256 599c35a391d46eedb74fb7c4dc02e63556d1b599c4115bfe974ab47ac4600b4c ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/artSettingsSeparator.png — 1712octets ; SHA256 b4abb5dfe5deada5b38fdcbe6ac2bae4717def6fd09bec6f214a9fb04c680fec ; références littérales 5 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse.gif — 12022octets ; SHA256 bfd6e51d73e644f8e72815c6fd124ca8e008465bf9904145ebbbc90b44e4e610 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00000.png — 2695octets ; SHA256 2034896ab7671eba469b5015cc82c3f2ea18d9142f1e64df2f307e38fea20765 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00001.png — 2703octets ; SHA256 4fc98cb1e9cf6eba73f4ef96ed9b8124d2558761d30671d4241072e351560c59 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00002.png — 2765octets ; SHA256 de1807bfba26cbcee5d450c9daab693a772652ceaa8ba2244a35cfe475867d14 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00003.png — 2757octets ; SHA256 901054cd79d6a4b34264952ff64df6d9cbcb07d3bffcbbcc76314ae75c571e2f ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00004.png — 2778octets ; SHA256 206254e3f96aaabd3dd449bbbeae87d3365fb9515159ac0b082be3057d9714e7 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00005.png — 2786octets ; SHA256 93323be06c583a4fb959d46b9f1f0a9c9d8299514e40e40212a02febe97bad72 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00006.png — 2772octets ; SHA256 bf92eed5727c37e4d932d911393288e399cdae6d2b6da0d7fb2e6d306779a6fc ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00007.png — 2789octets ; SHA256 7d1fafa1b04b1aea23c23993b882f59ae259b9523e5fd9f3c2646833975bd580 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00008.png — 2786octets ; SHA256 435be5864c3b8b00d36f8c11783f9667eb72d06d877e8dda9d5a5d0883572724 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00009.png — 2799octets ; SHA256 9c8047ee4bc5505070b5bfad35fcd6d3263a17609037c58fce71ca3033079819 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00010.png — 2795octets ; SHA256 d56fdb0e7f8e0f5eabe955a3ae2dc790c0c946c41ccc5d305572afbf44fa6394 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00011.png — 2803octets ; SHA256 07a33a48f2ab198e9d80edaffd65ba5af4c66385eb22fd0a5308bac865b2473b ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00012.png — 2833octets ; SHA256 da6179eb88fff2c517ebe1a56c492c708cf3342862a8bfa97c9f5bdfe6952eac ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00013.png — 2811octets ; SHA256 788623067f11e7edbe1e34fc745c274b335686a5ed51e89fcb518782f0001401 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00014.png — 2814octets ; SHA256 432969dc9ea41956bc05939561278195b300c680294f8d30077e95f4d4481353 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00015.png — 2798octets ; SHA256 5f9b32a5ea1c9f6350e4272c6dde94b60ee017d48a90e0ebe648ba90aaf8ec4a ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00016.png — 2818octets ; SHA256 5f13268dc113400000ef5b452d291a1b1ec18d2a60199edc677b025c4ded1e2f ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00017.png — 2818octets ; SHA256 04e97265d77bb28d45c1ef1c8fb00cc40d41aaf9cc6274617b1ce4fbc856f820 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00018.png — 2796octets ; SHA256 fb87c44431264d9afc7f93787a078d37c99e8c60f5bd39963a15a1f9ce65900d ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00019.png — 2803octets ; SHA256 3bb1f034584dbd9f4ccf589987927a5dad3b6946ba11a2af59cfca294daa707e ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00020.png — 2795octets ; SHA256 fa66897c73180727bb22464a023939bb913db5433dc539e1a53669cbaed97faf ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00021.png — 2783octets ; SHA256 2013c4f8080fc95f0a9683414894780f8bb33a472858bc1694e190488c9ff10f ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00022.png — 2789octets ; SHA256 7d1fafa1b04b1aea23c23993b882f59ae259b9523e5fd9f3c2646833975bd580 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00023.png — 2796octets ; SHA256 7a2784580ad4b06bff52a61897a8478eba50b66b3cf77d1b9b7f18e647dc3a06 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00024.png — 2776octets ; SHA256 118e6b69febae12263e9d6e7f800bfc0b3f91b79c6c0995800bbf689a5ae06ce ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00025.png — 2783octets ; SHA256 45716cb0c87a8bfe1fcd466204591c138cc91b1db8245e4b910ec2a5f2663bd6 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00026.png — 2775octets ; SHA256 d979db0bf2788374d1e1ca00287cd0a2921eeb8f81fd603dc517380965626a26 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00027.png — 2751octets ; SHA256 f7fe7aa82e9f998f54ff200bfc27fa62de540ed36c00299b22a59e8dfa4ec393 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00028.png — 2758octets ; SHA256 e13caac9aed32d1f357bae0382454ad6a04f5cfc6651c4ae2375cbed41a3bf2e ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00029.png — 2703octets ; SHA256 1e05f9e961180f62dbe9cda67dd44f84e4e7a572e9948ddf14c6f4fa02918bc7 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bar_pulse/bar_pulse_00030.png — 2695octets ; SHA256 2034896ab7671eba469b5015cc82c3f2ea18d9142f1e64df2f307e38fea20765 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bgChromeMain.png — 9125octets ; SHA256 371367575d7e30af5e079b34b6e9784a78c5d7e4d99f1a71badb3fe78e6f0952 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/bgOptionsMenu.jpg — 24670octets ; SHA256 ac726ab07ede2027fa2b51cf5a0504c70aad383b5fdbef6edb44e3e13925bf8d ; références littérales 5 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/btnControlsUp.png — 1422octets ; SHA256 863b148d85e7df4732233266790c5c9b9c153f8ddaaeb606afe8b85fa90bbfbf ; références littérales 6 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/iconCloseUp.png — 2099octets ; SHA256 11d8d43737e6bc629b02886fb1d23bcca2b938b9a91abd8cdc564e94bb5c1cf5 ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/iconMinUp.png — 1193octets ; SHA256 02a3b346c9ade0e034f5e59f2c5e9751719e84468e1ed6d21a22e568f515bf3e ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/iconSettingsOver.png — 2745octets ; SHA256 6b473cb6d608f74f986484b686a079dcfb70dfa3e4908beea43584ad414c3240 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/iconSettingsUp.png — 1921octets ; SHA256 ef2239d605b06c6a5483c702fca1d51e4d61da9adfff2c9d1b7a1b189f7ad516 ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/iconVolumeControl.png — 941octets ; SHA256 48cabc7db453da42f03339802bdcead690f76bd00138eb444caebae4e37e1da5 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/iconVolumeControl_full.png — 1224octets ; SHA256 00e4389105e37ba2b12cb06a2daf34b19930012fb980b90ac3221fe4374b1768 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/iconVolumeControl_low.png — 907octets ; SHA256 ce4509a73e03202128d8e7df9374e13cc75d3e7bda727d0a3782f1457a068fd0 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/iconVolumeControl_mid.png — 1068octets ; SHA256 804467b6152ab8a53c9cf9e962464c0045af9853364676696c66d1ea30c81459 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/iconVolumeControl_mute.png — 626octets ; SHA256 fd86e50088275e67b4de1fb01effc05ba369eb8562e95c8e95302a5f7c6d963e ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/iconVolumeControl_muted.png — 1050octets ; SHA256 d94476f557345931de6a3c2348fdf479d8f38739908d961f8ccf9c8af98c9212 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/initialPopupBg.png — 6081octets ; SHA256 4c47727c2e13ed2d8c6c60be1fd79a137b355618cf07ad9520e64dfb8d08c809 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/initialPopupButton.png — 9338octets ; SHA256 8a51bebfb2229bad6f192b9ef38cfa11c888642f46d78bba5fbd5ad867a91f7f ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/initialPopupFg.png — 132556octets ; SHA256 5671427d74b212986624b54d10c7989a4990ca8c07ba6bb77ed5e78a2154b9aa ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/initialPopupFrameBottom.png — 138851octets ; SHA256 722850abdc23aa7333843b69c3a25cb361d150714a46cb502e787a3ef1e1aec7 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/initialPopupFrameTop.png — 2806octets ; SHA256 f2fd0a42a4fb1567eacc45d507d1ea22d750af8a7b8c4b7c03553844ae10344a ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/initialPopupSeparator.png — 2936octets ; SHA256 d3351865f4db0aa31b3412111635916ae827a13dc0076b876af527d07614ad99 ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/initialPopupSplash.png — 346825octets ; SHA256 8c3180bd7f5747b242f5fb7c5fd99ff0ad40259b4905b4f8be9e3ebdd019a529 ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/initialPopupWings.png — 36720octets ; SHA256 311409d69134988f1b8047d40dc6dd42cad6882c17fe60422e0b02ff8f3a1073 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/loader_bg_loop.gif — 286112octets ; SHA256 dff8e0942396a8ab8ea1a3a23e556002c08eb08b595526ce49fc0c16cc7ac2c6 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/loader_bg_loop_small.gif — 518009octets ; SHA256 432c8f0b67a6d8604ee19afb8b379c331919e269ccecbd455d980626d2e68396 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/logoLeagueOfLegends.png — 19325octets ; SHA256 7ea586d8a0fc4b52373c2f4aed7dc814c87d518c95e79092d413856bfaedc314 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/logoRiotGames.png — 5996octets ; SHA256 0fcea8012e185f03f4bae3d021786ec21b4fcd1c58d3601da0286ead6a5ea194 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/maskPatchBar.png — 530octets ; SHA256 93af2c94d520fd0799975dd6417e45a18237cc838ef5ed989821b6089e00796a ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/maskPatchBarGlow.png — 1247octets ; SHA256 35cdfdda4016629102220e5a981bf05f715480c4a8f35b46a37bf9a6e056db70 ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/maskPatchBarSmall.png — 424octets ; SHA256 391c6239a782731e44659407f344f7a2d273b197e970088147e80d18f3c641e1 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/settingsPopupBG.png — 55781octets ; SHA256 6e3a78fc82efc2ea0bc3056490693d59aab294d80915c390f0e68ed306842829 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/ticker_message/artAlertBlueOver.png — 3552octets ; SHA256 97bb90173631e8c9869109abfa2ec18d9582142576927fa2fe52e95dc1161e84 ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/ticker_message/artAlertBlueUp.png — 3524octets ; SHA256 f807c4a73c8361eece55a3ae3483de429fbc57fd8ac9151e25427f6db9ad310a ; références littérales 4 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/ticker_message/artAlertIconOver.png — 1227octets ; SHA256 fadd5454299cbb43ec536e68e38cd6e43eb461eb54465d91be4b0e8310e2c568 ; références littérales 4 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/ticker_message/artAlertIconUp.png — 1226octets ; SHA256 003f3a94eeb613c11b03022b6a4e58ef6f65e764f627191ba5795aa0609d5299 ; références littérales 8 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/ticker_message/artAlertMessage.png — 1237octets ; SHA256 bdbfb0cc5194c81cdc6999358d2913fe0631e2f4b50d25a99cd36102c1bf6d13 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/ticker_message/artAlertRedOver.png — 3480octets ; SHA256 58d9dea9f308b222d8ea87caac723d1bcb4c2245da37f9830ecc21d42344fbf5 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/ticker_message/artAlertRedUp.png — 3330octets ; SHA256 1aaab312abbe138a3ebdb325b890fa6441d2e9a29183e9801ed1f894c3d7037e ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/ticker_message/artAlertYellowOver.png — 3813octets ; SHA256 7a462c4836bb2ab9be35a72748ddff272b2d486047f0791e41dd738d6fd41ae5 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/ticker_message/artAlertYellowUp.png — 3737octets ; SHA256 6fd90dd95ebc3fa7f40d86d97b97e9bb8c00bf5eab06ff10c6dd2eb39a87abc6 ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/ticker_message/art_ticker_divider.png — 131octets ; SHA256 b661d4e45beeb18badc32f69474f8a21ce9f618d1e59b6c365e64e94fb825926 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/ticker_message/btnTickerCollapseUp.png — 653octets ; SHA256 8ed838a0cacab9f8812f12cd95d1274b9979f75e550ddfaf74dcfc907ade9731 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/ticker_message/btnTickerExpandUp.png — 683octets ; SHA256 8d0a86ce43d8d9317210fb7537bdfedac3eb0fcff72f9a5a6788c2fb40b428f7 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-chrome/src/images/ticker_message/icon_min_arrow.png — 1545octets ; SHA256 0a8f0ce2e11492edfaec2cfaa1732af99e13185ff37b288160b6aeed5287502b ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-chrome.load.
- bundle-client-hub/images/ArticleBanner_DevDiary_ChampionVI.jpg — 59640octets ; SHA256 b91f6ebb9322281a7480f2e1a981bc8d097f377f98586be7575d218b7a5a2360 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-client-hub.load.
- bundle-client-hub/images/Article_Banner_Patcher_VU.jpg — 168918octets ; SHA256 c4348d9e69fcc186b79c24878d2bde239255eb74f4c230ba548ecd416f09a89d ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-client-hub.load.
- bundle-client-hub/images/banner_PatchNotesBG.png — 53378octets ; SHA256 9d35f77432398a507ad95328ac9737137d3c31ac0fe6d666a8b33e8ba137d24d ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-client-hub.load.
- bundle-client-hub/images/bg_green_magic.png — 221011octets ; SHA256 ac6ae68ce82fce4800644f5d3f761c0d51910a42a8be2dfa2b986b62af59df71 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-client-hub.load.
- bundle-client-hub/images/btn_close.png — 1214octets ; SHA256 857e2b01c35abcd47a235a11b42b59a4969c12596b3c2c2bf8e002e157730181 ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-client-hub.load.
- bundle-client-hub/images/hh_pvp.jpg — 137825octets ; SHA256 b84319679b432c861ab15ef702d79a76040999ae4f4f72ab9310df46c5624e50 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-client-hub.load.
- bundle-client-hub/images/hub_bg_01.png — 231879octets ; SHA256 9e01fc28521e62bd2ebb727f8bfec08a4cea976dd018c5b4ca147865b048c296 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-client-hub.load.
- bundle-hub-free-champion-rotation/public/images/artStatsBackground.png — 3019octets ; SHA256 bebb7ba569a972026976c74f8578d43abf8531646ad10fc5e9c30c84e7c00ee1 ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-hub-free-champion-rotation.load.
- bundle-hub-free-champion-rotation/public/images/bg_green_magic.png — 221011octets ; SHA256 ac6ae68ce82fce4800644f5d3f761c0d51910a42a8be2dfa2b986b62af59df71 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-hub-free-champion-rotation.load.
- bundle-hub-free-champion-rotation/public/images/championRotationBg.png — 45261octets ; SHA256 61a5eb2876e56059a286afe83e80bab1e1c716e4e3d1e08e2933df239a74b67a ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-hub-free-champion-rotation.load.
- bundle-hub-free-champion-rotation/public/images/mask_block.png — 936octets ; SHA256 24a71fce2e97f2552b5a96fb9da839d0a7e9f9ededc71f52467362b9cc27d76f ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-hub-free-champion-rotation.load.
- bundle-hub-free-champion-rotation/public/images/overlay_champions.png — 5244octets ; SHA256 7f5164429bc3c68c6544f87d022629bcddcd73393ad5fa86cc3a3b35b51faebc ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-hub-free-champion-rotation.load.
- bundle-hub-news-C/public/images/btn_close.png — 1214octets ; SHA256 857e2b01c35abcd47a235a11b42b59a4969c12596b3c2c2bf8e002e157730181 ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-hub-news-C.load.
- bundle-hub-news-C/public/json/frame-center.png — 1184octets ; SHA256 e25b9256a5f6831aef9b1654996cba85409a9f1271d4bf019dcd7a4354f87418 ; références littérales 3 ; source Content/Loadable/RiotClient/Release/bundle-hub-news-C.load.
- bundle-hub-patch-notes/public/images/bg_green_magic.png — 221011octets ; SHA256 ac6ae68ce82fce4800644f5d3f761c0d51910a42a8be2dfa2b986b62af59df71 ; références littérales 0 ; source Content/Loadable/RiotClient/Release/bundle-hub-patch-notes.load.
- bundle-hub-patch-notes/public/images/btn_close.png — 1214octets ; SHA256 857e2b01c35abcd47a235a11b42b59a4969c12596b3c2c2bf8e002e157730181 ; références littérales 2 ; source Content/Loadable/RiotClient/Release/bundle-hub-patch-notes.load.
- bundle-hub-patch-notes/public/images/button_arrow_down.png — 2680octets ; SHA256 5ad5da2c4f204975020899557c635bf4c5229f8f63961d541dd079bbb4cc42ce ; références littérales 1 ; source Content/Loadable/RiotClient/Release/bundle-hub-patch-notes.load.
- bundle-hub-patch-notes/public/json/frame-center.png — 1184octets ; SHA256 e25b9256a5f6831aef9b1654996cba85409a9f1271d4bf019dcd7a4354f87418 ; références littérales 3 ; source Content/Loadable/RiotClient/Release/bundle-hub-patch-notes.load.

## Emplacements réellement contrôlés
- F:\OpenLeague\launcher\web\assets : 9fichiers image/police, 0candidats de taille, 0copies d’octets identiques.
- F:\OpenLeague\docs\reference_patcher_sources\review : 0fichiers image/police, 0candidats de taille, 0copies d’octets identiques.
- E:\mapslol3v3\output\Launcher_420_Research : 3647fichiers image/police, 14candidats de taille, 0copies d’octets identiques.

Ces résultats ne prouvent pas une absence sur tout le PC ni celle de variantes réencodées. Les85membres avec référence littérale et30sans ne constituent pas une mesure d’usage ou de visibilité publique.

## Cinq conteneurs encore absents / couverture du parent ouverte
- Content/Loadable/RiotClient/Release/bundle-assets.load ; release 0.0.0.11 ; 54448044octets ; MD5 0b9e2bb8b82f9ea32549f666a1c294d8.
- Content/Loadable/RiotClient/Release/bundle-dev.load ; release 0.0.0.11 ; 449240octets ; MD5 d5eec71317fa25d43430f0a0cbdd5e5f.
- Content/Loadable/RiotClient/Release/bundle-hub-news-A.load ; release 0.0.0.11 ; 665232octets ; MD5 b4d1b90a862d2e30820444a8608abf6b.
- Content/Loadable/RiotClient/Release/bundle-hub-news-B.load ; release 0.0.0.11 ; 1380368octets ; MD5 518ff65771d7d6b9dd5e68bd8b6a94e3.
- Content/Loadable/RiotClient/Release/bundle-vendor-lib.load ; release 0.0.0.11 ; 7397172octets ; MD5 cfadc55c2ccf445a38d34abe7be68b6e.

Index local présent : E:\mapslol3v3\output\Launcher_420_Research\RADS.json.zstd ; SHA256 396974662b9ca030c21594a9668a795ab141bc7d14999bf64db97308e1d82b3c. Pas de disponibilité distante vérifiée ni de contenu de ces cinq conteneurs lu ici.

## Manques et reprises

### PATCHER-CONTAINER-MEMBER-COVERAGE
Cinq conteneurs du manifeste exact n’ont pas de payload présent aux chemins contrôlés. Leur population d’images et rôle effectif n’ont pas été examinés ;115images ne sont pas un dénominateur complet du patcher.
Reprise : Contrôler les cinq noms exacts dans l’index local épinglé, puis un payload admissible par release0.0.0.11/taille/MD5 et format LOAD ; qualifier membres/rôles ou source réellement indisponible. Ne pas exclure dev/vendor/news seulement d’après leur nom.

### PATCHER-INDIVIDUAL-COPIES
Aucune copie autonome d’octets identiques aux115images n’a été retrouvée dans les trois racines nommées. Cela ne prouve pas une absence sur tous les disques ni celle d’images réencodées.
Reprise : Notes par membre dans SYS-18.1-02 existante ; extraction contrôlée vers une destination autorisée, sans écrasement, et rattachement de provenance.

### PATCHER-PIXEL-AND-FRAME-VERIFICATION
Dimensions d’en-tête PNG seulement ; pixels, intégrité complète et éventuelles frames GIF non qualifiés. Les trois polices restent distinctes des115images.
Reprise : Décodage réel par format et identité exacts lorsque ce travail est repris ; rapporter dimensions/frames/alpha/résultats et refus, sans relancer le même simple relevé de headers.

### PATCHER-CURRENT-CONSUMER
Les neuf références de fichiers HTML/CSS courantes visent AIR420 et n’égalent aucun payload patcher. Une référence littérale dans85membres ne prouve ni routage actif, ni affichage ou disponibilité publique.
Reprise : Réutiliser tâches18.1.06..08 et écrans/rôles réellement admis ; associer le média au bon consommateur et vérifier le rendu séparément.

## Contrôles et portée
Exécutés : lecture pure manifeste/LOAD, identité de médias/headers, recherche de copies par taille puis SHA dans trois racines, références HTML/CSS, sources du producteur ancien, prérequis/tâche canonique et cohérence des preuves. Les14candidats de taille E n’ont aucun match ; aucun ancien code de sortie n’est fabriqué.
Non exécutés : décodage intégral d’image/frame, extraction/export/téléchargement, jeu/launcher/AIR/Rust/GUI/GPU/OS, services/réseau/REA, anciens tests ou programmes de vérification.

## Sept rubriques et suite
- 1 : Périmètre disponible du lot et objectif complet SYS-18.1-02 séparés.
- 2 : Sept conteneurs et manifeste exact ; cinq sources manquantes sont l’entrée précise de reprise.
- 3 : Consommateurs LOAD et HTML/CSS réels ;115images liées individuellement et recherches d’absence bornées.
- 4 : Identités et sources contrôlées ; limites headers/pixels/frame/ancien code de sortie explicitement conservées.
- 5 : Un vrai manque de couverture empêche la clôture du parent ; réalisation et rendu restent des dimensions différentes.
- 6 : 115notes dans la tâche existante, pas de nouvelle tâche produit ni critère ; correction de formulation documentaire sans histoire réécrite.
- 7 : Preuves datées, entrées et lecteur distinct ; goal/Plan/UI/registre/base inchangés.

La provenance disponible et les consommateurs sont examinés ; l’ancien terme décodé est précisé. La population des cinq conteneurs nommés reste une clause d’audit non examinée, pas un simple défaut produit à masquer. Le parent reste ouvert.
La tâche d’extraction SYS-18.1-02 existe ; les115notes détaillent son exécution future sans critère nouveau. Le manque de source et la portée de l’ancien reçu sont documentés séparément, pas convertis en une tâche produit générale.
Prochain lot : AUD-18.1-02-MISSING-CONTAINER-AVAILABILITY-01 — Contrôler disponibilité/provenance des cinq conteneurs nommés dans l’index d’archive local déjà vérifié, puis décider le prochain membre réellement accessible ; aucune nouvelle recherche générale.
Ajouts uniquement : ce rapport et F:\OpenLeague-work\audit-units\AUD-18.1-02-PATCHER-MEDIA-PROVENANCE-01. Aucun goal, critère normatif, produit, UI, suivi, registre ou base modifié.

Le premier producteur documentaire code1 est conservé : ses notes utilisaient le SHA du contenu comme ID, alors que plusieurs chemins distincts partagent les mêmes octets. V2 identifie chaque note par son chemin logique. 115membres image, 108payloads distincts ; aucune suppression ou fusion de ressources et aucun échec produit déduit.