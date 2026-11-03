package com.riotgames.platform.gameclient.chat.event
{
   import flash.events.Event;
   
   public class ChatContextMenuEvent extends Event
   {
      
      public static const BUDDY_CONTEXT_MENU_EVENT:String = "buddyContextMenuEvent";
      
      public static const GROUPCHAT_CONTEXT_MENU_EVENT:String = "groupContextMenuEvent";
      
      public static const CONTEXT_MENU_DATA_ADD_BUDDY:String = "addBuddy";
      
      public static const CONTEXT_MENU_DATA_ADD_TO_INVITE_BAY:String = "addToInviteBay";
      
      public static const CONTEXT_MENU_DATA_INVITE_TO_GAME:String = "inviteToGame";
      
      public static const CONTEXT_MENU_DATA_INVITE_TO_CHAT:String = "inviteToChat";
      
      public static const CONTEXT_MENU_DATA_REMOVE:String = "removeBuddy";
      
      public static const CONTEXT_MENU_DATA_VIEW_PROFILE:String = "viewProfile";
      
      public static const CONTEXT_MENU_DATA_BLOCK_USER:String = "blockUser";
      
      public static const CONTEXT_MENU_DATA_UNBLOCK_USER:String = "unblockUser";
      
      public static const CONTEXT_MENU_DATA_UPDATE_NOTE:String = "updateNote";
      
      public var itemData:Object;
      
      public var itemId:String;
      
      public function ChatContextMenuEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:String = null, param5:Object = null)
      {
         super(param1,param2,param3);
         if(Boolean(param4))
         {
            this.itemId = param4;
         }
         if(Boolean(param5))
         {
            this.itemData = param5;
         }
      }
      
      override public function clone() : Event
      {
         var _loc1_:ChatContextMenuEvent = new ChatContextMenuEvent(ChatContextMenuEvent.BUDDY_CONTEXT_MENU_EVENT,bubbles,cancelable);
         _loc1_.itemId = this.itemId;
         _loc1_.itemData = this.itemData;
         return _loc1_;
      }
   }
}

