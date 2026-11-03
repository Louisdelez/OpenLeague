package com.riotgames.platform.gameclient.views.game.normal
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.Models.MaxViewableTeamSize;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.views.chatpanel.ChampionSelectChatWindow;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.configurations.GuestSlotsConfig;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   import com.riotgames.platform.gameclient.views.IViewLifecycle;
   import com.riotgames.platform.gameclient.views.game.common.invite.InviteePanel;
   import com.riotgames.platform.gameclient.views.game.normal.normalTeamSelection.NormalTeamPanel;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.MasterGameViewController;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.IInviteProvider;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.suggestedplayers.ISuggestedPlayersProvider;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
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
   import mx.binding.utils.ChangeWatcher;
   import mx.collections.ArrayCollection;
   import mx.containers.Canvas;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.controls.HRule;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class CreateNormalArrangedGame extends Canvas implements IViewLifecycle, IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _1811186354statDetails:Label;
      
      private var _753137065rightGutter:ConstraintColumn;
      
      private var _masterGameViewController:MasterGameViewController;
      
      private var _1911380774bottomGutter:ConstraintRow;
      
      private var _567412016topGutter:ConstraintRow;
      
      private var _1236973911leftContentTopRow:ConstraintRow;
      
      private var _1775602690leftGutter:ConstraintColumn;
      
      mx_internal var _bindingsByDestination:Object;
      
      private var _51534353map_holder:Canvas;
      
      private var _guestSlotsEnabledConfig:ConfigurationModel;
      
      private var _620697998mapInfo_c:Canvas;
      
      private var _suggestedPlayersFeatureEnabled:Boolean = false;
      
      public var _CreateNormalArrangedGame_HRule1:HRule;
      
      private var _868055995topRow:ConstraintRow;
      
      private var _1836939262quitGame_btn:SoundEffectButton;
      
      private var _57576126bkg_img:Image;
      
      private var _94069131htmlMapDescription:String;
      
      private var _1634913538embeddedChat:ChampionSelectChatWindow;
      
      private var rankedTeamNameWatcher:ChangeWatcher = null;
      
      private var _gameQueueManager:GameQueueManager;
      
      private var _873431918rightColumn:ConstraintColumn;
      
      private var _1749478669isExpandedLayout:Boolean = false;
      
      private var _1476634820rightContentTop_c:Canvas;
      
      public var _CreateNormalArrangedGame_Canvas6:Canvas;
      
      public var _CreateNormalArrangedGame_Text1:Text;
      
      private var _1674077510mapDetails:Label;
      
      private var _2070565886startChampionSelection_btn:SoundEffectButton;
      
      private var _1655307837leftColumn:ConstraintColumn;
      
      private var _masterGameController:MasterGameController;
      
      private var _1525885706inviteGroup:InviteGroup;
      
      private var isInitialized:Boolean = false;
      
      private var _1148516281_showSuggestedPlayersPanel:Boolean = false;
      
      private var _200383958leftContent_c:Canvas;
      
      private var _1133197415teamGuestSlotsEnabled:Boolean = false;
      
      private var _1427263419guestSlotCountLabel:Label;
      
      private var _1855392849bottomRow:ConstraintRow;
      
      private var _suggestedPlayersProvider:ISuggestedPlayersProvider;
      
      private var inviteController:IInviteController;
      
      public var _CreateNormalArrangedGame_Image2:Image;
      
      public var _CreateNormalArrangedGame_Image3:Image;
      
      private var _298925952normalTeamPanel:NormalTeamPanel;
      
      mx_internal var _watchers:Array;
      
      private var queueConfig:ChangeWatcher = null;
      
      private var _769234152inviteePanel:InviteePanel;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      mx_internal var _bindings:Array;
      
      private var _158535007mapImage:Image;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function CreateNormalArrangedGame()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Image,
                  "id":"bkg_img",
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "0";
                     this.verticalCenter = "0";
                  }
               }),new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"leftContent_c",
                  "stylesFactory":function():void
                  {
                     this.left = "leftColumn:0";
                     this.right = "leftColumn:0";
                     this.top = "topRow:0";
                     this.bottom = "bottomRow:0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "cacheAsBitmap":true,
                        "styleName":"blueParchmentTablet",
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "constraintRows":[_CreateNormalArrangedGame_ConstraintRow5_i()],
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":GradientCanvas,
                           "stylesFactory":function():void
                           {
                              this.left = "-1";
                              this.right = "-1";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "styleName":"blueHeaderBackground",
                                 "height":30,
                                 "y":-1,
                                 "horizontalScrollPolicy":"off",
                                 "verticalScrollPolicy":"off",
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":Image,
                                    "id":"_CreateNormalArrangedGame_Image2",
                                    "stylesFactory":function():void
                                    {
                                       this.verticalCenter = "0";
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":Label,
                                    "id":"statDetails",
                                    "stylesFactory":function():void
                                    {
                                       this.left = "5";
                                       this.verticalCenter = "0";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {"styleName":"blueThemeHeaderText"};
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":Label,
                                    "id":"guestSlotCountLabel",
                                    "stylesFactory":function():void
                                    {
                                       this.right = "5";
                                       this.textAlign = "right";
                                       this.verticalCenter = "0";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "text":"Guest Slots 0x00",
                                          "styleName":"blueThemeHeaderText",
                                          "width":200
                                       };
                                    }
                                 })]
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":NormalTeamPanel,
                           "id":"normalTeamPanel",
                           "stylesFactory":function():void
                           {
                              this.top = "leftContentTopRow:30";
                              this.bottom = "leftContentTopRow:2";
                              this.left = "0";
                              this.right = "0";
                           }
                        }),new UIComponentDescriptor({
                           "type":HRule,
                           "id":"_CreateNormalArrangedGame_HRule1",
                           "stylesFactory":function():void
                           {
                              this.horizontalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":95,
                                 "styleName":"blueParchment",
                                 "alpha":0.5
                              };
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"rightContentTop_c",
                  "stylesFactory":function():void
                  {
                     this.left = "rightColumn:3";
                     this.right = "rightColumn:2";
                     this.top = "topRow:0";
                     this.bottom = "topRow:-1";
                     this.cornerRadius = 2;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "cacheAsBitmap":true,
                        "styleName":"blueParchmentTablet",
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Canvas,
                           "id":"mapInfo_c",
                           "stylesFactory":function():void
                           {
                              this.top = "0";
                              this.bottom = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "cacheAsBitmap":true,
                                 "percentWidth":100,
                                 "horizontalScrollPolicy":"off",
                                 "verticalScrollPolicy":"off",
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":GradientCanvas,
                                    "stylesFactory":function():void
                                    {
                                       this.top = "-1";
                                       this.left = "-1";
                                       this.right = "-1";
                                       this.borderStyle = "none";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "styleName":"blueHeaderBackground",
                                          "height":30,
                                          "y":-1,
                                          "horizontalScrollPolicy":"off",
                                          "verticalScrollPolicy":"off",
                                          "childDescriptors":[new UIComponentDescriptor({
                                             "type":Image,
                                             "id":"_CreateNormalArrangedGame_Image3",
                                             "stylesFactory":function():void
                                             {
                                                this.verticalCenter = "0";
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":Label,
                                             "id":"mapDetails",
                                             "stylesFactory":function():void
                                             {
                                                this.left = "5";
                                                this.verticalCenter = "0";
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {"styleName":"blueThemeHeaderText"};
                                             }
                                          })]
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":Canvas,
                                    "id":"map_holder",
                                    "stylesFactory":function():void
                                    {
                                       this.horizontalCenter = "0";
                                       this.cornerRadius = 0;
                                       this.top = "32";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "cacheAsBitmap":true,
                                          "styleName":"blueParchmentTablet",
                                          "width":291,
                                          "height":155,
                                          "verticalScrollPolicy":"off",
                                          "horizontalScrollPolicy":"off",
                                          "clipContent":true,
                                          "childDescriptors":[new UIComponentDescriptor({
                                             "type":Image,
                                             "id":"mapImage",
                                             "stylesFactory":function():void
                                             {
                                                this.verticalCenter = "0";
                                                this.horizontalCenter = "0";
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "maintainAspectRatio":false,
                                                   "percentHeight":100,
                                                   "percentWidth":100
                                                };
                                             }
                                          })]
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":Text,
                                    "id":"_CreateNormalArrangedGame_Text1",
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "styleName":"createGameMapText",
                                          "x":3,
                                          "selectable":false
                                       };
                                    }
                                 })]
                              };
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":InviteePanel,
                  "id":"inviteePanel",
                  "stylesFactory":function():void
                  {
                     this.left = "rightColumn:3";
                     this.right = "rightColumn:2";
                     this.top = "bottomRow:4";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "cacheAsBitmap":true,
                        "visible":true,
                        "nameColWidth":125
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":SoundEffectButton,
                  "id":"quitGame_btn",
                  "events":{"click":"__quitGame_btn_click"},
                  "stylesFactory":function():void
                  {
                     this.left = "rightColumn:6";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "styleName":"longButtonBlue",
                        "width":147
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":SoundEffectButton,
                  "id":"startChampionSelection_btn",
                  "events":{"click":"__startChampionSelection_btn_click"},
                  "stylesFactory":function():void
                  {
                     this.right = "rightColumn:6";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "styleName":"longButtonOrange2",
                        "toolTip":"",
                        "enabled":false,
                        "width":147
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"_CreateNormalArrangedGame_Canvas6",
                  "stylesFactory":function():void
                  {
                     this.top = "bottomGutter:2";
                     this.bottom = "bottomGutter:4";
                     this.left = "leftColumn:0";
                     this.backgroundAlpha = 1;
                     this.backgroundColor = 0;
                  }
               }),new UIComponentDescriptor({
                  "type":ChampionSelectChatWindow,
                  "id":"embeddedChat",
                  "stylesFactory":function():void
                  {
                     this.top = "bottomGutter:2";
                     this.bottom = "bottomGutter:4";
                     this.left = "leftColumn:0";
                  }
               })]};
            }
         });
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.backgroundAlpha = 0;
         };
         this.cacheAsBitmap = true;
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.constraintColumns = [this._CreateNormalArrangedGame_ConstraintColumn1_i(),this._CreateNormalArrangedGame_ConstraintColumn2_i(),this._CreateNormalArrangedGame_ConstraintColumn3_i(),this._CreateNormalArrangedGame_ConstraintColumn4_i()];
         this.constraintRows = [this._CreateNormalArrangedGame_ConstraintRow1_i(),this._CreateNormalArrangedGame_ConstraintRow2_i(),this._CreateNormalArrangedGame_ConstraintRow3_i(),this._CreateNormalArrangedGame_ConstraintRow4_i()];
         this.addEventListener("creationComplete",this.___CreateNormalArrangedGame_Canvas1_creationComplete);
         this.addEventListener("addedToStage",this.___CreateNormalArrangedGame_Canvas1_addedToStage);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         CreateNormalArrangedGame._watcherSetupUtil = param1;
      }
      
      private function set _269543472masterGameController(param1:MasterGameController) : void
      {
         if(param1)
         {
            this._masterGameController = param1;
         }
      }
      
      public function set quitGame_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1836939262quitGame_btn;
         if(_loc2_ !== param1)
         {
            this._1836939262quitGame_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"quitGame_btn",_loc2_,param1));
         }
      }
      
      public function set embeddedChat(param1:ChampionSelectChatWindow) : void
      {
         var _loc2_:Object = this._1634913538embeddedChat;
         if(_loc2_ !== param1)
         {
            this._1634913538embeddedChat = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"embeddedChat",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leftGutter() : ConstraintColumn
      {
         return this._1775602690leftGutter;
      }
      
      public function set leftGutter(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1775602690leftGutter;
         if(_loc2_ !== param1)
         {
            this._1775602690leftGutter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leftGutter",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get startChampionSelection_btn() : SoundEffectButton
      {
         return this._2070565886startChampionSelection_btn;
      }
      
      private function set isExpandedLayout(param1:Boolean) : void
      {
         var _loc2_:Object = this._1749478669isExpandedLayout;
         if(_loc2_ !== param1)
         {
            this._1749478669isExpandedLayout = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isExpandedLayout",_loc2_,param1));
         }
      }
      
      public function set startChampionSelection_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._2070565886startChampionSelection_btn;
         if(_loc2_ !== param1)
         {
            this._2070565886startChampionSelection_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"startChampionSelection_btn",_loc2_,param1));
         }
      }
      
      [Inject]
      public function get masterGameController() : MasterGameController
      {
         return this._masterGameController;
      }
      
      private function _CreateNormalArrangedGame_ConstraintColumn4_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.rightGutter = _loc1_;
         _loc1_.width = 265;
         _loc1_.initialized(this,"rightGutter");
         return _loc1_;
      }
      
      private function updateRankTeamName() : void
      {
         if(Boolean(this.gameQueueManager.selectedGameQueueConfig) && Boolean(this.gameQueueManager.selectedGameQueueConfig.teamOnly) && Boolean(this.htmlMapDescription))
         {
            if(this.gameQueueManager.rankedTeamName != GameQueueManager.TEAM_NAME_UNSELECTED)
            {
               this.htmlMapDescription += "\n<b><font color=\'#eeeeee\'>" + resourceManager.getString("resources","practiceGame_rankedTeamName",["</font> <font color=\'#c7c7c7\'>" + this.gameQueueManager.rankedTeamName + "</font>"]);
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leftColumn() : ConstraintColumn
      {
         return this._1655307837leftColumn;
      }
      
      [Bindable(event="propertyChange")]
      public function get topRow() : ConstraintRow
      {
         return this._868055995topRow;
      }
      
      public function set bottomGutter(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._1911380774bottomGutter;
         if(_loc2_ !== param1)
         {
            this._1911380774bottomGutter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottomGutter",_loc2_,param1));
         }
      }
      
      private function onAcceptedParticipantsModified(param1:CollectionEvent) : void
      {
         this.updateStartButton();
         this.updateGuestSlotsDisplay();
      }
      
      public function initializeView() : void
      {
         this.isInitialized = true;
         this.embeddedChat.initializeView();
         this.initHtmlMapDescription();
         if(this.queueConfig == null)
         {
            this.queueConfig = ChangeWatcher.watch(this.gameQueueManager,"selectedGameQueueConfig",this.onSelectedQueueChanged);
         }
         if(this.inviteGroup)
         {
            this.watchInvites();
            this.updateGuestSlotsDisplay();
            this.updateStartButton();
         }
         else
         {
            ProviderLookup.getProvider(IInviteProvider,this.onInviteProvider);
         }
         this.embeddedChat.focusInput();
         this.bkg_img.source = ImagePackLookup.instance.getClassFromSwfRef("e_pvp_landingBackground");
         if(this.rankedTeamNameWatcher == null)
         {
            this.rankedTeamNameWatcher = ChangeWatcher.watch(this.gameQueueManager,"rankedTeamName",this.onRankedTeamNameChanged);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rightGutter() : ConstraintColumn
      {
         return this._753137065rightGutter;
      }
      
      private function handleSuggestedPlayersProvider(param1:ISuggestedPlayersProvider) : void
      {
         this._suggestedPlayersProvider = param1;
         this.updateShowSuggestedPlayersPanel();
      }
      
      [Inject]
      public function get gameQueueManager() : GameQueueManager
      {
         return this._gameQueueManager;
      }
      
      private function updateShowSuggestedPlayersPanel() : void
      {
         this._suggestedPlayersFeatureEnabled = Boolean(DynamicClientConfigManager.getConfiguration("SuggestedPlayers","Enabled",true).getBoolean()) && !this.isRankedGame();
         this._showSuggestedPlayersPanel = this._suggestedPlayersFeatureEnabled;
      }
      
      [Bindable(event="propertyChange")]
      private function get teamGuestSlotsEnabled() : Boolean
      {
         return this._1133197415teamGuestSlotsEnabled;
      }
      
      private function _CreateNormalArrangedGame_ConstraintColumn3_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.rightColumn = _loc1_;
         _loc1_.percentWidth = 35;
         _loc1_.initialized(this,"rightColumn");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function set masterGameController(param1:MasterGameController) : void
      {
         var _loc2_:Object = this.masterGameController;
         if(_loc2_ !== param1)
         {
            this._269543472masterGameController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"masterGameController",_loc2_,param1));
         }
      }
      
      public function set leftColumn(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1655307837leftColumn;
         if(_loc2_ !== param1)
         {
            this._1655307837leftColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leftColumn",_loc2_,param1));
         }
      }
      
      public function set rightContentTop_c(param1:Canvas) : void
      {
         var _loc2_:Object = this._1476634820rightContentTop_c;
         if(_loc2_ !== param1)
         {
            this._1476634820rightContentTop_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightContentTop_c",_loc2_,param1));
         }
      }
      
      public function set bkg_img(param1:Image) : void
      {
         var _loc2_:Object = this._57576126bkg_img;
         if(_loc2_ !== param1)
         {
            this._57576126bkg_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bkg_img",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get normalTeamPanel() : NormalTeamPanel
      {
         return this._298925952normalTeamPanel;
      }
      
      private function onIsOwnerChanged() : void
      {
         this.updateAllowedToInvite();
      }
      
      private function _CreateNormalArrangedGame_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.statDetails.x - 8;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_pvp_headerFlame_blue");
         _loc1_ = resourceManager.getString("resources","normalGame_arrangedTeam_yourTeamHeaderLabel");
         _loc1_ = this.leftContent_c.height - 40;
         _loc1_ = !this.isExpandedLayout;
         _loc1_ = this.mapDetails.x - 8;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_pvp_headerFlame_blue");
         _loc1_ = resourceManager.getString("resources","normalGame_arrangedTeam_mapOptionsHeaderLabel");
         _loc1_ = ImagePackLookup.instance.getMapSource(this.masterGameController.gameModel.gameMap);
         _loc1_ = this.map_holder.y + this.map_holder.height + 2;
         _loc1_ = this.htmlMapDescription;
         _loc1_ = this.inviteGroup.isOwner || this.inviteGroup.allowedToInvite;
         _loc1_ = this._showSuggestedPlayersPanel ? "bottomGutter:4" : "bottomRow:0";
         _loc1_ = resourceManager.getString("resources","normalGame_arrangedTeam_cancelButtonLabel");
         _loc1_ = resourceManager.getString("resources","normalGame_arrangedTeam_cancelButton_tooltip");
         _loc1_ = !this.masterGameViewController.isBusy;
         _loc1_ = this._showSuggestedPlayersPanel ? "bottomGutter:4" : "bottomRow:0";
         _loc1_ = resourceManager.getString("resources","normalGame_arrangedTeam_startGameButtonLabel");
         _loc1_ = this.inviteGroup.isOwner;
         _loc1_ = this._showSuggestedPlayersPanel ? "bottomGutter:4" : "bottomRow:0";
         _loc1_ = this._showSuggestedPlayersPanel ? "leftColumn:0" : "rightColumn:2";
         _loc1_ = RiotResourceLoader.getString("practiceGame_chatRoom_title");
         _loc1_ = this._showSuggestedPlayersPanel ? "leftColumn:0" : "rightColumn:2";
      }
      
      public function set topRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._868055995topRow;
         if(_loc2_ !== param1)
         {
            this._868055995topRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topRow",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rightColumn() : ConstraintColumn
      {
         return this._873431918rightColumn;
      }
      
      public function set mapDetails(param1:Label) : void
      {
         var _loc2_:Object = this._1674077510mapDetails;
         if(_loc2_ !== param1)
         {
            this._1674077510mapDetails = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapDetails",_loc2_,param1));
         }
      }
      
      private function _CreateNormalArrangedGame_ConstraintRow5_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.leftContentTopRow = _loc1_;
         _loc1_.percentHeight = 100;
         _loc1_.initialized(this,"leftContentTopRow");
         return _loc1_;
      }
      
      public function resetView() : void
      {
         this.isInitialized = false;
         this.unwatchInvites();
         if(this.queueConfig != null)
         {
            this.queueConfig.unwatch();
            this.queueConfig = null;
         }
         if(this.embeddedChat != null)
         {
            this.embeddedChat.resetView();
         }
         this.bkg_img.source = null;
         if(this.rankedTeamNameWatcher != null)
         {
            this.rankedTeamNameWatcher.unwatch();
            this.rankedTeamNameWatcher = null;
         }
         this.inviteGroup.numGuestSlots = 0;
         this.inviteGroup.numGuestSlotsUsed = 0;
      }
      
      public function set statDetails(param1:Label) : void
      {
         var _loc2_:Object = this._1811186354statDetails;
         if(_loc2_ !== param1)
         {
            this._1811186354statDetails = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statDetails",_loc2_,param1));
         }
      }
      
      public function set rightGutter(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._753137065rightGutter;
         if(_loc2_ !== param1)
         {
            this._753137065rightGutter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightGutter",_loc2_,param1));
         }
      }
      
      public function set leftContentTopRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._1236973911leftContentTopRow;
         if(_loc2_ !== param1)
         {
            this._1236973911leftContentTopRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leftContentTopRow",_loc2_,param1));
         }
      }
      
      private function _CreateNormalArrangedGame_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.leftColumn = _loc1_;
         _loc1_.percentWidth = 70;
         _loc1_.initialized(this,"leftColumn");
         return _loc1_;
      }
      
      public function initHtmlMapDescription() : void
      {
         if(this.masterGameController.gameModel.gameMap == null)
         {
            return;
         }
         var _loc1_:GameMap = this.masterGameController.gameModel.gameMap;
         var _loc2_:ArrayCollection = Boolean(this.gameQueueManager) && Boolean(this.gameQueueManager.selectedGameQueueConfig) ? this.gameQueueManager.selectedGameQueueConfig.gameMutators : null;
         var _loc3_:String = Boolean(this.gameQueueManager) && Boolean(this.gameQueueManager.selectedGameQueueConfig) ? this.gameQueueManager.selectedGameQueueConfig.gameMode : null;
         var _loc4_:GameFlowVariant = GameFlowVariantFactory.instance.getVariant(_loc2_,_loc3_);
         var _loc5_:String = _loc4_.getArrangedTeamLobbyGameNameHint() != null ? " " + _loc4_.getArrangedTeamLobbyGameNameHint() : "";
         this.htmlMapDescription = "<b><font color=\'#eeeeee\'>" + RiotResourceLoader.getString("practiceGame_mapName_label") + "</font>" + " <font color=\'#c7c7c7\'>" + _loc1_.displayName + _loc5_ + "</font>";
         if(Boolean(this.gameQueueManager) && Boolean(this.gameQueueManager.selectedGameQueueConfig))
         {
            this.htmlMapDescription += "\n<font color=\'#eeeeee\'>" + resourceManager.getString("resources","practiceGame_teamSize_label") + "</font> <font color=\'#c7c7c7\'>" + this.gameQueueManager.selectedGameQueueConfig.name + "</font>";
            this.htmlMapDescription += "\n<font color=\'#eeeeee\'>" + resourceManager.getString("resources","practiceGame_queueType_label") + "</font> <font color=\'#c7c7c7\'>";
            if(this.gameQueueManager.selectedGameQueueConfig.ranked)
            {
               this.htmlMapDescription += resourceManager.getString("resources","summonerProfile_profile_statsHeaderRanked") + "</font>";
            }
            else if(this.masterGameController.gameModel.gameType == GameType.COOP_VS_AI)
            {
               this.htmlMapDescription += resourceManager.getString("resources","summonerProfile_profile_statsHeaderCoopVsAI") + "</font>";
            }
            else
            {
               this.htmlMapDescription += resourceManager.getString("resources","summonerProfile_profile_statsHeaderNormal") + "</font>";
            }
            if(this.masterGameController.gameModel.difficulty != null && this.masterGameController.gameModel.difficulty != "")
            {
               this.htmlMapDescription += "\n<b><font color=\'#eeeeee\'>" + resourceManager.getString("resources","practiceGame_difficulty_label") + "</b></font> <font color=\'#c7c7c7\'>" + resourceManager.getString("resources","practiceGame_difficulty_" + this.masterGameController.gameModel.difficulty.toLowerCase()) + "</font>";
            }
         }
         this.updateRankTeamName();
      }
      
      [Inject]
      public function get masterGameViewController() : MasterGameViewController
      {
         return this._masterGameViewController;
      }
      
      private function watchInvites() : void
      {
         if(!this.inviteGroup)
         {
            return;
         }
         this.inviteGroup.numGuestSlotsChanged.add(this.updateGuestSlotsDisplay);
         this.inviteGroup.numGuestSlotsUsedChanged.add(this.updateGuestSlotsDisplay);
         this.inviteGroup.allowedToInviteChanged.add(this.onIsOwnerChanged);
         this.inviteGroup.getIsOwnerChangedSignal().add(this.onIsOwnerChanged);
         this.inviteGroup.getChatRoomChangedSignal().add(this.onInviteChatRoomChanged);
         if(this.inviteGroup.acceptedParticipants)
         {
            this.inviteGroup.acceptedParticipants.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onAcceptedParticipantsModified);
         }
      }
      
      public function ___CreateNormalArrangedGame_Canvas1_addedToStage(param1:Event) : void
      {
         this.onAddedToStage();
      }
      
      public function set mapImage(param1:Image) : void
      {
         var _loc2_:Object = this._158535007mapImage;
         if(_loc2_ !== param1)
         {
            this._158535007mapImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapImage",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get topGutter() : ConstraintRow
      {
         return this._567412016topGutter;
      }
      
      private function _CreateNormalArrangedGame_ConstraintRow4_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.bottomGutter = _loc1_;
         _loc1_.height = 190;
         _loc1_.initialized(this,"bottomGutter");
         return _loc1_;
      }
      
      private function set _1137159790gameQueueManager(param1:GameQueueManager) : void
      {
         if(param1)
         {
            this._gameQueueManager = param1;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set gameQueueManager(param1:GameQueueManager) : void
      {
         var _loc2_:Object = this.gameQueueManager;
         if(_loc2_ !== param1)
         {
            this._1137159790gameQueueManager = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameQueueManager",_loc2_,param1));
         }
      }
      
      private function set teamGuestSlotsEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._1133197415teamGuestSlotsEnabled;
         if(_loc2_ !== param1)
         {
            this._1133197415teamGuestSlotsEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamGuestSlotsEnabled",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get inviteePanel() : InviteePanel
      {
         return this._769234152inviteePanel;
      }
      
      private function _CreateNormalArrangedGame_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.leftGutter = _loc1_;
         _loc1_.width = 135;
         _loc1_.initialized(this,"leftGutter");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      private function get inviteGroup() : InviteGroup
      {
         return this._1525885706inviteGroup;
      }
      
      private function updateGuestSlotsDisplay() : void
      {
         if(this.teamGuestSlotsEnabled && this.inviteGroup.numGuestSlots > 0 && (this._gameQueueManager.selectedGameQueueConfig.type == QueueType.RANKED_TEAM_3x3 || this._gameQueueManager.selectedGameQueueConfig.type == QueueType.RANKED_TEAM_5x5))
         {
            this.guestSlotCountLabel.visible = true;
            this.guestSlotCountLabel.text = RiotResourceLoader.getString("normalGame_arrangedTeam_guestSlotsHeaderLabel",null,[this.inviteGroup.numGuestSlotsUsed,this.inviteGroup.numGuestSlots]);
         }
         else
         {
            this.guestSlotCountLabel.visible = false;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get embeddedChat() : ChampionSelectChatWindow
      {
         return this._1634913538embeddedChat;
      }
      
      public function set normalTeamPanel(param1:NormalTeamPanel) : void
      {
         var _loc2_:Object = this._298925952normalTeamPanel;
         if(_loc2_ !== param1)
         {
            this._298925952normalTeamPanel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"normalTeamPanel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get isExpandedLayout() : Boolean
      {
         return this._1749478669isExpandedLayout;
      }
      
      private function _CreateNormalArrangedGame_ConstraintRow3_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.bottomRow = _loc1_;
         _loc1_.percentHeight = 46;
         _loc1_.initialized(this,"bottomRow");
         return _loc1_;
      }
      
      public function set mapInfo_c(param1:Canvas) : void
      {
         var _loc2_:Object = this._620697998mapInfo_c;
         if(_loc2_ !== param1)
         {
            this._620697998mapInfo_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapInfo_c",_loc2_,param1));
         }
      }
      
      private function onSelectedQueueChanged(param1:Event) : void
      {
         this.initHtmlMapDescription();
         this.updateStartButton();
      }
      
      private function cancelQueueButtonClicked() : void
      {
         this.inviteController.leaveLobby();
         this.masterGameViewController.cancelJoinQueueView();
      }
      
      private function onRankedTeamNameChanged(param1:Event) : void
      {
         this.initHtmlMapDescription();
      }
      
      private function updateAllowedToInvite() : void
      {
         this.inviteePanel.allowedtoInvite = Boolean(this.inviteGroup.isOwner) || Boolean(this.inviteGroup.allowedToInvite);
      }
      
      public function set rightColumn(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._873431918rightColumn;
         if(_loc2_ !== param1)
         {
            this._873431918rightColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightColumn",_loc2_,param1));
         }
      }
      
      public function set htmlMapDescription(param1:String) : void
      {
         var _loc2_:Object = this._94069131htmlMapDescription;
         if(_loc2_ !== param1)
         {
            this._94069131htmlMapDescription = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"htmlMapDescription",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomGutter() : ConstraintRow
      {
         return this._1911380774bottomGutter;
      }
      
      private function isRankedGame() : Boolean
      {
         if(!this.gameQueueManager || !this.gameQueueManager.selectedGameQueueConfig)
         {
            return false;
         }
         var _loc1_:GameQueueConfig = this.gameQueueManager.selectedGameQueueConfig;
         if(_loc1_.teamOnly)
         {
            return true;
         }
         if(_loc1_.ranked)
         {
            return true;
         }
         return false;
      }
      
      private function onMasterGameStateChanged(param1:Event) : void
      {
         if(this.masterGameController.currentState == GameViewState.JOIN_QUEUE)
         {
            if(!this.isInitialized)
            {
               this.initializeView();
            }
         }
         else if(this.isInitialized)
         {
            this.resetView();
         }
      }
      
      private function onCreationComplete() : void
      {
         ChangeWatcher.watch(this.masterGameController,"currentState",this.onMasterGameStateChanged);
         this._guestSlotsEnabledConfig = DynamicClientConfigManager.getConfiguration(GuestSlotsConfig.NAMESPACE,GuestSlotsConfig.ENABLED,false,this.onGuestSlotsEnabledChanged);
         this.onGuestSlotsEnabledChanged();
         ProviderLookup.getProvider(ISuggestedPlayersProvider,this.handleSuggestedPlayersProvider);
         if(this.masterGameController.currentState == GameViewState.JOIN_QUEUE)
         {
            this.initializeView();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rightContentTop_c() : Canvas
      {
         return this._1476634820rightContentTop_c;
      }
      
      [Bindable(event="propertyChange")]
      public function get bkg_img() : Image
      {
         return this._57576126bkg_img;
      }
      
      [Bindable(event="propertyChange")]
      public function get mapDetails() : Label
      {
         return this._1674077510mapDetails;
      }
      
      [Bindable(event="propertyChange")]
      public function get statDetails() : Label
      {
         return this._1811186354statDetails;
      }
      
      public function ___CreateNormalArrangedGame_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      private function _CreateNormalArrangedGame_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.topRow = _loc1_;
         _loc1_.percentHeight = 54;
         _loc1_.initialized(this,"topRow");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get leftContentTopRow() : ConstraintRow
      {
         return this._1236973911leftContentTopRow;
      }
      
      public function set bottomRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._1855392849bottomRow;
         if(_loc2_ !== param1)
         {
            this._1855392849bottomRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottomRow",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set masterGameViewController(param1:MasterGameViewController) : void
      {
         var _loc2_:Object = this.masterGameViewController;
         if(_loc2_ !== param1)
         {
            this._1450947915masterGameViewController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"masterGameViewController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapImage() : Image
      {
         return this._158535007mapImage;
      }
      
      private function set _showSuggestedPlayersPanel(param1:Boolean) : void
      {
         var _loc2_:Object = this._1148516281_showSuggestedPlayersPanel;
         if(_loc2_ !== param1)
         {
            this._1148516281_showSuggestedPlayersPanel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_showSuggestedPlayersPanel",_loc2_,param1));
         }
      }
      
      public function set guestSlotCountLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1427263419guestSlotCountLabel;
         if(_loc2_ !== param1)
         {
            this._1427263419guestSlotCountLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"guestSlotCountLabel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapInfo_c() : Canvas
      {
         return this._620697998mapInfo_c;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:CreateNormalArrangedGame = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._CreateNormalArrangedGame_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_normal_CreateNormalArrangedGameWatcherSetupUtil");
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
      
      private function _CreateNormalArrangedGame_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.topGutter = _loc1_;
         _loc1_.height = 2;
         _loc1_.initialized(this,"topGutter");
         return _loc1_;
      }
      
      public function set topGutter(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._567412016topGutter;
         if(_loc2_ !== param1)
         {
            this._567412016topGutter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topGutter",_loc2_,param1));
         }
      }
      
      private function onAddedToStage() : void
      {
         this.isExpandedLayout = this.masterGameViewController.gameQueueManager.selectedGameQueueConfig != null && this.masterGameViewController.gameQueueManager.selectedGameQueueConfig.maximumParticipantListSize > MaxViewableTeamSize.TEAM_SIZE_NORMAL_VIEW_LIMIT;
         this.updateShowSuggestedPlayersPanel();
      }
      
      [Bindable(event="propertyChange")]
      public function get htmlMapDescription() : String
      {
         return this._94069131htmlMapDescription;
      }
      
      private function updateStartButton() : void
      {
         if(!this.gameQueueManager.selectedGameQueueConfig)
         {
            return;
         }
         var _loc1_:Boolean = true;
         var _loc2_:int = 1;
         if(this.inviteGroup)
         {
            _loc2_ = int(this.inviteGroup.getAcceptedParticipantCount());
         }
         if(this.gameQueueManager.selectedGameQueueConfig.ranked)
         {
            if(this.gameQueueManager.selectedGameQueueConfig.type == QueueType.RANKED_PREMADE_5x5)
            {
               if(_loc2_ > 2 && _loc2_ != 5)
               {
                  _loc1_ = false;
                  this.startChampionSelection_btn.toolTip = ResourceManager.getInstance().getString("resources","rankedGame_arrangedTeam_startGameButton_5v5notEnoughPlayers_tooltip",[this.gameQueueManager.selectedGameQueueConfig.minimumParticipantListSize]);
               }
            }
            else if(_loc2_ < this.gameQueueManager.selectedGameQueueConfig.minimumParticipantListSize)
            {
               _loc1_ = false;
               this.startChampionSelection_btn.toolTip = ResourceManager.getInstance().getString("resources","rankedGame_arrangedTeam_startGameButton_3v3notEnoughPlayers_tooltip",[this.gameQueueManager.selectedGameQueueConfig.minimumParticipantListSize]);
            }
         }
         this.startChampionSelection_btn.enabled = _loc1_;
         if(_loc1_)
         {
            this.startChampionSelection_btn.toolTip = resourceManager.getString("resources","normalGame_arrangedTeam_startGameButton_tooltip");
         }
      }
      
      public function set leftContent_c(param1:Canvas) : void
      {
         var _loc2_:Object = this._200383958leftContent_c;
         if(_loc2_ !== param1)
         {
            this._200383958leftContent_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leftContent_c",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomRow() : ConstraintRow
      {
         return this._1855392849bottomRow;
      }
      
      [Bindable(event="propertyChange")]
      private function get _showSuggestedPlayersPanel() : Boolean
      {
         return this._1148516281_showSuggestedPlayersPanel;
      }
      
      [Bindable(event="propertyChange")]
      public function get guestSlotCountLabel() : Label
      {
         return this._1427263419guestSlotCountLabel;
      }
      
      private function joinQueueButtonClicked() : void
      {
         if(!this.masterGameViewController.isBusy)
         {
            this.masterGameViewController.joinQueue();
         }
      }
      
      private function onGuestSlotsEnabledChanged() : void
      {
         this.teamGuestSlotsEnabled = this._guestSlotsEnabledConfig.getValue();
         this.updateGuestSlotsDisplay();
      }
      
      public function set inviteePanel(param1:InviteePanel) : void
      {
         var _loc2_:Object = this._769234152inviteePanel;
         if(_loc2_ !== param1)
         {
            this._769234152inviteePanel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inviteePanel",_loc2_,param1));
         }
      }
      
      private function unwatchInvites() : void
      {
         if(!this.inviteGroup)
         {
            return;
         }
         this.inviteGroup.numGuestSlotsChanged.remove(this.updateGuestSlotsDisplay);
         this.inviteGroup.numGuestSlotsUsedChanged.remove(this.updateGuestSlotsDisplay);
         this.inviteGroup.getIsOwnerChangedSignal().remove(this.onIsOwnerChanged);
         this.inviteGroup.allowedToInviteChanged.remove(this.onIsOwnerChanged);
         this.inviteGroup.getChatRoomChangedSignal().remove(this.onInviteChatRoomChanged);
         if(this.inviteGroup.acceptedParticipants)
         {
            this.inviteGroup.acceptedParticipants.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onAcceptedParticipantsModified);
         }
      }
      
      private function onInviteProvider(param1:IInviteProvider) : void
      {
         this.inviteGroup = param1.getInviteGroup();
         this.inviteController = param1.getInviteController();
         if(this.embeddedChat)
         {
            this.embeddedChat.chatRoom = this.inviteGroup.chatRoom;
         }
         this.watchInvites();
         this.updateGuestSlotsDisplay();
         this.updateStartButton();
      }
      
      public function set map_holder(param1:Canvas) : void
      {
         var _loc2_:Object = this._51534353map_holder;
         if(_loc2_ !== param1)
         {
            this._51534353map_holder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"map_holder",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leftContent_c() : Canvas
      {
         return this._200383958leftContent_c;
      }
      
      private function set _1450947915masterGameViewController(param1:MasterGameViewController) : void
      {
         if(param1)
         {
            this._masterGameViewController = param1;
         }
      }
      
      public function __quitGame_btn_click(param1:MouseEvent) : void
      {
         this.cancelQueueButtonClicked();
      }
      
      private function set inviteGroup(param1:InviteGroup) : void
      {
         var _loc2_:Object = this._1525885706inviteGroup;
         if(_loc2_ !== param1)
         {
            this._1525885706inviteGroup = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inviteGroup",_loc2_,param1));
         }
      }
      
      public function __startChampionSelection_btn_click(param1:MouseEvent) : void
      {
         this.joinQueueButtonClicked();
      }
      
      [Bindable(event="propertyChange")]
      public function get map_holder() : Canvas
      {
         return this._51534353map_holder;
      }
      
      private function onInviteChatRoomChanged(param1:ChatRoom) : void
      {
         this.embeddedChat.chatRoom = param1;
      }
      
      private function _CreateNormalArrangedGame_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Number
         {
            return statDetails.x - 8;
         },function(param1:Number):void
         {
            _CreateNormalArrangedGame_Image2.x = param1;
         },"_CreateNormalArrangedGame_Image2.x");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_pvp_headerFlame_blue");
         },function(param1:Object):void
         {
            _CreateNormalArrangedGame_Image2.source = param1;
         },"_CreateNormalArrangedGame_Image2.source");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","normalGame_arrangedTeam_yourTeamHeaderLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            statDetails.text = param1;
         },"statDetails.text");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return this.leftContent_c.height - 40;
         },function(param1:Number):void
         {
            _CreateNormalArrangedGame_HRule1.y = param1;
         },"_CreateNormalArrangedGame_HRule1.y");
         result[3] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !isExpandedLayout;
         },function(param1:Boolean):void
         {
            _CreateNormalArrangedGame_HRule1.visible = param1;
         },"_CreateNormalArrangedGame_HRule1.visible");
         result[4] = binding;
         binding = new Binding(this,function():Number
         {
            return mapDetails.x - 8;
         },function(param1:Number):void
         {
            _CreateNormalArrangedGame_Image3.x = param1;
         },"_CreateNormalArrangedGame_Image3.x");
         result[5] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_pvp_headerFlame_blue");
         },function(param1:Object):void
         {
            _CreateNormalArrangedGame_Image3.source = param1;
         },"_CreateNormalArrangedGame_Image3.source");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","normalGame_arrangedTeam_mapOptionsHeaderLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            mapDetails.text = param1;
         },"mapDetails.text");
         result[7] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getMapSource(this.masterGameController.gameModel.gameMap);
         },function(param1:Object):void
         {
            mapImage.source = param1;
         },"mapImage.source");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = map_holder.y + map_holder.height + 2;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _CreateNormalArrangedGame_Text1.setStyle("top",param1);
         },"_CreateNormalArrangedGame_Text1.top");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.htmlMapDescription;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _CreateNormalArrangedGame_Text1.htmlText = param1;
         },"_CreateNormalArrangedGame_Text1.htmlText");
         result[10] = binding;
         binding = new Binding(this,function():Boolean
         {
            return Boolean(inviteGroup.isOwner) || Boolean(inviteGroup.allowedToInvite);
         },function(param1:Boolean):void
         {
            inviteePanel.allowedtoInvite = param1;
         },"inviteePanel.allowedtoInvite");
         result[11] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = _showSuggestedPlayersPanel ? "bottomGutter:4" : "bottomRow:0";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            inviteePanel.setStyle("bottom",param1);
         },"inviteePanel.bottom");
         result[12] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","normalGame_arrangedTeam_cancelButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            quitGame_btn.label = param1;
         },"quitGame_btn.label");
         result[13] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","normalGame_arrangedTeam_cancelButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            quitGame_btn.toolTip = param1;
         },"quitGame_btn.toolTip");
         result[14] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !this.masterGameViewController.isBusy;
         },function(param1:Boolean):void
         {
            quitGame_btn.enabled = param1;
         },"quitGame_btn.enabled");
         result[15] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = _showSuggestedPlayersPanel ? "bottomGutter:4" : "bottomRow:0";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            quitGame_btn.setStyle("bottom",param1);
         },"quitGame_btn.bottom");
         result[16] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","normalGame_arrangedTeam_startGameButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            startChampionSelection_btn.label = param1;
         },"startChampionSelection_btn.label");
         result[17] = binding;
         binding = new Binding(this,function():Boolean
         {
            return inviteGroup.isOwner;
         },function(param1:Boolean):void
         {
            startChampionSelection_btn.visible = param1;
         },"startChampionSelection_btn.visible");
         result[18] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = _showSuggestedPlayersPanel ? "bottomGutter:4" : "bottomRow:0";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            startChampionSelection_btn.setStyle("bottom",param1);
         },"startChampionSelection_btn.bottom");
         result[19] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = _showSuggestedPlayersPanel ? "leftColumn:0" : "rightColumn:2";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _CreateNormalArrangedGame_Canvas6.setStyle("right",param1);
         },"_CreateNormalArrangedGame_Canvas6.right");
         result[20] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_chatRoom_title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            embeddedChat.chatTitle = param1;
         },"embeddedChat.chatTitle");
         result[21] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = _showSuggestedPlayersPanel ? "leftColumn:0" : "rightColumn:2";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            embeddedChat.setStyle("right",param1);
         },"embeddedChat.right");
         result[22] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get quitGame_btn() : SoundEffectButton
      {
         return this._1836939262quitGame_btn;
      }
   }
}

