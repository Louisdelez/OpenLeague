package com.riotgames.pvpnet.navigation
{
   import blix.signals.ISignal;
   
   public class NavigationManager
   {
      
      private static var _instance:INavigationManager;
      
      public function NavigationManager()
      {
         super();
      }
      
      public static function getModalDialogPathChanged() : ISignal
      {
         return instance.getModalDialogPathChanged();
      }
      
      public static function navigate(param1:String) : void
      {
         instance.navigate(param1);
      }
      
      private static function get instance() : INavigationManager
      {
         if(_instance == null)
         {
            _instance = new NavigationManagerImpl();
         }
         return _instance;
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") static function setInstance(param1:INavigationManager) : void
      {
         _instance = param1;
      }
      
      public static function getPathChanged() : ISignal
      {
         return instance.getPathChanged();
      }
      
      public static function navigateToLast() : void
      {
         instance.navigateToLast();
      }
      
      public static function getPath() : String
      {
         return instance.getPath();
      }
      
      public static function modalDialog(param1:String) : void
      {
         instance.modalDialog(param1);
      }
      
      [ArrayElementType("String")]
      public static function getPathSplit() : Array
      {
         return instance.getPathSplit();
      }
   }
}

