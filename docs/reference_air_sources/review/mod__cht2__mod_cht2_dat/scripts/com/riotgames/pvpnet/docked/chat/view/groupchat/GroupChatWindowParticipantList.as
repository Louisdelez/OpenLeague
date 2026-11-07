package com.riotgames.pvpnet.docked.chat.view.groupchat
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.list.DataScroller;
   import blix.components.list.RendererFactory;
   import blix.components.scroll.ScrollPolicy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.ds.ListView;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import com.riotgames.platform.gameclient.chat.config.ChatConfig;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.utils.RiotPresence;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.IConfigurationRegistry;
   import com.riotgames.rust.data.ListAdapter;
   import flash.geom.Rectangle;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   
   public class GroupChatWindowParticipantList extends StatefulView
   {
      
      private var _model:ChatRoom;
      
      private var _participantsDataScroller:DataScroller;
      
      private var _participantsList:ListView;
      
      private var _participantsListAdapter:ListAdapter;
      
      private var _rendererFactory:RendererFactory;
      
      private var _sizer:SpriteProxy;
      
      private var _viewMediator:ChatViewMediator;
      
      private var _isMobileEnabled:Boolean;
      
      public function GroupChatWindowParticipantList(param1:IContext)
      {
         super(param1);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._viewMediator = getDependency(ChatViewMediator);
         this._viewMediator.getPrivacyListController().getActivePrivacyListUpdated().add(this.activePrivacyListChangedHandler);
         var _loc1_:IConfigurationRegistry = this.getDependency(IConfigurationRegistry);
         var _loc2_:ConfigurationModel = _loc1_.getConfigurationModel(ChatConfig.NAMESPACE,ChatConfig.MOBILE_ENABLED);
         this._isMobileEnabled = _loc2_.getValue();
      }
      
      private function activePrivacyListChangedHandler() : void
      {
         this._participantsList.reset();
      }
      
      override protected function createChildren() : void
      {
         this._participantsDataScroller = new DataScroller(this);
         this._participantsDataScroller.getLayoutInvalidated().add(invalidateLayout);
         this._participantsDataScroller.setScrollBarsAutoPosition(false);
         this._rendererFactory = new RendererFactory(GroupChatParticipantRenderer,[this]);
         this._participantsDataScroller.setRendererFactory(this._rendererFactory);
         this._participantsListAdapter = new ListAdapter();
         this._participantsList = new ListView(this._participantsListAdapter);
         this._participantsList.sortWithCompare(this.compareGroupChatParticipants);
         this._participantsDataScroller.setDataProvider(this._participantsList);
         this._participantsDataScroller.setScrollPolicy(ScrollPolicy.AUTO);
         var _loc1_:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
         this._participantsDataScroller.setLayoutAlgorithm(_loc1_);
         setTimelineChildByName("participantsScroller",this._participantsDataScroller);
         this._sizer = new SpriteProxy(this);
         setTimelineChildByName("participantPanelSizer",this._sizer);
         super.createChildren();
      }
      
      public function getModel() : ChatRoom
      {
         return this._model;
      }
      
      public function setModel(param1:ChatRoom) : void
      {
         if(param1 == this._model)
         {
            return;
         }
         if(this._model != null)
         {
            this._participantsListAdapter.setList(null);
         }
         this._model = param1;
         if(this._model != null)
         {
            this._participantsListAdapter.setList(this._model.getRoomOccupants());
         }
      }
      
      override public function destroy() : void
      {
         this.setModel(null);
         this._rendererFactory.destroy();
         super.destroy();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._participantsDataScroller.setExplicitSize(this._sizer.getWidth(),this._sizer.getHeight());
         return this._participantsDataScroller.getScaledBounds();
      }
      
      private function compareGroupChatParticipants(param1:Object, param2:Object) : int
      {
         var _loc7_:RiotPresence = null;
         var _loc8_:RiotPresence = null;
         var _loc3_:RoomOccupant = param1 as RoomOccupant;
         var _loc4_:RoomOccupant = param2 as RoomOccupant;
         if(_loc3_ == _loc4_)
         {
            return 0;
         }
         if(_loc4_ == null)
         {
            return -1;
         }
         if(_loc3_ == null)
         {
            return 1;
         }
         var _loc5_:Boolean = Boolean(this._viewMediator.getPrivacyListController().isBlocked(_loc3_.jid.bareJID));
         var _loc6_:Boolean = Boolean(this._viewMediator.getPrivacyListController().isBlocked(_loc4_.jid.bareJID));
         if(_loc5_ && !_loc6_)
         {
            return 1;
         }
         if(!_loc5_ && _loc6_)
         {
            return -1;
         }
         if(!(_loc5_ && _loc6_))
         {
            _loc7_ = RiotPresence.fromXiffPresence(_loc3_.show,this._isMobileEnabled);
            _loc8_ = RiotPresence.fromXiffPresence(_loc4_.show,this._isMobileEnabled);
            if(_loc7_ != _loc8_)
            {
               if(_loc7_ == RiotPresence.AWAY)
               {
                  return 1;
               }
               if(_loc8_ == RiotPresence.AWAY)
               {
                  return -1;
               }
               if(_loc7_ == RiotPresence.MOBILE)
               {
                  return 1;
               }
               if(_loc8_ == RiotPresence.MOBILE)
               {
                  return -1;
               }
               if(_loc7_ == RiotPresence.DND)
               {
                  return 1;
               }
               if(_loc8_ == RiotPresence.DND)
               {
                  return -1;
               }
            }
         }
         if(_loc3_.displayName.toLowerCase() < _loc4_.displayName.toLowerCase())
         {
            return -1;
         }
         return 1;
      }
   }
}

