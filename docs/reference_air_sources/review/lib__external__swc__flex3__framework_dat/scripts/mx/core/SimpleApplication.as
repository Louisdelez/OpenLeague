package mx.core
{
   import flash.display.MovieClip;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   [Frame(factoryClass="mx.core.FlexApplicationBootstrap")]
   public class SimpleApplication extends MovieClip
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function SimpleApplication()
      {
         super();
      }
   }
}

