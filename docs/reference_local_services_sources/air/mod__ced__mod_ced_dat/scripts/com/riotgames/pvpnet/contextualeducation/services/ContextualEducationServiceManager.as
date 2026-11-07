package com.riotgames.pvpnet.contextualeducation.services
{
   import flash.utils.Dictionary;
   
   public class ContextualEducationServiceManager implements IContextualEducationService
   {
      
      private var localService:ContextualEducationLocalService;
      
      private var service:IContextualEducationService;
      
      public function ContextualEducationServiceManager()
      {
         super();
         this.localService = new ContextualEducationLocalService();
         this.service = this.localService;
      }
      
      public function getRecords() : Dictionary
      {
         return this.service.getRecords();
      }
      
      public function saveRecords(param1:Dictionary) : void
      {
         this.service.saveRecords(param1);
      }
   }
}

