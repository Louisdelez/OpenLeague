package mx.managers
{
   import mx.core.Singleton;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class BrowserManager
   {
      
      private static var implClassDependency:BrowserManagerImpl;
      
      private static var instance:IBrowserManager;
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public function BrowserManager()
      {
         super();
      }
      
      public static function getInstance() : IBrowserManager
      {
         if(!instance)
         {
            instance = IBrowserManager(Singleton.getInstance("mx.managers::IBrowserManager"));
         }
         return instance;
      }
   }
}

