package blix.customsignals
{
   public class PreventDefault
   {
      
      private var _defaultPrevented:Boolean;
      
      public function PreventDefault()
      {
         super();
      }
      
      public function getDefaultPrevented() : Boolean
      {
         return this._defaultPrevented;
      }
      
      public function preventDefault() : void
      {
         this._defaultPrevented = true;
      }
   }
}

