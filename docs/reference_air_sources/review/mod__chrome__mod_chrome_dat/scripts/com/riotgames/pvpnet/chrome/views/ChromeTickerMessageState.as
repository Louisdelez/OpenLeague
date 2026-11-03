package com.riotgames.pvpnet.chrome.views
{
   public class ChromeTickerMessageState
   {
      
      public var been_read:Boolean = false;
      
      public var needs_reaping:Boolean = false;
      
      public function ChromeTickerMessageState()
      {
         super();
         this.been_read = false;
         this.needs_reaping = false;
      }
      
      public function read() : void
      {
         this.been_read = true;
      }
      
      public function reap() : void
      {
         this.needs_reaping = true;
      }
      
      public function keep() : void
      {
         this.needs_reaping = false;
      }
   }
}

