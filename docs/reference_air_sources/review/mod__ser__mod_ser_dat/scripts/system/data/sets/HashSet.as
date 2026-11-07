package system.data.sets
{
   import system.data.Set;
   import system.data.maps.HashMap;
   
   public class HashSet extends CoreSet implements Set
   {
      
      public function HashSet(param1:* = null)
      {
         super(new HashMap(),param1);
      }
      
      override public function clone() : *
      {
         return new HashSet(toArray());
      }
   }
}

