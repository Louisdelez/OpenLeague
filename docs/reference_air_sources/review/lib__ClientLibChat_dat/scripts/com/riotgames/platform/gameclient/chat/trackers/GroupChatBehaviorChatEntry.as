package com.riotgames.platform.gameclient.chat.trackers
{
   public class GroupChatBehaviorChatEntry
   {
      
      public var focused_last_start:Number;
      
      public var is_open:Boolean;
      
      public var messages_sent:int;
      
      public var marked_autojoin:Boolean;
      
      public var messages_total:int;
      
      public var subject:String;
      
      public var duration:Number;
      
      public var last_start:Number;
      
      public var focused_duration:Number;
      
      public function GroupChatBehaviorChatEntry()
      {
         super();
         this.marked_autojoin = false;
         this.messages_sent = this.messages_total = 0;
         this.duration = this.last_start = 0;
         this.is_open = false;
         this.focused_duration = this.focused_last_start = 0;
         this.subject = "";
      }
   }
}

