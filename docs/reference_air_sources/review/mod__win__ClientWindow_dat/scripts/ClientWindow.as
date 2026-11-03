package
{
   import blix.action.IAction;
   import blix.assets.proxy.DisplayAdapter;
   import blix.components.tooltip.IToolTipManager;
   import com.riotgames.platform.common.event.LoginEvent;
   import com.riotgames.platform.common.provider.ILoginProvider;
   import com.riotgames.platform.common.provider.IMainProvider;
   import com.riotgames.platform.common.provider.IMicroFeedbackProvider;
   import com.riotgames.platform.common.provider.MainProviderProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.platform.gameclient.events.InventoryEvent;
   import com.riotgames.platform.gameclient.events.RuneBookEvent;
   import com.riotgames.platform.gameclient.init.DeprecatedParentProxy;
   import com.riotgames.platform.gameclient.skin.datagrid.DataGridHeader;
   import com.riotgames.platform.gameclient.skin.datagrid.DataGridHeaderSeparator;
   import com.riotgames.platform.gameclient.skin.textinput.RedBorderSkin;
   import com.riotgames.platform.gameclient.skin.textinput.WhiteBorderSkin;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.metrics.UserFlow;
   import com.riotgames.pvpnet.system.config.LoginConfig;
   import com.riotgames.pvpnet.system.dataload.ClientDataLoad;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import flash.accessibility.*;
   import flash.data.*;
   import flash.debugger.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filesystem.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.html.*;
   import flash.html.script.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.skins.halo.ButtonSkin;
   import mx.skins.halo.HaloBorder;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class ClientWindow extends BaseShell
   {
      
      mx_internal static var _ClientWindow_StylesInit_done:Boolean = false;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueMinimize_up_png_54035824:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueMinimize_down_png_1319644295:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_bluePromote_up_png_1179241548:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueMinimize_over_png_694894823:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_facebook_bullet_png_521728554:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_kudos_report_mouseOver_png_2099983568:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_grey_up_png_1596301166:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_bluePromote_down_png_1909313406:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_grey_up_png_792950050:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_facebook_mainFrame_png_335401618:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueInviteEnable_up_png_91199468:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_facebook_pvp_closeBtnX_down_png_1317583510:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_facebook_pvp_closeBtnX_up_png_1435015148:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_over_png_1847432529:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueOptions_up_png_146983685:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_verticalScrollTrack_png_1964846194:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueEdit_over_png_324543870:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_orange_over_png_1586148332:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_glassChatBorder_png_338034408:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeActive_over_png_914362160:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_button_normal_png_1300113698:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_glassSeeThroughPanel_png_1321496377:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueClose_over_png_4979001:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueHome_up_png_1126336462:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueRadioButton_png_2101912986:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueInviteEnable_over_png_1487636990:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueHome_down_png_116949268:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_over_yellow_png_972066168:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_grey_up_png_454435440:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueForward_over_png_1856522420:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_kudos_report_disabled_png_1560818046:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_giftButton_over_png_1822488220:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_EndOfGame_socialBackground_png_2091497570:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_orange_up_png_153376104:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_disabled_blue_png_942324012:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_grey_up_png_316059783:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_questionnaire_buttonActive_png_1164934942:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_kudos_report_normal_png_777994352:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_up_png_1302752156:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueSort_over_png_75025506:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_eog_thumb_disable_png_228981432:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueClose_over_png_1845352302:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_EndOfGame_barOverlay_png_881787358:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_orange_up_png_1387952046:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_eog_thumb_hover_png_1890889264:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_giftButton_disabled_png_1811952620:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueReload_down_png_339216888:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueClose_down_png_1377063182:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_facebook_friendList_addFacebook_up_png_850364810:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueReload_over_png_1933104164:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_over_png_464204543:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_dockedChatBlendTab_png_1000475630:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_grey_up_png_1807695571:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueClose_up_png_840917884:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_button_hover_png_2030523216:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_playerProfile_stats_bluetab_over_png_1797537676:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_addButton_disabled_png_854593918:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_dockedChatTab_png_436340997:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redReport_down_png_1196873596:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_up_png_1630316287:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_over_png_408912100:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_up_png_1425684334:Class;
      
      private var inventoryEvent:InventoryEvent;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_down_png_1976556920:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_playerProfile_stats_tab1_png_226332508:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_over_png_170236676:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeActive_png_1017137470:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_questionnaire_buttonUp_png_1094145668:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_EndOfGame_graphBackground_png_1921673994:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addChatButton_up_png_1938260990:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redReport_disabled_png_486856912:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addChatButton_over_png_1369150264:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFriendButton_up_png_1692940050:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueEdit_up_png_1351820936:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueBack_over_png_1459683184:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_groupSeperator_png_1851043812:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_scrollTab_png_1542426484:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_verticalScrollThumb_png_1498799506:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_searchFriendButton_up_png_1242593780:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_disabled_yellow_png_2014677352:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_honorButton_over_png_1389318924:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueProfile_up_png_1303257954:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_addButton_up_png_2094875444:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_over_png_1958856570:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueMinimize_up_png_2096450087:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_orange_over_png_125339998:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_defaults_inputTextFieldSkin_png_1981790213:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_down_png_2059095186:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_addButton_over_png_311755666:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueClose_up_png_867218697:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_facebook_fbBG_png_1480804536:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_over_png_1384894514:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueMinimize_over_png_1556551070:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_friendItem_png_200583042:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_up_png_901665048:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_up_png_975416882:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_grey_up_png_260080784:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueCheckbox_png_1686428822:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_down_png_1553120907:Class;
      
      private var runeBookEvent:RuneBookEvent;
      
      private var _embed_css___________ClientAssets_imageEmbeds_facebook_tristFade_png_66724810:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeInactive_over_png_1073116274:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_facebook_pvp_closeBtnX_over_png_2073097910:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_scrollTrack_png_539614468:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redReport_over_png_1062490384:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueClose_down_png_2147173611:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueMinimize_down_png_633836926:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_chat_pvp_chat_icon_search_png_1817436086:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFolderButton_over_png_1977551996:Class;
      
      private var loginModule:IMainScreen;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_grey_up_png_1201506856:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_playerProfile_stats_bluetab_png_272294082:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_eog_thumb_up_png_1856414206:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_over_png_276846951:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_blue_over_png_1820662173:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_defaults_verticalThumbDown_png_2131644465:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_EndOfGame_scoreboardBack_png_1445792034:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueOptions_down_png_513526455:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueProfile_down_png_594146536:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_rewards_beveled_canvas_png_90844987:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redReport_up_png_1142976146:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_orange_up_png_1575779582:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueSort_up_png_2133366416:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeInactive_png_2068143408:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueSort_down_png_960100482:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_defaults_verticalTrack_png_1500363692:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_eog_thumb_down_png_222853836:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_over_png_1990165276:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueProfile_over_png_1364545484:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_EndOfGame_mainPanelOverview_png_1627397366:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueForward_up_png_777477214:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_over_png_75105412:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_up_png_548734898:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFriendButton_over_png_1501160476:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_thinShortButton_grey_up_png_1533575440:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueEdit_down_png_1220216098:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueBack_up_png_1752350174:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_honorButton_disabled_png_1982106532:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_EndOfGame_gridBackground_png_1170079210:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_bluePromote_over_png_1297513314:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_searchFriendButton_over_png_315365890:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_down_png_1520501104:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueCheckboxChecked_png_1453954900:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueInviteEnable_active_png_785485090:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_over_png_417214562:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_down_png_226213880:Class;
      
      private var logger:ILogger;
      
      private var _embed_css___________ClientAssets_imageEmbeds_facebook_friendList_addFacebook_over_png_763622760:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_up_yellow_png_239636706:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_reportButton_disabled_png_1816644908:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_defaults_verticalThumb_png_1925909757:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_reportButton_up_png_2141916846:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueBack_down_png_1996080420:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_up_png_128781458:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_reportButton_over_png_1281016036:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueOptions_over_png_24999845:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_questionnaire_buttonOver_png_288878722:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_over_png_1991982500:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_button_down_png_522022892:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_EndOfGame_EOGScrollTrack_png_973431885:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_EndOfGame_tabUnselected_png_430834958:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_facebook_addFacebookFriends_menuBackground_png_1819003002:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_thinShortButton_blue_over_png_395801876:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_greyAdd_up_png_1008228492:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueHome_over_png_1694156080:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_up_png_1604256082:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_down_png_1457981136:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_EndOfGame_tabSelected_png_806974748:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_blue_up_png_348001883:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_defaults_verticalThumbOver_png_113604593:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_thinShortButton_blue_up_png_828042718:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueForward_down_png_760877616:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_disabled_png_1756501876:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueReload_up_png_687408146:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_parchment_png_211406932:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_up_png_1080871433:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_up_png_701079487:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_defaults_blackBeveledCanvas_png_378850276:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFolderButton_up_png_1835595282:Class;
      
      private var parentProxy:DeprecatedParentProxy;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_orange_over_png_794329564:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_up_png_1124695032:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_up_blue_png_632968946:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_giftButton_up_png_1831168366:Class;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_honorButton_up_png_758944926:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueRadioButtonChecked_png_1781223640:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_facebook_tristFull_png_59629936:Class;
      
      private var _embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_over_blue_png_2066626692:Class;
      
      public function ClientWindow()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({"type":BaseShell});
         this.logger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueCheckboxChecked_png_1453954900 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueCheckboxChecked_png_1453954900;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueCheckbox_png_1686428822 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueCheckbox_png_1686428822;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueRadioButtonChecked_png_1781223640 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueRadioButtonChecked_png_1781223640;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueRadioButton_png_2101912986 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueRadioButton_png_2101912986;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueClose_down_png_2147173611 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueClose_down_png_2147173611;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueClose_over_png_4979001 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueClose_over_png_4979001;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueClose_up_png_867218697 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueClose_up_png_867218697;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueMinimize_down_png_1319644295 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueMinimize_down_png_1319644295;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueMinimize_over_png_694894823 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueMinimize_over_png_694894823;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueMinimize_up_png_2096450087 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueMinimize_up_png_2096450087;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueOptions_down_png_513526455 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueOptions_down_png_513526455;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueOptions_over_png_24999845 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueOptions_over_png_24999845;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueOptions_up_png_146983685 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueOptions_up_png_146983685;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_dockedChatBlendTab_png_1000475630 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_dockedChatBlendTab_png_1000475630;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_dockedChatTab_png_436340997 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_dockedChatTab_png_436340997;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_glassChatBorder_png_338034408 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_glassChatBorder_png_338034408;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_glassSeeThroughPanel_png_1321496377 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_glassSeeThroughPanel_png_1321496377;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_rewards_beveled_canvas_png_90844987 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_rewards_beveled_canvas_png_90844987;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_verticalScrollThumb_png_1498799506 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_verticalScrollThumb_png_1498799506;
         this._embed_css___________ClientAssets_imageEmbeds_CommonComponents_verticalScrollTrack_png_1964846194 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_CommonComponents_verticalScrollTrack_png_1964846194;
         this._embed_css___________ClientAssets_imageEmbeds_EndOfGame_EOGScrollTrack_png_973431885 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_EndOfGame_EOGScrollTrack_png_973431885;
         this._embed_css___________ClientAssets_imageEmbeds_EndOfGame_barOverlay_png_881787358 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_EndOfGame_barOverlay_png_881787358;
         this._embed_css___________ClientAssets_imageEmbeds_EndOfGame_graphBackground_png_1921673994 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_EndOfGame_graphBackground_png_1921673994;
         this._embed_css___________ClientAssets_imageEmbeds_EndOfGame_gridBackground_png_1170079210 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_EndOfGame_gridBackground_png_1170079210;
         this._embed_css___________ClientAssets_imageEmbeds_EndOfGame_mainPanelOverview_png_1627397366 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_EndOfGame_mainPanelOverview_png_1627397366;
         this._embed_css___________ClientAssets_imageEmbeds_EndOfGame_scoreboardBack_png_1445792034 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_EndOfGame_scoreboardBack_png_1445792034;
         this._embed_css___________ClientAssets_imageEmbeds_EndOfGame_socialBackground_png_2091497570 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_EndOfGame_socialBackground_png_2091497570;
         this._embed_css___________ClientAssets_imageEmbeds_EndOfGame_tabSelected_png_806974748 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_EndOfGame_tabSelected_png_806974748;
         this._embed_css___________ClientAssets_imageEmbeds_EndOfGame_tabUnselected_png_430834958 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_EndOfGame_tabUnselected_png_430834958;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_button_down_png_522022892 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_button_down_png_522022892;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_button_hover_png_2030523216 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_button_hover_png_2030523216;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_button_normal_png_1300113698 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_button_normal_png_1300113698;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_eog_thumb_disable_png_228981432 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_eog_thumb_disable_png_228981432;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_eog_thumb_down_png_222853836 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_eog_thumb_down_png_222853836;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_eog_thumb_hover_png_1890889264 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_eog_thumb_hover_png_1890889264;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_eog_thumb_up_png_1856414206 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_eog_thumb_up_png_1856414206;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_kudos_report_disabled_png_1560818046 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_kudos_report_disabled_png_1560818046;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_kudos_report_mouseOver_png_2099983568 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_kudos_report_mouseOver_png_2099983568;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_kudos_report_normal_png_777994352 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_kudos_report_normal_png_777994352;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_down_png_226213880 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_down_png_226213880;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_over_png_170236676 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_over_png_170236676;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_over_png_1991982500 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_over_png_1991982500;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_up_png_128781458 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_up_png_128781458;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_up_png_975416882 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_up_png_975416882;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_grey_up_png_260080784 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_grey_up_png_260080784;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_grey_up_png_454435440 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_grey_up_png_454435440;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_orange_over_png_794329564 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_orange_over_png_794329564;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_orange_up_png_1387952046 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_orange_up_png_1387952046;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_longButton_blue_over_png_1820662173 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_longButton_blue_over_png_1820662173;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_longButton_blue_up_png_348001883 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_longButton_blue_up_png_348001883;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_longButton_grey_up_png_1596301166 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_longButton_grey_up_png_1596301166;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_longButton_grey_up_png_1807695571 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_longButton_grey_up_png_1807695571;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_longButton_orange_over_png_125339998 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_longButton_orange_over_png_125339998;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_longButton_orange_up_png_153376104 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_longButton_orange_up_png_153376104;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_disabled_blue_png_942324012 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_disabled_blue_png_942324012;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_disabled_yellow_png_2014677352 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_disabled_yellow_png_2014677352;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_over_blue_png_2066626692 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_over_blue_png_2066626692;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_over_yellow_png_972066168 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_over_yellow_png_972066168;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_up_blue_png_632968946 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_up_blue_png_632968946;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_up_yellow_png_239636706 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_up_yellow_png_239636706;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_addButton_disabled_png_854593918 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_addButton_disabled_png_854593918;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_addButton_over_png_311755666 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_addButton_over_png_311755666;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_addButton_up_png_2094875444 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_addButton_up_png_2094875444;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_giftButton_disabled_png_1811952620 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_giftButton_disabled_png_1811952620;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_giftButton_over_png_1822488220 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_giftButton_over_png_1822488220;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_giftButton_up_png_1831168366 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_giftButton_up_png_1831168366;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_honorButton_disabled_png_1982106532 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_honorButton_disabled_png_1982106532;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_honorButton_over_png_1389318924 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_honorButton_over_png_1389318924;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_honorButton_up_png_758944926 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_honorButton_up_png_758944926;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_reportButton_disabled_png_1816644908 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_reportButton_disabled_png_1816644908;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_reportButton_over_png_1281016036 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_reportButton_over_png_1281016036;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_reportButton_up_png_2141916846 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_reportButton_up_png_2141916846;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_questionnaire_buttonActive_png_1164934942 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_questionnaire_buttonActive_png_1164934942;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_questionnaire_buttonOver_png_288878722 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_questionnaire_buttonOver_png_288878722;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_questionnaire_buttonUp_png_1094145668 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_questionnaire_buttonUp_png_1094145668;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_down_png_1520501104 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_down_png_1520501104;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_over_png_1958856570 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_over_png_1958856570;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_over_png_408912100 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_over_png_408912100;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_up_png_1124695032 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_up_png_1124695032;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_up_png_1604256082 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_up_png_1604256082;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_grey_up_png_1201506856 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_grey_up_png_1201506856;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_orange_over_png_1586148332 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_orange_over_png_1586148332;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_orange_up_png_1575779582 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_orange_up_png_1575779582;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_disabled_png_1756501876 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_disabled_png_1756501876;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_down_png_1976556920 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_down_png_1976556920;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_over_png_1990165276 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_over_png_1990165276;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_up_png_548734898 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_up_png_548734898;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueBack_down_png_1996080420 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueBack_down_png_1996080420;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueBack_over_png_1459683184 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueBack_over_png_1459683184;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueBack_up_png_1752350174 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueBack_up_png_1752350174;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueClose_down_png_1377063182 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueClose_down_png_1377063182;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueClose_over_png_1845352302 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueClose_over_png_1845352302;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueClose_up_png_840917884 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueClose_up_png_840917884;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueEdit_down_png_1220216098 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueEdit_down_png_1220216098;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueEdit_over_png_324543870 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueEdit_over_png_324543870;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueEdit_up_png_1351820936 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueEdit_up_png_1351820936;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueForward_down_png_760877616 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueForward_down_png_760877616;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueForward_over_png_1856522420 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueForward_over_png_1856522420;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueForward_up_png_777477214 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueForward_up_png_777477214;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueHome_down_png_116949268 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueHome_down_png_116949268;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueHome_over_png_1694156080 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueHome_over_png_1694156080;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueHome_up_png_1126336462 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueHome_up_png_1126336462;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueInviteEnable_active_png_785485090 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueInviteEnable_active_png_785485090;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueInviteEnable_over_png_1487636990 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueInviteEnable_over_png_1487636990;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueInviteEnable_up_png_91199468 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueInviteEnable_up_png_91199468;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueMinimize_down_png_633836926 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueMinimize_down_png_633836926;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueMinimize_over_png_1556551070 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueMinimize_over_png_1556551070;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueMinimize_up_png_54035824 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueMinimize_up_png_54035824;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueProfile_down_png_594146536 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueProfile_down_png_594146536;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueProfile_over_png_1364545484 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueProfile_over_png_1364545484;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueProfile_up_png_1303257954 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueProfile_up_png_1303257954;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_bluePromote_down_png_1909313406 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_bluePromote_down_png_1909313406;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_bluePromote_over_png_1297513314 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_bluePromote_over_png_1297513314;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_bluePromote_up_png_1179241548 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_bluePromote_up_png_1179241548;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueReload_down_png_339216888 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueReload_down_png_339216888;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueReload_over_png_1933104164 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueReload_over_png_1933104164;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueReload_up_png_687408146 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueReload_up_png_687408146;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueSort_down_png_960100482 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueSort_down_png_960100482;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueSort_over_png_75025506 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueSort_over_png_75025506;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueSort_up_png_2133366416 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueSort_up_png_2133366416;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_down_png_2059095186 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_down_png_2059095186;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_over_png_417214562 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_over_png_417214562;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_over_png_464204543 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_over_png_464204543;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_up_png_1302752156 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_up_png_1302752156;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_up_png_1630316287 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_up_png_1630316287;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_greyAdd_up_png_1008228492 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_greyAdd_up_png_1008228492;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_grey_up_png_316059783 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_grey_up_png_316059783;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_grey_up_png_792950050 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_grey_up_png_792950050;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_over_png_1384894514 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_over_png_1384894514;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_over_png_1847432529 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_over_png_1847432529;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_up_png_701079487 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_up_png_701079487;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_up_png_901665048 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_up_png_901665048;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_parchment_png_211406932 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_parchment_png_211406932;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_down_png_1457981136 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_down_png_1457981136;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_down_png_1553120907 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_down_png_1553120907;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_over_png_276846951 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_over_png_276846951;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_over_png_75105412 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_over_png_75105412;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_up_png_1080871433 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_up_png_1080871433;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_up_png_1425684334 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_up_png_1425684334;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redReport_disabled_png_486856912 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redReport_disabled_png_486856912;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redReport_down_png_1196873596 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redReport_down_png_1196873596;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redReport_over_png_1062490384 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redReport_over_png_1062490384;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redReport_up_png_1142976146 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redReport_up_png_1142976146;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_thinShortButton_blue_over_png_395801876 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_thinShortButton_blue_over_png_395801876;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_thinShortButton_blue_up_png_828042718 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_thinShortButton_blue_up_png_828042718;
         this._embed_css___________ClientAssets_imageEmbeds_buttons_thinShortButton_grey_up_png_1533575440 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_buttons_thinShortButton_grey_up_png_1533575440;
         this._embed_css___________ClientAssets_imageEmbeds_chat_pvp_chat_icon_search_png_1817436086 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_chat_pvp_chat_icon_search_png_1817436086;
         this._embed_css___________ClientAssets_imageEmbeds_defaults_blackBeveledCanvas_png_378850276 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_defaults_blackBeveledCanvas_png_378850276;
         this._embed_css___________ClientAssets_imageEmbeds_defaults_inputTextFieldSkin_png_1981790213 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_defaults_inputTextFieldSkin_png_1981790213;
         this._embed_css___________ClientAssets_imageEmbeds_defaults_verticalThumbDown_png_2131644465 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_defaults_verticalThumbDown_png_2131644465;
         this._embed_css___________ClientAssets_imageEmbeds_defaults_verticalThumbOver_png_113604593 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_defaults_verticalThumbOver_png_113604593;
         this._embed_css___________ClientAssets_imageEmbeds_defaults_verticalThumb_png_1925909757 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_defaults_verticalThumb_png_1925909757;
         this._embed_css___________ClientAssets_imageEmbeds_defaults_verticalTrack_png_1500363692 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_defaults_verticalTrack_png_1500363692;
         this._embed_css___________ClientAssets_imageEmbeds_facebook_addFacebookFriends_menuBackground_png_1819003002 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_facebook_addFacebookFriends_menuBackground_png_1819003002;
         this._embed_css___________ClientAssets_imageEmbeds_facebook_bullet_png_521728554 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_facebook_bullet_png_521728554;
         this._embed_css___________ClientAssets_imageEmbeds_facebook_fbBG_png_1480804536 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_facebook_fbBG_png_1480804536;
         this._embed_css___________ClientAssets_imageEmbeds_facebook_friendList_addFacebook_over_png_763622760 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_facebook_friendList_addFacebook_over_png_763622760;
         this._embed_css___________ClientAssets_imageEmbeds_facebook_friendList_addFacebook_up_png_850364810 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_facebook_friendList_addFacebook_up_png_850364810;
         this._embed_css___________ClientAssets_imageEmbeds_facebook_mainFrame_png_335401618 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_facebook_mainFrame_png_335401618;
         this._embed_css___________ClientAssets_imageEmbeds_facebook_pvp_closeBtnX_down_png_1317583510 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_facebook_pvp_closeBtnX_down_png_1317583510;
         this._embed_css___________ClientAssets_imageEmbeds_facebook_pvp_closeBtnX_over_png_2073097910 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_facebook_pvp_closeBtnX_over_png_2073097910;
         this._embed_css___________ClientAssets_imageEmbeds_facebook_pvp_closeBtnX_up_png_1435015148 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_facebook_pvp_closeBtnX_up_png_1435015148;
         this._embed_css___________ClientAssets_imageEmbeds_facebook_tristFade_png_66724810 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_facebook_tristFade_png_66724810;
         this._embed_css___________ClientAssets_imageEmbeds_facebook_tristFull_png_59629936 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_facebook_tristFull_png_59629936;
         this._embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addChatButton_over_png_1369150264 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addChatButton_over_png_1369150264;
         this._embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addChatButton_up_png_1938260990 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addChatButton_up_png_1938260990;
         this._embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFolderButton_over_png_1977551996 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFolderButton_over_png_1977551996;
         this._embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFolderButton_up_png_1835595282 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFolderButton_up_png_1835595282;
         this._embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFriendButton_over_png_1501160476 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFriendButton_over_png_1501160476;
         this._embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFriendButton_up_png_1692940050 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFriendButton_up_png_1692940050;
         this._embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_friendItem_png_200583042 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_friendItem_png_200583042;
         this._embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_groupSeperator_png_1851043812 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_groupSeperator_png_1851043812;
         this._embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_scrollTab_png_1542426484 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_scrollTab_png_1542426484;
         this._embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_scrollTrack_png_539614468 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_scrollTrack_png_539614468;
         this._embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_searchFriendButton_over_png_315365890 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_searchFriendButton_over_png_315365890;
         this._embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_searchFriendButton_up_png_1242593780 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_searchFriendButton_up_png_1242593780;
         this._embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeActive_over_png_914362160 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeActive_over_png_914362160;
         this._embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeActive_png_1017137470 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeActive_png_1017137470;
         this._embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeInactive_over_png_1073116274 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeInactive_over_png_1073116274;
         this._embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeInactive_png_2068143408 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeInactive_png_2068143408;
         this._embed_css___________ClientAssets_imageEmbeds_playerProfile_stats_bluetab_over_png_1797537676 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_playerProfile_stats_bluetab_over_png_1797537676;
         this._embed_css___________ClientAssets_imageEmbeds_playerProfile_stats_bluetab_png_272294082 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_playerProfile_stats_bluetab_png_272294082;
         this._embed_css___________ClientAssets_imageEmbeds_playerProfile_stats_tab1_png_226332508 = ClientWindow__embed_css___________ClientAssets_imageEmbeds_playerProfile_stats_tab1_png_226332508;
         super();
         mx_internal::_document = this;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.showFlexChrome = false;
            this.cornerRadius = 10;
            this.borderStyle = "none";
         };
         mx_internal::_ClientWindow_StylesInit();
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.addEventListener("displayStateChanging",this.___ClientWindow_BaseShell1_displayStateChanging);
      }
      
      private function onDataLoadOperationsComplete() : void
      {
         this.mainBox.removeAllChildren();
         var _loc1_:IMainProvider = MainProviderProxy.instance;
         _loc1_.showMainView(this.mainBox,this.handleMainViewReady);
         setMainReady();
         this.loginModule.hide();
         UserFlow.track("session","successful_login");
      }
      
      private function onMainLoaded(param1:IMainProvider) : void
      {
         ProviderLookup.getProvider(IMicroFeedbackProvider,this.onMicroFeedbackProvider);
      }
      
      private function loadLoginModule() : void
      {
         if(frameParent != null)
         {
            frameParent.visible = frameParent.includeInLayout = true;
         }
         ProviderLookup.getProvider(ILoginProvider,function(param1:ILoginProvider):void
         {
            var displayAdapter:DisplayAdapter;
            var wrapper:UIComponent = null;
            var loginProvider:ILoginProvider = param1;
            loginModule = loginProvider.createLoginModule(parentProxy);
            loginModule.show();
            displayAdapter = null;
            if(loginModule is IUIComponent)
            {
               displayAdapter = new DisplayAdapter(parentProxy);
            }
            else
            {
               wrapper = new UIComponent();
               wrapper.tabEnabled = false;
               wrapper.tabChildren = true;
               wrapper.focusEnabled = false;
               wrapper.addEventListener(Event.REMOVED,function(param1:Event):void
               {
                  param1.stopImmediatePropagation();
                  param1.stopPropagation();
               },false,1000);
               mainBox.addChild(wrapper);
               displayAdapter = new DisplayAdapter(wrapper);
               LoginConfig.instance.getLoginConfigurationComplete().add(loginCompleteCallShellDispatcher);
            }
            displayAdapter.addChild(loginModule);
         },this.onLoginModuleError);
      }
      
      private function onMicroFeedbackProvider(param1:IMicroFeedbackProvider) : void
      {
         param1.setParentView(this);
      }
      
      mx_internal function _ClientWindow_StylesInit() : void
      {
         var style:CSSStyleDeclaration = null;
         var effects:Array = null;
         if(mx_internal::_ClientWindow_StylesInit_done)
         {
            return;
         }
         mx_internal::_ClientWindow_StylesInit_done = true;
         style = StyleManager.getStyleDeclaration(".summonerStatsTextSmall");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerStatsTextSmall",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 11;
            };
         }
         style = StyleManager.getStyleDeclaration(".correctLargeButtonBlue");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".correctLargeButtonBlue",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_up_png_975416882;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_down_png_226213880;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_over_png_1991982500;
               this.color = 15658734;
               this.focusAlpha = 0;
               this.textRollOverColor = 16777215;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_grey_up_png_454435440;
               this.fontSize = 14;
               this.textSelectedColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".champStatsName");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".champStatsName",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".boostBonusIpGain");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".boostBonusIpGain",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fillColors = [15263783,9342490];
               this.fillAlphas = [1,1];
            };
         }
         style = StyleManager.getStyleDeclaration(".closeButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".closeButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = close_button;
            };
         }
         style = StyleManager.getStyleDeclaration(".runeInventoryBlue");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runeInventoryBlue",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 5025791;
               this.skin = GroupBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseGameTooltipTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseGameTooltipTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15845738;
               this.textRollOverColor = 16777215;
               this.fontSize = 15;
               this.textSelectedColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".tradeText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".tradeText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".championStory");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championStory",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".scoreboardEnemyText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".scoreboardEnemyText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15542302;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".search");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".search",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = SearchButtonSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".toolbarPopinBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".toolbarPopinBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = ToolbarPopinBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".championSelectionTimeLeft");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championSelectionTimeLeft",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15000804;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".endOfGameTreeHeaderLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endOfGameTreeHeaderLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".championTips");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championTips",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".combinerButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".combinerButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = CombineButtonSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".stepDisabled");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".stepDisabled",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 11184810;
            };
         }
         style = StyleManager.getStyleDeclaration(".ribbonFormLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ribbonFormLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13343830;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".profileDataGridStats");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileDataGridStats",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 11250603;
               this.backgroundColor = 0;
               this.rollOverColor = 274764;
               this.headerStyleName = "dataGridHeader";
               this.headerHeight = 23;
               this.textRollOverColor = 13487565;
               this.fontSize = 13;
               this.selectionColor = 274764;
               this.backgroundAlpha = 0;
               this.color = 0;
               this.alternatingItemColors = null;
               this.verticalSeparatorSkin = DataGridHeaderSeparatorSkin;
               this.borderSkin = null;
               this.borderThickness = 1;
               this.headerBackgroundSkin = DataListHeader;
               this.headerSeparatorSkin = DataGridHeaderSeparatorSkin;
               this.fontFamily = "ApplicationFont2";
               this.textSelectedColor = 13487565;
            };
         }
         style = StyleManager.getStyleDeclaration(".parchment");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".parchment",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.shadowColor = 15260600;
               this.strokeColor = 12102270;
               this.strokeWidth = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".rerollBarMaxLevel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".rerollBarMaxLevel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 0;
               this.fillColors = [1900582,0];
               this.fillAlphas = [1,1];
               this.borderAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".s1FormCheckbox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".s1FormCheckbox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.focusAlpha = 0;
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".wide");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".wide",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.thumbDownSkin = _embed_css___________ClientAssets_imageEmbeds_defaults_verticalThumbDown_png_2131644465;
               this.thumbOffset = 0;
               this.thumbOverSkin = _embed_css___________ClientAssets_imageEmbeds_defaults_verticalThumbOver_png_113604593;
               this.downArrowSkin = VScrollBarDownArrowSkin;
               this.trackSkin = _embed_css___________ClientAssets_imageEmbeds_defaults_verticalTrack_png_1500363692;
               this.thumbUpSkin = _embed_css___________ClientAssets_imageEmbeds_defaults_verticalThumb_png_1925909757;
               this.upArrowSkin = VScrollBarUpArrowSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".rssFeedEntryContent");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".rssFeedEntryContent",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 12303291;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".championSelectProgressBarText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championSelectProgressBarText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".optionsTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".optionsTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 13343830;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 24;
            };
         }
         style = StyleManager.getStyleDeclaration(".itemLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".itemLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13343830;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 11;
            };
         }
         style = StyleManager.getStyleDeclaration(".tabNewMessage");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".tabNewMessage",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.borderColor = 1710618;
               this.backgroundColor = 1710618;
               this.color = 11184810;
               this.cornerRadius = 0;
               this.textRollOverColor = 15658734;
               this.fontFamily = "ApplicationFont1";
               this.fillColors = [0,52479];
               this.fontSize = 13;
               this.fillAlphas = [1,1];
               this.themeColor = 1710618;
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseSoloGameButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseSoloGameButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 29;
               this.textSelectedColor = 16777215;
               this.skin = big_game_button_normal;
            };
         }
         style = StyleManager.getStyleDeclaration(".summoner");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summoner",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 16;
               this.textSelectedColor = 16777215;
               this.skin = SummonerButtonSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".profileTabBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileTabBar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.selectedButtonTextStyleName = "profileTabBarSelectedTab";
               this.buttonStyleName = "profileTabBarTab";
            };
         }
         style = StyleManager.getStyleDeclaration(".profileToggleButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileToggleButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_button_normal_png_1300113698;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_button_down_png_522022892;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_button_hover_png_2030523216;
               this.color = 2762265;
               this.textRollOverColor = 2762265;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_button_normal_png_1300113698;
               this.textSelectedColor = 6684672;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_button_down_png_522022892;
            };
         }
         style = StyleManager.getStyleDeclaration(".runeTierCheckBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runeTierCheckBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.fontSize = 10;
            };
         }
         style = StyleManager.getStyleDeclaration(".spellSelectionText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".spellSelectionText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".eogDataGridStats");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".eogDataGridStats",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 16777215;
               this.backgroundColor = 16711680;
               this.rollOverColor = 274764;
               this.headerStyleName = "dataGridHeader";
               this.textRollOverColor = 13487565;
               this.headerHeight = 20;
               this.fontSize = 13;
               this.selectionColor = 274764;
               this.backgroundAlpha = 0;
               this.color = 16777215;
               this.verticalSeparatorSkin = DataGridHeaderSeparatorSkin;
               this.alternatingItemColors = null;
               this.borderSkin = null;
               this.borderThickness = 1;
               this.headerBackgroundSkin = DataListHeader;
               this.headerSeparatorSkin = DataGridHeaderSeparatorSkin;
               this.fontFamily = "ApplicationFont2";
               this.textSelectedColor = 13487565;
            };
         }
         style = StyleManager.getStyleDeclaration(".summonerWizardTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerWizardTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 13343830;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 20;
            };
         }
         style = StyleManager.getStyleDeclaration(".popupMessageHRule");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".popupMessageHRule",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.shadowColor = 3948621;
               this.strokeColor = 0;
               this.strokeWidth = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".runePageTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runePageTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 6684672;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatTransparentBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatTransparentBackground",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fillColors = [3355443,0];
               this.fillAlphas = [0.5,0.5];
            };
         }
         style = StyleManager.getStyleDeclaration(".championStoryPanel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championStoryPanel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.borderStyle = "none";
               this.color = 16777215;
               this.backgroundColor = "0x000000";
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 12;
               this.backgroundAlpha = 0.8;
            };
         }
         style = StyleManager.getStyleDeclaration(".myTabs");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".myTabs",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderColor = 16777215;
               this.textRollOverColor = 16777215;
               this.fillColors = [0,3355443];
               this.fillAlphas = [0.6,1];
               this.themeColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".baseIpGain");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".baseIpGain",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fillColors = [15204391,9306650];
               this.fillAlphas = [1,1];
            };
         }
         style = StyleManager.getStyleDeclaration(".statsHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statsHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 4460817;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 18;
            };
         }
         style = StyleManager.getStyleDeclaration(".firstLoginCanvas");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".firstLoginCanvas",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 7829367;
               this.backgroundColor = 0;
               this.cornerRadius = 3;
               this.borderThickness = 1;
               this.backgroundAlpha = 0.4;
            };
         }
         style = StyleManager.getStyleDeclaration(".newbieTipFooter");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".newbieTipFooter",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 10066329;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 11;
            };
         }
         style = StyleManager.getStyleDeclaration("Tree");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("Tree",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderColor = 0;
               this.color = 16777215;
               this.rollOverColor = 2172715;
               this.textRollOverColor = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.focusThickness = 0;
               this.fontSize = 13;
               this.backgroundAlpha = 0;
               this.paddingRight = 20;
            };
         }
         style = StyleManager.getStyleDeclaration(".teamBTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".teamBTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 15400960;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 20;
            };
         }
         style = StyleManager.getStyleDeclaration(".silverTexturedText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".silverTexturedText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 6974058;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 18;
            };
         }
         style = StyleManager.getStyleDeclaration("AlerterPanel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("AlerterPanel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.modalTransparency = 0.5;
               this.modalTransparencyBlur = 0;
               this.modalTransparencyColor = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".arrowLeftBlue");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".arrowLeftBlue",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = cs_largeSquareButtonBlueArrowLeft;
            };
         }
         style = StyleManager.getStyleDeclaration(".summonerStatsText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerStatsText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatDisplay");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatDisplay",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "none";
               this.verticalScrollBarStyleName = "chatScroll";
               this.color = 16777215;
               this.backgroundColor = 0;
               this.fontFamily = "ApplicationFont1";
               this.focusThickness = 0;
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".profileStatsTabBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileStatsTabBar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.selectedButtonTextStyleName = "profileStatsTabBarSelectedTab";
               this.buttonStyleName = "profileStatsTabBarTab";
               this.buttonWidth = 117;
               this.buttonHeight = 32;
            };
         }
         style = StyleManager.getStyleDeclaration(".whiteChatBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".whiteChatBackground",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fillColors = [16777215,12303291];
               this.fillAlphas = [1,1];
            };
         }
         style = StyleManager.getStyleDeclaration(".contextAlertTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".contextAlertTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 11004918;
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".friendCount");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".friendCount",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "Bold";
               this.color = 39423;
               this.textAlign = "right";
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 27;
            };
         }
         style = StyleManager.getStyleDeclaration(".eogMainTabSelectedButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".eogMainTabSelectedButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
               this.textSelectedColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".profileStatsTabBarSelectedTab");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileStatsTabBarSelectedTab",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 4460817;
               this.textRollOverColor = 4460817;
               this.fontSize = 14;
               this.textSelectedColor = 4460817;
            };
         }
         style = StyleManager.getStyleDeclaration(".endGameTooltip4");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endGameTooltip4",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15197497;
               this.fontStyle = "italic";
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 11;
            };
         }
         style = StyleManager.getStyleDeclaration(".championSelectionMenuBarLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championSelectionMenuBarLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 16777215;
               this.textAlign = "center";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".endGameTooltip2");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endGameTooltip2",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 11;
            };
         }
         style = StyleManager.getStyleDeclaration(".messageCenterText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".messageCenterText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16250857;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".endGameTooltip3");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endGameTooltip3",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 10066329;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".parchmentCloseButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".parchmentCloseButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_parchment_png_211406932;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_parchment_png_211406932;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_parchment_png_211406932;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_parchment_png_211406932;
            };
         }
         style = StyleManager.getStyleDeclaration(".endGameTooltip1");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endGameTooltip1",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".addButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".addButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_up_png_548734898;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_down_png_1976556920;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_over_png_1990165276;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_disabled_png_1756501876;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_up_png_548734898;
            };
         }
         style = StyleManager.getStyleDeclaration(".rssFeedTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".rssFeedTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.letterSpacing = 1;
               this.color = 9210759;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 24;
            };
         }
         style = StyleManager.getStyleDeclaration(".kudosReportButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".kudosReportButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_kudos_report_normal_png_777994352;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_kudos_report_normal_png_777994352;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_kudos_report_mouseOver_png_2099983568;
               this.focusAlpha = 0;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_kudos_report_disabled_png_1560818046;
            };
         }
         style = StyleManager.getStyleDeclaration(".eogCanvas");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".eogCanvas",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 7829367;
               this.backgroundColor = 0;
               this.cornerRadius = 3;
               this.borderThickness = 2;
               this.backgroundAlpha = 0.8;
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseAdvancedTutorialGameButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseAdvancedTutorialGameButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 29;
               this.textSelectedColor = 16777215;
               this.skin = smallGameButton_tutorialBattleTraining;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatPromptHistory");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatPromptHistory",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderColor = 13421772;
               this.verticalScrollBarStyleName = "chatScroll";
               this.color = 16777215;
               this.borderThickness = "2";
               this.fontFamily = "ApplicationFont2";
               this.focusThickness = 0;
               this.fontSize = 10;
            };
         }
         style = StyleManager.getStyleDeclaration(".whiteInput");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".whiteInput",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "none";
               this.color = 0;
               this.backgroundColor = 16777215;
               this.borderSkin = WhiteBorderSkin;
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".spellToolTipDescription");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".spellToolTipDescription",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".profileTabSelected");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileTabSelected",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeActive_over_png_914362160;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeActive_over_png_914362160;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeActive_over_png_914362160;
               this.color = 6684672;
               this.textRollOverColor = 7807522;
               this.fontSize = 20;
               this.textSelectedColor = 6684672;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeActive_png_1017137470;
            };
         }
         style = StyleManager.getStyleDeclaration(".toggleNotificationsBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".toggleNotificationsBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = NOTLargeBarBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".smallSquareButtonBlue");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".smallSquareButtonBlue",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_up_png_1630316287;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_over_png_464204543;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_over_png_464204543;
               this.selectedDownSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_over_png_1847432529;
               this.color = 15658734;
               this.focusAlpha = 0;
               this.selectedUpSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_up_png_701079487;
               this.textRollOverColor = 16777215;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_grey_up_png_316059783;
               this.fontSize = 14;
               this.textSelectedColor = 16777215;
               this.selectedOverSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_over_png_1847432529;
            };
         }
         style = StyleManager.getStyleDeclaration(".toolBarOptionsBtnSmall");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".toolBarOptionsBtnSmall",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueOptions_up_png_146983685;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueOptions_down_png_513526455;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueOptions_over_png_24999845;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueOptions_up_png_146983685;
            };
         }
         style = StyleManager.getStyleDeclaration(".transferOwner");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".transferOwner",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_bluePromote_up_png_1179241548;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_bluePromote_down_png_1909313406;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_bluePromote_over_png_1297513314;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_bluePromote_up_png_1179241548;
            };
         }
         style = StyleManager.getStyleDeclaration(".endOfGameDetailsText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endOfGameDetailsText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".rssSimpleNewsTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".rssSimpleNewsTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 9210759;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookInviteFriendListSent");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookInviteFriendListSent",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".blueBeveled");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".blueBeveled",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.shadowColor = 0;
               this.strokeColor = 22952;
               this.strokeWidth = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".sendChatMessage");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".sendChatMessage",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_blue_up_png_348001883;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_blue_over_png_1820662173;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_blue_over_png_1820662173;
               this.color = 15658734;
               this.focusAlpha = 0;
               this.textRollOverColor = 16777215;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_grey_up_png_1807695571;
               this.fontSize = 14;
               this.textSelectedColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".addGroupBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".addGroupBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFolderButton_up_png_1835595282;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFolderButton_over_png_1977551996;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFolderButton_over_png_1977551996;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFolderButton_up_png_1835595282;
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseNormalGameButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseNormalGameButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 29;
               this.textSelectedColor = 16777215;
               this.skin = big_game_button_unranked;
            };
         }
         style = StyleManager.getStyleDeclaration(".ribbonFormLabelSmall");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ribbonFormLabelSmall",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13343830;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 10;
            };
         }
         style = StyleManager.getStyleDeclaration(".serverPopupCanvas");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".serverPopupCanvas",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderColor = 10066329;
               this.borderThickness = 1;
               this.cornerRadius = 5;
               this.fillColors = [922921,0];
               this.borderAlpha = 0.5;
               this.fillAlphas = [0.9,0.9];
               this.backgroundAlpha = 0.9;
            };
         }
         style = StyleManager.getStyleDeclaration(".ipXpBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ipXpBar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundImage = _embed_css___________ClientAssets_imageEmbeds_EndOfGame_barOverlay_png_881787358;
            };
         }
         style = StyleManager.getStyleDeclaration(".rollOverInfo");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".rollOverInfo",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = "0xFFFFFF";
               this.color = "0xFFFFFF";
               this.backgroundColor = "0x000000";
               this.cornerRadius = 4;
               this.borderThickness = 1;
               this.fontSize = 13;
               this.backgroundAlpha = 0.8;
            };
         }
         style = StyleManager.getStyleDeclaration(".championSelectTabNavigator");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championSelectTabNavigator",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.firstTabStyleName = "myTabs";
               this.borderStyle = "solid";
               this.borderColor = 16777215;
               this.selectedTabTextStyleName = "mySelectedTabs";
               this.tabStyleName = "myTabs";
               this.color = 10066329;
               this.backgroundColor = 1649471;
               this.lastTabStyleName = "myTabs";
               this.borderThickness = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".smallTexturedText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".smallTexturedText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 13343830;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".gameOptionsTitleText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".gameOptionsTitleText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 14540253;
               this.textAlign = "left";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".rerollBarBonusBoost");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".rerollBarBonusBoost",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 0;
               this.fillColors = [0,38655];
               this.fillAlphas = [1,1];
               this.borderAlpha = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".panelHeaderText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".panelHeaderText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 20;
            };
         }
         style = StyleManager.getStyleDeclaration(".serverPopupHRule");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".serverPopupHRule",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.shadowColor = 3948621;
               this.strokeColor = 0;
               this.strokeWidth = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".spellDetailsTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".spellDetailsTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 28;
            };
         }
         style = StyleManager.getStyleDeclaration(".eloQuestionaireSkillToolTipText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".eloQuestionaireSkillToolTipText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15658734;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration("Application");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("Application",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.modalTransparency = 0.5;
               this.modalTransparencyDuration = 1;
               this.modalTransparencyColor = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".mapRendererMapName");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".mapRendererMapName",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 20;
            };
         }
         style = StyleManager.getStyleDeclaration(".championNameText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championNameText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".endOfGameGraphCheckBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endOfGameGraphCheckBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderColor = 39372;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
               this.fillColors = [16777215,16777215,16777215,15658734];
               this.fillAlphas = [0.6,1,0.75,0.65];
            };
         }
         style = StyleManager.getStyleDeclaration(".genericSquare");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".genericSquare",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_up_png_1302752156;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_down_png_2059095186;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_over_png_417214562;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_grey_up_png_792950050;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blue_up_png_1302752156;
            };
         }
         style = StyleManager.getStyleDeclaration(".searchButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".searchButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.icon = _embed_css___________ClientAssets_imageEmbeds_chat_pvp_chat_icon_search_png_1817436086;
               this.downSkin = ButtonSkin;
               this.overSkin = ButtonSkin;
               this.borderColor = 2236962;
               this.selectedDisabledSkin = ButtonSkin;
               this.cornerRadius = 0;
               this.textRollOverColor = 16777215;
               this.selectedUpSkin = ButtonSkin;
               this.fillAlphas = [1,1,0.63,0.83];
               this.verticalGap = 2;
               this.themeColor = 3355443;
               this.upSkin = ButtonSkin;
               this.selectedDownSkin = ButtonSkin;
               this.color = 16777215;
               this.borderThickness = 3;
               this.highlightAlphas = [0.4,0.02];
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fillColors = [0,0,0,3355443];
               this.disabledSkin = ButtonSkin;
               this.horizontalGap = 2;
               this.textSelectedColor = 16777215;
               this.selectedOverSkin = ButtonSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".profileStatsTabBarTab");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileStatsTabBarTab",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_playerProfile_stats_bluetab_png_272294082;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_playerProfile_stats_bluetab_png_272294082;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_playerProfile_stats_bluetab_over_png_1797537676;
               this.color = 2762265;
               this.textRollOverColor = 2762265;
               this.fontSize = 14;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_playerProfile_stats_bluetab_png_272294082;
               this.textSelectedColor = 4460817;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_playerProfile_stats_tab1_png_226332508;
            };
         }
         style = StyleManager.getStyleDeclaration(".optionsTextSpells");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".optionsTextSpells",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 0;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseGameTooltipText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseGameTooltipText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 12;
               this.textSelectedColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".toolbarMinimizeBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".toolbarMinimizeBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueMinimize_up_png_54035824;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueMinimize_down_png_633836926;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueMinimize_over_png_1556551070;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueMinimize_up_png_54035824;
            };
         }
         style = StyleManager.getStyleDeclaration(".whiteComboBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".whiteComboBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13685195;
               this.fontFamily = "ApplicationFont2";
               this.dropDownStyleName = "whiteComboBoxDropdownList";
               this.fontSize = 14;
               this.paddingBottom = 7;
               this.skin = DropDown;
            };
         }
         style = StyleManager.getStyleDeclaration(".friendInviteScroll");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".friendInviteScroll",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "none";
               this.thumbOffset = 1;
               this.trackColors = [134682,66826];
               this.downArrowSkin = null;
               this.trackSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_scrollTrack_png_539614468;
               this.iconColor = 8514;
               this.cornerRadius = 3;
               this.highlightAlphas = [0.2,0];
               this.upArrowSkin = null;
               this.fillColors = [2125235,13411,4561382,13411];
               this.fillAlphas = [1,1,1,1];
               this.themeColor = 3965897;
               this.thumbSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_scrollTab_png_1542426484;
            };
         }
         style = StyleManager.getStyleDeclaration("TextArea");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("TextArea",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderSkin = TextArea_borderSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".largeButtonBlue");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".largeButtonBlue",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_up_png_975416882;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_over_png_1991982500;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_over_png_1991982500;
               this.color = 15658734;
               this.focusAlpha = 0;
               this.textRollOverColor = 16777215;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_grey_up_png_1807695571;
               this.fontSize = 14;
               this.textSelectedColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".gradientCanvas");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".gradientCanvas",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.cornerRadius = 5;
               this.fillColors = [922921,0];
               this.fillAlphas = [0.9,0.9];
            };
         }
         style = StyleManager.getStyleDeclaration(".ipDescriptionText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ipDescriptionText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".optionsSubHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".optionsSubHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13148737;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".addBuddyBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".addBuddyBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFriendButton_up_png_1692940050;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFriendButton_over_png_1501160476;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFriendButton_over_png_1501160476;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addFriendButton_up_png_1692940050;
            };
         }
         style = StyleManager.getStyleDeclaration(".endOfGameGridSectionStatsLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endOfGameGridSectionStatsLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".endOfGameGraph");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endOfGameGraph",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundImage = _embed_css___________ClientAssets_imageEmbeds_EndOfGame_graphBackground_png_1921673994;
            };
         }
         style = StyleManager.getStyleDeclaration(".itemSlot");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".itemSlot",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 0;
               this.backgroundColor = 12632256;
               this.borderThickness = 1;
               this.backgroundAlpha = 0.5;
            };
         }
         style = StyleManager.getStyleDeclaration(".runeInventoryStats");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runeInventoryStats",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 9;
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseGameDialogButtonText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseGameDialogButtonText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 29;
               this.textSelectedColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".ignoreList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ignoreList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 0;
               this.verticalScrollBarStyleName = "buddyListScrollBar";
               this.color = 16777215;
               this.borderThickness = 1;
               this.backgroundAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".championOverlayButtonBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championOverlayButtonBar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.selectedButtonTextStyleName = "selectedToggleButton";
               this.buttonStyleName = "championOverlayTabButton";
               this.buttonHeight = 30;
               this.horizontalGap = 5;
            };
         }
         style = StyleManager.getStyleDeclaration(".toolbarSettingsBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".toolbarSettingsBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = ToolbarSettingsBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".s1FormHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".s1FormHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.focusAlpha = 0;
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".optionsTextSpellsReq");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".optionsTextSpellsReq",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 10;
            };
         }
         style = StyleManager.getStyleDeclaration(".endOfGameVictoryText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endOfGameVictoryText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16766720;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 33;
            };
         }
         style = StyleManager.getStyleDeclaration(".EditableTextArea");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".EditableTextArea",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.paddingTop = 4;
               this.letterSpacing = 1;
               this.color = 0;
               this.borderSkin = _embed_css___________ClientAssets_imageEmbeds_defaults_inputTextFieldSkin_png_1981790213;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 14;
               this.paddingLeft = 3;
            };
         }
         style = StyleManager.getStyleDeclaration(".hRule");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".hRule",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.shadowColor = 3948621;
               this.strokeColor = 0;
               this.strokeWidth = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatButtonSelected");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatButtonSelected",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.downSkin = ButtonSkin;
               this.overSkin = ButtonSkin;
               this.borderColor = 11187123;
               this.selectedDisabledSkin = ButtonSkin;
               this.cornerRadius = 0;
               this.textRollOverColor = 16777215;
               this.selectedUpSkin = ButtonSkin;
               this.fillAlphas = [1,1,0.63,0.83];
               this.verticalGap = 2;
               this.themeColor = 2236962;
               this.upSkin = ButtonSkin;
               this.selectedDownSkin = ButtonSkin;
               this.color = 16777215;
               this.borderThickness = 3;
               this.highlightAlphas = [0.25,0.02];
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fillColors = [4473924,1118481,4473924,6710886];
               this.disabledSkin = ButtonSkin;
               this.horizontalGap = 2;
               this.textSelectedColor = 16777215;
               this.selectedOverSkin = ButtonSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".toolbarSortBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".toolbarSortBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueSort_up_png_2133366416;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueSort_down_png_960100482;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueSort_over_png_75025506;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueSort_up_png_2133366416;
            };
         }
         style = StyleManager.getStyleDeclaration(".rssFeedSubtitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".rssFeedSubtitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 14540253;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookOptInText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookOptInText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15263976;
               this.leading = 8;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseGameExitButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseGameExitButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 15;
               this.textSelectedColor = 16777215;
               this.skin = pg_close_button;
            };
         }
         style = StyleManager.getStyleDeclaration(".championSelectionFooter");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championSelectionFooter",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13421772;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".runeInventoryList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runeInventoryList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "none";
               this.backgroundAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".xpBarBoost");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".xpBarBoost",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 0;
               this.fillColors = [8651007,0];
               this.fillAlphas = [1,1];
               this.borderAlpha = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".viewProfileButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".viewProfileButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueProfile_up_png_1303257954;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueProfile_down_png_594146536;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueProfile_over_png_1364545484;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueProfile_over_png_1364545484;
            };
         }
         style = StyleManager.getStyleDeclaration(".browserRefresh");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".browserRefresh",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueReload_up_png_687408146;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueReload_down_png_339216888;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueReload_over_png_1933104164;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueReload_over_png_1933104164;
            };
         }
         style = StyleManager.getStyleDeclaration(".RerollBarText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".RerollBarText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15658734;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".runeInventoryYellow");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runeInventoryYellow",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 14540032;
               this.skin = GroupBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".toolbarSearchBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".toolbarSearchBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = ToolbarSearchBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".blueParchment");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".blueParchment",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.strokeColor = 5076132;
               this.strokeWidth = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".texturedText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".texturedText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 18;
            };
         }
         style = StyleManager.getStyleDeclaration(".buddyListInGameStatus");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buddyListInGameStatus",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13421568;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 9;
            };
         }
         style = StyleManager.getStyleDeclaration(".rerollBarTNL");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".rerollBarTNL",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 0;
               this.fillColors = [0,0];
               this.fillAlphas = [1,1];
               this.borderAlpha = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".s1FormNote");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".s1FormNote",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13882582;
               this.focusAlpha = 0;
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatEntryContainers");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatEntryContainers",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingTop = 4;
               this.backgroundColor = 1710618;
               this.paddingBottom = 6;
               this.backgroundAlpha = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".endOfGameChatDisplay");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endOfGameChatDisplay",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "none";
               this.verticalScrollBarStyleName = "chatScroll";
               this.color = 16777215;
               this.backgroundColor = 0;
               this.fontFamily = "ApplicationFont1";
               this.focusThickness = 0;
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".buddyStatusLarge");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buddyStatusLarge",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16750848;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".spectatorPanelHeaderText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".spectatorPanelHeaderText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15790320;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".playGameText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".playGameText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 30;
            };
         }
         style = StyleManager.getStyleDeclaration(".runeCombinerDesc");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runeCombinerDesc",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".runeComboBoxDropDowns");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runeComboBoxDropDowns",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".toggleBuddyListBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".toggleBuddyListBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = FLLargeBarBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".rerollBarBoost");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".rerollBarBoost",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 0;
               this.fillColors = [8651007,0];
               this.fillAlphas = [1,1];
               this.borderAlpha = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".errorText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".errorText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 16711680;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".xpBarMaxLevel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".xpBarMaxLevel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 0;
               this.fillColors = [1900582,0];
               this.fillAlphas = [1,1];
               this.borderAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookOptInHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookOptInHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 19;
            };
         }
         style = StyleManager.getStyleDeclaration(".popupMessageTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".popupMessageTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "Bold";
               this.color = 16777215;
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".dialogTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".dialogTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".endOfGameGridSectionHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endOfGameGridSectionHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".toolBarMinimizeBtnSmall");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".toolBarMinimizeBtnSmall",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueMinimize_up_png_2096450087;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueMinimize_down_png_1319644295;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueMinimize_over_png_694894823;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueMinimize_up_png_2096450087;
            };
         }
         style = StyleManager.getStyleDeclaration(".s1FormLoginButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".s1FormLoginButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_orange_up_png_1575779582;
               this.fontWeight = "normal";
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_orange_over_png_1586148332;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_orange_over_png_1586148332;
               this.color = 15658734;
               this.focusAlpha = 0;
               this.textRollOverColor = 16777215;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_grey_up_png_1201506856;
               this.fontSize = 14;
               this.textSelectedColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".s1FormInput");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".s1FormInput",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 16777215;
               this.focusAlpha = 0;
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatInput");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatInput",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "none";
               this.color = 0;
               this.backgroundColor = 16777215;
               this.borderSkin = WhiteBorderSkin;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".descriptionText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".descriptionText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 5000268;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".championSelectionHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championSelectionHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 39423;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".toolbarMinimizeBtnOLD");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".toolbarMinimizeBtnOLD",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = ToolbarMinimizeBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".playerSummaryGiftButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".playerSummaryGiftButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_giftButton_up_png_1831168366;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_giftButton_over_png_1822488220;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_giftButton_over_png_1822488220;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_giftButton_disabled_png_1811952620;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_giftButton_up_png_1831168366;
            };
         }
         style = StyleManager.getStyleDeclaration(".optionsText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".optionsText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".summonerProfileUnrankedText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerProfileUnrankedText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 3552516;
               this.fontSize = 17;
            };
         }
         style = StyleManager.getStyleDeclaration(".s1TextInput");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".s1TextInput",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingTop = 0;
               this.color = 734012;
               this.focusAlpha = 0;
               this.paddingLeft = 0;
               this.paddingRight = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".optionsFlowList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".optionsFlowList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "none";
               this.backgroundAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".summonerInfoHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerInfoHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.dropShadowEnabled = true;
               this.color = 15790320;
               this.dropShadowColor = 16777215;
               this.fontFamily = "ApplicationFont2";
            };
         }
         style = StyleManager.getStyleDeclaration(".helpButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".helpButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = HelpButtonSkin;
            };
         }
         style = StyleManager.getStyleDeclaration("TextInput");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("TextInput",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.paddingTop = 4;
               this.letterSpacing = 1;
               this.color = 16777215;
               this.borderSkin = TextInputSkin;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 14;
               this.paddingLeft = 3;
            };
         }
         style = StyleManager.getStyleDeclaration(".loginPageButtons");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".loginPageButtons",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 13343830;
               this.textRollOverColor = 15052896;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
               this.horizontalGap = 38;
               this.skin = LoginURLButton_skin;
            };
         }
         style = StyleManager.getStyleDeclaration(".endOfGameGrid");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endOfGameGrid",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundImage = _embed_css___________ClientAssets_imageEmbeds_EndOfGame_gridBackground_png_1170079210;
            };
         }
         style = StyleManager.getStyleDeclaration(".championDescriptionText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championDescriptionText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 36846;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 18;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatDisconnectedText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatDisconnectedText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15207997;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
               this.horizontalCenter = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatWindow");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatWindow",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "none";
               this.paddingTop = -6;
               this.titleTextStyleName = "windowTitleText";
               this.headerHeight = 20;
               this.dropShadowColor = 1315860;
               this.verticalGap = 0;
               this.paddingLeft = 0;
               this.backgroundAlpha = 0;
               this.paddingRight = 0;
               this.dropShadowEnabled = true;
               this.color = 0;
               this.buttonPadding = 14;
               this.gripperStyleName = "windowGripperStyle";
               this.titleAlignment = "auto";
               this.paddingBottom = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".stoneTablet");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".stoneTablet",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 3290677;
               this.backgroundColor = 0;
               this.borderThickness = 2;
               this.backgroundAlpha = 0.7;
            };
         }
         style = StyleManager.getStyleDeclaration(".infoButtonYellow");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".infoButtonYellow",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_up_yellow_png_239636706;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_disabled_yellow_png_2014677352;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_over_yellow_png_972066168;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_disabled_yellow_png_2014677352;
            };
         }
         style = StyleManager.getStyleDeclaration(".titleBarBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".titleBarBackground",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 6645093;
               this.backgroundColor = 1710618;
               this.borderThickness = 1;
               this.backgroundAlpha = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".recentPlayersList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".recentPlayersList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "none";
               this.verticalScrollBarStyleName = "buddyListScrollBar";
               this.backgroundAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".runeSelectionComboBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runeSelectionComboBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.dropdownStyleName = "runeComboBoxDropDowns";
               this.openDuration = 200;
               this.fontAntiAliasType = "advanced";
               this.color = 0;
               this.cornerRadius = 3;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 12;
               this.disabledColor = 3355443;
               this.fillAlphas = [1,1,1,1];
            };
         }
         style = StyleManager.getStyleDeclaration(".endOfGameStatsComboBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endOfGameStatsComboBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.dropDownStyleName = "whiteComboBoxDropdownList";
               this.fontSize = 12;
               this.paddingBottom = 7;
               this.skin = DropDown;
            };
         }
         style = StyleManager.getStyleDeclaration(".genericButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".genericButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_up_png_1124695032;
               this.fontWeight = "normal";
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_over_png_1958856570;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_over_png_1958856570;
               this.color = 15658734;
               this.focusAlpha = 0;
               this.textRollOverColor = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".eogMainTabSelectedButtonCN");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".eogMainTabSelectedButtonCN",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
               this.textSelectedColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".profileTabDropdown");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileTabDropdown",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.paddingTop = 0;
               this.borderColor = 6684672;
               this.useRollOver = false;
               this.borderThickness = 1;
               this.paddingLeft = 0;
               this.paddingBottom = 0;
               this.backgroundAlpha = 0;
               this.paddingRight = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".yellowHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".yellowHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".stepSelected");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".stepSelected",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatPlayerNameHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatPlayerNameHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".newbieTipText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".newbieTipText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".browser");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".browser",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 11184810;
               this.backgroundColor = 0;
               this.borderWidth = 1;
               this.borderThickness = 1;
               this.cornerRadius = 5;
            };
         }
         style = StyleManager.getStyleDeclaration(".addFacebookFriendsBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".addFacebookFriendsBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_facebook_friendList_addFacebook_up_png_850364810;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_facebook_friendList_addFacebook_over_png_763622760;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_facebook_friendList_addFacebook_over_png_763622760;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_facebook_friendList_addFacebook_up_png_850364810;
            };
         }
         style = StyleManager.getStyleDeclaration(".summonerInfoText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerInfoText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 0;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".helpTopicList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".helpTopicList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.dropShadowEnabled = true;
               this.color = 16777215;
               this.rollOverColor = 0;
               this.borderThickness = 0;
               this.textRollOverColor = 16777215;
               this.dropShadowColor = 0;
               this.fontFamily = "ApplicationFont2";
               this.fillColors = [12632256,0];
               this.fontSize = 14;
               this.fillAlphas = [1,1];
               this.textSelectedColor = 16777215;
               this.backgroundAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".windowClose");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".windowClose",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = pvp_frame_closebtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".runeCombinerTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runeCombinerTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".blueComboBoxDropdownList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".blueComboBoxDropdownList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingLeft = 10;
               this.paddingRight = 10;
            };
         }
         style = StyleManager.getStyleDeclaration(".buddyBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buddyBackground",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 1118481;
               this.backgroundColor = 0;
               this.backgroundImage = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_friendItem_png_200583042;
               this.cornerRadius = 5;
               this.borderThickness = 2;
               this.backgroundAlpha = 0.5;
            };
         }
         style = StyleManager.getStyleDeclaration(".championSelectionTeamName");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championSelectionTeamName",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 24;
            };
         }
         style = StyleManager.getStyleDeclaration(".ribbonQueueLabelBold");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ribbonQueueLabelBold",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseGameArrangeTeamTooltip");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseGameArrangeTeamTooltip",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 12;
               this.textSelectedColor = 16777215;
               this.skin = pg_tooltip_at;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatPromptHistoryRead");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatPromptHistoryRead",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
            };
         }
         style = StyleManager.getStyleDeclaration(".parchmentGradient");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".parchmentGradient",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 10058542;
               this.borderThickness = 1;
               this.fillColors = [15920086,14601370];
               this.fillAlphas = [1,1];
               this.backgroundAlpha = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookOptInDialog");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookOptInDialog",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundImage = _embed_css___________ClientAssets_imageEmbeds_facebook_mainFrame_png_335401618;
            };
         }
         style = StyleManager.getStyleDeclaration(".profileToggleButtonBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileToggleButtonBar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.selectedButtonTextStyleName = "profileSelectedToggleButton";
               this.buttonStyleName = "profileToggleButton";
               this.buttonHeight = 30;
            };
         }
         style = StyleManager.getStyleDeclaration(".talentToolTipDescText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".talentToolTipDescText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.letterSpacing = 0;
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 10;
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseStoreButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseStoreButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 20;
               this.textSelectedColor = 16777215;
               this.skin = LargeNavigationButtonSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".players");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".players",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.backgroundColor = 1184274;
               this.borderThickness = 0;
               this.fontFamily = "ApplicationFont1";
               this.focusThickness = 0;
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".toolbarCloseBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".toolbarCloseBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = ToolbarCloseBtn;
            };
         }
         style = StyleManager.getStyleDeclaration("BlackBeveledCanvas");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("BlackBeveledCanvas",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderSkin = _embed_css___________ClientAssets_imageEmbeds_defaults_blackBeveledCanvas_png_378850276;
            };
         }
         style = StyleManager.getStyleDeclaration(".arrowRightBlue");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".arrowRightBlue",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = cs_largeSquareButtonBlueArrowRight;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatAccordion");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatAccordion",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 0;
               this.dropShadowEnabled = false;
               this.backgroundColor = 14214;
               this.headerStyleName = "chatAccordionHeader";
               this.borderThickness = 2;
               this.textRollOverColor = 16777215;
               this.highlightAlphas = [0.16,0.2];
               this.fillColors = [16777215,13421772,16777215,15658734];
               this.fillAlphas = [1,0.4,0.75,0.65];
               this.textSelectedColor = 16777215;
               this.themeColor = 26367;
            };
         }
         style = StyleManager.getStyleDeclaration(".callToActionText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".callToActionText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.textDecoration = "underline";
               this.color = 17346;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 17;
               this.skin = null;
            };
         }
         style = StyleManager.getStyleDeclaration(".botSelectComboBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".botSelectComboBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.dropdownStyleName = "runeComboBoxDropDowns";
               this.openDuration = 200;
               this.fontAntiAliasType = "advanced";
               this.color = 0;
               this.cornerRadius = 3;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 12;
               this.fillAlphas = [1,1,1,1];
            };
         }
         style = StyleManager.getStyleDeclaration(".profileTabUnselected");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileTabUnselected",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeInactive_png_2068143408;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeInactive_over_png_1073116274;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeInactive_over_png_1073116274;
               this.color = 0;
               this.textRollOverColor = 2236962;
               this.fontSize = 20;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeInactive_over_png_1073116274;
               this.textSelectedColor = 0;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_playerProfile_profileMain_tabLargeInactive_png_2068143408;
            };
         }
         style = StyleManager.getStyleDeclaration(".smallSquareButtonLightBlue");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".smallSquareButtonLightBlue",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_up_png_901665048;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_over_png_1384894514;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_over_png_1384894514;
               this.color = 15658734;
               this.focusAlpha = 0;
               this.textRollOverColor = 16777215;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_lightBlue_up_png_901665048;
               this.fontSize = 14;
               this.textSelectedColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".blueRadioButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".blueRadioButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.selectedOverIcon = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueRadioButtonChecked_png_1781223640;
               this.selectedUpIcon = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueRadioButtonChecked_png_1781223640;
               this.upIcon = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueRadioButton_png_2101912986;
               this.selectedDownIcon = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueRadioButton_png_2101912986;
               this.fontFamily = "ApplicationFont2";
               this.overIcon = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueRadioButton_png_2101912986;
               this.fontSize = 14;
               this.downIcon = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueRadioButtonChecked_png_1781223640;
            };
         }
         style = StyleManager.getStyleDeclaration(".buddyWindow");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buddyWindow",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 3290677;
               this.cornerRadius = 0;
               this.borderThickness = 3;
            };
         }
         style = StyleManager.getStyleDeclaration(".runeListCountDisplaySmallBold");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runeListCountDisplaySmallBold",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 0;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 11;
            };
         }
         style = StyleManager.getStyleDeclaration(".summonerToolTipButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerToolTipButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderColor = 0;
               this.paddingTop = -2;
               this.cornerRadius = 5;
               this.textRollOverColor = 10066329;
               this.fontSize = 9;
               this.fillAlphas = [1,1,1,1];
               this.themeColor = 0;
               this.paddingLeft = 0;
               this.paddingRight = 0;
               this.fontWeight = "normal";
               this.color = 6710886;
               this.fillColors = [0,0,0,0];
               this.textSelectedColor = 6710886;
               this.paddingBottom = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".playerTooltip");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".playerTooltip",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.borderStyle = "none";
               this.openDuration = 0;
               this.color = 13343830;
               this.selectionDuration = 100000;
               this.useRollOver = false;
               this.textRollOverColor = 15052896;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 18;
               this.textSelectedColor = 15052896;
               this.backgroundAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".blackTransparentBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".blackTransparentBackground",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 0;
               this.backgroundAlpha = 0.95;
            };
         }
         style = StyleManager.getStyleDeclaration(".blueHeaderBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".blueHeaderBackground",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "none";
               this.borderColor = 5076132;
               this.borderThickness = 0;
               this.fillColors = [2112092,1187891];
               this.fillAlphas = [1,1];
            };
         }
         style = StyleManager.getStyleDeclaration(".xpBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".xpBar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 0;
               this.fillColors = [4397055,0];
               this.fillAlphas = [1,1];
               this.borderAlpha = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".playerSummaryAddButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".playerSummaryAddButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_addButton_up_png_2094875444;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_addButton_up_png_2094875444;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_addButton_over_png_311755666;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_addButton_disabled_png_854593918;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_addButton_up_png_2094875444;
            };
         }
         style = StyleManager.getStyleDeclaration(".navigationSmall");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".navigationSmall",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 20;
               this.textSelectedColor = 16777215;
               this.skin = SmallNavigationButtonSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".pageBackward");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".pageBackward",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = PageBackButtonSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".summonerIconScrollBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerIconScrollBar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.thumbOffset = 1;
               this.borderColor = 5592405;
               this.trackColors = [134682,394506];
               this.downArrowSkin = null;
               this.cornerRadius = 3;
               this.highlightAlphas = [0.2,0.2,0.2];
               this.upArrowSkin = null;
               this.fillColors = [8947848,2829099];
               this.fillAlphas = [1,1,1,1];
               this.themeColor = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".buddyBay");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buddyBay",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "none";
               this.verticalScrollBarStyleName = "wide";
               this.color = 16777215;
               this.backgroundColor = 0;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 12;
               this.backgroundAlpha = 0.95;
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseCustomGameButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseCustomGameButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 29;
               this.textSelectedColor = 16777215;
               this.skin = small_game_button_custom;
            };
         }
         style = StyleManager.getStyleDeclaration(".texturedButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".texturedButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 13343830;
               this.textRollOverColor = 15052896;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 18;
               this.skin = Button_skin;
            };
         }
         style = StyleManager.getStyleDeclaration(".itemsList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".itemsList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.disabledOverlayAlpha = 0.1;
               this.fontWeight = "normal";
               this.color = 13343830;
               this.backgroundColor = 0;
               this.backgroundDisabledColor = 0;
               this.cornerRadius = 5;
               this.iconColor = 13343830;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 11;
               this.fillColors = [0,0];
               this.backgroundAlpha = 0.8;
            };
         }
         style = StyleManager.getStyleDeclaration(".endOfGameWinLossText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endOfGameWinLossText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 0;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 40;
            };
         }
         style = StyleManager.getStyleDeclaration("ServerWaitPopup");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ServerWaitPopup",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.modalTransparency = 0;
               this.modalTransparencyBlur = 0;
               this.modalTransparencyColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".helpTextLarge");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".helpTextLarge",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalScrollBarStyleName = "chatScroll";
               this.color = 16777215;
               this.focusAlpha = 0;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".instructionsHeaderLarge");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".instructionsHeaderLarge",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 18;
            };
         }
         style = StyleManager.getStyleDeclaration(".ribbonUserLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ribbonUserLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 11776947;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".itemTooltipHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".itemTooltipHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 1763364;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".normalGameHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".normalGameHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.dropShadowEnabled = true;
               this.color = 15790320;
               this.dropShadowColor = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 18;
            };
         }
         style = StyleManager.getStyleDeclaration(".dockedChatTabInactive");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".dockedChatTabInactive",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_dockedChatTab_png_436340997;
            };
         }
         style = StyleManager.getStyleDeclaration(".playerSummaryKudos");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".playerSummaryKudos",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_honorButton_up_png_758944926;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_honorButton_over_png_1389318924;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_honorButton_over_png_1389318924;
               this.focusAlpha = 0;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_honorButton_disabled_png_1982106532;
            };
         }
         style = StyleManager.getStyleDeclaration(".gameGrid");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".gameGrid",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 0;
               this.horizontalGridLineColor = 16711680;
               this.rollOverColor = 274764;
               this.headerStyleName = "dataGridHeader";
               this.textRollOverColor = 13487565;
               this.selectionColor = 1187891;
               this.backgroundAlpha = 0;
               this.color = 13421772;
               this.verticalSeparatorSkin = DataGridHeaderSeparator;
               this.alternatingItemColors = [0,0];
               this.alpha = 0;
               this.borderSkin = DataGridBorderSkin;
               this.headerColors = [2112092,1187891];
               this.headerSeparatorSkin = DataGridHeaderSeparator;
               this.headerBackgroundSkin = DataGridHeader;
               this.textSelectedColor = 13487565;
            };
         }
         style = StyleManager.getStyleDeclaration(".buddyStatusRanked");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buddyStatusRanked",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16750848;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".silverHighlightText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".silverHighlightText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 10066329;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 24;
            };
         }
         style = StyleManager.getStyleDeclaration(".profileHeaderText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileHeaderText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 4460817;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".buddyRendererRealName");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buddyRendererRealName",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".rankedStatsGraphSelectorRadioButtonStyle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".rankedStatsGraphSelectorRadioButtonStyle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".teamMemberLevelInset");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".teamMemberLevelInset",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 15658734;
               this.backgroundColor = 15658734;
               this.borderThickness = 0;
               this.cornerRadius = 5;
               this.backgroundAlpha = 0.7;
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseArrangedTeamGameButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseArrangedTeamGameButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 29;
               this.textSelectedColor = 16777215;
               this.skin = big_game_button_at;
            };
         }
         style = StyleManager.getStyleDeclaration(".firstTab");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".firstTab",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fillColors = [1315860,1315860];
            };
         }
         style = StyleManager.getStyleDeclaration(".endOfGameGraphNumber");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endOfGameGraphNumber",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textAlign = "right";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookListRolloverNone");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookListRolloverNone",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 2975436;
               this.backgroundAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".glassSeeThroughPanel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".glassSeeThroughPanel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_glassSeeThroughPanel_png_1321496377;
            };
         }
         style = StyleManager.getStyleDeclaration(".champScroll");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".champScroll",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.thumbOffset = 1;
               this.borderColor = 996439;
               this.trackColors = [134682,66826];
               this.downArrowSkin = null;
               this.iconColor = 8514;
               this.cornerRadius = 3;
               this.highlightAlphas = [0.2,0];
               this.upArrowSkin = null;
               this.fillColors = [2125235,13411,4561382,13411];
               this.fillAlphas = [1,1,1,1];
               this.themeColor = 3965897;
            };
         }
         style = StyleManager.getStyleDeclaration(".championTooltipText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championTooltipText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 14540253;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 17;
            };
         }
         style = StyleManager.getStyleDeclaration(".practiceGameStats");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".practiceGameStats",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".toolBarCloseBtnSmall");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".toolBarCloseBtnSmall",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueClose_up_png_867218697;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueClose_down_png_2147173611;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueClose_over_png_4979001;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_buttons_smallSquare22px_blueClose_up_png_867218697;
            };
         }
         style = StyleManager.getStyleDeclaration(".s1InputHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".s1InputHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.focusAlpha = 0;
               this.fontSize = 13;
               this.paddingBottom = -7;
            };
         }
         style = StyleManager.getStyleDeclaration(".ipBarBoostDisabled");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ipBarBoostDisabled",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 0;
               this.fillColors = [0,13421772];
               this.fillAlphas = [1,1];
               this.borderAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".optionsSubTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".optionsSubTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 13343830;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 18;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookInviteDetail");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookInviteDetail",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15263976;
               this.leading = 9;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseGameTypeButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseGameTypeButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 20;
               this.textSelectedColor = 16777215;
               this.skin = pvp_playbtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".standard");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".standard",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingTop = 0;
               this.color = 734012;
               this.borderSkin = HaloBorder;
               this.fontFamily = "ApplicationFont1";
               this.paddingLeft = 0;
               this.paddingRight = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatPrompt");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatPrompt",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.borderThickness = 0;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookOptInDetailBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookOptInDetailBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 1388886;
               this.backgroundColor = 0;
               this.cornerRadius = 3;
            };
         }
         style = StyleManager.getStyleDeclaration(".windowTitleText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".windowTitleText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".runeInventoryHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runeInventoryHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = GroupBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".buddyButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buddyButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = BuddyIcon;
            };
         }
         style = StyleManager.getStyleDeclaration(".summonerStatsTextLarge");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerStatsTextLarge",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".longButtonOrange2");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".longButtonOrange2",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_orange_up_png_153376104;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_orange_over_png_125339998;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_orange_over_png_125339998;
               this.color = 15658734;
               this.focusAlpha = 0;
               this.textRollOverColor = 16777215;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_grey_up_png_1596301166;
               this.fontSize = 14;
               this.textSelectedColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".boostDisabledIpGain");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".boostDisabledIpGain",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fillColors = [15263976,9342606];
               this.fillAlphas = [1,1];
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookTristanaBGFaded");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookTristanaBGFaded",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundImage = _embed_css___________ClientAssets_imageEmbeds_facebook_tristFade_png_66724810;
            };
         }
         style = StyleManager.getStyleDeclaration(".runToolTipText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runToolTipText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration("DragManager");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("DragManager",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.linkCursor = DragManager_linkCursor;
            };
         }
         style = StyleManager.getStyleDeclaration(".endOfGameChampName");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endOfGameChampName",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".placeholderCanvas");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".placeholderCanvas",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 2237989;
               this.backgroundColor = 12303291;
               this.borderThickness = 2;
               this.backgroundAlpha = 0.7;
            };
         }
         style = StyleManager.getStyleDeclaration(".XPBarTextLevelUp");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".XPBarTextLevelUp",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15259909;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".popupButtonText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".popupButtonText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".scoreboardHeaderText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".scoreboardHeaderText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 11184810;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".runeInventoryBlack");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runeInventoryBlack",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 11360767;
               this.skin = GroupBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".ipBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ipBar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 0;
               this.fillColors = [0,3604224];
               this.fillAlphas = [1,1];
               this.borderAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".enterChatbutton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".enterChatbutton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = GroupBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".errorTip");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".errorTip",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".blackBeveled");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".blackBeveled",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.shadowColor = 0;
               this.strokeColor = 3291192;
               this.strokeWidth = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".stoneTabletSeason1");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".stoneTabletSeason1",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 10058542;
               this.backgroundColor = 12691300;
               this.borderThickness = 1;
               this.backgroundAlpha = 0.8;
            };
         }
         style = StyleManager.getStyleDeclaration(".rerollBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".rerollBar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 0;
               this.fillColors = [4397055,0];
               this.fillAlphas = [1,1];
               this.borderAlpha = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".profileBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileBackground",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 16711680;
               this.backgroundColor = 65280;
               this.borderThickness = 2;
               this.cornerRadius = 4;
               this.backgroundAlpha = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".queueSizeButtonText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".queueSizeButtonText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 42;
            };
         }
         style = StyleManager.getStyleDeclaration(".yellow");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".yellow",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "none";
               this.thumbOffset = 1;
               this.borderColor = 13214268;
               this.trackColors = [13021300,13021300];
               this.verticalScrollBarStyleName = "yellow";
               this.iconColor = 13214268;
               this.cornerRadius = 3;
               this.highlightAlphas = [0.2,0];
               this.fillColors = [16249306,15918521,16249306,16249306];
               this.fillAlphas = [1,1,1,1];
               this.themeColor = 13214268;
               this.backgroundAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatHeaderText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatHeaderText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".glassChatRoom");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".glassChatRoom",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_glassChatBorder_png_338034408;
            };
         }
         style = StyleManager.getStyleDeclaration(".rankedTeamText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".rankedTeamText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatPanelTabs");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatPanelTabs",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingTop = 0;
               this.color = 0;
               this.verticalGap = 0;
               this.paddingBottom = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseGameOptionsButtonTextArea");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseGameOptionsButtonTextArea",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15658734;
               this.textAlign = "center";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.downSkin = ButtonSkin;
               this.overSkin = ButtonSkin;
               this.borderColor = 2236962;
               this.selectedDisabledSkin = ButtonSkin;
               this.cornerRadius = 0;
               this.textRollOverColor = 16777215;
               this.selectedUpSkin = ButtonSkin;
               this.fillAlphas = [1,1,0.63,0.83];
               this.verticalGap = 2;
               this.themeColor = 3355443;
               this.upSkin = ButtonSkin;
               this.selectedDownSkin = ButtonSkin;
               this.color = 16777215;
               this.borderThickness = 3;
               this.highlightAlphas = [0.4,0.02];
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fillColors = [0,0,0,3355443];
               this.disabledSkin = ButtonSkin;
               this.horizontalGap = 2;
               this.textSelectedColor = 16777215;
               this.selectedOverSkin = ButtonSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".infoButtonBlue");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".infoButtonBlue",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_up_blue_png_632968946;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_disabled_blue_png_942324012;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_over_blue_png_2066626692;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_lvlUp_disabled_blue_png_942324012;
            };
         }
         style = StyleManager.getStyleDeclaration(".champSatsStatus");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".champSatsStatus",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15262410;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatActiveBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatActiveBackground",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fillColors = [0,52479];
               this.fillAlphas = [1,1];
            };
         }
         style = StyleManager.getStyleDeclaration(".runeInventoryRed");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runeInventoryRed",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 14483456;
               this.skin = GroupBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".rankedTeamHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".rankedTeamHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 7086617;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 17;
            };
         }
         style = StyleManager.getStyleDeclaration(".testOptionButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".testOptionButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 10;
            };
         }
         style = StyleManager.getStyleDeclaration(".blueToggleButtonBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".blueToggleButtonBar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.selectedButtonTextStyleName = "selectedToggleButton";
               this.buttonStyleName = "blueToggleButton";
               this.buttonHeight = 30;
               this.horizontalGap = 5;
            };
         }
         style = StyleManager.getStyleDeclaration(".xpBarTNL");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".xpBarTNL",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 0;
               this.fillColors = [0,0];
               this.fillAlphas = [1,1];
               this.borderAlpha = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".windowMaximize");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".windowMaximize",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = pvp_frame_maxRestoreBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".blueThemeHeaderText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".blueThemeHeaderText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15790320;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 19;
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseTutorialTypesGameButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseTutorialTypesGameButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 29;
               this.textSelectedColor = 16777215;
               this.skin = small_game_button_tutorial;
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseTutorialGameButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseTutorialGameButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 29;
               this.textSelectedColor = 16777215;
               this.skin = smallGameButton_tutorialBasic;
            };
         }
         style = StyleManager.getStyleDeclaration(".rssFeedEntrySubtitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".rssFeedEntrySubtitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 10066329;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".selectedToggleButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".selectedToggleButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.bottom = 20;
               this.textRollOverColor = 16777215;
               this.fontSize = 12;
               this.textSelectedColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookInviteDialogTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookInviteDialogTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15263976;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 17;
            };
         }
         style = StyleManager.getStyleDeclaration(".profileSearchBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileSearchBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingTop = 3;
               this.color = 734012;
               this.borderSkin = HaloBorder;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 12;
               this.paddingLeft = 0;
               this.paddingRight = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".buddyStatus");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buddyStatus",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16750848;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatPromptTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatPromptTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.borderThickness = 0;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 10;
               this.backgroundGradientColors = [16777215,0];
            };
         }
         style = StyleManager.getStyleDeclaration(".runeStatsTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runeStatsTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 6684672;
               this.textAlign = "left";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".footerText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".footerText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 10;
            };
         }
         style = StyleManager.getStyleDeclaration(".endOfGameReportAPlayer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endOfGameReportAPlayer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redReport_up_png_1142976146;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redReport_down_png_1196873596;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redReport_over_png_1062490384;
               this.focusAlpha = 0;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redReport_disabled_png_486856912;
            };
         }
         style = StyleManager.getStyleDeclaration(".profileRankingStatsLabels");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileRankingStatsLabels",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 11;
            };
         }
         style = StyleManager.getStyleDeclaration(".blueComboBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".blueComboBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 13685195;
               this.fontFamily = "ApplicationFont2";
               this.dropDownStyleName = "blueComboBoxDropdownList";
               this.fontSize = 14;
               this.paddingBottom = 7;
               this.skin = ComboBoxSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatInputDisabled");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatInputDisabled",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "none";
               this.color = 0;
               this.backgroundColor = 16777215;
               this.borderSkin = RedBorderSkin;
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".masteriesPageName");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".masteriesPageName",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".instructionsTextLarge");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".instructionsTextLarge",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".resetPasswordLink");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".resetPasswordLink",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 7781073;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".browserClose");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".browserClose",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_up_png_1425684334;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_down_png_1457981136;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_over_png_75105412;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_over_png_75105412;
            };
         }
         style = StyleManager.getStyleDeclaration(".teamMemberLevelInsetLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".teamMemberLevelInsetLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".summonerSummaryBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerSummaryBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.fontFamily = "ApplicationFont2";
            };
         }
         style = StyleManager.getStyleDeclaration(".gold");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".gold",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_orange_up_png_153376104;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_orange_over_png_125339998;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_orange_over_png_125339998;
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 15;
               this.textSelectedColor = 16777215;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_orange_over_png_125339998;
            };
         }
         style = StyleManager.getStyleDeclaration(".teamMemberName");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".teamMemberName",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookFeatureBullet");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookFeatureBullet",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".champSelectTitleText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".champSelectTitleText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".lockInButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".lockInButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 16;
               this.skin = cs_largeButton;
            };
         }
         style = StyleManager.getStyleDeclaration(".runeBookStatsText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runeBookStatsText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 10;
            };
         }
         style = StyleManager.getStyleDeclaration(".blueGlassScrollBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".blueGlassScrollBar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.thumbDownSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_verticalScrollThumb_png_1498799506;
               this.thumbOverSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_verticalScrollThumb_png_1498799506;
               this.trackSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_verticalScrollTrack_png_1964846194;
               this.downArrowSkin = null;
               this.cornerRadius = 3;
               this.thumbDisabledSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_verticalScrollThumb_png_1498799506;
               this.thumbUpSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_verticalScrollThumb_png_1498799506;
               this.upArrowSkin = null;
            };
         }
         style = StyleManager.getStyleDeclaration(".playerSummaryReportAPlayer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".playerSummaryReportAPlayer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_reportButton_up_png_2141916846;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_reportButton_over_png_1281016036;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_reportButton_over_png_1281016036;
               this.focusAlpha = 0;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_playerSummary_reportButton_disabled_png_1816644908;
            };
         }
         style = StyleManager.getStyleDeclaration(".popupTablet");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".popupTablet",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 3290677;
               this.backgroundColor = 0;
               this.cornerRadius = 6;
               this.borderThickness = 2;
               this.backgroundAlpha = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatInputPrompt");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatInputPrompt",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 11184810;
               this.borderThickness = 0;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 12;
               this.backgroundGradientColors = [16777215,0];
            };
         }
         style = StyleManager.getStyleDeclaration(".talentToolTipNameText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".talentToolTipNameText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.letterSpacing = 0;
               this.color = 11360767;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".spellToolTipName");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".spellToolTipName",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatAccordionHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatAccordionHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 13;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_groupSeperator_png_1851043812;
            };
         }
         style = StyleManager.getStyleDeclaration(".championSelectionBody");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championSelectionBody",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".optionsLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".optionsLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 9013641;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".inviteFacebookFriendsCloseBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".inviteFacebookFriendsCloseBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_facebook_pvp_closeBtnX_up_png_1435015148;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_facebook_pvp_closeBtnX_down_png_1317583510;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_facebook_pvp_closeBtnX_over_png_2073097910;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_facebook_pvp_closeBtnX_up_png_1435015148;
            };
         }
         style = StyleManager.getStyleDeclaration(".championSelectionClock");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championSelectionClock",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 36;
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseRankedGameButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseRankedGameButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 29;
               this.textSelectedColor = 16777215;
               this.skin = big_game_button_ranked;
            };
         }
         style = StyleManager.getStyleDeclaration(".spellToolTipRequirement");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".spellToolTipRequirement",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16579477;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".talentTreeNameHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".talentTreeNameHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15790320;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".errorMessageText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".errorMessageText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 15;
               this.horizontalCenter = 0;
               this.verticalCenter = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".playTutorialHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".playTutorialHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 22;
            };
         }
         style = StyleManager.getStyleDeclaration(".ipBarAlternate");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ipBarAlternate",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 0;
               this.fillColors = [0,38655];
               this.fillAlphas = [1,1];
               this.borderAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".spellTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".spellTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 6684672;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatTitleText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatTitleText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 13487565;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".serverPopupTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".serverPopupTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "Bold";
               this.color = 16777215;
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".createGameMapText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".createGameMapText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookInviteFriendListLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookInviteFriendListLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration("Button");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("Button",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 15;
               this.textSelectedColor = 16777215;
               this.skin = BlueButtonSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".blackBeveledInverted");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".blackBeveledInverted",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.shadowColor = 3291192;
               this.strokeColor = 0;
               this.strokeWidth = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".ipBarText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ipBarText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 10;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatClose");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatClose",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = ChatCloseButtonSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".summonerPreviewStatsTextLarge");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerPreviewStatsTextLarge",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 18;
            };
         }
         style = StyleManager.getStyleDeclaration(".flatChatBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".flatChatBackground",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fillColors = [65797,0];
               this.fillAlphas = [1,1];
            };
         }
         style = StyleManager.getStyleDeclaration(".selectedProfileTab");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".selectedProfileTab",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 6684672;
               this.letterSpacing = 0;
               this.textRollOverColor = 6684672;
            };
         }
         style = StyleManager.getStyleDeclaration(".summonerIconTileList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerIconTileList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "none";
               this.rollOverColor = transparent;
               this.borderThickness = 0;
               this.cornerRadius = 3;
               this.selectionColor = transparent;
            };
         }
         style = StyleManager.getStyleDeclaration("CursorManager");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("CursorManager",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.busyCursor = CursorManager_busyCursor;
               this.onCursor = Cursor;
               this.overCursor = Cursor_Over;
               this.defaultCursor = Cursor;
            };
         }
         style = StyleManager.getStyleDeclaration(".RewardedBeveledCanvas");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".RewardedBeveledCanvas",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_rewards_beveled_canvas_png_90844987;
            };
         }
         style = StyleManager.getStyleDeclaration(".s1FormMessage");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".s1FormMessage",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.borderThickness = 0;
               this.focusAlpha = 0;
               this.textAlign = "center";
               this.fontSize = 17;
               this.backgroundAlpha = 0;
               this.paddingLeft = 0;
               this.paddingRight = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".orange");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".orange",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 14791216;
               this.textRollOverColor = 14791216;
               this.fontSize = 15;
               this.textSelectedColor = 14791216;
               this.skin = OrangeButtonSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".s1Questionaire");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".s1Questionaire",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.selectedOverIcon = _embed_css___________ClientAssets_imageEmbeds_buttons_questionnaire_buttonActive_png_1164934942;
               this.selectedUpIcon = _embed_css___________ClientAssets_imageEmbeds_buttons_questionnaire_buttonActive_png_1164934942;
               this.upIcon = _embed_css___________ClientAssets_imageEmbeds_buttons_questionnaire_buttonUp_png_1094145668;
               this.selectedDownIcon = _embed_css___________ClientAssets_imageEmbeds_buttons_questionnaire_buttonActive_png_1164934942;
               this.focusAlpha = 0;
               this.overIcon = _embed_css___________ClientAssets_imageEmbeds_buttons_questionnaire_buttonOver_png_288878722;
               this.downIcon = _embed_css___________ClientAssets_imageEmbeds_buttons_questionnaire_buttonOver_png_288878722;
            };
         }
         style = StyleManager.getStyleDeclaration(".lifetimeTabs");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".lifetimeTabs",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderColor = 16777215;
               this.backgroundColor = 0;
               this.textRollOverColor = 16777215;
               this.fillColors = [0,3355443];
               this.fillAlphas = [0.1,0.2];
               this.backgroundAlpha = 0.65;
               this.themeColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatLoaderView");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatLoaderView",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".season1");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".season1",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.thumbOffset = 1;
               this.borderColor = 13214268;
               this.trackColors = [13021300,13021300];
               this.iconColor = 13214268;
               this.cornerRadius = 3;
               this.highlightAlphas = [0.2,0];
               this.fillColors = [16249306,15918521,16249306,16249306];
               this.fillAlphas = [1,1,1,1];
               this.themeColor = 13214268;
            };
         }
         style = StyleManager.getStyleDeclaration(".endOfGameStatsText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endOfGameStatsText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".eogAddBuddyButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".eogAddBuddyButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = AddBuddyBtnNew;
            };
         }
         style = StyleManager.getStyleDeclaration(".navigation");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".navigation",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 20;
               this.textSelectedColor = 16777215;
               this.skin = LargeNavigationButtonSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".buddyName");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buddyName",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 11;
            };
         }
         style = StyleManager.getStyleDeclaration(".timeBonusIpGain");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".timeBonusIpGain",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fillColors = [59431,167450];
               this.fillAlphas = [1,1];
            };
         }
         style = StyleManager.getStyleDeclaration(".profileTabBarSelectedTab");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileTabBarSelectedTab",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 4460817;
               this.textRollOverColor = 4460817;
               this.fontSize = 20;
               this.textSelectedColor = 4460817;
            };
         }
         style = StyleManager.getStyleDeclaration(".embeddedChatWindow");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".embeddedChatWindow",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderSkin = StoneTabletSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".tradeTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".tradeTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".championScroll");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championScroll",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.trackSkin = scrollbar_track_v;
               this.thumbSkin = scrollbar_tab_v;
            };
         }
         style = StyleManager.getStyleDeclaration(".whiteComboBoxDropdownList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".whiteComboBoxDropdownList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderSkin = DropDownList;
               this.paddingLeft = 10;
               this.paddingRight = 10;
            };
         }
         style = StyleManager.getStyleDeclaration(".errorMessageTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".errorMessageTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.textDecoration = "underline";
               this.color = 13343830;
               this.textAlign = "center";
               this.left = 0;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 25;
               this.right = 0;
               this.top = 50;
            };
         }
         style = StyleManager.getStyleDeclaration(".mapDescriptionText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".mapDescriptionText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 11119017;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".errorContainer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".errorContainer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = "0xFFFFFF";
               this.backgroundColor = "0x000000";
               this.cornerRadius = 4;
               this.backgroundAlpha = 0.8;
            };
         }
         style = StyleManager.getStyleDeclaration(".invitePanel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".invitePanel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.borderSkin = TextInputSkin;
               this.fontFamily = "ApplicationFont2";
            };
         }
         style = StyleManager.getStyleDeclaration(".popupMessageCanvas");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".popupMessageCanvas",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderColor = 10066329;
               this.borderThickness = 1;
               this.cornerRadius = 5;
               this.fillColors = [922921,0];
               this.borderAlpha = 0.5;
               this.fillAlphas = [0.9,0.9];
               this.backgroundAlpha = 0.9;
            };
         }
         style = StyleManager.getStyleDeclaration(".runeStatsStatName");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runeStatsStatName",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 0;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 11;
            };
         }
         style = StyleManager.getStyleDeclaration(".iconSmallText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".iconSmallText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 9;
            };
         }
         style = StyleManager.getStyleDeclaration(".breadcrumbs");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".breadcrumbs",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".EndOfGameGridScrollBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".EndOfGameGridScrollBar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.thumbDownSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_verticalScrollThumb_png_1498799506;
               this.thumbOverSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_verticalScrollThumb_png_1498799506;
               this.trackSkin = _embed_css___________ClientAssets_imageEmbeds_EndOfGame_EOGScrollTrack_png_973431885;
               this.downArrowSkin = null;
               this.cornerRadius = 3;
               this.thumbDisabledSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_verticalScrollThumb_png_1498799506;
               this.thumbUpSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_verticalScrollThumb_png_1498799506;
               this.upArrowSkin = null;
            };
         }
         style = StyleManager.getStyleDeclaration(".inviteFacebookFriendsBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".inviteFacebookFriendsBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_up_png_1604256082;
               this.fontWeight = "normal";
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_down_png_1520501104;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_over_png_408912100;
               this.color = 15658734;
               this.focusAlpha = 0;
               this.textRollOverColor = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 15;
               this.textSelectedColor = 16777215;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_up_png_1604256082;
            };
         }
         style = StyleManager.getStyleDeclaration(".eogMainTab");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".eogMainTab",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.selectedButtonTextStyleName = "eogMainTabSelectedButton";
               this.buttonStyleName = "eogMainTabButton";
               this.buttonHeight = 30;
            };
         }
         style = StyleManager.getStyleDeclaration(".summonerWizardText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerWizardText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 13343830;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookInviteHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookInviteHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16750848;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 23;
            };
         }
         style = StyleManager.getStyleDeclaration(".championSearchTags");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championSearchTags",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.dropShadowEnabled = true;
               this.color = 15790320;
               this.dropShadowColor = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".spellSelectSelectedLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".spellSelectSelectedLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 40;
            };
         }
         style = StyleManager.getStyleDeclaration(".masteryDetailText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".masteryDetailText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 2236962;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatPlayerNameHeaderInGame");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatPlayerNameHeaderInGame",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13421568;
               this.borderThickness = 0;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".largeGreyButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".largeGreyButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = LargeGreyBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".lockInVoteButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".lockInVoteButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 16;
               this.skin = cs_largeButton;
            };
         }
         style = StyleManager.getStyleDeclaration(".s1FormLinkLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".s1FormLinkLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.focusAlpha = 0;
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".browserBack");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".browserBack",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueBack_up_png_1752350174;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueBack_down_png_1996080420;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueBack_over_png_1459683184;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueBack_over_png_1459683184;
            };
         }
         style = StyleManager.getStyleDeclaration(".superTabSelectedText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".superTabSelectedText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.textDecoration = "underline";
               this.color = 15658734;
            };
         }
         style = StyleManager.getStyleDeclaration(".statsBigStats");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".statsBigStats",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".homeButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".homeButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueHome_up_png_1126336462;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueHome_down_png_116949268;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueHome_over_png_1694156080;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueHome_up_png_1126336462;
            };
         }
         style = StyleManager.getStyleDeclaration(".largeTexturedText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".largeTexturedText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 13343830;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 36;
            };
         }
         style = StyleManager.getStyleDeclaration(".championAbilityPanel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championAbilityPanel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.borderStyle = "none";
               this.color = 16777215;
               this.backgroundColor = "0x000000";
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 12;
               this.backgroundAlpha = 0.8;
            };
         }
         style = StyleManager.getStyleDeclaration(".effectsList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".effectsList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 13343830;
               this.backgroundColor = 0;
               this.cornerRadius = 5;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
               this.backgroundAlpha = 0.8;
            };
         }
         style = StyleManager.getStyleDeclaration(".toolbarAddBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".toolbarAddBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = ToolbarAddBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".thinShortButtonBlue");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".thinShortButtonBlue",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_thinShortButton_blue_up_png_828042718;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_thinShortButton_blue_over_png_395801876;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_thinShortButton_blue_over_png_395801876;
               this.color = 15658734;
               this.focusAlpha = 0;
               this.textRollOverColor = 16777215;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_thinShortButton_grey_up_png_1533575440;
               this.fontSize = 14;
               this.textSelectedColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseMapRendererName");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseMapRendererName",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.fontSizeL = 42;
               this.color = 16777215;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
            };
         }
         style = StyleManager.getStyleDeclaration(".addChatRoomBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".addChatRoomBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addChatButton_up_png_1938260990;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addChatButton_over_png_1369150264;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addChatButton_over_png_1369150264;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_addChatButton_up_png_1938260990;
            };
         }
         style = StyleManager.getStyleDeclaration(".submitLogsFormLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".submitLogsFormLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".kudosButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".kudosButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_eog_thumb_up_png_1856414206;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_eog_thumb_down_png_222853836;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_eog_thumb_hover_png_1890889264;
               this.focusAlpha = 0;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_eog_thumb_disable_png_228981432;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookInviteFriendsDialog");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookInviteFriendsDialog",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundImage = _embed_css___________ClientAssets_imageEmbeds_facebook_addFacebookFriends_menuBackground_png_1819003002;
            };
         }
         style = StyleManager.getStyleDeclaration(".tab");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".tab",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 13;
               this.skin = TabBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".inviteBayRemoveButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".inviteBayRemoveButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 10682368;
               this.textRollOverColor = 10066329;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".whiteBorderSkin");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".whiteBorderSkin",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderSkin = WhiteBorderSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".giftButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".giftButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_up_png_548734898;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_down_png_1976556920;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_over_png_1990165276;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_greyAdd_up_png_1008228492;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueAdd_up_png_548734898;
            };
         }
         style = StyleManager.getStyleDeclaration(".loadingModalMask");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".loadingModalMask",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 0;
               this.backgroundAlpha = 0.6;
            };
         }
         style = StyleManager.getStyleDeclaration(".removeButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".removeButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_up_png_1080871433;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_down_png_1553120907;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_over_png_276846951;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_redClose_over_png_276846951;
            };
         }
         style = StyleManager.getStyleDeclaration(".texturedHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".texturedHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 13343830;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 23;
            };
         }
         style = StyleManager.getStyleDeclaration(".endOfGameHeaderText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endOfGameHeaderText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 39423;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatUserName");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatUserName",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatRolloverBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatRolloverBackground",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fillColors = [4473924,1118481];
               this.fillAlphas = [1,1];
            };
         }
         style = StyleManager.getStyleDeclaration(".talentTreeTotal");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".talentTreeTotal",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 18;
            };
         }
         style = StyleManager.getStyleDeclaration(".TexturedButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".TexturedButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = Button_skin;
            };
         }
         style = StyleManager.getStyleDeclaration(".mySelectedTabs");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".mySelectedTabs",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16750848;
               this.textRollOverColor = 16750950;
            };
         }
         style = StyleManager.getStyleDeclaration(".preferencePopup");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".preferencePopup",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = "0xFFFFFF";
               this.color = "0xFFFFFF";
               this.backgroundColor = "0x000000";
               this.cornerRadius = 4;
               this.borderThickness = 1;
               this.backgroundAlpha = 0.8;
            };
         }
         style = StyleManager.getStyleDeclaration(".formLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".formLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration("ScrollThumb");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ScrollThumb",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = scrollClip;
            };
         }
         style = StyleManager.getStyleDeclaration(".matchDetailsText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".matchDetailsText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13421772;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookOptInBullet");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookOptInBullet",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15263976;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".profileSelectedToggleButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileSelectedToggleButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 4460817;
               this.textRollOverColor = 4460817;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
               this.textSelectedColor = 4460817;
            };
         }
         style = StyleManager.getStyleDeclaration(".ribbonQueueLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ribbonQueueLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".serverPopupBody");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".serverPopupBody",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.borderThickness = 0;
               this.textAlign = "center";
               this.fontSize = 16;
               this.backgroundAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".toggleChatPanelBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".toggleChatPanelBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = CRLLargeBarBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".summonerXPText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerXPText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 23;
            };
         }
         style = StyleManager.getStyleDeclaration(".popupMessageBody");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".popupMessageBody",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.borderThickness = 0;
               this.textAlign = "center";
               this.fontSize = 16;
               this.backgroundAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".buddyListScrollBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buddyListScrollBar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.thumbDownSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_scrollTab_png_1542426484;
               this.thumbOffset = 1;
               this.borderColor = 5592405;
               this.thumbOverSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_scrollTab_png_1542426484;
               this.trackColors = [134682,394506];
               this.trackSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_scrollTrack_png_539614468;
               this.downArrowSkin = null;
               this.cornerRadius = 3;
               this.thumbDisabledSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_scrollTab_png_1542426484;
               this.thumbUpSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_scrollTab_png_1542426484;
               this.upArrowSkin = null;
               this.themeColor = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".championAbilityItemDescription");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championAbilityItemDescription",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textAlign = "left";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookOptInBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookOptInBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_up_png_128781458;
               this.fontWeight = "normal";
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_over_png_170236676;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_over_png_170236676;
               this.color = 15658734;
               this.focusAlpha = 0;
               this.textRollOverColor = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 15;
               this.textSelectedColor = 16777215;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_up_png_128781458;
            };
         }
         style = StyleManager.getStyleDeclaration(".masteryPageTooltipLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".masteryPageTooltipLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration("WindowedApplication");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("WindowedApplication",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 0;
               this.fontFamily = "ApplicationFont2";
               this.backgroundAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".profileHeaderBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileHeaderBackground",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 10058542;
               this.backgroundColor = 16773829;
               this.borderThickness = 1;
               this.backgroundAlpha = 0.5;
            };
         }
         style = StyleManager.getStyleDeclaration(".loginQueueNextUpdateLabel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".loginQueueNextUpdateLabel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.leading = -2;
               this.color = 11184810;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".arrowedAlertText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".arrowedAlertText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookTristanaBGFull");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookTristanaBGFull",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundImage = _embed_css___________ClientAssets_imageEmbeds_facebook_tristFull_png_59629936;
            };
         }
         style = StyleManager.getStyleDeclaration(".blueParchmentTablet");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".blueParchmentTablet",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.borderColor = 5076132;
               this.backgroundColor = 330514;
               this.borderThickness = 1;
               this.cornerRadius = 2;
               this.backgroundAlpha = 0.85;
            };
         }
         style = StyleManager.getStyleDeclaration(".title");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".title",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 11;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookInviteFriendsBullet");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookInviteFriendsBullet",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundImage = _embed_css___________ClientAssets_imageEmbeds_facebook_bullet_png_521728554;
            };
         }
         style = StyleManager.getStyleDeclaration(".largeButtonOrange");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".largeButtonOrange",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_orange_up_png_1387952046;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_orange_over_png_794329564;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_orange_over_png_794329564;
               this.color = 15658734;
               this.focusAlpha = 0;
               this.textRollOverColor = 16777215;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_grey_up_png_260080784;
               this.fontSize = 14;
               this.textSelectedColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".RerollBarTextLevelUp");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".RerollBarTextLevelUp",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15259909;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".lifetimeStatsTabNavigator");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".lifetimeStatsTabNavigator",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.firstTabStyleName = "lifetimeTabs";
               this.borderStyle = "solid";
               this.borderColor = 16777215;
               this.selectedTabTextStyleName = "lifetimeSelectedTabs";
               this.tabStyleName = "lifetimeTabs";
               this.color = 10066329;
               this.backgroundColor = 0;
               this.lastTabStyleName = "lifetimeTabs";
               this.borderThickness = 1;
               this.backgroundAlpha = 0.15;
            };
         }
         style = StyleManager.getStyleDeclaration(".ipBarGold");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".ipBarGold",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 0;
               this.fillColors = [14051355,15856278];
               this.fillAlphas = [1,1];
               this.borderAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".summonerSearchBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerSearchBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_searchFriendButton_up_png_1242593780;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_searchFriendButton_over_png_315365890;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_searchFriendButton_over_png_315365890;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_friendsList_friendList_searchFriendButton_up_png_1242593780;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatLoadingText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatLoadingText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 16;
               this.horizontalCenter = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookListRollover");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookListRollover",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 2975436;
               this.backgroundAlpha = 1;
            };
         }
         style = StyleManager.getStyleDeclaration(".promptButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".promptButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.downSkin = ButtonSkin;
               this.overSkin = ButtonSkin;
               this.selectedDisabledSkin = ButtonSkin;
               this.cornerRadius = 0;
               this.textRollOverColor = 0;
               this.selectedUpSkin = ButtonSkin;
               this.fontSize = 11;
               this.fillAlphas = [1,1,0.75,0.65];
               this.verticalGap = 2;
               this.upSkin = ButtonSkin;
               this.selectedDownSkin = ButtonSkin;
               this.color = 0;
               this.borderThickness = 3;
               this.highlightAlphas = [0.34,0.52];
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fillColors = [52479,52479,65535,65535];
               this.disabledSkin = ButtonSkin;
               this.horizontalGap = 2;
               this.textSelectedColor = 0;
               this.selectedOverSkin = ButtonSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".options");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".options",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 16777215;
               this.backgroundColor = 0;
               this.textRollOverColor = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 20;
               this.textSelectedColor = 16777215;
               this.skin = pvp_frame_optionsbtn;
               this.backgroundAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".browserForward");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".browserForward",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueForward_up_png_777477214;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueForward_down_png_760877616;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueForward_over_png_1856522420;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueForward_over_png_1856522420;
            };
         }
         style = StyleManager.getStyleDeclaration(".infoText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".infoText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 11515060;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".firstWinBonusIpGain");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".firstWinBonusIpGain",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fillColors = [2615528,1740430];
               this.fillAlphas = [1,1];
            };
         }
         style = StyleManager.getStyleDeclaration(".championSkinBrowserHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championSkinBrowserHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontSize = 14;
               this.skin = GroupBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".endOfGameChatCanvas");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endOfGameChatCanvas",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundImage = _embed_css___________ClientAssets_imageEmbeds_EndOfGame_socialBackground_png_2091497570;
            };
         }
         style = StyleManager.getStyleDeclaration(".whiteText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".whiteText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.focusAlpha = 0;
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".sendButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".sendButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = GroupBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".endOfGameMainPanel");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endOfGameMainPanel",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundImage = _embed_css___________ClientAssets_imageEmbeds_EndOfGame_mainPanelOverview_png_1627397366;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatCloseButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatCloseButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.downSkin = ButtonSkin;
               this.overSkin = ButtonSkin;
               this.borderColor = 2236962;
               this.selectedDisabledSkin = ButtonSkin;
               this.cornerRadius = 0;
               this.textRollOverColor = 16777215;
               this.selectedUpSkin = ButtonSkin;
               this.fillAlphas = [0,0,0.63,0.83];
               this.verticalGap = 2;
               this.themeColor = 3355443;
               this.upSkin = ButtonSkin;
               this.selectedDownSkin = ButtonSkin;
               this.color = 16777215;
               this.borderThickness = 3;
               this.highlightAlphas = [0,0];
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fillColors = [0,0,0,3355443];
               this.disabledSkin = ButtonSkin;
               this.horizontalGap = 2;
               this.textSelectedColor = 16777215;
               this.selectedOverSkin = ButtonSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatPromptHistoryUnread");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatPromptHistoryUnread",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 52479;
               this.fontFamily = "ApplicationFont2";
            };
         }
         style = StyleManager.getStyleDeclaration(".largeYellowHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".largeYellowHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 30;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookInviteSubHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookInviteSubHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15263976;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 17;
            };
         }
         style = StyleManager.getStyleDeclaration(".buddyListStatus");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buddyListStatus",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 14540253;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 9;
            };
         }
         style = StyleManager.getStyleDeclaration(".s1FormButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".s1FormButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_up_png_1604256082;
               this.fontWeight = "normal";
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_over_png_408912100;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_blue_over_png_408912100;
               this.color = 15658734;
               this.focusAlpha = 0;
               this.textRollOverColor = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_grey_up_png_1201506856;
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".inviteGrid");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".inviteGrid",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "none";
               this.backgroundColor = 0;
               this.rollOverColor = 274764;
               this.textRollOverColor = 13487565;
               this.headerHeight = 38;
               this.fontSize = 13;
               this.selectionColor = 274764;
               this.backgroundAlpha = 0;
               this.fontWeight = "normal";
               this.color = 13421772;
               this.alpha = 0;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont1";
               this.textSelectedColor = 13487565;
            };
         }
         style = StyleManager.getStyleDeclaration(".boostToolTipLabelText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".boostToolTipLabelText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 40191;
               this.textAlign = "left";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".talentToolTipReqDescText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".talentToolTipReqDescText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.letterSpacing = 0;
               this.color = 16711680;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 10;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookOptInCongratsHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookOptInCongratsHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16693760;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 34;
            };
         }
         style = StyleManager.getStyleDeclaration(".summonerInfoSubHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerInfoSubHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.dropShadowEnabled = true;
               this.color = 15790320;
               this.dropShadowColor = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".inviteList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".inviteList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.verticalScrollBarStyleName = "friendInviteScroll";
               this.backgroundColor = 0;
               this.rollOverColor = 2975436;
               this.borderThickness = 0;
               this.focusThickness = 0;
               this.selectionColor = 2975436;
               this.backgroundAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatUserList");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatUserList",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.verticalScrollBarStyleName = "blueGlassScrollBar";
               this.color = 16777215;
               this.backgroundColor = 1184274;
               this.rollOverColor = 2982911;
               this.borderThickness = 0;
               this.fontFamily = "ApplicationFont2";
               this.focusThickness = 0;
               this.fontSize = 13;
               this.selectionColor = 2982911;
            };
         }
         style = StyleManager.getStyleDeclaration(".summonerToolTipText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerToolTipText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.leading = 0;
               this.color = 7829367;
               this.borderThickness = 0;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 11;
               this.backgroundAlpha = 0;
            };
         }
         style = StyleManager.getStyleDeclaration("ToolTip");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("ToolTip",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "toolTip";
               this.borderColor = 13421772;
               this.color = 16777215;
               this.backgroundColor = 2236962;
               this.cornerRadius = 4;
               this.borderThickness = 2;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 12;
               this.shadowColor = 0;
               this.backgroundAlpha = 0.8;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatBackground",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.cornerRadius = 4;
               this.fillColors = [3355443,0];
               this.fillAlphas = [1,1];
            };
         }
         style = StyleManager.getStyleDeclaration(".gameOptionsSubTitleText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".gameOptionsSubTitleText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 14540253;
               this.textAlign = "left";
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".finishStreakIpGain");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".finishStreakIpGain",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fillColors = [2556136,1704590];
               this.fillAlphas = [1,1];
            };
         }
         style = StyleManager.getStyleDeclaration(".championViewIconName");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championViewIconName",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".smallButtonOrange");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".smallButtonOrange",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_orange_up_png_1575779582;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_orange_over_png_1586148332;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_orange_over_png_1586148332;
               this.color = 15658734;
               this.focusAlpha = 0;
               this.textRollOverColor = 16777215;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallButton_grey_up_png_1201506856;
               this.fontSize = 14;
               this.textSelectedColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".buddyListButtonText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".buddyListButtonText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 15658734;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".loginInfoSubHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".loginInfoSubHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 9210759;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 10;
            };
         }
         style = StyleManager.getStyleDeclaration(".blueToggleButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".blueToggleButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13421772;
               this.textRollOverColor = 14540253;
               this.fontSize = 12;
               this.textSelectedColor = 16777215;
               this.skin = TabNavigatorButtonSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".rerollButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".rerollButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_up_png_975416882;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_down_png_226213880;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_blue_over_png_1991982500;
               this.color = 15658734;
               this.focusAlpha = 0;
               this.textRollOverColor = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_largeButton_grey_up_png_454435440;
               this.fontSize = 16;
               this.textSelectedColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".status");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".status",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 15;
            };
         }
         style = StyleManager.getStyleDeclaration(".eogMainTabCN");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".eogMainTabCN",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.selectedButtonTextStyleName = "eogMainTabSelectedButtonCN";
               this.buttonStyleName = "eogMainTabButtonCN";
               this.buttonHeight = 30;
            };
         }
         style = StyleManager.getStyleDeclaration(".blueCloseButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".blueCloseButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueClose_up_png_840917884;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueClose_down_png_1377063182;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueClose_over_png_1845352302;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueClose_up_png_840917884;
            };
         }
         style = StyleManager.getStyleDeclaration(".global");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".global",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.focusAlpha = 0;
               this.fontFamily = "ApplicationFont2";
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseGameNormalTooltip");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseGameNormalTooltip",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 12;
               this.textSelectedColor = 16777215;
               this.skin = pg_tooltip_normal;
            };
         }
         style = StyleManager.getStyleDeclaration(".browserUrlBar");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".browserUrlBar",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "none";
               this.color = 0;
               this.backgroundColor = 16777215;
               this.borderSkin = WhiteBorderSkin;
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".whiteTablet");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".whiteTablet",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "none";
               this.backgroundColor = 16777215;
               this.backgroundAlpha = 0.8;
            };
         }
         style = StyleManager.getStyleDeclaration(".pageForward");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".pageForward",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = PageForwardButtonSkin;
            };
         }
         style = StyleManager.getStyleDeclaration(".formLabelLarge");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".formLabelLarge",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 18;
            };
         }
         style = StyleManager.getStyleDeclaration(".profileTabNav");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileTabNav",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.firstTabStyleName = "profileTabs";
               this.borderStyle = "solid";
               this.borderColor = 12691300;
               this.selectedTabTextStyleName = "selectedProfileTab";
               this.tabStyleName = "profileTabs";
               this.backgroundColor = 12691300;
               this.lastTabStyleName = "profileTabs";
               this.cornerRadius = 0;
               this.horizontalAlign = "left";
               this.textIndent = 0;
               this.tabOffset = 0;
               this.backgroundAlpha = 0.8;
               this.dropShadowEnabled = false;
               this.color = 0;
               this.borderThickness = 1;
               this.horizontalGap = 2;
            };
         }
         style = StyleManager.getStyleDeclaration(".championOverlayTabButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championOverlayTabButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13421772;
               this.textRollOverColor = 14540253;
               this.fontSize = 12;
               this.textSelectedColor = 16777215;
               this.skin = info_tab;
            };
         }
         style = StyleManager.getStyleDeclaration(".summonerToolTipTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerToolTipTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 16;
            };
         }
         style = StyleManager.getStyleDeclaration(".championAbilityItemName");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championAbilityItemName",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 36846;
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".selectQueueGameButton4");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".selectQueueGameButton4",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13421772;
               this.textRollOverColor = 14540253;
               this.fontSize = 12;
               this.textSelectedColor = 16777215;
               this.skin = small_game_button_3v3;
            };
         }
         style = StyleManager.getStyleDeclaration(".selectQueueGameButton1");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".selectQueueGameButton1",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13421772;
               this.textRollOverColor = 14540253;
               this.fontSize = 12;
               this.textSelectedColor = 16777215;
               this.skin = small_game_button_5v5;
            };
         }
         style = StyleManager.getStyleDeclaration(".lifetimeSelectedTabs");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".lifetimeSelectedTabs",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 0;
               this.color = 16750848;
               this.textRollOverColor = 16750950;
               this.backgroundAlpha = 0.15;
            };
         }
         style = StyleManager.getStyleDeclaration(".boostToolTipValueText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".boostToolTipValueText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 11184810;
               this.textAlign = "left";
               this.fontThickness = 1;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".runToolTipNameText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".runToolTipNameText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".scoreboardFriendlyText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".scoreboardFriendlyText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".teamATitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".teamATitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.color = 7935;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 20;
            };
         }
         style = StyleManager.getStyleDeclaration(".delegateInvitePower");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".delegateInvitePower",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueInviteEnable_up_png_91199468;
               this.selectedDownSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueInviteEnable_active_png_785485090;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueInviteEnable_over_png_1487636990;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueInviteEnable_over_png_1487636990;
               this.selectedUpSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueInviteEnable_active_png_785485090;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueInviteEnable_up_png_91199468;
               this.selectedOverSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueInviteEnable_active_png_785485090;
            };
         }
         style = StyleManager.getStyleDeclaration(".contextAlertText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".contextAlertText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".facebookOptInGeneric");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".facebookOptInGeneric",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundImage = _embed_css___________ClientAssets_imageEmbeds_facebook_fbBG_png_1480804536;
            };
         }
         style = StyleManager.getStyleDeclaration(".squareButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".squareButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = squareButton_skin;
            };
         }
         style = StyleManager.getStyleDeclaration(".summonerToolTipContainer");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".summonerToolTipContainer",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderStyle = "solid";
               this.backgroundColor = 0;
               this.borderThickness = 0;
               this.cornerRadius = 5;
            };
         }
         style = StyleManager.getStyleDeclaration(".friendCountFound");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".friendCountFound",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 39423;
               this.textAlign = "right";
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 17;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatPlayerNameHeaderOffline");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatPlayerNameHeaderOffline",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 7368816;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".blueCheckBox");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".blueCheckBox",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.selectedOverIcon = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueCheckboxChecked_png_1453954900;
               this.selectedUpIcon = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueCheckboxChecked_png_1453954900;
               this.upIcon = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueCheckbox_png_1686428822;
               this.selectedDownIcon = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueCheckbox_png_1686428822;
               this.fontFamily = "ApplicationFont2";
               this.overIcon = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueCheckbox_png_1686428822;
               this.fontSize = 14;
               this.downIcon = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_blueCheckboxChecked_png_1453954900;
            };
         }
         style = StyleManager.getStyleDeclaration(".longButtonBlue");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".longButtonBlue",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_blue_up_png_348001883;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_blue_over_png_1820662173;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_blue_over_png_1820662173;
               this.color = 15658734;
               this.focusAlpha = 0;
               this.textRollOverColor = 16777215;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_longButton_grey_up_png_1807695571;
               this.fontSize = 14;
               this.textSelectedColor = 16777215;
            };
         }
         style = StyleManager.getStyleDeclaration(".itemTooltipDesc");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".itemTooltipDesc",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".eogMainTabButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".eogMainTabButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_EndOfGame_tabUnselected_png_430834958;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_EndOfGame_tabUnselected_png_430834958;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_EndOfGame_tabUnselected_png_430834958;
               this.color = 15658734;
               this.textRollOverColor = 15658734;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
               this.disabledSkin = _embed_css___________ClientAssets_imageEmbeds_EndOfGame_tabUnselected_png_430834958;
               this.textSelectedColor = 15658734;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_EndOfGame_tabSelected_png_806974748;
            };
         }
         style = StyleManager.getStyleDeclaration(".eogScoreboardCanvas");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".eogScoreboardCanvas",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundImage = _embed_css___________ClientAssets_imageEmbeds_EndOfGame_scoreboardBack_png_1445792034;
            };
         }
         style = StyleManager.getStyleDeclaration(".chatScroll");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chatScroll",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.thumbOffset = 1;
               this.borderColor = 996439;
               this.trackColors = [134682,66826];
               this.iconColor = 8514;
               this.cornerRadius = 3;
               this.highlightAlphas = [0.2,0];
               this.fillColors = [2125235,13411,4561382,13411];
               this.fillAlphas = [1,1,1,1];
               this.themeColor = 3965897;
            };
         }
         style = StyleManager.getStyleDeclaration(".editMasteriesButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".editMasteriesButton",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.upSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueEdit_up_png_1351820936;
               this.downSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueEdit_down_png_1220216098;
               this.overSkin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueEdit_over_png_324543870;
               this.skin = _embed_css___________ClientAssets_imageEmbeds_buttons_smallSquareButton_blueEdit_up_png_1351820936;
            };
         }
         style = StyleManager.getStyleDeclaration(".dataGridHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".dataGridHeader",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.rollOverColor = 16777215;
               this.textRollOverColor = 16777215;
               this.backgroundGradientColors = [2112092,1187891];
            };
         }
         style = StyleManager.getStyleDeclaration(".championStatsGraphColumnChart");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".championStatsGraphColumnChart",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 0;
               this.fontFamily = "ApplicationFont1";
            };
         }
         style = StyleManager.getStyleDeclaration(".dockedChatTabActive");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".dockedChatTabActive",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderSkin = _embed_css___________ClientAssets_imageEmbeds_CommonComponents_dockedChatBlendTab_png_1000475630;
            };
         }
         style = StyleManager.getStyleDeclaration(".rssFeedEntryTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".rssFeedEntryTitle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 18;
            };
         }
         style = StyleManager.getStyleDeclaration(".endofGameStatsRadioButtons");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".endofGameStatsRadioButtons",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 12;
            };
         }
         style = StyleManager.getStyleDeclaration(".rankedTeamCenteredText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".rankedTeamCenteredText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".toolbarPopoutBtn");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".toolbarPopoutBtn",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = ToolbarPopoutBtn;
            };
         }
         style = StyleManager.getStyleDeclaration(".spellDetailViewText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".spellDetailViewText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 10057489;
               this.textAlign = "center";
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 20;
            };
         }
         style = StyleManager.getStyleDeclaration(".XPBarText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".XPBarText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15658734;
               this.fontFamily = "ApplicationFont1";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".profileTabs");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".profileTabs",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderColor = 12691300;
               this.color = 2762265;
               this.backgroundColor = 12691300;
               this.cornerRadius = 4;
               this.textRollOverColor = 2762265;
               this.highlightAlphas = [0,0];
               this.fillColors = [12760727,12760727];
               this.fillAlphas = [0.8,0.8];
               this.themeColor = 12691300;
               this.backgroundAlpha = 0.8;
            };
         }
         style = StyleManager.getStyleDeclaration(".chooseCustomGameTooltip");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".chooseCustomGameTooltip",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.textRollOverColor = 16777215;
               this.fontSize = 12;
               this.textSelectedColor = 16777215;
               this.skin = pg_tooltip;
            };
         }
         style = StyleManager.getStyleDeclaration(".createGameMapHeading");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".createGameMapHeading",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 14403352;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 14;
            };
         }
         style = StyleManager.getStyleDeclaration(".talentToolTipRankText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".talentToolTipRankText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.letterSpacing = 0;
               this.color = 11360767;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 10;
            };
         }
         style = StyleManager.getStyleDeclaration(".newbieTipHeaderText");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".newbieTipHeaderText",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16769387;
               this.fontFamily = "ApplicationFont2";
               this.fontSize = 13;
            };
         }
         style = StyleManager.getStyleDeclaration(".windowMinimize");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".windowMinimize",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skin = pvp_frame_minimizebtn;
            };
         }
         StyleManager.mx_internal::initProtoChainRoots();
      }
      
      private function handleLoginEvent(param1:LoginEvent) : void
      {
         var _loc2_:ClientDataLoad = null;
         if(!Session.instance.passwordResetLockout)
         {
            _loc2_ = new ClientDataLoad();
            _loc2_.getCompleted().add(this.onDataLoadOperationsComplete);
            _loc2_.getErred().add(this.dataLoadErredHandler);
            _loc2_.invoke();
         }
         else
         {
            this.onDataLoadOperationsComplete();
         }
      }
      
      private function handleMainViewReady() : void
      {
         this.frameParent.visible = this.frameParent.includeInLayout = false;
      }
      
      override protected function onSecondaryResourcesLoaded() : void
      {
         ProviderLookup.getProvider(IMainProvider,this.onMainLoaded);
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         super.initialize();
      }
      
      private function loginCompleteCallShellDispatcher() : void
      {
         this.handleLoginEvent(null);
      }
      
      private function preventUserMaximize(param1:NativeWindowDisplayStateEvent) : void
      {
         if(param1.afterDisplayState == NativeWindowDisplayState.MAXIMIZED)
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            stage.nativeWindow.restore();
         }
      }
      
      private function dataLoadErredHandler(param1:IAction) : void
      {
         this.logger.error(param1.getError().message);
      }
      
      public function ___ClientWindow_BaseShell1_displayStateChanging(param1:NativeWindowDisplayStateEvent) : void
      {
         this.preventUserMaximize(param1);
      }
      
      private function onLoginModuleError(param1:Error) : void
      {
         var _loc2_:String = ":-( You may need to REPAIR your install.\n(Login Module Error)\n" + param1.message;
         fatalError(_loc2_);
      }
      
      override protected function initializeRiotModules() : void
      {
         super.initializeRiotModules();
         var _loc1_:UIComponent = new UIComponent();
         mainBox.addChild(_loc1_);
         this.parentProxy = new DeprecatedParentProxy(_loc1_);
         var _loc2_:IToolTipManager = TipsProviderProxy.instance.createWindowToolTipManager(this.parentProxy);
         this.parentProxy.registerToolTipManager(_loc2_);
         ShellDispatcher.instance.addEventListener(LoginEvent.LOGIN,this.handleLoginEvent);
         this.loadLoginModule();
         loadSecondaryResources();
      }
   }
}

