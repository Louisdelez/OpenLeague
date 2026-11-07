package mx.events
{
   import flash.events.Event;
   
   public class CubeEvent extends Event
   {
      
      public static const QUERY_PROGRESS:String = "queryProgress";
      
      public static const CUBE_PROGRESS:String = "progress";
      
      public static const CUBE_COMPLETE:String = "complete";
      
      public var total:int;
      
      public var message:String;
      
      public var progress:int;
      
      public function CubeEvent(type:String)
      {
         super(type);
      }
   }
}

