package com.riotgames.platform.gameclient.views.game.practice.teamselection
{
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.Models.MaxViewableTeamSize;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.views.chatpanel.ChampionSelectChatWindow;
   import com.riotgames.pvpnet.game.controllers.TeamSelectionController;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlerterProviderProxy;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
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
   import mx.collections.ArrayCollection;
   import mx.containers.Canvas;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.controls.VRule;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class TeamSelectionPanel2 extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _1655307837leftColumn:ConstraintColumn;
      
      public var alerter:IAlerterProvider = AlerterProviderProxy.instance;
      
      mx_internal var _watchers:Array = [];
      
      private var _567412016topGutter:ConstraintRow;
      
      private var _11848684spectatorTeam:SpectatorPanel;
      
      private var _1634913538embeddedChat:ChampionSelectChatWindow;
      
      [Inject]
      private var _843995307teamSelectionController:TeamSelectionController;
      
      private var _873431918rightColumn:ConstraintColumn;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _1095982834redTeam_c:TeamPanel2;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private const BUTTON_WIDTH:int = 200;
      
      public var _TeamSelectionPanel2_Canvas4:Canvas;
      
      private var _739102562chatRow:ConstraintRow;
      
      private var _19981317blueTeam_c:TeamPanel2;
      
      mx_internal var _bindings:Array = [];
      
      private var _1439300035teamRow:ConstraintRow;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Canvas,
               "stylesFactory":function():void
               {
                  this.cornerRadius = 2;
                  this.top = "teamRow:0";
                  this.bottom = "teamRow:2";
                  this.left = "0";
                  this.right = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"blueParchmentTablet",
                     "constraintColumns":[_TeamSelectionPanel2_ConstraintColumn1_i(),_TeamSelectionPanel2_ConstraintColumn2_i()],
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":TeamPanel2,
                        "id":"blueTeam_c",
                        "stylesFactory":function():void
                        {
                           this.top = "0";
                           this.bottom = "0";
                           this.left = "0";
                           this.right = "leftColumn:-1";
                        }
                     }),new UIComponentDescriptor({
                        "type":TeamPanel2,
                        "id":"redTeam_c",
                        "stylesFactory":function():void
                        {
                           this.top = "0";
                           this.bottom = "0";
                           this.left = "rightColumn:-1";
                           this.right = "0";
                        }
                     }),new UIComponentDescriptor({
                        "type":VRule,
                        "stylesFactory":function():void
                        {
                           this.right = "leftColumn:-1";
                           this.top = "4";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "styleName":"blackBeveledInverted",
                              "height":20
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":VRule,
                        "stylesFactory":function():void
                        {
                           this.right = "leftColumn:-1";
                           this.top = "40";
                           this.bottom = "8";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"styleName":"blackBeveled"};
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "stylesFactory":function():void
               {
                  this.top = "chatRow:2";
                  this.bottom = "chatRow:0";
                  this.left = "0";
                  this.right = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {"childDescriptors":[new UIComponentDescriptor({
                     "type":ChampionSelectChatWindow,
                     "id":"embeddedChat",
                     "stylesFactory":function():void
                     {
                        this.top = "0";
                        this.bottom = "1";
                        this.left = "0";
                     }
                  }),new UIComponentDescriptor({
                     "type":Canvas,
                     "id":"_TeamSelectionPanel2_Canvas4",
                     "stylesFactory":function():void
                     {
                        this.cornerRadius = 2;
                        this.top = "0";
                        this.left = "645";
                        this.bottom = "0";
                        this.right = "0";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "styleName":"blueParchmentTablet",
                           "childDescriptors":[new UIComponentDescriptor({
                              "type":SpectatorPanel,
                              "id":"spectatorTeam",
                              "stylesFactory":function():void
                              {
                                 this.top = "0";
                                 this.bottom = "0";
                                 this.left = "0";
                                 this.right = "0";
                              }
                           })]
                        };
                     }
                  })]};
               }
            })]};
         }
      });
      
      public function TeamSelectionPanel2()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.percentWidth = 100;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.constraintRows = [this._TeamSelectionPanel2_ConstraintRow1_i(),this._TeamSelectionPanel2_ConstraintRow2_i(),this._TeamSelectionPanel2_ConstraintRow3_i()];
         this.addEventListener("initialize",this.___TeamSelectionPanel2_Canvas1_initialize);
         this.addEventListener("addedToStage",this.___TeamSelectionPanel2_Canvas1_addedToStage);
         this.addEventListener("removedFromStage",this.___TeamSelectionPanel2_Canvas1_removedFromStage);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         TeamSelectionPanel2._watcherSetupUtil = param1;
      }
      
      public function set teamRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._1439300035teamRow;
         if(_loc2_ !== param1)
         {
            this._1439300035teamRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamRow",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get blueTeam_c() : TeamPanel2
      {
         return this._19981317blueTeam_c;
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
      
      public function set blueTeam_c(param1:TeamPanel2) : void
      {
         var _loc2_:Object = this._19981317blueTeam_c;
         if(_loc2_ !== param1)
         {
            this._19981317blueTeam_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"blueTeam_c",_loc2_,param1));
         }
      }
      
      private function onGameChanged() : void
      {
         var _loc1_:Boolean = false;
         if(this.teamSelectionController.masterGameController.currentGame != null)
         {
            _loc1_ = this.teamSelectionController.masterGameController.currentGame.maxNumPlayers / 2 > MaxViewableTeamSize.TEAM_SIZE_NORMAL_VIEW_LIMIT;
            this.teamRow.height = _loc1_ ? 460 : 388;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get spectatorTeam() : SpectatorPanel
      {
         return this._11848684spectatorTeam;
      }
      
      [Bindable(event="propertyChange")]
      public function get embeddedChat() : ChampionSelectChatWindow
      {
         return this._1634913538embeddedChat;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:TeamSelectionPanel2 = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._TeamSelectionPanel2_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_practice_teamselection_TeamSelectionPanel2WatcherSetupUtil");
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
      
      public function ___TeamSelectionPanel2_Canvas1_removedFromStage(param1:Event) : void
      {
         this.onRemovedFromStage();
      }
      
      private function _TeamSelectionPanel2_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.teamRow = _loc1_;
         _loc1_.height = 388;
         _loc1_.initialized(this,"teamRow");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get rightColumn() : ConstraintColumn
      {
         return this._873431918rightColumn;
      }
      
      private function onAddedToStage() : void
      {
         this.teamSelectionController.masterGameController.getCurrentGameChanged().add(this.onGameChanged);
         this.onGameChanged();
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
      
      private function _TeamSelectionPanel2_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.rightColumn = _loc1_;
         _loc1_.percentWidth = 50;
         _loc1_.initialized(this,"rightColumn");
         return _loc1_;
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
      public function get teamRow() : ConstraintRow
      {
         return this._1439300035teamRow;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get teamSelectionController() : TeamSelectionController
      {
         return this._843995307teamSelectionController;
      }
      
      private function onTeamFullError() : void
      {
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc2_:AlertAction = new AlertAction(_loc1_.getString("resources","practiceGame_new_switchTeamsErrorTitle"),_loc1_.getString("resources",MessageDictionary.TEAM_FULL));
         _loc2_.add();
      }
      
      public function set chatRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._739102562chatRow;
         if(_loc2_ !== param1)
         {
            this._739102562chatRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatRow",_loc2_,param1));
         }
      }
      
      private function onSwitchTeamsError(param1:ServerError) : void
      {
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:AlertAction = new AlertAction(_loc2_.getString("resources","practiceGame_new_switchTeamsErrorTitle"),_loc2_.getString("resources",param1.errorCode,param1.messageArguments));
         _loc3_.add();
      }
      
      public function ___TeamSelectionPanel2_Canvas1_addedToStage(param1:Event) : void
      {
         this.onAddedToStage();
      }
      
      [Bindable(event="propertyChange")]
      public function get topGutter() : ConstraintRow
      {
         return this._567412016topGutter;
      }
      
      [Bindable(event="propertyChange")]
      public function get leftColumn() : ConstraintColumn
      {
         return this._1655307837leftColumn;
      }
      
      [Bindable]
      [Inject]
      private function onInitialize() : void
      {
      }
      
      public function set spectatorTeam(param1:SpectatorPanel) : void
      {
         var _loc2_:Object = this._11848684spectatorTeam;
         if(_loc2_ !== param1)
         {
            this._11848684spectatorTeam = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spectatorTeam",_loc2_,param1));
         }
      }
      
      private function _TeamSelectionPanel2_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = RiotResourceLoader.getString("practiceGame_teamSelection_team1_label");
         _loc1_ = this.teamSelectionController.blueTeamSlots;
         _loc1_ = RiotResourceLoader.getString("practiceGame_teamSelection_team2_label");
         _loc1_ = this.teamSelectionController.purpleTeamSlots;
         _loc1_ = this.teamSelectionController.currentGameSpectatable ? 304 : 0;
         _loc1_ = RiotResourceLoader.getString("practiceGame_chatRoom_title");
         _loc1_ = this.teamSelectionController.chatRoom;
         _loc1_ = this.teamSelectionController.currentGameSpectatable;
         _loc1_ = RiotResourceLoader.getString("practiceGame_teamSelection_spectators_label");
         _loc1_ = this.teamSelectionController.spectatorTeamSlots;
      }
      
      public function set teamSelectionController(param1:TeamSelectionController) : void
      {
         var _loc2_:Object = this._843995307teamSelectionController;
         if(_loc2_ !== param1)
         {
            this._843995307teamSelectionController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamSelectionController",_loc2_,param1));
         }
      }
      
      private function _TeamSelectionPanel2_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.topGutter = _loc1_;
         _loc1_.height = 0;
         _loc1_.initialized(this,"topGutter");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get chatRow() : ConstraintRow
      {
         return this._739102562chatRow;
      }
      
      public function set redTeam_c(param1:TeamPanel2) : void
      {
         var _loc2_:Object = this._1095982834redTeam_c;
         if(_loc2_ !== param1)
         {
            this._1095982834redTeam_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"redTeam_c",_loc2_,param1));
         }
      }
      
      private function _TeamSelectionPanel2_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.leftColumn = _loc1_;
         _loc1_.percentWidth = 50;
         _loc1_.initialized(this,"leftColumn");
         return _loc1_;
      }
      
      private function _TeamSelectionPanel2_ConstraintRow3_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.chatRow = _loc1_;
         _loc1_.percentHeight = 100;
         _loc1_.initialized(this,"chatRow");
         return _loc1_;
      }
      
      private function onSwitchTeamsButtonClicked(param1:MouseEvent) : void
      {
         this.teamSelectionController.switchTeams(this.onTeamFullError,this.onSwitchTeamsError);
      }
      
      private function _TeamSelectionPanel2_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_teamSelection_team1_label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            blueTeam_c.teamLabel = param1;
         },"blueTeam_c.teamLabel");
         result[0] = binding;
         binding = new Binding(this,function():ArrayCollection
         {
            return this.teamSelectionController.blueTeamSlots;
         },function(param1:ArrayCollection):void
         {
            blueTeam_c.teamMembers = param1;
         },"blueTeam_c.teamMembers");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_teamSelection_team2_label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            redTeam_c.teamLabel = param1;
         },"redTeam_c.teamLabel");
         result[2] = binding;
         binding = new Binding(this,function():ArrayCollection
         {
            return this.teamSelectionController.purpleTeamSlots;
         },function(param1:ArrayCollection):void
         {
            redTeam_c.teamMembers = param1;
         },"redTeam_c.teamMembers");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.teamSelectionController.currentGameSpectatable ? 304 : 0;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            embeddedChat.setStyle("right",param1);
         },"embeddedChat.right");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_chatRoom_title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            embeddedChat.chatTitle = param1;
         },"embeddedChat.chatTitle");
         result[5] = binding;
         binding = new Binding(this,function():ChatRoom
         {
            return this.teamSelectionController.chatRoom;
         },function(param1:ChatRoom):void
         {
            embeddedChat.chatRoom = param1;
         },"embeddedChat.chatRoom");
         result[6] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.teamSelectionController.currentGameSpectatable;
         },function(param1:Boolean):void
         {
            _TeamSelectionPanel2_Canvas4.visible = param1;
         },"_TeamSelectionPanel2_Canvas4.visible");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("practiceGame_teamSelection_spectators_label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            spectatorTeam.teamLabel = param1;
         },"spectatorTeam.teamLabel");
         result[8] = binding;
         binding = new Binding(this,function():ArrayCollection
         {
            return this.teamSelectionController.spectatorTeamSlots;
         },function(param1:ArrayCollection):void
         {
            spectatorTeam.teamMembers = param1;
         },"spectatorTeam.teamMembers");
         result[9] = binding;
         return result;
      }
      
      private function onRemovedFromStage() : void
      {
         this.teamSelectionController.masterGameController.getCurrentGameChanged().remove(this.onGameChanged);
      }
      
      public function ___TeamSelectionPanel2_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      [Bindable(event="propertyChange")]
      public function get redTeam_c() : TeamPanel2
      {
         return this._1095982834redTeam_c;
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
   }
}

