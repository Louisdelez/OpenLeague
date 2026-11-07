package com.riotgames.platform.gameclient.views.game.normal.normalTeamSelection
{
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.Models.MaxViewableTeamSize;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.chat.IPresenceProvider;
   import com.riotgames.platform.gameclient.configurations.GuestSlotsConfig;
   import com.riotgames.platform.gameclient.views.game.common.renderers.teamlobby.TeamLobbyMemberFactory;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.MasterGameViewController;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.IInviteProvider;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
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
   import mx.containers.Canvas;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.controls.List;
   import mx.core.ClassFactory;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class NormalTeamPanel extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _1655307837leftColumn:ConstraintColumn;
      
      private var _655255227centerRow:ConstraintRow;
      
      mx_internal var _watchers:Array;
      
      private var _inviteGroup:InviteGroup;
      
      private var _chatRosterProvider:IChatRosterProvider;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _1749478669isExpandedLayout:Boolean = false;
      
      private var _511756277centerColumn:ConstraintColumn;
      
      private var _inviteController:IInviteController;
      
      private var _guestSlotsEnabledConfig:ConfigurationModel;
      
      private var _presenceProvider:IPresenceProvider;
      
      [Inject]
      private var _1450947915masterGameViewController:MasterGameViewController;
      
      mx_internal var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _1668243733team_lst:List;
      
      public function NormalTeamPanel()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":List,
                  "id":"team_lst",
                  "stylesFactory":function():void
                  {
                     this.left = "3";
                     this.right = "3";
                     this.top = "centerRow:0";
                     this.bottom = "centerRow:0";
                     this.backgroundAlpha = 0;
                     this.borderStyle = "none";
                     this.useRollOver = false;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "selectable":false,
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "styleName":"texturedHeader"
                     };
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
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.constraintColumns = [this._NormalTeamPanel_ConstraintColumn1_i(),this._NormalTeamPanel_ConstraintColumn2_i()];
         this.constraintRows = [this._NormalTeamPanel_ConstraintRow1_i()];
         this.addEventListener("initialize",this.___NormalTeamPanel_Canvas1_initialize);
         this.addEventListener("addedToStage",this.___NormalTeamPanel_Canvas1_addedToStage);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         NormalTeamPanel._watcherSetupUtil = param1;
      }
      
      private function getPresenceProvider() : void
      {
         ProviderLookup.getProvider(IPresenceProvider,this.onPresenceProvider);
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
      
      private function onPresenceProvider(param1:IPresenceProvider) : void
      {
         this._presenceProvider = param1;
         this.setRenderer();
      }
      
      [Bindable(event="propertyChange")]
      public function get team_lst() : List
      {
         return this._1668243733team_lst;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:NormalTeamPanel = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._NormalTeamPanel_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_normal_normalTeamSelection_NormalTeamPanelWatcherSetupUtil");
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
      
      [Bindable(event="propertyChange")]
      public function get centerColumn() : ConstraintColumn
      {
         return this._511756277centerColumn;
      }
      
      [Bindable(event="propertyChange")]
      private function get isExpandedLayout() : Boolean
      {
         return this._1749478669isExpandedLayout;
      }
      
      public function set centerColumn(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._511756277centerColumn;
         if(_loc2_ !== param1)
         {
            this._511756277centerColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"centerColumn",_loc2_,param1));
         }
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
      
      private function onAddedToStage() : void
      {
         this.isExpandedLayout = this.masterGameViewController.gameQueueManager.selectedGameQueueConfig != null && this.masterGameViewController.gameQueueManager.selectedGameQueueConfig.maximumParticipantListSize > MaxViewableTeamSize.TEAM_SIZE_NORMAL_VIEW_LIMIT;
      }
      
      private function _NormalTeamPanel_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.leftColumn = _loc1_;
         _loc1_.width = 50;
         _loc1_.initialized(this,"leftColumn");
         return _loc1_;
      }
      
      private function setTeamListItemRenderer() : void
      {
         TeamLobbyMemberFactory.instance.assetsLoaded.remove(this.setTeamListItemRenderer);
         this.team_lst.itemRenderer = TeamLobbyMemberFactory.createRendererFactory({
            "inviteGroup":this._inviteGroup,
            "inviteController":this._inviteController,
            "session":Session.instance
         });
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get masterGameViewController() : MasterGameViewController
      {
         return this._1450947915masterGameViewController;
      }
      
      [Bindable(event="propertyChange")]
      public function get leftColumn() : ConstraintColumn
      {
         return this._1655307837leftColumn;
      }
      
      private function setRenderer() : void
      {
         if(Boolean(this._inviteController) && Boolean(this._inviteGroup) && Boolean(this._presenceProvider))
         {
            if(this._guestSlotsEnabledConfig.getValue())
            {
               if(TeamLobbyMemberFactory.instance.haveAssetsLoaded)
               {
                  this.setTeamListItemRenderer();
               }
               else
               {
                  TeamLobbyMemberFactory.instance.assetsLoaded.add(this.setTeamListItemRenderer);
               }
            }
            else
            {
               this.setNormalRenderer();
            }
         }
         if(!this._inviteController || !this._inviteGroup)
         {
            ProviderLookup.getProvider(IInviteProvider,this.onInviteProvider);
         }
         if(!this._presenceProvider)
         {
            this.getPresenceProvider();
         }
      }
      
      private function setNormalRenderer() : void
      {
         var _loc1_:ClassFactory = new ClassFactory(NormalTeamMemberRenderer);
         _loc1_.properties = {
            "inviteGroup":this._inviteGroup,
            "inviteController":this._inviteController,
            "presenceProvider":this._presenceProvider,
            "lobbyController":this.masterGameViewController.lobbyController,
            "session":Session.instance
         };
         this.team_lst.itemRenderer = _loc1_;
      }
      
      private function onInitialize() : void
      {
         this._guestSlotsEnabledConfig = DynamicClientConfigManager.getConfiguration(GuestSlotsConfig.NAMESPACE,GuestSlotsConfig.ENABLED,false,this.onGuestSlotEnabledChanged);
         this.setRenderer();
      }
      
      public function ___NormalTeamPanel_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      private function onInviteProvider(param1:IInviteProvider) : void
      {
         this._inviteController = param1.getInviteController();
         this._inviteGroup = param1.getInviteGroup();
         this.team_lst.dataProvider = this._inviteGroup.acceptedParticipants;
         this.setRenderer();
      }
      
      [Bindable(event="propertyChange")]
      public function get centerRow() : ConstraintRow
      {
         return this._655255227centerRow;
      }
      
      public function set team_lst(param1:List) : void
      {
         var _loc2_:Object = this._1668243733team_lst;
         if(_loc2_ !== param1)
         {
            this._1668243733team_lst = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"team_lst",_loc2_,param1));
         }
      }
      
      private function onGuestSlotEnabledChanged() : void
      {
         this.setRenderer();
      }
      
      private function _NormalTeamPanel_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return _inviteGroup.acceptedParticipants;
         },function(param1:Object):void
         {
            team_lst.dataProvider = param1;
         },"team_lst.dataProvider");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return isExpandedLayout ? 74 : 82;
         },function(param1:Number):void
         {
            team_lst.rowHeight = param1;
         },"team_lst.rowHeight");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return isExpandedLayout ? 0 : 4;
         },function(param1:Number):void
         {
            team_lst.setStyle("paddingBottom",param1);
         },"team_lst.paddingBottom");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return isExpandedLayout ? 0 : 4;
         },function(param1:Number):void
         {
            team_lst.setStyle("paddingTop",param1);
         },"team_lst.paddingTop");
         result[3] = binding;
         return result;
      }
      
      private function _NormalTeamPanel_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.centerColumn = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.initialized(this,"centerColumn");
         return _loc1_;
      }
      
      private function _NormalTeamPanel_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this._inviteGroup.acceptedParticipants;
         _loc1_ = this.isExpandedLayout ? 74 : 82;
         _loc1_ = this.isExpandedLayout ? 0 : 4;
         _loc1_ = this.isExpandedLayout ? 0 : 4;
      }
      
      public function set masterGameViewController(param1:MasterGameViewController) : void
      {
         var _loc2_:Object = this._1450947915masterGameViewController;
         if(_loc2_ !== param1)
         {
            this._1450947915masterGameViewController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"masterGameViewController",_loc2_,param1));
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
      
      private function _NormalTeamPanel_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.centerRow = _loc1_;
         _loc1_.percentHeight = 100;
         _loc1_.initialized(this,"centerRow");
         return _loc1_;
      }
      
      public function ___NormalTeamPanel_Canvas1_addedToStage(param1:Event) : void
      {
         this.onAddedToStage();
      }
   }
}

