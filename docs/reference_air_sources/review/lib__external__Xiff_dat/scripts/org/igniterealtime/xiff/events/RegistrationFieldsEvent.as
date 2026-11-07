package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   import org.igniterealtime.xiff.data.register.RegisterExtension;
   
   public class RegistrationFieldsEvent extends Event
   {
      
      public static var REG_FIELDS:String = "registrationFields";
      
      private var _fields:Array;
      
      private var _data:RegisterExtension;
      
      public function RegistrationFieldsEvent()
      {
         super(RegistrationFieldsEvent.REG_FIELDS,false,false);
      }
      
      public function get fields() : Array
      {
         return this._fields;
      }
      
      public function set fields(param1:Array) : void
      {
         this._fields = param1;
      }
      
      public function get data() : RegisterExtension
      {
         return this._data;
      }
      
      public function set data(param1:RegisterExtension) : void
      {
         this._data = param1;
      }
   }
}

