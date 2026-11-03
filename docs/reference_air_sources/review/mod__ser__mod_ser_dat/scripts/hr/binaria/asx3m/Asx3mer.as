package hr.binaria.asx3m
{
   public class Asx3mer
   {
      
      private static var _instance:Asx3mer;
      
      private var _instance:Asx3mer;
      
      private var _xstream:Asx3m;
      
      public function Asx3mer(param1:SingletonEnforcer)
      {
         super();
         init();
      }
      
      public static function get instance() : Asx3mer
      {
         if(Asx3mer._instance == null)
         {
            Asx3mer._instance = new Asx3mer(new SingletonEnforcer());
         }
         return Asx3mer._instance;
      }
      
      private function init() : void
      {
         _xstream = new Asx3m(this,null,null,null);
      }
      
      public function toXML(param1:Object, param2:String = null) : XML
      {
         if(param2 != null)
         {
            return _xstream.toCustomTypedXML(param1,param2);
         }
         return _xstream.toXML(param1);
      }
      
      public function fromXML(param1:XML) : Object
      {
         return _xstream.fromXML(param1);
      }
   }
}

class SingletonEnforcer
{
   
   public function SingletonEnforcer()
   {
      super();
   }
}
