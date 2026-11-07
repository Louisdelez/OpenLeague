package com.riotgames.platform.gameclient.controllers.game.views.itemRenderers
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.championselection.enum.ChampionSelectState;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.controllers.game.event.ChampionSelectionEvent;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionTrade;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import com.riotgames.platform.gameclient.controllers.game.utils.ChampionImages;
   import com.riotgames.platform.gameclient.controllers.game.views.TradeMessagePanel;
   import com.riotgames.platform.gameclient.controllers.game.views.TradeRequestPanel;
   import com.riotgames.platform.gameclient.controllers.game.views.popup.SpellToolTip;
   import com.riotgames.platform.gameclient.domain.BotParticipant;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import com.riotgames.platform.gameclient.kudos.IKudosChampSelectBadgeRenderer;
   import com.riotgames.platform.gameclient.kudos.IKudosFactory;
   import com.riotgames.platform.gameclient.kudos.KudosFactoryProxy;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
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
   import mx.containers.Canvas;
   import mx.controls.Image;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.effects.Fade;
   import mx.effects.Parallel;
   import mx.effects.Sequence;
   import mx.effects.Zoom;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ToolTipEvent;
   import mx.styles.*;
   import mx.utils.StringUtil;
   
   public class ChampionSelectPlayerRenderer extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _1282133823fadeIn:Parallel;
      
      private var spell2_img:Image = null;
      
      private var _2095816831playerSlot:ChampionSelect;
      
      private var _2114901552tradeBtnCanvas:Canvas;
      
      private var _711327457viewProfile_btn:SoundEffectButton;
      
      private var spectatorModeChanged:Boolean = false;
      
      private var _spectatorMode:Boolean = false;
      
      private var tradeRequestPanel:TradeRequestPanel = null;
      
      private var _tradeBtnOver:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object = {};
      
      public var locale:String = "";
      
      protected var participantChampionSelectionChanged:Boolean = false;
      
      public var slotIndex:int = 0;
      
      private var _participantSelection:PlayerSelection;
      
      private var championTrade:ChampionTrade;
      
      public var shouldShowSpellsForSpectator:Boolean = true;
      
      private var spell1_img:Image = null;
      
      private var selectionStateChanged:Boolean = false;
      
      private var badgeRenderer:IKudosChampSelectBadgeRenderer;
      
      private var lastState:String = "";
      
      public var shouldShowChampionForSpectator:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array = [];
      
      private var _canShow:Boolean = true;
      
      private var _975372164playerOutOfSyncImage:Image;
      
      private var tradeMessagePanel:TradeMessagePanel = null;
      
      private var tradeMessageLifeTimeout:uint = 0;
      
      private var champ_img:Image = null;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object = {};
      
      private var _1271196248tradeBtn:cs_tradeButton;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "width":220,
               "height":94,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":ChampionSelect,
                  "id":"playerSlot",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":108,
                        "y":47,
                        "animateFlag":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"playerOutOfSyncImage",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":63,
                        "y":10,
                        "visible":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"tradeBtnCanvas",
                  "stylesFactory":function():void
                  {
                     this.top = "6";
                     this.right = "10";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"childDescriptors":[new UIComponentDescriptor({
                        "type":cs_tradeButton,
                        "id":"tradeBtn",
                        "events":{
                           "mouseOver":"__tradeBtn_mouseOver",
                           "mouseOut":"__tradeBtn_mouseOut",
                           "mouseDown":"__tradeBtn_mouseDown",
                           "mouseUp":"__tradeBtn_mouseUp"
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"visible":false};
                        }
                     })]};
                  }
               }),new UIComponentDescriptor({
                  "type":SoundEffectButton,
                  "id":"viewProfile_btn",
                  "events":{"click":"__viewProfile_btn_click"},
                  "stylesFactory":function():void
                  {
                     this.right = "10";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "y":5,
                        "height":26,
                        "width":26,
                        "styleName":"viewProfileButton",
                        "useHandCursor":true,
                        "buttonMode":true,
                        "visible":false
                     };
                  }
               })]
            };
         }
      });
      
      private var _tradeBtnDown:Boolean = false;
      
      public function ChampionSelectPlayerRenderer()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.width = 220;
         this.height = 94;
         this.clipContent = false;
         this._ChampionSelectPlayerRenderer_Parallel1_i();
         this.addEventListener("creationComplete",this.___ChampionSelectPlayerRenderer_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChampionSelectPlayerRenderer._watcherSetupUtil = param1;
      }
      
      public function set playerSlot(param1:ChampionSelect) : void
      {
         var _loc2_:Object = this._2095816831playerSlot;
         if(_loc2_ !== param1)
         {
            this._2095816831playerSlot = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerSlot",_loc2_,param1));
         }
      }
      
      private function onSelectionStateTextChanged(param1:Event) : void
      {
         this.updateSelectionText();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.badgeRenderer.updateLayout(param1,param2);
      }
      
      private function updateAlpha() : void
      {
         if(!this.participantSelection)
         {
            return;
         }
         if(this.participantSelection.selectionState == GameState.PRE_CHAMPION_SELECTION)
         {
            this.alpha = this.slotIndex == 0 ? 1 : 0.15;
         }
         else if(this.participantSelection.selectionState == GameState.CHAMPION_SELECTION)
         {
            this.alpha = this.participantSelection.participant.pickMode == GameParticipant.PICK_MODE_ACTIVE ? 1 : 0.5;
            if(this.participantSelection.participant is BotParticipant)
            {
               this.alpha = 1;
            }
         }
         else
         {
            this.alpha = 1;
         }
      }
      
      public function __tradeBtn_mouseUp(param1:MouseEvent) : void
      {
         this.onTradeMouseUp();
      }
      
      protected function setParticipantSelection() : void
      {
         if(!this.participantSelection)
         {
            this.playerSlot.animateFlag = false;
         }
         else
         {
            this.visible = true;
            this.participantSelection.addEventListener("championTradeChanged",this.onTradeRecipientChanged,false,0,true);
            this.participantSelection.addEventListener("championChanged",this.onChampionChanged,false,0,true);
            this.participantSelection.addEventListener("selectionStateChanged",this.onSelectionStateChanged,false,0,true);
            this.participantSelection.addEventListener("selectionStateTextChanged",this.onSelectionStateTextChanged,false,0,true);
            this.participantSelection.addEventListener("isInSyncChanged",this.onIsInSyncChanged,false,0,true);
            this.participantSelection.addEventListener("tradeAvailableChanged",this.onTradeAvailableChanged,false,0,true);
            this.participantSelection.addEventListener(PlayerSelection.TRADE_ACTIVE_CHANGED,this.onTradeAvailableChanged,false,0,true);
            this.participantSelection.addEventListener("gameStatChanged",this.onGameStateChanged,false,0,true);
            this.participantSelection.addEventListener("badgesChanged",this.updateBadgeRenderer,false,0,true);
            this.playerSlot.animateFlag = UserPreferencesManager.userPrefs.enableAnimations;
            if(this.participantSelection.champion)
            {
               this.participantSelection.addEventListener("spell1Changed",this.onSpell1Changed,false,0,true);
               this.participantSelection.addEventListener("spell2Changed",this.onSpell2Changed,false,0,true);
               this.onSpell1Changed(null);
               this.onSpell2Changed(null);
            }
         }
         this.updateOutOfSyncImage();
         this.updateTradeAvailable();
         this.updateViewProfileButton();
         this.updateAlpha();
         this.updateSelectionText();
         this.selectionStateChanged = true;
         this.updateChampion();
         this.invalidateProperties();
      }
      
      private function destroyTradeMessage() : void
      {
         if(this.tradeMessagePanel == null)
         {
            return;
         }
         this.removeChild(this.tradeMessagePanel);
         this.tradeMessagePanel = null;
         if(this.tradeMessageLifeTimeout > 0)
         {
            clearTimeout(this.tradeMessageLifeTimeout);
            this.tradeMessageLifeTimeout = 0;
         }
      }
      
      private function createTradeMessage() : void
      {
         if(this.tradeMessagePanel != null)
         {
            return;
         }
         this.tradeMessagePanel = new TradeMessagePanel();
         this.tradeMessagePanel.message = this.championTrade.tradeMessage;
         this.tradeMessagePanel.title = this.championTrade.tradeTitle;
         this.tradeMessagePanel.x = 170;
         this.tradeMessagePanel.y = -18;
         this.addChild(this.tradeMessagePanel);
         if(UserPreferencesManager.userPrefs.enableAnimations)
         {
            this.fadeIn.play([this.tradeMessagePanel]);
         }
      }
      
      protected function addNewChampionTradeListeners() : void
      {
         if(!this.participantSelection)
         {
            return;
         }
         this.championTrade = this.participantSelection.championTrade;
         if(!this.championTrade)
         {
            return;
         }
         this.championTrade.addEventListener(ChampionTrade.PENDING_TRADE_CHANGED,this.onPendingTradeChanged);
         this.championTrade.addEventListener(ChampionTrade.TRADE_MESSAGE_CHANGED,this.onTradeMessageChanged);
         this.championTrade.addEventListener(ChampionTrade.TRADE_TITLE_CHANGED,this.onTradeTitleChanged);
      }
      
      private function throwTrade(param1:ChampionSelectionEvent) : void
      {
         this.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get viewProfile_btn() : SoundEffectButton
      {
         return this._711327457viewProfile_btn;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:IKudosFactory = null;
         super.createChildren();
         if(this.playerSlot)
         {
            this.initializePlayerSlot();
            if(Boolean(this.playerSlot.slotName_mc) && Boolean(this.playerSlot.slotName_mc.label_txt))
            {
               this.playerSlot.slotName_mc.label_txt.embedFonts = true;
               this.playerSlot.slotRating_mc.label_txt.embedFonts = true;
               this.setupTextFormat();
            }
         }
         this.updateViewProfileButton();
         this.spectatorModeChanged = false;
         if(!this.badgeRenderer)
         {
            _loc1_ = KudosFactoryProxy.getInstance();
            this.badgeRenderer = _loc1_.getChampSelectBadgeRenderer();
            this.badgeRenderer.addAsChildOf(this);
         }
      }
      
      protected function onChampionChanged(param1:Event) : void
      {
         this.selectionStateChanged = true;
         this.participantSelection.addEventListener("spell1Changed",this.onSpell1Changed,false,0,true);
         this.participantSelection.addEventListener("spell2Changed",this.onSpell2Changed,false,0,true);
         this.updateSelectionText();
         this.updateChampion();
         this.onSpell1Changed(null);
         this.onSpell2Changed(null);
         this.invalidateProperties();
      }
      
      private function initializePlayerSlot() : void
      {
         this.champ_img = new Image();
         this.champ_img.source = null;
         this.champ_img.buttonMode = true;
         this.champ_img.useHandCursor = true;
         this.champ_img.autoLoad = true;
         this.champ_img.addEventListener(MouseEvent.CLICK,this.onChampClicked);
         this.spell1_img = new Image();
         this.spell1_img.source = null;
         this.spell1_img.autoLoad = true;
         this.spell1_img.toolTip = "unused";
         this.spell1_img.addEventListener(ToolTipEvent.TOOL_TIP_CREATE,this.onSpell1TooltipCreate);
         this.spell2_img = new Image();
         this.spell2_img.source = null;
         this.spell2_img.autoLoad = true;
         this.spell2_img.toolTip = "unused";
         this.spell2_img.addEventListener(ToolTipEvent.TOOL_TIP_CREATE,this.onSpell2TooltipCreate);
         this.playerSlot.setSlotItem(0,this.champ_img,this.spell1_img,this.spell2_img);
         this.playerSlot.currentState = ChampionSelectState.CHAMPION_SELECT_STATE_INACTIVEOTHER;
      }
      
      public function get spectatorMode() : Boolean
      {
         return this._spectatorMode;
      }
      
      protected function removeParticipantSelection() : void
      {
         if(!this.participantSelection)
         {
            return;
         }
         this.spell1_img.source = null;
         this.spell2_img.source = null;
         this.champ_img.toolTip = "";
         this.champ_img.source = null;
         this.participantSelection.removeEventListener("championTradeChanged",this.onTradeRecipientChanged);
         this.participantSelection.removeEventListener("championChanged",this.onChampionChanged);
         this.participantSelection.removeEventListener("spell1Changed",this.onSpell1Changed);
         this.participantSelection.removeEventListener("spell2Changed",this.onSpell2Changed);
         this.participantSelection.removeEventListener("selectionStateChanged",this.onSelectionStateChanged);
         this.participantSelection.removeEventListener("selectionStateTextChanged",this.onSelectionStateTextChanged);
         this.participantSelection.removeEventListener("isInSyncChanged",this.onIsInSyncChanged);
         this.participantSelection.removeEventListener("gameStatChanged",this.onGameStateChanged);
         this.participantSelection.removeEventListener("badgesChanged",this.updateBadgeRenderer);
      }
      
      protected function onTradeRecipientChanged(param1:Event) : void
      {
         this.removeOldChampionTradeListeners();
         this.addNewChampionTradeListeners();
         this.createMessage();
      }
      
      public function set participantSelection(param1:PlayerSelection) : void
      {
         if(this._participantSelection == param1)
         {
            return;
         }
         this.removeParticipantSelection();
         this._participantSelection = param1;
         this.setParticipantSelection();
         this.participantChampionSelectionChanged = true;
         this.invalidateProperties();
      }
      
      private function onIsInSyncChanged(param1:Event) : void
      {
         this.updateOutOfSyncImage();
      }
      
      private function updateBadgeRenderer(param1:Event = null) : void
      {
         var _loc2_:GameParticipant = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         if(this.participantSelection)
         {
            _loc2_ = this.participantSelection.participant;
         }
         if(_loc2_)
         {
            _loc3_ = int(_loc2_.getBadges());
            _loc4_ = int(_loc2_.team);
            _loc5_ = Boolean(this.badgeRenderer.displayAppropriateBadge(_loc3_,_loc4_,this.spectatorMode));
            this.playerSlot.bg_mc.commend_champ_frame.visible = _loc5_;
         }
         else
         {
            this.badgeRenderer.displayAppropriateBadge(0,0,false);
            this.playerSlot.bg_mc.commend_champ_frame.visible = false;
         }
      }
      
      private function onTradeMouseOut() : void
      {
         if(!this.tradeBtn)
         {
            return;
         }
         this._tradeBtnOver = false;
         this._tradeBtnDown = false;
         this.updateTradeMouseState();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.participantSelection = data as PlayerSelection;
      }
      
      public function ___ChampionSelectPlayerRenderer_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.setParticipantSelection();
      }
      
      [Bindable(event="propertyChange")]
      public function get tradeBtn() : cs_tradeButton
      {
         return this._1271196248tradeBtn;
      }
      
      private function updateChampion() : void
      {
         var _loc1_:String = "";
         var _loc2_:String = null;
         if(this.participantSelection != null)
         {
            if(this.participantSelection.champion != null)
            {
               if(this.participantSelection.champion.isWildCardChampion())
               {
                  _loc1_ = this.participantSelection.champion.displayName;
               }
               else
               {
                  _loc1_ = RiotResourceLoader.getString("championSelection_player_champIcon_tooltip","championSelection_player_champIcon_tooltip",[this.participantSelection.champion.displayName]);
               }
               _loc2_ = ChampionImages.getIconPath(this.participantSelection.champion.skinName);
               this.updateTradeRequestPanel();
            }
            else if(this.participantSelection.defaultChampionVisualName != null)
            {
               _loc2_ = ChampionImages.getIconPath_nonContent(this.participantSelection.defaultChampionVisualName);
            }
         }
         this.champ_img.toolTip = _loc1_;
         this.champ_img.source = _loc2_;
      }
      
      private function destroyTradeRequestPanel() : void
      {
         if(this.tradeRequestPanel == null)
         {
            return;
         }
         this.tradeRequestPanel.removeEventListener(ChampionSelectionEvent.TRADE_ACCEPTED,this.throwTrade);
         this.removeChild(this.tradeRequestPanel);
         this.tradeRequestPanel = null;
      }
      
      private function _ChampionSelectPlayerRenderer_Fade1_c() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.duration = 350;
         return _loc1_;
      }
      
      private function updateTradeMouseState() : void
      {
         var _loc1_:String = "_up";
         if(this._tradeBtnOver)
         {
            _loc1_ = "_over";
         }
         if(this._tradeBtnDown)
         {
            _loc1_ = "_down";
         }
         if(this.tradeBtn.enabled == false)
         {
            _loc1_ = "_disabled";
         }
         this.tradeBtn.currentState = _loc1_;
      }
      
      protected function createMessage() : void
      {
         if(Boolean(this.championTrade) && Boolean(this.championTrade.pendingTrade))
         {
            this.destroyTradeMessage();
            this.createTradeRequestPanel();
         }
         else if(Boolean(this.championTrade) && Boolean(this.championTrade.tradeMessage != "") && this.championTrade.tradeMessage != null)
         {
            this.destroyTradeRequestPanel();
            this.createTradeMessage();
         }
         else
         {
            this.destroyTradeRequestPanel();
            this.destroyTradeMessage();
         }
      }
      
      private function _ChampionSelectPlayerRenderer_Zoom2_c() : Zoom
      {
         var _loc1_:Zoom = new Zoom();
         _loc1_.zoomWidthTo = 1;
         _loc1_.zoomHeightTo = 1;
         _loc1_.zoomWidthFrom = 1.066;
         _loc1_.zoomHeightFrom = 1.066;
         _loc1_.duration = 50;
         return _loc1_;
      }
      
      private function onChampClicked(param1:MouseEvent) : void
      {
         if(Boolean(this.participantSelection) && Boolean(this.participantSelection.champion))
         {
            this.dispatchEvent(new ChampionSelectionEvent(ChampionSelectionEvent.VIEW_PARTICIPANT_CHAMPION,this.participantSelection,true));
         }
      }
      
      private function updateTradeRequestPanel() : void
      {
         if(this.tradeRequestPanel == null)
         {
            return;
         }
         this.tradeRequestPanel.update();
      }
      
      private function updateOutOfSyncImage() : void
      {
         if(this.playerOutOfSyncImage)
         {
            this.playerOutOfSyncImage.visible = this.participantSelection && this.participantSelection.champion == null && this.participantSelection.participant && !this.participantSelection.isInSync && this.participantSelection.selectionState != GameState.PRE_CHAMPION_SELECTION;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playerOutOfSyncImage() : Image
      {
         return this._975372164playerOutOfSyncImage;
      }
      
      private function _ChampionSelectPlayerRenderer_Parallel1_i() : Parallel
      {
         var _loc1_:Parallel = new Parallel();
         this.fadeIn = _loc1_;
         _loc1_.children = [this._ChampionSelectPlayerRenderer_Fade1_c(),this._ChampionSelectPlayerRenderer_Sequence1_c()];
         return _loc1_;
      }
      
      private function _ChampionSelectPlayerRenderer_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_cs_discIcon");
         },function(param1:Object):void
         {
            playerOutOfSyncImage.source = param1;
         },"playerOutOfSyncImage.source");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","championSelection_clientOutOfSyncTooltipDisplay");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            playerOutOfSyncImage.toolTip = param1;
         },"playerOutOfSyncImage.toolTip");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_viewProfile");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            viewProfile_btn.toolTip = param1;
         },"viewProfile_btn.toolTip");
         result[2] = binding;
         return result;
      }
      
      private function onViewProfileClicked() : void
      {
         dispatchEvent(new ChampionSelectionEvent(ChampionSelectionEvent.VIEW_PROFILE,this.participantSelection,true));
      }
      
      protected function onPendingTradeChanged(param1:Event) : void
      {
         this.createMessage();
      }
      
      private function _ChampionSelectPlayerRenderer_Sequence1_c() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         _loc1_.children = [this._ChampionSelectPlayerRenderer_Zoom1_c(),this._ChampionSelectPlayerRenderer_Zoom2_c()];
         return _loc1_;
      }
      
      private function updateSelectionState() : void
      {
         if(Boolean(this.playerSlot) && Boolean(this.participantSelection))
         {
            this.playerSlot.currentState = this.participantSelection.selectionState;
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChampionSelectPlayerRenderer = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChampionSelectPlayerRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_itemRenderers_ChampionSelectPlayerRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },bindings,watchers);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         super.initialize();
      }
      
      public function set fadeIn(param1:Parallel) : void
      {
         var _loc2_:Object = this._1282133823fadeIn;
         if(_loc2_ !== param1)
         {
            this._1282133823fadeIn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn",_loc2_,param1));
         }
      }
      
      private function onSpell2TooltipCreate(param1:ToolTipEvent) : void
      {
         this.createSpellTooltip(this.participantSelection.spell2,param1);
      }
      
      public function get participantSelection() : PlayerSelection
      {
         return this._participantSelection;
      }
      
      private function createTradeRequestPanel() : void
      {
         if(this.tradeRequestPanel != null)
         {
            return;
         }
         this.tradeRequestPanel = new TradeRequestPanel();
         this.tradeRequestPanel.x = 175;
         this.tradeRequestPanel.y = -17;
         this.tradeRequestPanel.championTrade = this.participantSelection.championTrade;
         this.tradeRequestPanel.summonerName = this.participantSelection.participant.summonerName;
         this.addChild(this.tradeRequestPanel);
         if(UserPreferencesManager.userPrefs.enableAnimations)
         {
            this.fadeIn.play([this.tradeRequestPanel]);
         }
      }
      
      public function __tradeBtn_mouseDown(param1:MouseEvent) : void
      {
         this.onTradeMouseDown();
      }
      
      protected function onTradeTitleChanged(param1:Event) : void
      {
         if(this.tradeMessagePanel)
         {
            this.tradeMessagePanel.title = this.championTrade.tradeTitle;
         }
      }
      
      private function onTradeMouseUp() : void
      {
         if(!this.tradeBtn)
         {
            return;
         }
         if(Boolean(this.tradeBtn.enabled) && this._tradeBtnDown && this._tradeBtnOver)
         {
            this.dispatchEvent(new ChampionSelectionEvent(ChampionSelectionEvent.TRADE_REQUESTED,this.participantSelection,true));
         }
         this._tradeBtnDown = false;
         this.updateTradeMouseState();
      }
      
      public function set tradeBtnCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._2114901552tradeBtnCanvas;
         if(_loc2_ !== param1)
         {
            this._2114901552tradeBtnCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tradeBtnCanvas",_loc2_,param1));
         }
      }
      
      private function updateSelectionText() : void
      {
         var _loc1_:String = null;
         if(Boolean(this.playerSlot) && Boolean(this.participantSelection))
         {
            if(this.participantSelection.participant)
            {
               _loc1_ = this.participantSelection.participant.summonerName;
            }
            if(_loc1_ == null || StringUtil.trim(_loc1_).length == 0)
            {
               _loc1_ = RiotResourceLoader.getString("championSelection_player_summoner_anonymous","championSelection_player_summoner_anonymous",[this.slotIndex + 1]);
               if(_loc1_ == null)
               {
                  _loc1_ = "Summoner " + (this.slotIndex + 1);
               }
            }
            this.playerSlot.setText(this.participantSelection.selectionStateText,_loc1_);
         }
      }
      
      private function onTradeMouseDown() : void
      {
         if(!this.tradeBtn)
         {
            return;
         }
         this._tradeBtnDown = true;
         this.updateTradeMouseState();
      }
      
      [Bindable(event="propertyChange")]
      public function set spectatorMode(param1:Boolean) : void
      {
         var _loc2_:Object = this.spectatorMode;
         if(_loc2_ !== param1)
         {
            this._11649842spectatorMode = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spectatorMode",_loc2_,param1));
         }
      }
      
      protected function onSpell2Changed(param1:Event) : void
      {
         if(Boolean(this.participantSelection) && Boolean(this.participantSelection.spell2) && (this.spectatorMode && this.shouldShowSpellsForSpectator || !this.spectatorMode))
         {
            this.spell2_img.source = ImagePackLookup.instance.getSpellSource(this.participantSelection.spell2);
         }
         else
         {
            this.spell2_img.source = null;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playerSlot() : ChampionSelect
      {
         return this._2095816831playerSlot;
      }
      
      private function set _11649842spectatorMode(param1:Boolean) : void
      {
         if(param1 == this._spectatorMode)
         {
            return;
         }
         this._spectatorMode = param1;
         this.spectatorModeChanged = true;
         this.invalidateProperties();
      }
      
      private function onTradeAvailableChanged(param1:Event) : void
      {
         this.updateTradeAvailable();
      }
      
      public function set tradeBtn(param1:cs_tradeButton) : void
      {
         var _loc2_:Object = this._1271196248tradeBtn;
         if(_loc2_ !== param1)
         {
            this._1271196248tradeBtn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tradeBtn",_loc2_,param1));
         }
      }
      
      private function _ChampionSelectPlayerRenderer_Zoom1_c() : Zoom
      {
         var _loc1_:Zoom = new Zoom();
         _loc1_.zoomWidthTo = 1.066;
         _loc1_.zoomHeightTo = 1.066;
         _loc1_.zoomWidthFrom = 0.8;
         _loc1_.zoomHeightFrom = 0.8;
         _loc1_.duration = 250;
         return _loc1_;
      }
      
      public function __tradeBtn_mouseOut(param1:MouseEvent) : void
      {
         this.onTradeMouseOut();
      }
      
      private function _ChampionSelectPlayerRenderer_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_cs_discIcon");
         _loc1_ = resourceManager.getString("resources","championSelection_clientOutOfSyncTooltipDisplay");
         _loc1_ = RiotResourceLoader.getString("practiceGame_teamMemberRenderer_tooltip_viewProfile");
      }
      
      override protected function commitProperties() : void
      {
         if(this.selectionStateChanged)
         {
            this.updateSelectionState();
            this.updateSelectionText();
            this.selectionStateChanged = false;
         }
         if(this.participantChampionSelectionChanged)
         {
            this.updateBadgeRenderer();
            this.participantChampionSelectionChanged = false;
         }
         this.visible = this.participantSelection != null ? this._canShow : false;
         super.commitProperties();
         if(this.spectatorModeChanged)
         {
            this.updateViewProfileButton();
            this.spectatorModeChanged = false;
         }
      }
      
      protected function onSpell1Changed(param1:Event) : void
      {
         if(Boolean(this.participantSelection) && Boolean(this.participantSelection.spell1) && (this.spectatorMode && this.shouldShowSpellsForSpectator || !this.spectatorMode))
         {
            this.spell1_img.source = ImagePackLookup.instance.getSpellSource(this.participantSelection.spell1);
         }
         else
         {
            this.spell1_img.source = null;
         }
      }
      
      private function updateViewProfileButton() : void
      {
         if(Boolean(this.participantSelection) && Boolean(this.viewProfile_btn) && this.spectatorMode)
         {
            if(this.participantSelection.participant is BotParticipant)
            {
               this.viewProfile_btn.visible = false;
            }
            else
            {
               this.viewProfile_btn.visible = true;
            }
         }
         else if(this.viewProfile_btn)
         {
            this.viewProfile_btn.visible = false;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn() : Parallel
      {
         return this._1282133823fadeIn;
      }
      
      public function __viewProfile_btn_click(param1:MouseEvent) : void
      {
         this.onViewProfileClicked();
      }
      
      protected function onTradeMessageChanged(param1:Event) : void
      {
         this.createMessage();
      }
      
      private function onTradeMouseOver() : void
      {
         if(!this.tradeBtn)
         {
            return;
         }
         this._tradeBtnOver = true;
         this.updateTradeMouseState();
      }
      
      private function createSpellTooltip(param1:Spell, param2:ToolTipEvent) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc3_:SpellToolTip = new SpellToolTip();
         _loc3_.data = param1;
         param2.toolTip = _loc3_;
      }
      
      public function __tradeBtn_mouseOver(param1:MouseEvent) : void
      {
         this.onTradeMouseOver();
      }
      
      [Bindable(event="propertyChange")]
      public function get tradeBtnCanvas() : Canvas
      {
         return this._2114901552tradeBtnCanvas;
      }
      
      private function setupTextFormat() : void
      {
         var _loc1_:TextFormat = this.playerSlot.slotName_mc.label_txt.defaultTextFormat;
         _loc1_.font = "ApplicationFont2";
         if(this.locale == "zh_CN")
         {
            _loc1_.bold = false;
         }
         this.playerSlot.slotName_mc.label_txt.defaultTextFormat = _loc1_;
         this.playerSlot.slotRating_mc.label_txt.defaultTextFormat = _loc1_;
      }
      
      public function set viewProfile_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._711327457viewProfile_btn;
         if(_loc2_ !== param1)
         {
            this._711327457viewProfile_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"viewProfile_btn",_loc2_,param1));
         }
      }
      
      protected function removeOldChampionTradeListeners() : void
      {
         if(!this.championTrade)
         {
            return;
         }
         this.championTrade.removeEventListener(ChampionTrade.PENDING_TRADE_CHANGED,this.onPendingTradeChanged);
         this.championTrade.removeEventListener(ChampionTrade.TRADE_MESSAGE_CHANGED,this.onTradeMessageChanged);
         this.championTrade.removeEventListener(ChampionTrade.TRADE_TITLE_CHANGED,this.onTradeTitleChanged);
      }
      
      public function set canShow(param1:Boolean) : void
      {
         this._canShow = param1;
         this.invalidateProperties();
      }
      
      private function updateTradeAvailable() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(Boolean(this.participantSelection) && Boolean(this.tradeBtn))
         {
            _loc1_ = this.participantSelection.tradeActive && this.participantSelection.participant && !this.participantSelection.participant.isMe && !(this.participantSelection.participant is BotParticipant);
            _loc2_ = Boolean(this.participantSelection.tradeAvailable);
            this.tradeBtn.visible = _loc1_;
            this.tradeBtn.enabled = _loc2_;
            _loc3_ = "";
            if(_loc1_ && _loc2_)
            {
               _loc3_ = "champion_trading_trade_button";
            }
            else if(_loc1_)
            {
               _loc3_ = "champion_trading_trade_button_unavailable";
            }
            _loc4_ = resourceManager.getString("resources",_loc3_);
            if(_loc3_ != "" && (_loc4_ == null || _loc4_ == ""))
            {
               _loc4_ = "**" + _loc3_;
            }
            this.tradeBtnCanvas.toolTip = _loc4_;
            this.updateTradeMouseState();
         }
      }
      
      private function onSelectionStateChanged(param1:Event) : void
      {
         this.selectionStateChanged = true;
         this.invalidateProperties();
      }
      
      private function onGameStateChanged(param1:Event) : void
      {
         this.updateAlpha();
      }
      
      public function set playerOutOfSyncImage(param1:Image) : void
      {
         var _loc2_:Object = this._975372164playerOutOfSyncImage;
         if(_loc2_ !== param1)
         {
            this._975372164playerOutOfSyncImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerOutOfSyncImage",_loc2_,param1));
         }
      }
      
      private function onSpell1TooltipCreate(param1:ToolTipEvent) : void
      {
         this.createSpellTooltip(this.participantSelection.spell1,param1);
      }
   }
}

