package com.riotgames.platform.common.utils.app
{
   import mx.core.Application;
   
   public class ApplicationUtil
   {
      
      public function ApplicationUtil()
      {
         super();
      }
      
      [Bindable("propertyChange")]
      public static function get application() : Object
      {
         return Application.application;
      }
   }
}

