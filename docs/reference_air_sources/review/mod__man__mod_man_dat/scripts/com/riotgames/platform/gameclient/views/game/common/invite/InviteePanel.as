package com.riotgames.platform.gameclient.views.game.common.invite
{
   import blix.action.IAction;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.gameclient.domain.gameinvite.InviteType;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.pvpnet.invite.IInviteProvider;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.suggestedplayers.ISuggestedPlayersProvider;
   import com.riotgames.pvpnet.suggestedplayers.model.SuggestedPlayer;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.util.json.jsonEncode;
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
   import mx.containers.VBox;
   import mx.controls.HRule;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.List;
   import mx.controls.Spacer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.ClassFactory;
   import mx.core.IFactory;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class InviteePanel extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _2010874441_suggestedPlayersDataProvider:ArrayCollection;
      
      mx_internal var _watchers:Array;
      
      private var _450753047inviteFriends_btn:SoundEffectButton;
      
      public var _InviteePanel_HRule1:HRule;
      
      private var _407556049nameColWidth:Number;
      
      private var _41626890inviteHeader:Label;
      
      private var _2125520928suggested_player_list:List;
      
      public var _InviteePanel_Image1:Image;
      
      private var _inviteProvider:IInviteProvider;
      
      public var _InviteePanel_Label2:Label;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _1148516281_showSuggestedPlayersPanel:Boolean = false;
      
      private var _1901004423invite_dg:List;
      
      mx_internal var _bindingsByDestination:Object;
      
      private var _1371077388allowedtoInvite:Boolean = false;
      
      private var _2147038007_inviteGroup:InviteGroup;
      
      [Inject]
      private var _1019249940chatController:ChatController;
      
      public var _InviteePanel_VBox1:VBox;
      
      [Inject]
      public var gameQueueManager:GameQueueManager;
      
      mx_internal var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _suggestedPlayersFeatureEnabled:Boolean = false;
      
      private var _suggestedPlayersProvider:ISuggestedPlayersProvider;
      
      public function InviteePanel()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":GradientCanvas,
                  "stylesFactory":function():void
                  {
                     this.top = "-1";
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
                           "id":"_InviteePanel_Image1",
                           "stylesFactory":function():void
                           {
                              this.verticalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"x":2};
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"inviteHeader",
                           "stylesFactory":function():void
                           {
                              this.left = "6";
                              this.verticalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "styleName":"blueThemeHeaderText",
                                 "selectable":false
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":SoundEffectButton,
                           "id":"inviteFriends_btn",
                           "events":{"click":"__inviteFriends_btn_click"},
                           "stylesFactory":function():void
                           {
                              this.left = "7";
                              this.top = "4";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "width":120,
                                 "height":22,
                                 "styleName":"thinShortButtonBlue"
                              };
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":VBox,
                  "id":"_InviteePanel_VBox1",
                  "stylesFactory":function():void
                  {
                     this.top = "30";
                     this.bottom = "38";
                     this.backgroundAlpha = 0;
                     this.verticalScrollBarStyleName = "blueGlassScrollBar";
                     this.paddingLeft = 6;
                     this.paddingRight = 6;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":100,
                        "minHeight":0,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":List,
                           "id":"invite_dg",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "styleName":"inviteGrid",
                                 "includeInLayout":true,
                                 "rowHeight":25,
                                 "percentWidth":100,
                                 "selectable":false
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Spacer,
                           "propertiesFactory":function():Object
                           {
                              return {"height":6};
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"_InviteePanel_Label2",
                           "stylesFactory":function():void
                           {
                              this.textAlign = "left";
                              this.fontSize = 14;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "styleName":"spectatorPanelHeaderText"
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":HRule,
                           "id":"_InviteePanel_HRule1",
                           "stylesFactory":function():void
                           {
                              this.horizontalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "styleName":"blueParchment",
                                 "alpha":0.5,
                                 "height":1
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":List,
                           "id":"suggested_player_list",
                           "events":{"creationComplete":"__suggested_player_list_creationComplete"},
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "styleName":"inviteGrid",
                                 "rowHeight":30,
                                 "percentWidth":100,
                                 "selectable":false
                              };
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":HRule,
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "0";
                     this.bottom = "37";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":95,
                        "styleName":"blueParchment",
                        "alpha":0.5
                     };
                  }
               })]};
            }
         });
         this._2010874441_suggestedPlayersDataProvider = new ArrayCollection();
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
            this.cornerRadius = 2;
         };
         this.styleName = "blueParchmentTablet";
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.addEventListener("initialize",this.___InviteePanel_Canvas1_initialize);
         this.addEventListener("creationComplete",this.___InviteePanel_Canvas1_creationComplete);
         this.addEventListener("addedToStage",this.___InviteePanel_Canvas1_addedToStage);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         InviteePanel._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get invite_dg() : List
      {
         return this._1901004423invite_dg;
      }
      
      private function onOpenInvitePanelClicked(param1:MouseEvent) : void
      {
         var _loc2_:IAction = this._inviteProvider.getOpenInvitePanelAction();
         _loc2_.invoke();
      }
      
      private function set _inviteGroup(param1:InviteGroup) : void
      {
         var _loc2_:Object = this._2147038007_inviteGroup;
         if(_loc2_ !== param1)
         {
            this._2147038007_inviteGroup = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_inviteGroup",_loc2_,param1));
         }
      }
      
      public function set invite_dg(param1:List) : void
      {
         var _loc2_:Object = this._1901004423invite_dg;
         if(_loc2_ !== param1)
         {
            this._1901004423invite_dg = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"invite_dg",_loc2_,param1));
         }
      }
      
      public function set inviteFriends_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._450753047inviteFriends_btn;
         if(_loc2_ !== param1)
         {
            this._450753047inviteFriends_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inviteFriends_btn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get allowedtoInvite() : Boolean
      {
         return this._1371077388allowedtoInvite;
      }
      
      public function declineSuggestedPlayer(param1:SuggestedPlayer) : void
      {
         if(this._suggestedPlayersProvider)
         {
            this._suggestedPlayersProvider.declineSuggestedPlayerAndGetReplacement(this._suggestedPlayersDataProvider,param1);
         }
         this.updateSuggestedPlayersPanelVisibility();
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:InviteePanel = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._InviteePanel_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_common_invite_InviteePanelWatcherSetupUtil");
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
      
      private function set _suggestedPlayersDataProvider(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._2010874441_suggestedPlayersDataProvider;
         if(_loc2_ !== param1)
         {
            this._2010874441_suggestedPlayersDataProvider = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_suggestedPlayersDataProvider",_loc2_,param1));
         }
      }
      
      public function ___InviteePanel_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      protected function getSuggestedInviteRendererFactory() : IFactory
      {
         var _loc1_:ClassFactory = new ClassFactory(SuggestedPlayerRenderer);
         _loc1_.properties = {
            "percentWidth":100,
            "height":25
         };
         return _loc1_;
      }
      
      private function updateSuggestedPlayersPanelVisibility() : void
      {
         if(!this._inviteGroup)
         {
            return;
         }
         this._showSuggestedPlayersPanel = this._suggestedPlayersFeatureEnabled && this._suggestedPlayersDataProvider.length > 0;
         this._showSuggestedPlayersPanel = this._showSuggestedPlayersPanel && (Boolean(this._inviteGroup.allowedToInvite) && Boolean(this._inviteGroup.isOwner));
      }
      
      protected function suggestionListCreationComplete(param1:FlexEvent) : void
      {
         this.suggested_player_list.addEventListener(SuggestedPlayerRenderer.SUGGESTED_PLAYER_INVITED,this.handleSuggestedPlayerInvited,false,0,true);
         this.suggested_player_list.addEventListener(SuggestedPlayerRenderer.SUGGESTED_PLAYER_DECLINED,this.handleSuggestedPlayerDeclined,false,0,true);
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get chatController() : ChatController
      {
         return this._1019249940chatController;
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
      
      private function isSuggestedPlayersEnabled() : Boolean
      {
         return Boolean(DynamicClientConfigManager.getConfiguration("SuggestedPlayers","Enabled",true).getBoolean()) && !this.isRankedGame() && !this.isCustomGame();
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.getSuggestedPlayersDataIfEnabled();
         this.updateSuggestedPlayersPanelVisibility();
      }
      
      public function inviteSuggestedPlayer(param1:SuggestedPlayer, param2:String, param3:String = "") : void
      {
         this._inviteProvider.getInviteController().invitePlayerBySummonerName(param1.summonerName,param2,param3);
      }
      
      protected function getInviteTypeFromSuggestionReason(param1:int) : String
      {
         if(param1 == SuggestedPlayer.REASON_FRIEND_OF_FRIEND)
         {
            return InviteType.FRIEND_OF_FRIEND;
         }
         if(param1 == SuggestedPlayer.REASON_HONORED)
         {
            return InviteType.HONORED_PLAYER;
         }
         if(param1 == SuggestedPlayer.REASON_VICTORIOUS_COMRADE)
         {
            return InviteType.VICTORIOUS_COMRADE;
         }
         return InviteType.DEFAULT;
      }
      
      [Bindable(event="propertyChange")]
      public function get suggested_player_list() : List
      {
         return this._2125520928suggested_player_list;
      }
      
      public function set nameColWidth(param1:Number) : void
      {
         var _loc2_:Object = this._407556049nameColWidth;
         if(_loc2_ !== param1)
         {
            this._407556049nameColWidth = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nameColWidth",_loc2_,param1));
         }
      }
      
      private function onCreationComplete() : void
      {
         this.callLater(this.invite_dg.setStyle,["alternatingItemColors",[]]);
         this.callLater(this.invite_dg.setStyle,["backgroundAlpha",0]);
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
      
      private function retrieveSuggestedPlayersData() : void
      {
         var _loc1_:GameQueueConfig = this.gameQueueManager.selectedGameQueueConfig;
         this._suggestedPlayersProvider.getSuggestedPlayerModels(_loc1_,this.handleSuggestedPlayers);
      }
      
      private function _InviteePanel_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_pvp_headerFlame_blue");
         },function(param1:Object):void
         {
            _InviteePanel_Image1.source = param1;
         },"_InviteePanel_Image1.source");
         result[0] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !allowedtoInvite;
         },function(param1:Boolean):void
         {
            _InviteePanel_Image1.visible = param1;
         },"_InviteePanel_Image1.visible");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","inviteePanel_inviteBuddies_label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            inviteHeader.text = param1;
         },"inviteHeader.text");
         result[2] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !allowedtoInvite;
         },function(param1:Boolean):void
         {
            inviteHeader.visible = param1;
         },"inviteHeader.visible");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","inviteePanel_inviteBuddies_label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            inviteFriends_btn.label = param1;
         },"inviteFriends_btn.label");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = _inviteGroup.isInviteActive ? resourceManager.getString("resources","inviteePanel_inviteBuddies_tooltip") : resourceManager.getString("resources","inviteePanel_inviteBuddiesDisconnected_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            inviteFriends_btn.toolTip = param1;
         },"inviteFriends_btn.toolTip");
         result[5] = binding;
         binding = new Binding(this,function():Boolean
         {
            return allowedtoInvite;
         },function(param1:Boolean):void
         {
            inviteFriends_btn.visible = param1;
         },"inviteFriends_btn.visible");
         result[6] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _inviteGroup.isInviteActive;
         },function(param1:Boolean):void
         {
            inviteFriends_btn.enabled = param1;
         },"inviteFriends_btn.enabled");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ScrollPolicy.OFF;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _InviteePanel_VBox1.horizontalScrollPolicy = param1;
         },"_InviteePanel_VBox1.horizontalScrollPolicy");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ScrollPolicy.AUTO;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _InviteePanel_VBox1.verticalScrollPolicy = param1;
         },"_InviteePanel_VBox1.verticalScrollPolicy");
         result[9] = binding;
         binding = new Binding(this,function():Object
         {
            return this._inviteGroup.allParticipants;
         },function(param1:Object):void
         {
            invite_dg.dataProvider = param1;
         },"invite_dg.dataProvider");
         result[10] = binding;
         binding = new Binding(this,function():Number
         {
            return this._inviteGroup.allParticipants.length * 25;
         },function(param1:Number):void
         {
            invite_dg.height = param1;
         },"invite_dg.height");
         result[11] = binding;
         binding = new Binding(this,function():IFactory
         {
            return getInviteStatusRendererFactory();
         },function(param1:IFactory):void
         {
            invite_dg.itemRenderer = param1;
         },"invite_dg.itemRenderer");
         result[12] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","normalGame_arrangedTeam_suggestedPlayers_header");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _InviteePanel_Label2.text = param1;
         },"_InviteePanel_Label2.text");
         result[13] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _showSuggestedPlayersPanel;
         },function(param1:Boolean):void
         {
            _InviteePanel_Label2.includeInLayout = param1;
         },"_InviteePanel_Label2.includeInLayout");
         result[14] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _showSuggestedPlayersPanel;
         },function(param1:Boolean):void
         {
            _InviteePanel_Label2.visible = param1;
         },"_InviteePanel_Label2.visible");
         result[15] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _showSuggestedPlayersPanel;
         },function(param1:Boolean):void
         {
            _InviteePanel_HRule1.includeInLayout = param1;
         },"_InviteePanel_HRule1.includeInLayout");
         result[16] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _showSuggestedPlayersPanel;
         },function(param1:Boolean):void
         {
            _InviteePanel_HRule1.visible = param1;
         },"_InviteePanel_HRule1.visible");
         result[17] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _showSuggestedPlayersPanel;
         },function(param1:Boolean):void
         {
            suggested_player_list.includeInLayout = param1;
         },"suggested_player_list.includeInLayout");
         result[18] = binding;
         binding = new Binding(this,function():Boolean
         {
            return _showSuggestedPlayersPanel;
         },function(param1:Boolean):void
         {
            suggested_player_list.visible = param1;
         },"suggested_player_list.visible");
         result[19] = binding;
         binding = new Binding(this,function():Object
         {
            return this._suggestedPlayersDataProvider;
         },function(param1:Object):void
         {
            suggested_player_list.dataProvider = param1;
         },"suggested_player_list.dataProvider");
         result[20] = binding;
         binding = new Binding(this,function():Number
         {
            return this._suggestedPlayersDataProvider.length * 30;
         },function(param1:Number):void
         {
            suggested_player_list.height = param1;
         },"suggested_player_list.height");
         result[21] = binding;
         binding = new Binding(this,function():IFactory
         {
            return getSuggestedInviteRendererFactory();
         },function(param1:IFactory):void
         {
            suggested_player_list.itemRenderer = param1;
         },"suggested_player_list.itemRenderer");
         result[22] = binding;
         return result;
      }
      
      protected function handleSuggestedPlayerInvited(param1:Event) : void
      {
         var _loc2_:IListItemRenderer = param1.target as IListItemRenderer;
         var _loc3_:SuggestedPlayer = _loc2_.data as SuggestedPlayer;
         var _loc4_:String = this.getInviteTypeFromSuggestionReason(_loc3_.suggestionReason);
         var _loc5_:String = this.getPayloadForInvite(_loc3_);
         this.inviteSuggestedPlayer(_loc3_,_loc4_,_loc5_);
      }
      
      public function set suggested_player_list(param1:List) : void
      {
         var _loc2_:Object = this._2125520928suggested_player_list;
         if(_loc2_ !== param1)
         {
            this._2125520928suggested_player_list = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"suggested_player_list",_loc2_,param1));
         }
      }
      
      protected function getPayloadForInvite(param1:SuggestedPlayer) : String
      {
         if(param1.suggestionReason == SuggestedPlayer.REASON_FRIEND_OF_FRIEND)
         {
            return jsonEncode({"commonFriendId":param1.commonFriendId});
         }
         return "";
      }
      
      public function ___InviteePanel_Canvas1_addedToStage(param1:Event) : void
      {
         this.onAddedToStage(param1);
      }
      
      protected function getInviteStatusRendererFactory() : IFactory
      {
         var _loc1_:ClassFactory = new ClassFactory(InviteStatusRenderer);
         _loc1_.properties = {
            "percentWidth":100,
            "height":25
         };
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      private function get _inviteGroup() : InviteGroup
      {
         return this._2147038007_inviteGroup;
      }
      
      private function onSuggestedPlayersProviderRetrieved(param1:ISuggestedPlayersProvider) : void
      {
         this._suggestedPlayersProvider = param1;
         this.getSuggestedPlayersDataIfEnabled();
      }
      
      private function onInitialize() : void
      {
         ProviderLookup.getProvider(IInviteProvider,this.onInviteProvider);
      }
      
      public function __inviteFriends_btn_click(param1:MouseEvent) : void
      {
         this.onOpenInvitePanelClicked(param1);
      }
      
      private function isCustomGame() : Boolean
      {
         return Boolean(this.gameQueueManager) && !this.gameQueueManager.selectedGameQueueConfig;
      }
      
      private function handleSuggestedPlayers(param1:ArrayCollection) : void
      {
         this._suggestedPlayersDataProvider = param1;
         this.removeInviteParticipantsFromSuggestedPlayers();
         this.updateSuggestedPlayersPanelVisibility();
      }
      
      private function onInviteProvider(param1:IInviteProvider) : void
      {
         this._inviteProvider = param1;
         this._inviteGroup = param1.getInviteGroup();
         this._inviteGroup.getInvitedParticipantsChangedSignal().add(this.handleInviteGroupParticipantsChanged);
         this._inviteGroup.allowedToInviteChanged.add(this.updateSuggestedPlayersPanelVisibility);
         this._inviteGroup.getIsOwnerChangedSignal().add(this.updateSuggestedPlayersPanelVisibility);
      }
      
      [Bindable(event="propertyChange")]
      private function get _showSuggestedPlayersPanel() : Boolean
      {
         return this._1148516281_showSuggestedPlayersPanel;
      }
      
      public function __suggested_player_list_creationComplete(param1:FlexEvent) : void
      {
         this.suggestionListCreationComplete(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get nameColWidth() : Number
      {
         return this._407556049nameColWidth;
      }
      
      public function set allowedtoInvite(param1:Boolean) : void
      {
         var _loc2_:Object = this._1371077388allowedtoInvite;
         if(_loc2_ !== param1)
         {
            this._1371077388allowedtoInvite = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"allowedtoInvite",_loc2_,param1));
         }
      }
      
      private function removeInviteParticipantsFromSuggestedPlayers() : void
      {
         var _loc1_:InviteParticipant = null;
         var _loc2_:SuggestedPlayer = null;
         if(!this._inviteGroup || !this._suggestedPlayersDataProvider)
         {
            return;
         }
         for each(_loc1_ in this._inviteGroup.participants)
         {
            for each(_loc2_ in this._suggestedPlayersDataProvider)
            {
               if(_loc2_.summonerName.toLowerCase() == _loc1_.name.toLowerCase())
               {
                  _loc2_.invited = true;
                  _loc2_.visible = false;
                  break;
               }
            }
         }
         this._suggestedPlayersProvider.updateSuggestedPlayerVisibility(this._suggestedPlayersDataProvider);
         this.updateSuggestedPlayersPanelVisibility();
      }
      
      [Bindable(event="propertyChange")]
      public function get inviteFriends_btn() : SoundEffectButton
      {
         return this._450753047inviteFriends_btn;
      }
      
      protected function handleSuggestedPlayerDeclined(param1:Event) : void
      {
         var _loc2_:IListItemRenderer = param1.target as IListItemRenderer;
         var _loc3_:Object = _loc2_.data;
         this.declineSuggestedPlayer(_loc3_ as SuggestedPlayer);
      }
      
      [Bindable(event="propertyChange")]
      private function get _suggestedPlayersDataProvider() : ArrayCollection
      {
         return this._2010874441_suggestedPlayersDataProvider;
      }
      
      public function ___InviteePanel_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      private function _InviteePanel_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_pvp_headerFlame_blue");
         _loc1_ = !this.allowedtoInvite;
         _loc1_ = resourceManager.getString("resources","inviteePanel_inviteBuddies_label");
         _loc1_ = !this.allowedtoInvite;
         _loc1_ = resourceManager.getString("resources","inviteePanel_inviteBuddies_label");
         _loc1_ = this._inviteGroup.isInviteActive ? resourceManager.getString("resources","inviteePanel_inviteBuddies_tooltip") : resourceManager.getString("resources","inviteePanel_inviteBuddiesDisconnected_tooltip");
         _loc1_ = this.allowedtoInvite;
         _loc1_ = this._inviteGroup.isInviteActive;
         _loc1_ = ScrollPolicy.OFF;
         _loc1_ = ScrollPolicy.AUTO;
         _loc1_ = this._inviteGroup.allParticipants;
         _loc1_ = this._inviteGroup.allParticipants.length * 25;
         _loc1_ = this.getInviteStatusRendererFactory();
         _loc1_ = resourceManager.getString("resources","normalGame_arrangedTeam_suggestedPlayers_header");
         _loc1_ = this._showSuggestedPlayersPanel;
         _loc1_ = this._showSuggestedPlayersPanel;
         _loc1_ = this._showSuggestedPlayersPanel;
         _loc1_ = this._showSuggestedPlayersPanel;
         _loc1_ = this._showSuggestedPlayersPanel;
         _loc1_ = this._showSuggestedPlayersPanel;
         _loc1_ = this._suggestedPlayersDataProvider;
         _loc1_ = this._suggestedPlayersDataProvider.length * 30;
         _loc1_ = this.getSuggestedInviteRendererFactory();
      }
      
      private function handleInviteGroupParticipantsChanged() : void
      {
         this.removeInviteParticipantsFromSuggestedPlayers();
      }
      
      private function getSuggestedPlayersDataIfEnabled() : void
      {
         if(this._suggestedPlayersProvider)
         {
            this._suggestedPlayersFeatureEnabled = this.isSuggestedPlayersEnabled();
            this.retrieveSuggestedPlayersData();
         }
         else
         {
            ProviderLookup.getProvider(ISuggestedPlayersProvider,this.onSuggestedPlayersProviderRetrieved);
         }
      }
      
      public function set inviteHeader(param1:Label) : void
      {
         var _loc2_:Object = this._41626890inviteHeader;
         if(_loc2_ !== param1)
         {
            this._41626890inviteHeader = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inviteHeader",_loc2_,param1));
         }
      }
      
      public function set chatController(param1:ChatController) : void
      {
         var _loc2_:Object = this._1019249940chatController;
         if(_loc2_ !== param1)
         {
            this._1019249940chatController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get inviteHeader() : Label
      {
         return this._41626890inviteHeader;
      }
   }
}

