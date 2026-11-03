package com.riotgames.pvpnet.tracking.trackers.chat
{
   internal class ChatBehaviorBestFriend
   {
      
      public var message_count_sent:int;
      
      public var message_count_rcvd:int;
      
      public var message_count_rcvd_while_inactive:int;
      
      public var duration:Number;
      
      public var total_chars_sent:int;
      
      public var init_by_me:Boolean;
      
      public var last_start:Number;
      
      public var largest_sent:int;
      
      public var is_open:Boolean;
      
      public function ChatBehaviorBestFriend()
      {
         super();
         this.duration = 0;
         this.message_count_rcvd = 0;
         this.message_count_sent = 0;
         this.largest_sent = 0;
         this.total_chars_sent = 0;
         this.init_by_me = false;
         this.message_count_rcvd_while_inactive = 0;
         this.last_start = 0;
         this.is_open = false;
      }
      
      public function recordMessageLength(param1:uint) : void
      {
         this.total_chars_sent += param1;
         if(param1 > this.largest_sent)
         {
            this.largest_sent = param1;
         }
      }
   }
}

