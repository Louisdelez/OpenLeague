package flash.events
{
   [API("669")]
   public class LocationChangeEvent extends Event
   {
      
      public static const LOCATION_CHANGE:String = "locationChange";
      
      public static const LOCATION_CHANGING:String = "locationChanging";
      
      private var m_location:String;
      
      public function LocationChangeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, location:String = null)
      {
         super(type,bubbles,cancelable);
         this.m_location = location;
      }
      
      override public function clone() : Event
      {
         return new LocationChangeEvent(type,bubbles,cancelable,this.m_location);
      }
      
      override public function toString() : String
      {
         return formatToString("LocationChangeEvent","type","bubbles","cancelable","eventPhase","location");
      }
      
      public function get location() : String
      {
         return this.m_location;
      }
      
      public function set location(value:String) : void
      {
         this.m_location = value;
      }
   }
}

