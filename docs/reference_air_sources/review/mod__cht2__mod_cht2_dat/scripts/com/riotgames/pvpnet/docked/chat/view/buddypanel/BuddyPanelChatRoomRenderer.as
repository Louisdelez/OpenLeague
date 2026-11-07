package com.riotgames.pvpnet.docked.chat.view.buddypanel
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.renderer.IItemRenderer;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.chat.domain.ChatRoomInfo;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import flash.display.MovieClip;
   import flash.display.NativeMenu;
   import flash.display.NativeMenuItem;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.resources.ResourceManager;
   
   public class BuddyPanelChatRoomRenderer extends ButtonX implements IItemRenderer
   {
      
      private var _index:uint;
      
      private var _chatRoomInfo:ChatRoomInfo;
      
      private var _chatRoomName:TextFieldProxy;
      
      private var _userCount:TextFieldProxy;
      
      public function BuddyPanelChatRoomRenderer(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("ChatRoomRenderer");
         setMouseChildren(false);
      }
      
      override protected function createChildren() : void
      {
         this._chatRoomName = new TextFieldProxy(this);
         setTimelineChildByName("chatRoomNameText",this._chatRoomName);
         this._userCount = new TextFieldProxy(this);
         setTimelineChildByName("userCountText",this._userCount);
         addEventListener(MouseEvent.RIGHT_CLICK,this.handleContextMenu);
         addEventListener(MouseEvent.CLICK,this.handleJoinChat);
         super.createChildren();
      }
      
      private function handleContextMenu(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         if(!this._chatRoomInfo)
         {
            return;
         }
         var _loc2_:NativeMenu = new NativeMenu();
         var _loc3_:Point = this.localToGlobal(new Point(param1.localX,param1.localY));
         this.buildMenuItem(_loc2_,ResourceManager.getInstance().getString("resources","chat_room_join_chat"),this.handleJoinChat,true);
         this.buildMenuItem(_loc2_,ResourceManager.getInstance().getString("resources","chat_room_leave_chat"),this.handleLeaveChat,true);
         _loc2_.display(this.getStage(),_loc3_.x,_loc3_.y);
      }
      
      private function handleJoinChat(param1:Event) : void
      {
         var _loc2_:ChatViewMediator = getDependency(ChatViewMediator);
         _loc2_.openChatRoom(this._chatRoomInfo);
      }
      
      private function handleLeaveChat(param1:Event) : void
      {
         var _loc2_:ChatViewMediator = getDependency(ChatViewMediator);
         _loc2_.closeChatRoomBySubject(this._chatRoomInfo.subject,this._chatRoomInfo.roomType);
      }
      
      private function buildMenuItem(param1:NativeMenu, param2:String, param3:Function, param4:Boolean) : void
      {
         var _loc5_:NativeMenuItem = new NativeMenuItem(param2);
         _loc5_.enabled = param4;
         param1.addItem(_loc5_);
         if(param3 != null)
         {
            _loc5_.addEventListener(Event.SELECT,param3,false,0,true);
         }
      }
      
      private function setChatRoom(param1:ChatRoomInfo) : void
      {
         if(param1 != this._chatRoomInfo)
         {
            if(this._chatRoomInfo)
            {
               this._chatRoomInfo.getOccupantCountChanged().remove(this.updateUserCount);
            }
            this._chatRoomInfo = param1;
            if(this._chatRoomInfo)
            {
               this.updateUserCount();
               this.updateChatRoomName();
               this._chatRoomInfo.getOccupantCountChanged().add(this.updateUserCount);
            }
         }
      }
      
      private function updateUserCount() : void
      {
         if(this._chatRoomInfo)
         {
            this._userCount.setText(ResourceManager.getInstance().getString("resources","chat_usersList_Title",[this._chatRoomInfo.occupantCount]));
         }
      }
      
      private function updateChatRoomName() : void
      {
         if(this._chatRoomInfo)
         {
            this._chatRoomName.setText(this._chatRoomInfo.subject);
         }
      }
      
      override public function destroy() : void
      {
         if(this._chatRoomInfo)
         {
            this._chatRoomInfo.getOccupantCountChanged().remove(this.updateUserCount);
         }
         super.destroy();
      }
      
      override public function getData() : *
      {
         return null;
      }
      
      override public function setData(param1:*) : void
      {
         this.setChatRoom(param1);
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
   }
}

