package com.riotgames.pvpnet.matchhistoryiron.ironviews
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.components.button.LabelButtonX;
   import blix.components.text.Text;
   import blix.components.tooltip.IToolTipManager;
   import blix.context.IContext;
   import blix.ds.ListX;
   import blix.layout.LayoutContainerView;
   import blix.layout.algorithms.VerticalLayout;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.AccountSummary;
   import com.riotgames.platform.gameclient.domain.PlayerGameStats;
   import com.riotgames.platform.module.RiotModuleInfo;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLinkage;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLocalization;
   import com.riotgames.pvpnet.matchhistoryiron.legacyviews.MatchHistoryGameDataGroupLegacyView;
   import com.riotgames.pvpnet.matchhistoryiron.legacyviews.MatchHistoryStatContainerLegacyView;
   import com.riotgames.pvpnet.matchhistoryiron.model.MatchHistoryModel;
   import com.riotgames.pvpnet.matchhistoryiron.model.MatchHistoryStatModel;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.rust.components.sidebar.INestedScreen;
   import com.riotgames.rust.module.RiotModuleView;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextFieldAutoSize;
   import mx.utils.StringUtil;
   
   public class MatchHistoryIronView extends RiotModuleView implements INestedScreen
   {
      
      private var _hideCompleted:Signal = new Signal();
      
      private var _moduleInfo:RiotModuleInfo;
      
      private var _assetsUrlRequest:URLRequest;
      
      private var _model:MatchHistoryModel;
      
      private var _gameContainer:MatchHistoryGameDataGroupLegacyView;
      
      private var _gameContainerLong:MatchHistoryGameDataGroupLegacyView;
      
      private var _statContainer:MatchHistoryStatContainerLegacyView;
      
      private var _tooltipContainer:DisplayObjectContainerProxy;
      
      private var _launchMatchHistoryButton:ButtonX;
      
      private var _hybridMatchHistoryButton:LabelButtonX;
      
      private var _matchHistoryUrlTemplate:ConfigurationModel;
      
      private var _matchHistoryEnabled:ConfigurationModel;
      
      private var _matchDetailsUrlTemplate:ConfigurationModel;
      
      private var _newMatchHistoryTitle1:Text;
      
      private var _newMatchHistoryTitle2:Text;
      
      private var _newMatchHistoryDesc:Text;
      
      private var _newMatchHistoryBullet1Text:Text;
      
      private var _newMatchHistoryBullet2Text:Text;
      
      private var _newMatchHistoryBullet3Text:Text;
      
      private var _newMatchHistoryDirectionsText:Text;
      
      private var _newMatchHistoryBullet1:SpriteProxy;
      
      private var _newMatchHistoryBullet2:SpriteProxy;
      
      private var _newMatchHistoryBullet3:SpriteProxy;
      
      private var _newMatchHistoryButtonText:Text;
      
      private var _newMatchHistoryBulletContainer:LayoutContainerView;
      
      private var _gameClickDescription:Text;
      
      private var _gameContainerSizer:SpriteProxy;
      
      private var _size:Point = new Point();
      
      public function MatchHistoryIronView(param1:IContext, param2:RiotModuleInfo, param3:MatchHistoryModel)
      {
         this._model = param3;
         this._moduleInfo = param2;
         super(param1);
         var _loc4_:String = ClientConfig.instance.locale;
         if(_loc4_ == "zh_CN" || _loc4_ == "zh_MY" || _loc4_ == "zh_TW")
         {
            setLinkagePostfix("_chinese");
         }
         setLinkage(EMatchHistoryLinkage.MAIN_LINKAGE);
         registerDependency(IToolTipManager,TipsProviderProxy.instance.createWindowToolTipManager(this));
         this._matchHistoryEnabled = DynamicClientConfigManager.getConfiguration("ShareMatchHistory","matchHistoryEnabled",false,this.onConfigChange);
         this._matchHistoryUrlTemplate = DynamicClientConfigManager.getConfiguration("ShareMatchHistory","matchHistoryUrlTemplate","",this.onConfigChange);
         this._matchDetailsUrlTemplate = DynamicClientConfigManager.getConfiguration("ShareMatchHistory","matchDetailsUrlTemplate","",this.onConfigChange);
         this.onConfigChange();
      }
      
      private function onConfigChange() : void
      {
         var _loc1_:String = ClientConfig.instance.locale.substr(0,2);
         var _loc2_:String = RiotResourceLoader.getString("endOfGame_shareGameButton_locale",_loc1_);
         var _loc3_:Boolean = Boolean(this._matchHistoryEnabled.getBoolean()) && this._matchHistoryUrlTemplate.getString() != "" && _loc2_ != "";
         if(_loc3_)
         {
            setCurrentState("InlineMatchHistory");
         }
         else
         {
            setCurrentState("DefaultMatchHistory");
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._gameContainerSizer = new SpriteProxy(this);
         this._gameContainerSizer.getAssetChanged().add(this.onSizerAssigned);
         this._gameContainer = new MatchHistoryGameDataGroupLegacyView(this,"");
         this._statContainer = new MatchHistoryStatContainerLegacyView(this);
         this._gameContainer.onGameClicked.add(this.onGameClicked);
         this._gameContainer.setModel(this._model);
         this._gameContainer.getLayoutInvalidated().add(invalidateLayout);
         this._gameContainerLong = new MatchHistoryGameDataGroupLegacyView(this,"Long");
         this._gameContainerLong.onGameClicked.add(this.onGameClicked);
         this._gameContainerLong.setModel(this._model);
         this._gameContainerLong.getLayoutInvalidated().add(invalidateLayout);
         this._launchMatchHistoryButton = new ButtonX(this);
         this._launchMatchHistoryButton.addEventListener(MouseEvent.CLICK,this.onLaunchMatchHistory);
         this._hybridMatchHistoryButton = new LabelButtonX(this);
         this._hybridMatchHistoryButton.addEventListener(MouseEvent.CLICK,this.onLaunchMatchHistory);
         this._hybridMatchHistoryButton.setText(EMatchHistoryLocalization.getLocalizedString(EMatchHistoryLocalization.SHARE_MATCH_HISTORY_BUTTON_TEXT_SHORT));
         this._newMatchHistoryTitle1 = new Text(this);
         this._newMatchHistoryTitle1.setText(EMatchHistoryLocalization.getLocalizedString(EMatchHistoryLocalization.SHARE_MATCH_HISTORY_TITLE1));
         this._newMatchHistoryTitle2 = new Text(this);
         this._newMatchHistoryTitle2.setText(EMatchHistoryLocalization.getLocalizedString(EMatchHistoryLocalization.SHARE_MATCH_HISTORY_TITLE2));
         this._newMatchHistoryDesc = new Text(this);
         this._newMatchHistoryDesc.setText(EMatchHistoryLocalization.getLocalizedString(EMatchHistoryLocalization.SHARE_MATCH_HISTORY_DESC));
         this._gameClickDescription = new Text(this);
         this._gameClickDescription.setText(EMatchHistoryLocalization.getLocalizedString(EMatchHistoryLocalization.GAME_CLICK_DESCRIPTION_TEXT));
         this._newMatchHistoryBullet1Text = new Text(this);
         this._newMatchHistoryBullet1Text.setAutoSize(TextFieldAutoSize.LEFT);
         this._newMatchHistoryBullet1Text.setText(EMatchHistoryLocalization.getLocalizedString(EMatchHistoryLocalization.SHARE_MATCH_HISTORY_BULLET1));
         this._newMatchHistoryBullet2Text = new Text(this);
         this._newMatchHistoryBullet2Text.setAutoSize(TextFieldAutoSize.LEFT);
         this._newMatchHistoryBullet2Text.setText(EMatchHistoryLocalization.getLocalizedString(EMatchHistoryLocalization.SHARE_MATCH_HISTORY_BULLET2));
         this._newMatchHistoryBullet3Text = new Text(this);
         this._newMatchHistoryBullet3Text.setAutoSize(TextFieldAutoSize.LEFT);
         this._newMatchHistoryBullet3Text.setText(EMatchHistoryLocalization.getLocalizedString(EMatchHistoryLocalization.SHARE_MATCH_HISTORY_BULLET3));
         this._newMatchHistoryDirectionsText = new Text(this);
         this._newMatchHistoryDirectionsText.setAutoSize(TextFieldAutoSize.LEFT);
         this._newMatchHistoryDirectionsText.setText(EMatchHistoryLocalization.getLocalizedString(EMatchHistoryLocalization.SHARE_MATCH_HISTORY_DIRECTIONS));
         this._newMatchHistoryButtonText = new Text(this);
         this._newMatchHistoryButtonText.setText(EMatchHistoryLocalization.getLocalizedString(EMatchHistoryLocalization.SHARE_MATCH_HISTORY_BUTTON_TEXT));
         this._newMatchHistoryBullet1 = new SpriteProxy(this);
         this._newMatchHistoryBullet2 = new SpriteProxy(this);
         this._newMatchHistoryBullet3 = new SpriteProxy(this);
         this._newMatchHistoryBulletContainer = new LayoutContainerView(this);
         var _loc1_:VerticalLayout = new VerticalLayout();
         this._newMatchHistoryBulletContainer.setLayoutAlgorithm(_loc1_);
         this._newMatchHistoryBulletContainer.addElement(this._newMatchHistoryBullet1);
         this._newMatchHistoryBulletContainer.addElement(this._newMatchHistoryBullet2);
         this._newMatchHistoryBulletContainer.addElement(this._newMatchHistoryBullet3);
         this.setTimelineChildren();
      }
      
      private function onLaunchMatchHistory(param1:Event) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc2_:String = this._matchHistoryUrlTemplate.getString();
         var _loc3_:String = ClientConfig.instance.locale.substr(0,2);
         _loc3_ = RiotResourceLoader.getString("endOfGame_shareGameButton_locale",_loc3_);
         if(_loc3_ != "" && _loc2_ != "")
         {
            _loc4_ = this._model.accountId;
            _loc5_ = null;
            _loc6_ = StringUtil.substitute(_loc2_,_loc4_,_loc5_,_loc3_);
            navigateToURL(new URLRequest(_loc6_),"_blank");
         }
      }
      
      private function onSizerAssigned() : void
      {
         this._size.x = this._gameContainerSizer.getWidth();
         this._size.y = this._gameContainerSizer.getHeight();
         invalidateLayout();
      }
      
      private function setTimelineChildren() : void
      {
         setTimelineChildByName(EMatchHistoryLinkage.GAME_CONTAINER_VIEW,this._gameContainer);
         setTimelineChildByName(EMatchHistoryLinkage.GAME_CONTAINER_LONG_VIEW,this._gameContainerLong);
         setTimelineChildByName(EMatchHistoryLinkage.STAT_CONTAINER_VIEW,this._statContainer);
         setTimelineChildByName(EMatchHistoryLinkage.GAME_CONTAINER_SIZER,this._gameContainerSizer);
         setTimelineChildByName(EMatchHistoryLinkage.LAUNCH_MATCH_HISTORY_BUTTON,this._launchMatchHistoryButton);
         setTimelineChildByName(EMatchHistoryLinkage.HYBRID_MATCH_HISTORY_BUTTON,this._hybridMatchHistoryButton);
         setTimelineChildByName(EMatchHistoryLinkage.LAUNCH_MATCH_HISTORY_TITLE1,this._newMatchHistoryTitle1);
         setTimelineChildByName(EMatchHistoryLinkage.LAUNCH_MATCH_HISTORY_TITLE2,this._newMatchHistoryTitle2);
         setTimelineChildByName(EMatchHistoryLinkage.LAUNCH_MATCH_HISTORY_DESC,this._newMatchHistoryDesc);
         setTimelineChildByName(EMatchHistoryLinkage.LAUNCH_MATCH_HISTORY_BULLET_CONTAINER,this._newMatchHistoryBulletContainer);
         setTimelineChildByName(EMatchHistoryLinkage.LAUNCH_MATCH_HISTORY_BUTTON_TEXT,this._newMatchHistoryButtonText);
         this._newMatchHistoryBulletContainer.setTimelineChildByName(EMatchHistoryLinkage.LAUNCH_MATCH_HISTORY_BULLET1,this._newMatchHistoryBullet1);
         this._newMatchHistoryBulletContainer.setTimelineChildByName(EMatchHistoryLinkage.LAUNCH_MATCH_HISTORY_BULLET2,this._newMatchHistoryBullet2);
         this._newMatchHistoryBulletContainer.setTimelineChildByName(EMatchHistoryLinkage.LAUNCH_MATCH_HISTORY_BULLET3,this._newMatchHistoryBullet3);
         this._newMatchHistoryBullet1.setTimelineChildByName(EMatchHistoryLinkage.LAUNCH_MATCH_HISTORY_BULLET1_TEXT,this._newMatchHistoryBullet1Text);
         this._newMatchHistoryBullet2.setTimelineChildByName(EMatchHistoryLinkage.LAUNCH_MATCH_HISTORY_BULLET2_TEXT,this._newMatchHistoryBullet2Text);
         this._newMatchHistoryBullet3.setTimelineChildByName(EMatchHistoryLinkage.LAUNCH_MATCH_HISTORY_BULLET3_TEXT,this._newMatchHistoryBullet3Text);
         setTimelineChildByName(EMatchHistoryLinkage.LAUNCH_MATCH_HISTORY_DIRECTIONS,this._newMatchHistoryDirectionsText);
         setTimelineChildByName(EMatchHistoryLinkage.GAME_CLICK_DESCRIPTION,this._gameClickDescription);
      }
      
      private function onGameClicked(param1:MatchHistoryStatModel) : void
      {
         if(this._statContainer.getIsOnStage())
         {
            this._statContainer.updateView(param1);
         }
         else
         {
            this.navigateToMatchHistoryPage(param1);
         }
      }
      
      private function navigateToMatchHistoryPage(param1:MatchHistoryStatModel) : void
      {
         var _loc3_:URLRequest = null;
         var _loc2_:String = this.buildMatchURL(param1);
         if(_loc2_)
         {
            _loc3_ = new URLRequest(_loc2_);
            navigateToURL(_loc3_);
         }
      }
      
      private function buildMatchURL(param1:MatchHistoryStatModel) : String
      {
         var _loc2_:Session = Session.instance;
         var _loc3_:AccountSummary = _loc2_.accountSummary;
         var _loc4_:Number = this._model.accountId;
         var _loc5_:PlayerGameStats = param1.stat;
         var _loc6_:Number = Number(_loc5_.gameId);
         var _loc7_:ClientConfig = ClientConfig.instance;
         var _loc8_:String = _loc7_.locale;
         var _loc9_:String = _loc8_.substr(0,2);
         var _loc10_:String = RiotResourceLoader.getString("endOfGame_shareGameButton_locale",_loc9_);
         var _loc11_:String = this._matchDetailsUrlTemplate.getString();
         var _loc12_:String = _loc11_.replace("{2}",_loc10_);
         var _loc13_:String = _loc12_.replace("{0}",_loc6_);
         var _loc14_:String = _loc13_.replace("{1}",_loc4_);
         if(!_loc11_ || !_loc6_ || !_loc10_ || !_loc4_)
         {
            return "";
         }
         return _loc14_;
      }
      
      public function show() : void
      {
         this.cleanView();
         this._assetsUrlRequest = getThemeAssetUrl(this._moduleInfo.getPath(),"matchHistoryAssets.swf");
         loadAssets(this._assetsUrlRequest);
      }
      
      private function cleanView() : void
      {
         this._gameContainer.invalidateCache();
         this._gameContainer.setDataProvider(new ListX(new Array()));
         this._statContainer.cleanView();
         this._gameContainerLong.invalidateCache();
         this._gameContainerLong.setDataProvider(new ListX(new Array()));
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._gameContainer.setExplicitSize(this._size.x,this._size.y);
         this._gameContainer.setScrollRect(new Rectangle(0,0,this._size.x,this._size.y));
         this._gameContainerLong.setExplicitSize(this._gameContainerSizer.getWidth(),this._gameContainerSizer.getHeight());
         this._gameContainerLong.setScrollRect(new Rectangle(0,0,this._gameContainerSizer.getWidth(),this._gameContainerSizer.getHeight()));
         return super.updateLayout(param1,param2);
      }
      
      public function getHideCompleted() : ISignal
      {
         return this._hideCompleted;
      }
      
      public function hide() : void
      {
         this._hideCompleted.dispatch();
         unloadAssets(this._assetsUrlRequest);
      }
   }
}

