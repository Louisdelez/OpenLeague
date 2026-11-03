package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.IQ;
   
   public class IQEvent extends Event
   {
      
      private var _data:IExtension;
      
      private var _iq:IQ;
      
      public function IQEvent(param1:String)
      {
         super(param1,false,false);
      }
      
      public function get data() : IExtension
      {
         return this._data;
      }
      
      public function set data(param1:IExtension) : void
      {
         this._data = param1;
      }
      
      public function get iq() : IQ
      {
         return this._iq;
      }
      
      public function set iq(param1:IQ) : void
      {
         this._iq = param1;
      }
   }
}

