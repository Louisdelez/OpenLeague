package com.riotgames.platform.gameclient.views.game.practice.join
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.JoinGamePopup;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.game.practice.PracticeGameSearchResult;
   import com.riotgames.platform.gameclient.event.JoinGamePopupEvent;
   import com.riotgames.pvpnet.game.controllers.practice.JoinGameController;
   import com.riotgames.pvpnet.game.controllers.practice.PracticeGameParameters;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlertWaitAction;
   import com.riotgames.pvpnet.system.alerter.AlerterProviderProxy;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.util.string.RiotStringUtil;
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
   import mx.containers.Canvas;
   import mx.containers.HBox;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.controls.CheckBox;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.Spacer;
   import mx.controls.Text;
   import mx.controls.TextInput;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.CursorManager;
   import mx.managers.PopUpManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class JoinGamePanel extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static const MINIMUM_GAME_REFRESH_COOLDOWN:int = 3000;
      
      private static const SPECTATE_GAME_COOLDOWN:int = 2000;
      
      private var _753137065rightGutter:ConstraintColumn;
      
      private var _1051062164quit_btn:SoundEffectButton;
      
      private var _1911380774bottomGutter:ConstraintRow;
      
      private var _567412016topGutter:ConstraintRow;
      
      private var _htmlMapDescription:String;
      
      private var _810109986lobbyTitle:String;
      
      private var _1775602690leftGutter:ConstraintColumn;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      public var _JoinGamePanel_Image2:Image;
      
      private var _11564360buttonRow:ConstraintRow;
      
      private var joiningPracticeGameWaitAction:AlertWaitAction;
      
      private var _1764567629refreshAllowed:Boolean;
      
      private var _1980494804canJoinGame:Boolean;
      
      private var isBusyChangeWatcher:ChangeWatcher;
      
      private var _870998989mapInfoRightGutter:ConstraintColumn;
      
      private var _868055995topRow:ConstraintRow;
      
      private var joiningGame:Boolean = false;
      
      private var _1362340074mapInfoLabel:Label;
      
      private var _377667256btnJoinGame:SoundEffectButton;
      
      public var _JoinGamePanel_SoundEffectButton2:SoundEffectButton;
      
      private var _2087765919lobbyTitleColor:uint = 16777215;
      
      private var _837049952map_img:Image;
      
      private var filterText:String = "";
      
      private var _1149084451spectateOnCooldown:Boolean = false;
      
      private var _1131641650btnObserveGame:SoundEffectButton;
      
      private var _102302328mapInfoHeading:GradientCanvas;
      
      private var _1703146155mapInfoCenterColumn:ConstraintColumn;
      
      private var _873431918rightColumn:ConstraintColumn;
      
      private var _1600778643btnGoToCreateGame:SoundEffectButton;
      
      private var _475302141mapInfoHeaderRow:ConstraintRow;
      
      private var _1661684654customGameSearchTextInput:TextInput;
      
      private var _2051331124mapInfoLeftGutter:ConstraintColumn;
      
      private var _1655307837leftColumn:ConstraintColumn;
      
      private var _655255227centerRow:ConstraintRow;
      
      public var alerter:IAlerterProvider = AlerterProviderProxy.instance;
      
      private var _1895424275clientConfig:ClientConfig;
      
      private var _1905772862canObserveGame:Boolean;
      
      private var _2016930040mapInfoDescriptionRow:ConstraintRow;
      
      private var isOnCooldown:Boolean = false;
      
      private var _1810458494showPrivateGamesCheckbox:CheckBox;
      
      private var _1520224996practiceGames_dg:CustomGameDataGrid;
      
      [Inject]
      private var _620829944joinGameController:JoinGameController;
      
      private var _200383958leftContent_c:Canvas;
      
      private var _1166031975headerLabel:Label;
      
      private var _11595557buttons_c:HBox;
      
      private var _688102488mapInfoMapRow:ConstraintRow;
      
      mx_internal var _watchers:Array = [];
      
      private var _240714593rightContent_c:Canvas;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      public var _JoinGamePanel_Text1:Text;
      
      private var passwordCanvas:JoinGamePopup;
      
      public var _JoinGamePanel_Label2:Label;
      
      public var _JoinGamePanel_Label3:Label;
      
      mx_internal var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":HBox,
               "stylesFactory":function():void
               {
                  this.left = "leftColumn:0";
                  this.right = "leftColumn:0";
                  this.top = "topRow:0";
                  this.verticalAlign = "middle";
                  this.paddingTop = 0;
                  this.paddingLeft = 10;
               },
               "propertiesFactory":function():Object
               {
                  return {"childDescriptors":[new UIComponentDescriptor({
                     "type":Label,
                     "id":"headerLabel",
                     "stylesFactory":function():void
                     {
                        this.fontSize = 18;
                     }
                  }),new UIComponentDescriptor({
                     "type":Spacer,
                     "propertiesFactory":function():Object
                     {
                        return {"percentWidth":100};
                     }
                  }),new UIComponentDescriptor({
                     "type":Label,
                     "id":"_JoinGamePanel_Label2",
                     "stylesFactory":function():void
                     {
                        this.fontSize = 14;
                        this.color = 16777215;
                        this.paddingTop = 8;
                     }
                  }),new UIComponentDescriptor({
                     "type":TextInput,
                     "id":"customGameSearchTextInput",
                     "events":{
                        "change":"__customGameSearchTextInput_change",
                        "click":"__customGameSearchTextInput_click"
                     },
                     "stylesFactory":function():void
                     {
                        this.paddingRight = 10;
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "styleName":"standard",
                           "width":250
                        };
                     }
                  })]};
               }
            }),new UIComponentDescriptor({
               "type":Label,
               "id":"_JoinGamePanel_Label3",
               "stylesFactory":function():void
               {
                  this.fontSize = 18;
                  this.color = 16777215;
                  this.left = "rightColumn:13";
                  this.right = "rightColumn:3";
                  this.top = "topRow:2";
                  this.bottom = "topRow:5";
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"leftContent_c",
               "stylesFactory":function():void
               {
                  this.backgroundAlpha = 0;
                  this.left = "leftColumn:0";
                  this.right = "leftColumn:0";
                  this.top = "centerRow:0";
                  this.bottom = "centerRow:0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "styleName":"blueParchmentTablet",
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":CustomGameDataGrid,
                        "id":"practiceGames_dg",
                        "events":{
                           "itemDoubleClick":"__practiceGames_dg_itemDoubleClick",
                           "change":"__practiceGames_dg_change"
                        },
                        "stylesFactory":function():void
                        {
                           this.top = "0";
                           this.left = "-2";
                           this.right = "-2";
                           this.bottom = "0";
                           this.paddingTop = 10;
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "rowHeight":35,
                              "headerHeight":35,
                              "doubleClickEnabled":true
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":HBox,
               "id":"buttons_c",
               "stylesFactory":function():void
               {
                  this.verticalAlign = "middle";
                  this.left = "-1";
                  this.right = "3";
                  this.top = "buttonRow:0";
                  this.bottom = "buttonRow:5";
                  this.horizontalGap = 0;
               },
               "propertiesFactory":function():Object
               {
                  return {"childDescriptors":[new UIComponentDescriptor({
                     "type":SoundEffectButton,
                     "id":"quit_btn",
                     "events":{"click":"__quit_btn_click"},
                     "propertiesFactory":function():Object
                     {
                        return {"styleName":"longButtonBlue"};
                     }
                  }),new UIComponentDescriptor({
                     "type":SoundEffectButton,
                     "id":"_JoinGamePanel_SoundEffectButton2",
                     "events":{"click":"___JoinGamePanel_SoundEffectButton2_click"},
                     "propertiesFactory":function():Object
                     {
                        return {"styleName":"longButtonBlue"};
                     }
                  }),new UIComponentDescriptor({
                     "type":Spacer,
                     "propertiesFactory":function():Object
                     {
                        return {"width":5};
                     }
                  }),new UIComponentDescriptor({
                     "type":CheckBox,
                     "id":"showPrivateGamesCheckbox",
                     "events":{
                        "change":"__showPrivateGamesCheckbox_change",
                        "creationComplete":"__showPrivateGamesCheckbox_creationComplete"
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "selected":false,
                           "styleName":"blueCheckBox"
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":Spacer,
                     "propertiesFactory":function():Object
                     {
                        return {"percentWidth":100};
                     }
                  }),new UIComponentDescriptor({
                     "type":SoundEffectButton,
                     "id":"btnObserveGame",
                     "events":{"click":"__btnObserveGame_click"},
                     "propertiesFactory":function():Object
                     {
                        return {"styleName":"longButtonBlue"};
                     }
                  }),new UIComponentDescriptor({
                     "type":SoundEffectButton,
                     "id":"btnGoToCreateGame",
                     "events":{"click":"__btnGoToCreateGame_click"},
                     "propertiesFactory":function():Object
                     {
                        return {"styleName":"longButtonBlue"};
                     }
                  }),new UIComponentDescriptor({
                     "type":SoundEffectButton,
                     "id":"btnJoinGame",
                     "events":{"click":"__btnJoinGame_click"},
                     "propertiesFactory":function():Object
                     {
                        return {
                           "styleName":"longButtonBlue",
                           "width":150,
                           "height":45
                        };
                     }
                  })]};
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"rightContent_c",
               "stylesFactory":function():void
               {
                  this.left = "rightColumn:8";
                  this.right = "rightColumn:3";
                  this.top = "centerRow:0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "height":192,
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "styleName":"blueParchmentTablet",
                     "constraintColumns":[_JoinGamePanel_ConstraintColumn5_i(),_JoinGamePanel_ConstraintColumn6_i(),_JoinGamePanel_ConstraintColumn7_i()],
                     "constraintRows":[_JoinGamePanel_ConstraintRow6_i(),_JoinGamePanel_ConstraintRow7_i(),_JoinGamePanel_ConstraintRow8_i()],
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Image,
                        "id":"map_img",
                        "stylesFactory":function():void
                        {
                           this.left = "0";
                           this.bottom = "0";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "width":297,
                              "maintainAspectRatio":true
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":GradientCanvas,
                        "id":"mapInfoHeading",
                        "stylesFactory":function():void
                        {
                           this.left = "-1";
                           this.right = "-1";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "styleName":"blueHeaderBackground",
                              "height":36,
                              "y":-1,
                              "horizontalScrollPolicy":"off",
                              "verticalScrollPolicy":"off",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":Image,
                                 "id":"_JoinGamePanel_Image2",
                                 "stylesFactory":function():void
                                 {
                                    this.verticalCenter = "0";
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Label,
                                 "id":"mapInfoLabel",
                                 "stylesFactory":function():void
                                 {
                                    this.left = "10";
                                    this.verticalCenter = "0";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {"styleName":"blueThemeHeaderText"};
                                 }
                              })]
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "stylesFactory":function():void
               {
                  this.left = "rightColumn:8";
                  this.right = "rightColumn:3";
                  this.top = "240";
                  this.bottom = "centerRow:0";
                  this.verticalScrollBarStyleName = "wide";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "styleName":"blueParchmentTablet",
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Text,
                        "id":"_JoinGamePanel_Text1",
                        "stylesFactory":function():void
                        {
                           this.fontSize = 13;
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":100,
                              "percentHeight":100,
                              "x":2,
                              "selectable":false
                           };
                        }
                     })]
                  };
               }
            })]};
         }
      });
      
      public function JoinGamePanel()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.constraintColumns = [this._JoinGamePanel_ConstraintColumn1_i(),this._JoinGamePanel_ConstraintColumn2_i(),this._JoinGamePanel_ConstraintColumn3_i(),this._JoinGamePanel_ConstraintColumn4_i()];
         this.constraintRows = [this._JoinGamePanel_ConstraintRow1_i(),this._JoinGamePanel_ConstraintRow2_i(),this._JoinGamePanel_ConstraintRow3_i(),this._JoinGamePanel_ConstraintRow4_i(),this._JoinGamePanel_ConstraintRow5_i()];
         this.addEventListener("initialize",this.___JoinGamePanel_Canvas1_initialize);
         this.addEventListener("addedToStage",this.___JoinGamePanel_Canvas1_addedToStage);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         JoinGamePanel._watcherSetupUtil = param1;
      }
      
      private function onRefreshButtonClicked(param1:MouseEvent) : void
      {
         this.clearJoinOrObserveGameToggles();
         this.practiceGames_dg.selectedItem = null;
         this.htmlMapDescription = "";
         this.mapImageSource = null;
         this.map_img.source = null;
         this.joinGameController.refreshAvailablePracticeGames();
         this.isOnCooldown = true;
         this.updateRefreshAllowed();
         setTimeout(this.onCooldownTimeout,MINIMUM_GAME_REFRESH_COOLDOWN);
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
      
      public function set mapInfoHeaderRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._475302141mapInfoHeaderRow;
         if(_loc2_ !== param1)
         {
            this._475302141mapInfoHeaderRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapInfoHeaderRow",_loc2_,param1));
         }
      }
      
      public function set mapInfoDescriptionRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._2016930040mapInfoDescriptionRow;
         if(_loc2_ !== param1)
         {
            this._2016930040mapInfoDescriptionRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapInfoDescriptionRow",_loc2_,param1));
         }
      }
      
      public function __btnObserveGame_click(param1:MouseEvent) : void
      {
         this.onObserveGameButtonClicked(param1);
      }
      
      private function _JoinGamePanel_ConstraintRow3_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.centerRow = _loc1_;
         _loc1_.percentHeight = 100;
         _loc1_.initialized(this,"centerRow");
         return _loc1_;
      }
      
      public function popupEventListener(param1:JoinGamePopupEvent) : void
      {
         var _loc2_:String = null;
         if(param1.type == JoinGamePopupEvent.OK_BUTTON_CLICK)
         {
            PopUpManager.removePopUp(this.passwordCanvas);
            _loc2_ = JoinGamePopupEvent(param1).params;
            this.joinGame(_loc2_);
         }
         else
         {
            PopUpManager.removePopUp(this.passwordCanvas);
         }
      }
      
      public function __customGameSearchTextInput_change(param1:Event) : void
      {
         this.doCustomGameFilter();
      }
      
      private function _JoinGamePanel_ConstraintColumn5_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.mapInfoLeftGutter = _loc1_;
         _loc1_.width = 5;
         _loc1_.initialized(this,"mapInfoLeftGutter");
         return _loc1_;
      }
      
      private function spectateCooldownExpired() : void
      {
         this.spectateOnCooldown = false;
      }
      
      [Bindable(event="propertyChange")]
      private function get lobbyTitle() : String
      {
         return this._810109986lobbyTitle;
      }
      
      public function set practiceGames_dg(param1:CustomGameDataGrid) : void
      {
         var _loc2_:Object = this._1520224996practiceGames_dg;
         if(_loc2_ !== param1)
         {
            this._1520224996practiceGames_dg = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"practiceGames_dg",_loc2_,param1));
         }
      }
      
      private function onGameSelected(param1:ListEvent) : void
      {
         this.htmlMapDescription = null;
         this.map_img.source = this.mapImageSource;
         if(this.practiceGames_dg.selectedItem != null && !this.joinGameController.isBusy)
         {
            this.canObserveGame = Boolean(this.practiceGames_dg.selectedItem.canLobbySpectate) && !this.practiceGames_dg.selectedItem.isSpectatorFull && !this.spectateOnCooldown;
            this.canJoinGame = !this.practiceGames_dg.selectedItem.isGameFull;
         }
         else
         {
            this.clearJoinOrObserveGameToggles();
         }
      }
      
      private function joinGame(param1:String) : void
      {
         var _loc2_:PracticeGameSearchResult = this.practiceGames_dg.selectedItem as PracticeGameSearchResult;
         if(_loc2_ != null)
         {
            this.joiningGame = true;
            this.joinGameController.joinGame(_loc2_,param1,this.onJoinGameError);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leftColumn() : ConstraintColumn
      {
         return this._1655307837leftColumn;
      }
      
      private function set lobbyTitle(param1:String) : void
      {
         var _loc2_:Object = this._810109986lobbyTitle;
         if(_loc2_ !== param1)
         {
            this._810109986lobbyTitle = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lobbyTitle",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get topRow() : ConstraintRow
      {
         return this._868055995topRow;
      }
      
      private function set spectateOnCooldown(param1:Boolean) : void
      {
         var _loc2_:Object = this._1149084451spectateOnCooldown;
         if(_loc2_ !== param1)
         {
            this._1149084451spectateOnCooldown = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spectateOnCooldown",_loc2_,param1));
         }
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
      
      [Bindable(event="propertyChange")]
      private function get canJoinGame() : Boolean
      {
         return this._1980494804canJoinGame;
      }
      
      public function set buttons_c(param1:HBox) : void
      {
         var _loc2_:Object = this._11595557buttons_c;
         if(_loc2_ !== param1)
         {
            this._11595557buttons_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buttons_c",_loc2_,param1));
         }
      }
      
      public function __practiceGames_dg_change(param1:ListEvent) : void
      {
         this.onGameSelected(param1);
      }
      
      private function _JoinGamePanel_ConstraintColumn4_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.rightGutter = _loc1_;
         _loc1_.width = 5;
         _loc1_.initialized(this,"rightGutter");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get customGameSearchTextInput() : TextInput
      {
         return this._1661684654customGameSearchTextInput;
      }
      
      public function get mapImageSource() : Object
      {
         if(this.practiceGames_dg.selectedItem == null)
         {
            return null;
         }
         var _loc1_:GameMap = this.practiceGames_dg.selectedItem.gameMap;
         return ImagePackLookup.instance.getMapSource(_loc1_);
      }
      
      private function customGameFilter(param1:Object) : Boolean
      {
         var _loc4_:PracticeGameParameters = null;
         var _loc5_:GameFlowVariant = null;
         var _loc6_:GameFlowVariant = null;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:PracticeGameSearchResult = param1 as PracticeGameSearchResult;
         if(_loc3_ != null)
         {
            _loc4_ = this.joinGameController.practiceGameParameters;
            _loc5_ = _loc4_.variant;
            _loc6_ = GameFlowVariantFactory.instance.getVariant(_loc3_.gameMutators,_loc3_.gameMode);
            _loc2_ ||= Boolean(_loc5_.showsJoinGameLobbyItem(_loc6_));
            if(!RiotStringUtil.isEmpty(this.filterText))
            {
               _loc7_ = _loc3_.name.toLowerCase().indexOf(this.customGameSearchTextInput.text.toLowerCase()) > -1;
               _loc8_ = _loc3_.owner.summonerName.toLowerCase().indexOf(this.customGameSearchTextInput.text.toLowerCase()) > -1;
               _loc2_ &&= _loc7_ || _loc8_;
            }
            if(!this.showPrivateGamesCheckbox.selected)
            {
               _loc2_ &&= !_loc3_.privateGame;
            }
         }
         return _loc2_;
      }
      
      private function _JoinGamePanel_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.topRow = _loc1_;
         _loc1_.height = 35;
         _loc1_.initialized(this,"topRow");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get rightGutter() : ConstraintColumn
      {
         return this._753137065rightGutter;
      }
      
      private function set canJoinGame(param1:Boolean) : void
      {
         var _loc2_:Object = this._1980494804canJoinGame;
         if(_loc2_ !== param1)
         {
            this._1980494804canJoinGame = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"canJoinGame",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get lobbyTitleColor() : uint
      {
         return this._2087765919lobbyTitleColor;
      }
      
      public function set btnObserveGame(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1131641650btnObserveGame;
         if(_loc2_ !== param1)
         {
            this._1131641650btnObserveGame = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnObserveGame",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get refreshAllowed() : Boolean
      {
         return this._1764567629refreshAllowed;
      }
      
      [Bindable(event="propertyChange")]
      public function get quit_btn() : SoundEffectButton
      {
         return this._1051062164quit_btn;
      }
      
      private function onCustomGameFilterClicked() : void
      {
         this.customGameSearchTextInput.text = "";
         this.filterText = "";
         this.joinGameController.practiceGames.refresh();
      }
      
      [Bindable(event="propertyChange")]
      public function get map_img() : Image
      {
         return this._837049952map_img;
      }
      
      [Bindable(event="propertyChange")]
      public function get mapInfoHeading() : GradientCanvas
      {
         return this._102302328mapInfoHeading;
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
      
      [Bindable(event="propertyChange")]
      public function get btnGoToCreateGame() : SoundEffectButton
      {
         return this._1600778643btnGoToCreateGame;
      }
      
      private function onQuitButtonClicked(param1:MouseEvent) : void
      {
         this.joinGameController.quit();
      }
      
      private function set canObserveGame(param1:Boolean) : void
      {
         var _loc2_:Object = this._1905772862canObserveGame;
         if(_loc2_ !== param1)
         {
            this._1905772862canObserveGame = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"canObserveGame",_loc2_,param1));
         }
      }
      
      public function ___JoinGamePanel_Canvas1_addedToStage(param1:Event) : void
      {
         this.onShowLobby();
      }
      
      [Bindable(event="propertyChange")]
      public function get headerLabel() : Label
      {
         return this._1166031975headerLabel;
      }
      
      public function set buttonRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._11564360buttonRow;
         if(_loc2_ !== param1)
         {
            this._11564360buttonRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buttonRow",_loc2_,param1));
         }
      }
      
      public function set centerRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._655255227centerRow;
         if(_loc2_ !== param1)
         {
            this._655255227centerRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"centerRow",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rightColumn() : ConstraintColumn
      {
         return this._873431918rightColumn;
      }
      
      private function _JoinGamePanel_ConstraintColumn3_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.rightColumn = _loc1_;
         _loc1_.width = 285;
         _loc1_.initialized(this,"rightColumn");
         return _loc1_;
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
      
      private function _JoinGamePanel_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.topGutter = _loc1_;
         _loc1_.height = 5;
         _loc1_.initialized(this,"topGutter");
         return _loc1_;
      }
      
      private function set refreshAllowed(param1:Boolean) : void
      {
         var _loc2_:Object = this._1764567629refreshAllowed;
         if(_loc2_ !== param1)
         {
            this._1764567629refreshAllowed = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"refreshAllowed",_loc2_,param1));
         }
      }
      
      public function set customGameSearchTextInput(param1:TextInput) : void
      {
         var _loc2_:Object = this._1661684654customGameSearchTextInput;
         if(_loc2_ !== param1)
         {
            this._1661684654customGameSearchTextInput = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"customGameSearchTextInput",_loc2_,param1));
         }
      }
      
      public function set mapInfoCenterColumn(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1703146155mapInfoCenterColumn;
         if(_loc2_ !== param1)
         {
            this._1703146155mapInfoCenterColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapInfoCenterColumn",_loc2_,param1));
         }
      }
      
      public function set mapImageSource(param1:Object) : void
      {
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
      
      [Bindable(event="propertyChange")]
      public function get btnJoinGame() : SoundEffectButton
      {
         return this._377667256btnJoinGame;
      }
      
      private function onShowPrivateGamesChanged() : void
      {
         this.joinGameController.practiceGames.filterFunction = this.customGameFilter;
         this.joinGameController.practiceGames.refresh();
      }
      
      public function set rightContent_c(param1:Canvas) : void
      {
         var _loc2_:Object = this._240714593rightContent_c;
         if(_loc2_ !== param1)
         {
            this._240714593rightContent_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightContent_c",_loc2_,param1));
         }
      }
      
      public function set headerLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1166031975headerLabel;
         if(_loc2_ !== param1)
         {
            this._1166031975headerLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerLabel",_loc2_,param1));
         }
      }
      
      private function onInitialize() : void
      {
         this.initializePasswordPromptPanel();
         this.isBusyChangeWatcher = ChangeWatcher.watch(this.joinGameController,"isBusy",this.onControllerIsBusyChanged);
         this.joinGameController.practiceGamesChanged.add(this.clearJoinOrObserveGameToggles);
         this.updateRefreshAllowed();
         this.clientConfig = ClientConfig.instance;
      }
      
      private function set lobbyTitleColor(param1:uint) : void
      {
         var _loc2_:Object = this._2087765919lobbyTitleColor;
         if(_loc2_ !== param1)
         {
            this._2087765919lobbyTitleColor = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lobbyTitleColor",_loc2_,param1));
         }
      }
      
      private function _JoinGamePanel_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.leftColumn = _loc1_;
         _loc1_.width = 972;
         _loc1_.initialized(this,"leftColumn");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get topGutter() : ConstraintRow
      {
         return this._567412016topGutter;
      }
      
      public function set map_img(param1:Image) : void
      {
         var _loc2_:Object = this._837049952map_img;
         if(_loc2_ !== param1)
         {
            this._837049952map_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"map_img",_loc2_,param1));
         }
      }
      
      public function set btnGoToCreateGame(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1600778643btnGoToCreateGame;
         if(_loc2_ !== param1)
         {
            this._1600778643btnGoToCreateGame = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnGoToCreateGame",_loc2_,param1));
         }
      }
      
      private function _JoinGamePanel_ConstraintRow8_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.mapInfoDescriptionRow = _loc1_;
         _loc1_.percentHeight = 70;
         _loc1_.initialized(this,"mapInfoDescriptionRow");
         return _loc1_;
      }
      
      public function ___JoinGamePanel_SoundEffectButton2_click(param1:MouseEvent) : void
      {
         this.onRefreshButtonClicked(param1);
      }
      
      public function set quit_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1051062164quit_btn;
         if(_loc2_ !== param1)
         {
            this._1051062164quit_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"quit_btn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapInfoLabel() : Label
      {
         return this._1362340074mapInfoLabel;
      }
      
      [Bindable(event="propertyChange")]
      public function get clientConfig() : ClientConfig
      {
         return this._1895424275clientConfig;
      }
      
      public function ___JoinGamePanel_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      public function set mapInfoHeading(param1:GradientCanvas) : void
      {
         var _loc2_:Object = this._102302328mapInfoHeading;
         if(_loc2_ !== param1)
         {
            this._102302328mapInfoHeading = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapInfoHeading",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get joinGameController() : JoinGameController
      {
         return this._620829944joinGameController;
      }
      
      public function set showPrivateGamesCheckbox(param1:CheckBox) : void
      {
         var _loc2_:Object = this._1810458494showPrivateGamesCheckbox;
         if(_loc2_ !== param1)
         {
            this._1810458494showPrivateGamesCheckbox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showPrivateGamesCheckbox",_loc2_,param1));
         }
      }
      
      private function onObserveGameButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:PracticeGameSearchResult = null;
         if(this.practiceGames_dg.selectedItem != null)
         {
            _loc2_ = this.practiceGames_dg.selectedItem as PracticeGameSearchResult;
            if(_loc2_.privateGame)
            {
               this.passwordCanvas = new JoinGamePopup();
               this.passwordCanvas.addEventListener(JoinGamePopupEvent.OK_BUTTON_CLICK,this.popupEventListener_Observe);
               this.passwordCanvas.addEventListener(JoinGamePopupEvent.CANCEL_BUTTON_CLICK,this.popupEventListener_Observe);
               PopUpManager.addPopUp(this.passwordCanvas,this,true);
               PopUpManager.centerPopUp(this.passwordCanvas);
            }
            else
            {
               this.observeGame(null);
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapInfoDescriptionRow() : ConstraintRow
      {
         return this._2016930040mapInfoDescriptionRow;
      }
      
      private function doCustomGameFilter() : void
      {
         if(this.customGameSearchTextInput.text == this.filterText)
         {
            return;
         }
         this.filterText = this.customGameSearchTextInput.text;
         this.joinGameController.practiceGames.filterFunction = this.customGameFilter;
         this.joinGameController.practiceGames.refresh();
      }
      
      private function _JoinGamePanel_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.lobbyTitle;
         _loc1_ = this.lobbyTitleColor;
         _loc1_ = RiotResourceLoader.getString("practiceGame_createOrJoinGame_searchGame");
         _loc1_ = RiotResourceLoader.getString("practiceGame_createOrJoinGame_selectedGameDetails");
         _loc1_ = this.joinGameController.practiceGames;
         _loc1_ = this.clientConfig.observerModeEnabled;
         _loc1_ = resourceManager.getString("resources","practiceGame_createOrJoinGame_cancelButtonLabel");
         _loc1_ = resourceManager.getString("resources","practiceGame_createOrJoinGame_cancelButton_tooltip");
         _loc1_ = this.btnJoinGame.width;
         _loc1_ = this.btnJoinGame.height;
         _loc1_ = resourceManager.getString("resources","practiceGame_createOrJoinGame_findGamesButtonLabel");
         _loc1_ = resourceManager.getString("resources","practiceGame_createOrJoinGame_findGamesButton_tooltip");
         _loc1_ = this.refreshAllowed;
         _loc1_ = this.quit_btn.width;
         _loc1_ = this.quit_btn.height;
         _loc1_ = RiotResourceLoader.getString("practiceGame_createOrJoinGame_filterPrivateGames");
         _loc1_ = RiotResourceLoader.getString("practiceGame_createOrJoinGame_spectateButtonLabel");
         _loc1_ = RiotResourceLoader.getString("practiceGame_createOrJoinGame_spectateButtonTooltip");
         _loc1_ = this.canObserveGame;
         _loc1_ = this.clientConfig.observerModeEnabled;
         _loc1_ = this.quit_btn.width;
         _loc1_ = this.quit_btn.height;
         _loc1_ = resourceManager.getString("resources","practiceGame_createOrJoinGame_goToCreateGameButtonLabel");
         _loc1_ = resourceManager.getString("resources","practiceGame_createOrJoinGame_goToCreateGameButton_tooltip");
         _loc1_ = this.quit_btn.width;
         _loc1_ = this.quit_btn.height;
         _loc1_ = RiotResourceLoader.getString("practiceGame_createOrJoinGame_joinGameButtonLabel");
         _loc1_ = RiotResourceLoader.getString("practiceGame_createOrJoinGame_joinGameButton_tooltip");
         _loc1_ = this.canJoinGame;
         _loc1_ = this.mapInfoLabel.x - 8;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_pvp_headerFlame_blue");
         _loc1_ = RiotResourceLoader.getString("practiceGame_createPracticeGame_mapInformation_heading","Map Info");
         _loc1_ = this.htmlMapDescription == null ? "" : this.htmlMapDescription;
      }
      
      [Bindable(event="propertyChange")]
      public function get mapInfoHeaderRow() : ConstraintRow
      {
         return this._475302141mapInfoHeaderRow;
      }
      
      [Bindable(event="propertyChange")]
      public function set htmlMapDescription(param1:String) : void
      {
         var _loc2_:Object = this.htmlMapDescription;
         if(_loc2_ !== param1)
         {
            this._94069131htmlMapDescription = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"htmlMapDescription",_loc2_,param1));
         }
      }
      
      private function _JoinGamePanel_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.leftGutter = _loc1_;
         _loc1_.width = 5;
         _loc1_.initialized(this,"leftGutter");
         return _loc1_;
      }
      
      private function onJoinGameButtonClicked(param1:Event) : void
      {
         var _loc2_:PracticeGameSearchResult = null;
         if(this.practiceGames_dg.selectedItem != null)
         {
            _loc2_ = this.practiceGames_dg.selectedItem as PracticeGameSearchResult;
            if(_loc2_.privateGame)
            {
               this.passwordCanvas = new JoinGamePopup();
               this.passwordCanvas.addEventListener(JoinGamePopupEvent.OK_BUTTON_CLICK,this.popupEventListener);
               this.passwordCanvas.addEventListener(JoinGamePopupEvent.CANCEL_BUTTON_CLICK,this.popupEventListener);
               PopUpManager.addPopUp(this.passwordCanvas,this,true);
               PopUpManager.centerPopUp(this.passwordCanvas);
            }
            else
            {
               this.joinGame(null);
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get practiceGames_dg() : CustomGameDataGrid
      {
         return this._1520224996practiceGames_dg;
      }
      
      private function _JoinGamePanel_ConstraintRow7_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.mapInfoMapRow = _loc1_;
         _loc1_.percentHeight = 30;
         _loc1_.initialized(this,"mapInfoMapRow");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      private function get spectateOnCooldown() : Boolean
      {
         return this._1149084451spectateOnCooldown;
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
      
      [Bindable(event="propertyChange")]
      public function get buttons_c() : HBox
      {
         return this._11595557buttons_c;
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomGutter() : ConstraintRow
      {
         return this._1911380774bottomGutter;
      }
      
      private function observeGame(param1:String) : void
      {
         var _loc2_:PracticeGameSearchResult = this.practiceGames_dg.selectedItem as PracticeGameSearchResult;
         if(_loc2_ != null)
         {
            this.joiningGame = true;
            this.joinGameController.observeGame(_loc2_,param1,this.onJoinGameError);
            this.spectateOnCooldown = true;
            setTimeout(this.spectateCooldownExpired,SPECTATE_GAME_COOLDOWN);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get btnObserveGame() : SoundEffectButton
      {
         return this._1131641650btnObserveGame;
      }
      
      [Bindable(event="propertyChange")]
      private function get canObserveGame() : Boolean
      {
         return this._1905772862canObserveGame;
      }
      
      [Bindable(event="propertyChange")]
      public function get centerRow() : ConstraintRow
      {
         return this._655255227centerRow;
      }
      
      private function onCreateGameButtonClicked(param1:MouseEvent) : void
      {
         this.joinGameController.startPracticeGameFlowAtCreateGame();
      }
      
      private function onPracticeGameDoubleClick(param1:Event) : void
      {
         this.onJoinGameButtonClicked(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get buttonRow() : ConstraintRow
      {
         return this._11564360buttonRow;
      }
      
      public function __btnGoToCreateGame_click(param1:MouseEvent) : void
      {
         this.onCreateGameButtonClicked(param1);
      }
      
      public function set mapInfoMapRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._688102488mapInfoMapRow;
         if(_loc2_ !== param1)
         {
            this._688102488mapInfoMapRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapInfoMapRow",_loc2_,param1));
         }
      }
      
      private function _JoinGamePanel_ConstraintRow6_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.mapInfoHeaderRow = _loc1_;
         _loc1_.height = 45;
         _loc1_.initialized(this,"mapInfoHeaderRow");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get mapInfoCenterColumn() : ConstraintColumn
      {
         return this._1703146155mapInfoCenterColumn;
      }
      
      private function comparePracticeGames(param1:Object, param2:Object) : Boolean
      {
         return param1.id == param2.id;
      }
      
      public function __btnJoinGame_click(param1:MouseEvent) : void
      {
         this.onJoinGameButtonClicked(param1);
      }
      
      public function set btnJoinGame(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._377667256btnJoinGame;
         if(_loc2_ !== param1)
         {
            this._377667256btnJoinGame = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnJoinGame",_loc2_,param1));
         }
      }
      
      private function updateRefreshAllowed() : void
      {
         if(this.joinGameController != null)
         {
            this.refreshAllowed = !this.joinGameController.isBusy && !this.isOnCooldown;
         }
         else
         {
            this.refreshAllowed = false;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rightContent_c() : Canvas
      {
         return this._240714593rightContent_c;
      }
      
      public function __customGameSearchTextInput_click(param1:MouseEvent) : void
      {
         this.onCustomGameFilterClicked();
      }
      
      [Bindable(event="propertyChange")]
      public function get showPrivateGamesCheckbox() : CheckBox
      {
         return this._1810458494showPrivateGamesCheckbox;
      }
      
      private function set _94069131htmlMapDescription(param1:String) : void
      {
         this._htmlMapDescription = param1;
      }
      
      private function clearJoinOrObserveGameToggles() : void
      {
         this.canObserveGame = false;
         this.canJoinGame = false;
      }
      
      private function onJoinGameError(param1:ServerError) : void
      {
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:AlertAction = new AlertAction(_loc2_.getString("resources","practiceGame_createOrJoinGame_invalidJoinErrorTitle"),_loc2_.getString("resources",param1.errorCode,param1.messageArguments));
         _loc3_.add();
      }
      
      public function get htmlMapDescription() : String
      {
         var _loc1_:GameMap = null;
         if(this.practiceGames_dg.selectedItem == null)
         {
            this._htmlMapDescription = null;
         }
         else
         {
            _loc1_ = this.practiceGames_dg.selectedItem.gameMap as GameMap;
            this._htmlMapDescription = "<font color=\'#DBC718\'>" + RiotResourceLoader.getString("practiceGame_mapName_label") + "</font><font color=\'#FFFFFF\'>  " + _loc1_.displayName + "<br/>" + "</font><font color=\'#DBC718\'>" + RiotResourceLoader.getString("practiceGame_mapPlayers_label") + "</font><font color=\'#FFFFFF\'>  " + (_loc1_.totalPlayers / 2 + "x" + _loc1_.totalPlayers / 2).toString() + "<br/>" + "</font><font color=\'#DBC718\'>" + RiotResourceLoader.getString("practiceGame_mapDescription_label") + "</font><font color=\'#FFFFFF\'>  " + _loc1_.description + "</font>";
         }
         return this._htmlMapDescription;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:JoinGamePanel = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._JoinGamePanel_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_practice_join_JoinGamePanelWatcherSetupUtil");
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
      
      private function _JoinGamePanel_ConstraintRow5_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.bottomGutter = _loc1_;
         _loc1_.height = 4;
         _loc1_.initialized(this,"bottomGutter");
         return _loc1_;
      }
      
      public function set mapInfoRightGutter(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._870998989mapInfoRightGutter;
         if(_loc2_ !== param1)
         {
            this._870998989mapInfoRightGutter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapInfoRightGutter",_loc2_,param1));
         }
      }
      
      private function _JoinGamePanel_ConstraintColumn7_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.mapInfoRightGutter = _loc1_;
         _loc1_.width = 5;
         _loc1_.initialized(this,"mapInfoRightGutter");
         return _loc1_;
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
      
      private function onCooldownTimeout() : void
      {
         this.isOnCooldown = false;
         this.updateRefreshAllowed();
      }
      
      public function __showPrivateGamesCheckbox_change(param1:Event) : void
      {
         this.onShowPrivateGamesChanged();
      }
      
      public function initializePasswordPromptPanel() : void
      {
         var _loc1_:JoinGamePopup = new JoinGamePopup();
      }
      
      [Bindable(event="propertyChange")]
      public function get mapInfoMapRow() : ConstraintRow
      {
         return this._688102488mapInfoMapRow;
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
      
      private function onShowLobby() : void
      {
         var _loc1_:PracticeGameParameters = null;
         var _loc2_:GameFlowVariant = null;
         if(this.joinGameController != null)
         {
            _loc1_ = this.joinGameController.practiceGameParameters;
            _loc2_ = _loc1_.variant;
            this.lobbyTitle = _loc2_.getJoinGameLobbyTitle();
            this.lobbyTitleColor = _loc2_.getGameFlowColor();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapInfoRightGutter() : ConstraintColumn
      {
         return this._870998989mapInfoRightGutter;
      }
      
      public function set mapInfoLeftGutter(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._2051331124mapInfoLeftGutter;
         if(_loc2_ !== param1)
         {
            this._2051331124mapInfoLeftGutter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapInfoLeftGutter",_loc2_,param1));
         }
      }
      
      private function onControllerIsBusyChanged(param1:PropertyChangeEvent) : void
      {
         var _loc2_:IResourceManager = null;
         if(param1.newValue as Boolean)
         {
            CursorManager.getInstance().setBusyCursor();
            if(this.joiningGame)
            {
               _loc2_ = ResourceManager.getInstance();
               this.joiningPracticeGameWaitAction = new AlertWaitAction(_loc2_.getString("resources","serverWait_retrievingDataMessage"),_loc2_.getString("resources","serverWait_loadingMessage"));
               this.joiningPracticeGameWaitAction.add();
            }
         }
         else
         {
            this.joiningGame = false;
            if(this.joiningPracticeGameWaitAction)
            {
               this.joiningPracticeGameWaitAction.complete();
            }
            CursorManager.getInstance().removeBusyCursor();
         }
         this.updateRefreshAllowed();
      }
      
      private function _JoinGamePanel_ConstraintColumn6_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.mapInfoCenterColumn = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.initialized(this,"mapInfoCenterColumn");
         return _loc1_;
      }
      
      private function _JoinGamePanel_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = lobbyTitle;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            headerLabel.text = param1;
         },"headerLabel.text");
         result[0] = binding;
         binding = new Binding(this,function():uint
         {
            return lobbyTitleColor;
         },function(param1:uint):void
         {
            headerLabel.setStyle("color",param1);
         },"headerLabel.color");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_createOrJoinGame_searchGame");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _JoinGamePanel_Label2.text = param1;
         },"_JoinGamePanel_Label2.text");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_createOrJoinGame_selectedGameDetails");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _JoinGamePanel_Label3.text = param1;
         },"_JoinGamePanel_Label3.text");
         result[3] = binding;
         binding = new Binding(this,function():Object
         {
            return joinGameController.practiceGames;
         },function(param1:Object):void
         {
            practiceGames_dg.dataProvider = param1;
         },"practiceGames_dg.dataProvider");
         result[4] = binding;
         binding = new Binding(this,function():Boolean
         {
            return clientConfig.observerModeEnabled;
         },function(param1:Boolean):void
         {
            practiceGames_dg.observerModeEnabled = param1;
         },"practiceGames_dg.observerModeEnabled");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createOrJoinGame_cancelButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            quit_btn.label = param1;
         },"quit_btn.label");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createOrJoinGame_cancelButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            quit_btn.toolTip = param1;
         },"quit_btn.toolTip");
         result[7] = binding;
         binding = new Binding(this,function():Number
         {
            return this.btnJoinGame.width;
         },function(param1:Number):void
         {
            quit_btn.width = param1;
         },"quit_btn.width");
         result[8] = binding;
         binding = new Binding(this,function():Number
         {
            return this.btnJoinGame.height;
         },function(param1:Number):void
         {
            quit_btn.height = param1;
         },"quit_btn.height");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createOrJoinGame_findGamesButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _JoinGamePanel_SoundEffectButton2.label = param1;
         },"_JoinGamePanel_SoundEffectButton2.label");
         result[10] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createOrJoinGame_findGamesButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _JoinGamePanel_SoundEffectButton2.toolTip = param1;
         },"_JoinGamePanel_SoundEffectButton2.toolTip");
         result[11] = binding;
         binding = new Binding(this,function():Boolean
         {
            return refreshAllowed;
         },function(param1:Boolean):void
         {
            _JoinGamePanel_SoundEffectButton2.enabled = param1;
         },"_JoinGamePanel_SoundEffectButton2.enabled");
         result[12] = binding;
         binding = new Binding(this,function():Number
         {
            return this.quit_btn.width;
         },function(param1:Number):void
         {
            _JoinGamePanel_SoundEffectButton2.width = param1;
         },"_JoinGamePanel_SoundEffectButton2.width");
         result[13] = binding;
         binding = new Binding(this,function():Number
         {
            return this.quit_btn.height;
         },function(param1:Number):void
         {
            _JoinGamePanel_SoundEffectButton2.height = param1;
         },"_JoinGamePanel_SoundEffectButton2.height");
         result[14] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_createOrJoinGame_filterPrivateGames");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            showPrivateGamesCheckbox.label = param1;
         },"showPrivateGamesCheckbox.label");
         result[15] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_createOrJoinGame_spectateButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            btnObserveGame.label = param1;
         },"btnObserveGame.label");
         result[16] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_createOrJoinGame_spectateButtonTooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            btnObserveGame.toolTip = param1;
         },"btnObserveGame.toolTip");
         result[17] = binding;
         binding = new Binding(this,function():Boolean
         {
            return canObserveGame;
         },function(param1:Boolean):void
         {
            btnObserveGame.enabled = param1;
         },"btnObserveGame.enabled");
         result[18] = binding;
         binding = new Binding(this,function():Boolean
         {
            return clientConfig.observerModeEnabled;
         },function(param1:Boolean):void
         {
            btnObserveGame.visible = param1;
         },"btnObserveGame.visible");
         result[19] = binding;
         binding = new Binding(this,function():Number
         {
            return this.quit_btn.width;
         },function(param1:Number):void
         {
            btnObserveGame.width = param1;
         },"btnObserveGame.width");
         result[20] = binding;
         binding = new Binding(this,function():Number
         {
            return this.quit_btn.height;
         },function(param1:Number):void
         {
            btnObserveGame.height = param1;
         },"btnObserveGame.height");
         result[21] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createOrJoinGame_goToCreateGameButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            btnGoToCreateGame.label = param1;
         },"btnGoToCreateGame.label");
         result[22] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_createOrJoinGame_goToCreateGameButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            btnGoToCreateGame.toolTip = param1;
         },"btnGoToCreateGame.toolTip");
         result[23] = binding;
         binding = new Binding(this,function():Number
         {
            return this.quit_btn.width;
         },function(param1:Number):void
         {
            btnGoToCreateGame.width = param1;
         },"btnGoToCreateGame.width");
         result[24] = binding;
         binding = new Binding(this,function():Number
         {
            return this.quit_btn.height;
         },function(param1:Number):void
         {
            btnGoToCreateGame.height = param1;
         },"btnGoToCreateGame.height");
         result[25] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_createOrJoinGame_joinGameButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            btnJoinGame.label = param1;
         },"btnJoinGame.label");
         result[26] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_createOrJoinGame_joinGameButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            btnJoinGame.toolTip = param1;
         },"btnJoinGame.toolTip");
         result[27] = binding;
         binding = new Binding(this,function():Boolean
         {
            return canJoinGame;
         },function(param1:Boolean):void
         {
            btnJoinGame.enabled = param1;
         },"btnJoinGame.enabled");
         result[28] = binding;
         binding = new Binding(this,function():Number
         {
            return mapInfoLabel.x - 8;
         },function(param1:Number):void
         {
            _JoinGamePanel_Image2.x = param1;
         },"_JoinGamePanel_Image2.x");
         result[29] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_pvp_headerFlame_blue");
         },function(param1:Object):void
         {
            _JoinGamePanel_Image2.source = param1;
         },"_JoinGamePanel_Image2.source");
         result[30] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_createPracticeGame_mapInformation_heading","Map Info");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            mapInfoLabel.text = param1;
         },"mapInfoLabel.text");
         result[31] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.htmlMapDescription == null ? "" : this.htmlMapDescription;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _JoinGamePanel_Text1.htmlText = param1;
         },"_JoinGamePanel_Text1.htmlText");
         result[32] = binding;
         return result;
      }
      
      public function set mapInfoLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1362340074mapInfoLabel;
         if(_loc2_ !== param1)
         {
            this._1362340074mapInfoLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapInfoLabel",_loc2_,param1));
         }
      }
      
      public function __quit_btn_click(param1:MouseEvent) : void
      {
         this.onQuitButtonClicked(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get leftContent_c() : Canvas
      {
         return this._200383958leftContent_c;
      }
      
      private function _JoinGamePanel_ConstraintRow4_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.buttonRow = _loc1_;
         _loc1_.height = 42;
         _loc1_.initialized(this,"buttonRow");
         return _loc1_;
      }
      
      public function popupEventListener_Observe(param1:JoinGamePopupEvent) : void
      {
         var _loc2_:String = null;
         if(param1.type == JoinGamePopupEvent.OK_BUTTON_CLICK)
         {
            PopUpManager.removePopUp(this.passwordCanvas);
            _loc2_ = JoinGamePopupEvent(param1).params;
            this.observeGame(_loc2_);
         }
         else
         {
            PopUpManager.removePopUp(this.passwordCanvas);
         }
      }
      
      public function __practiceGames_dg_itemDoubleClick(param1:ListEvent) : void
      {
         this.onPracticeGameDoubleClick(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get mapInfoLeftGutter() : ConstraintColumn
      {
         return this._2051331124mapInfoLeftGutter;
      }
      
      public function set clientConfig(param1:ClientConfig) : void
      {
         var _loc2_:Object = this._1895424275clientConfig;
         if(_loc2_ !== param1)
         {
            this._1895424275clientConfig = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clientConfig",_loc2_,param1));
         }
      }
      
      public function set joinGameController(param1:JoinGameController) : void
      {
         var _loc2_:Object = this._620829944joinGameController;
         if(_loc2_ !== param1)
         {
            this._620829944joinGameController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"joinGameController",_loc2_,param1));
         }
      }
      
      public function __showPrivateGamesCheckbox_creationComplete(param1:FlexEvent) : void
      {
         this.onShowPrivateGamesChanged();
      }
   }
}

