package com.riotgames.pvpnet.nativeextensionmain
{
   import com.riotgames.binding.AirLanguageBinding;
   import com.riotgames.binding.ModuleProxy;
   
   public class NativeExtensionMain
   {
      
      private static var _binding:AirLanguageBinding;
      
      public static var _module:ModuleProxy;
      
      public function NativeExtensionMain()
      {
         super();
      }
      
      public static function InitLolNativeExtension() : void
      {
         _binding = new AirLanguageBinding("com.riotgames.binding");
         _module = _binding.Module;
         var _loc1_:Object = _module.Help();
      }
      
      public static function createMessageBox(param1:String) : void
      {
      }
      
      public static function testAneFunction() : int
      {
         var _loc1_:Object = _module.TestANEFunction();
         return _loc1_.TestANEReturn;
      }
      
      public static function dispose() : void
      {
         _binding.dispose();
      }
   }
}

