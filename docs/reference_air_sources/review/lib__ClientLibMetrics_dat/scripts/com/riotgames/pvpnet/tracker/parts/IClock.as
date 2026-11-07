package com.riotgames.pvpnet.tracker.parts
{
   public interface IClock
   {
      
      function get isUTCmode() : Boolean;
      
      function set isUTCmode(param1:Boolean) : void;
      
      function getNow() : Number;
   }
}

