package com.riotgames.pvpnet.contextualeducation.services
{
   import flash.utils.Dictionary;
   
   public interface IContextualEducationService
   {
      
      function getRecords() : Dictionary;
      
      function saveRecords(param1:Dictionary) : void;
   }
}

